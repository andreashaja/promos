#!/bin/bash
# Hook: Wird bei jedem User-Input ausgeführt
# Kombiniert update-metrics und entry-point Logik für korrekte Reihenfolge

# Finde das Projekt-Root dynamisch
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/find-project-root.sh"
PROJECT_ROOT="$(find_project_root)"

# Log-Funktionen laden
source "$SCRIPT_DIR/log-function.sh"

# Erfasse User-Input (wird von Claude über stdin übergeben)
USER_INPUT=""
if [ ! -t 0 ]; then
    RAW_INPUT=$(cat)
    # Versuche JSON zu parsen - schaue nach "prompt" oder "message" Feld
    if echo "$RAW_INPUT" | grep -q '"prompt"\|"message"'; then
        # Es ist JSON - extrahiere das prompt oder message Feld
        USER_INPUT=$(echo "$RAW_INPUT" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    # Claude Code nutzt 'prompt', andere nutzen 'message'
    text = data.get('prompt', '') or data.get('message', '')
    print(text.strip())
except:
    pass
" 2>/dev/null)
        # Fallback falls JSON parsing fehlschlägt
        if [ -z "$USER_INPUT" ]; then
            USER_INPUT="$RAW_INPUT"
        fi
    else
        # Kein JSON - nutze direkt
        USER_INPUT="$RAW_INPUT"
    fi
fi

# Definiere Pfade
MONITOR_FILE="$PROJECT_ROOT/kernel/scheduler/system-monitor.txt"
QUEUE_FILE="$PROJECT_ROOT/kernel/scheduler/action-queue.txt"
CONFIG_FILE="$PROJECT_ROOT/kernel/config/scheduler-config.txt"

# ============================
# TEIL 1: METRICS UPDATE
# ============================

# Sicherheitsprüfung: Monitor-Datei muss existieren
if [ ! -f "$MONITOR_FILE" ]; then
    log_error "HOOK" "$MONITOR_FILE nicht gefunden!"
    exit 1
fi

# Sicherheitsprüfung: Config-Datei muss existieren
if [ ! -f "$CONFIG_FILE" ]; then
    log_error "HOOK" "$CONFIG_FILE nicht gefunden!"
    exit 1
fi

# Lese aktuellen Message-Counter
MSG_COUNT=$(grep "^MSG:" "$MONITOR_FILE" | cut -d: -f2)
[ -z "$MSG_COUNT" ] && MSG_COUNT=0

# Lese aktuellen Token-Counter (VOR dem Überschreiben!)
TOKEN_COUNT=$(grep "^TOKENS:" "$MONITOR_FILE" | cut -d: -f2)
[ -z "$TOKEN_COUNT" ] && TOKEN_COUNT=0

# Bewahre TRIGGERED_AT_TOKENS Markierungen
TRIGGERED_MARKS=$(grep "^TRIGGERED_AT_TOKENS:" "$MONITOR_FILE" 2>/dev/null || true)

# Erhöhe Message-Counter um 1
NEW_COUNT=$((MSG_COUNT + 1))
log_info "METRICS" "Message counter increased: $MSG_COUNT → $NEW_COUNT"

# Schreibe aktualisierten System-Monitor (MIT Token-Zeile und Trigger-Marks!)
{
    echo "# SYSTEM MONITOR - Aktueller System-Status"
    echo "# NICHT EDITIEREN - Wird vom System verwaltet"
    echo "MSG:$NEW_COUNT"
    echo "TOKENS:$TOKEN_COUNT"
    if [ -n "$TRIGGERED_MARKS" ]; then
        echo "$TRIGGERED_MARKS"
    fi
} > "$MONITOR_FILE"

# ============================
# TEIL 2: SCHEDULER & QUEUE
# ============================

# Baue Action-Queue auf basierend auf Scheduler-Config
QUEUE=""

# Parse die scheduler-config.txt für EVERY, AT und AT_TOKENS Regeln
while IFS=: read -r type frequency action_with_comment; do
    # Überspringe Kommentare und leere Zeilen
    [[ "$type" =~ ^#.*$ ]] && continue
    [ -z "$type" ] && continue
    
    # Entferne Kommentare und Whitespace von der Action
    action=$(echo "$action_with_comment" | sed 's/#.*$//' | xargs)
    
    if [ "$type" = "EVERY" ]; then
        # EVERY:X:action bedeutet: alle X Messages diese Aktion ausführen
        if [ $((NEW_COUNT % frequency)) -eq 0 ]; then
            log_info "SCHEDULER" "Rule triggered: $type:$frequency:$action at message $NEW_COUNT"
            QUEUE="${QUEUE}${action}
"
        fi
    elif [ "$type" = "AT" ]; then
        # AT:X:action bedeutet: NUR bei Message X diese Aktion ausführen (nicht bei allen folgenden)
        if [ $NEW_COUNT -eq $frequency ]; then
            # Prüfe ob es eine höhere Warnstufe gibt
            if [ "$action" = "export-warn" ]; then
                # Prüfe ob export-force bereits fällig
                if grep -q "^AT:.*:export-force" "$CONFIG_FILE"; then
                    FORCE_THRESHOLD=$(grep "^AT:.*:export-force" "$CONFIG_FILE" | cut -d: -f2)
                    if [ $NEW_COUNT -ge $FORCE_THRESHOLD ]; then
                        continue  # Skip warn wenn im force-Bereich
                    fi
                fi
            fi
            log_info "SCHEDULER" "Rule triggered: $type:$frequency:$action at message $NEW_COUNT"
            QUEUE="${QUEUE}${action}
"
        fi
    elif [ "$type" = "AT_TOKENS" ]; then
        # AT_TOKENS:X:action bedeutet: Bei X Tokens diese Aktion ausführen
        if [ $TOKEN_COUNT -ge $frequency ]; then
            # Prüfe ob es eine höhere Token-Warnstufe gibt
            if [ "$action" = "export-warn" ]; then
                # Prüfe ob export-force bereits fällig
                if grep -q "^AT_TOKENS:.*:export-force" "$CONFIG_FILE"; then
                    FORCE_TOKEN_THRESHOLD=$(grep "^AT_TOKENS:.*:export-force" "$CONFIG_FILE" | cut -d: -f2)
                    if [ $TOKEN_COUNT -ge $FORCE_TOKEN_THRESHOLD ]; then
                        continue  # Skip warn wenn im force-Bereich
                    fi
                fi
            fi
            # Nur einmal pro Token-Schwelle triggern (prüfe ob schon in Queue-History)
            if ! grep -q "TRIGGERED_AT_TOKENS:$frequency:$action" "$MONITOR_FILE" 2>/dev/null; then
                log_info "SCHEDULER" "Token rule triggered: $type:$frequency:$action at $TOKEN_COUNT tokens"
                QUEUE="${QUEUE}${action}
"
                # Markiere als getriggert
                echo "TRIGGERED_AT_TOKENS:$frequency:$action" >> "$MONITOR_FILE"
            fi
        fi
    fi
done < "$CONFIG_FILE"

# Schreibe die Queue-Datei (wird gleich gelesen)
if [ -n "$QUEUE" ]; then
    # Schreibe Queue ohne trailing newline
    printf "# QUEUE\n%s" "${QUEUE%$'\n'}" > "$QUEUE_FILE"
else
    echo "# QUEUE" > "$QUEUE_FILE"
fi

# Gebe Warnungen aus wenn entsprechende Aktionen in der Queue sind
if [[ "$QUEUE" == *"export-force"* ]]; then
    if [ $TOKEN_COUNT -gt 0 ]; then
        TOKEN_PERCENTAGE=$((TOKEN_COUNT * 100 / 200000))
        echo "🔴 SCHEDULER: Force export at $TOKEN_COUNT tokens ($TOKEN_PERCENTAGE%)"
    else
        echo "🔴 SCHEDULER: Force export triggered"
    fi
elif [[ "$QUEUE" == *"export-warn"* ]]; then
    if [ $TOKEN_COUNT -gt 0 ]; then
        TOKEN_PERCENTAGE=$((TOKEN_COUNT * 100 / 200000))
        echo "⚠️ SCHEDULER: Export recommended at $TOKEN_COUNT tokens ($TOKEN_PERCENTAGE%)"
    else
        echo "⚠️ SCHEDULER: Export recommended"
    fi
fi

# ============================
# TEIL 3: ENTRY-POINT AUSFÜHRUNG
# ============================

# 1. System-Monitor anzeigen (immer - nur 15 Tokens)
echo "## METRICS"
cat "$MONITOR_FILE"
echo ""

# 2. Action-Queue prüfen und Inhalt injizieren
if [ -f "$QUEUE_FILE" ]; then
    QUEUE_CONTENT=$(grep -v "^# QUEUE" "$QUEUE_FILE")
    
    if [ -n "$QUEUE_CONTENT" ]; then
        echo "## SCHEDULED-ACTIONS"
        echo "Die folgenden Aktionen sind geplant und MÜSSEN ausgeführt werden:"
        echo ""
        
        # Für jede Action in Queue
        while IFS= read -r action; do
            log_info "ACTION" "Executing: $action"
            case "$action" in
                "load-policies")
                    echo "→ Policies laden (wird automatisch injiziert)"
                    echo "[SYSTEM: Policies wurden geladen]"
                    log_info "ACTION" "Policies loaded successfully"
                    echo "## POLICIES"
                    cat "$PROJECT_ROOT/kernel/policies/policies.md"
                    echo ""
                    ;;
                "memory-reorg")
                    echo "→ Memory reorganisieren (wird automatisch injiziert)"
                    echo "[SYSTEM: Memory-Reorganisation gestartet]"
                    log_info "ACTION" "Memory reorganization initiated"
                    echo "## MEMORY-REORG"
                    cat "$PROJECT_ROOT/kernel/prompts/memory-reorganization.md"
                    echo ""
                    ;;
                "export-warn")
                    echo "→ ⚠️ Export empfohlen bei hohem Context-Verbrauch"
                    log_warn "ACTION" "Export warning displayed - high context usage"
                    ;;
                "export-force")
                    echo "→ 🔴 KRITISCH: Export SOFORT durchführen!"
                    echo "   Read(\"kernel/prompts/export-conversation.md\")"
                    log_error "ACTION" "CRITICAL: Force export triggered - context limit approaching"
                    ;;
                "estimate-tokens")
                    echo "→ Token-Verbrauch schätzen"
                    echo "[SYSTEM: Token-Schätzung wird durchgeführt]"
                    log_info "ACTION" "Token estimation initiated"
                    echo "## ESTIMATE-TOKENS"
                    cat "$PROJECT_ROOT/kernel/prompts/system/estimate-context-tokens.md"
                    echo ""
                    ;;
                "continue-conversation")
                    echo "→ Letzte Konversation fortsetzen"
                    echo "[SYSTEM: Lade gespeicherte Konversation]"
                    log_info "ACTION" "Continue conversation initiated"
                    echo "## CONTINUE-CONVERSATION"
                    cat "$PROJECT_ROOT/kernel/prompts/memory/maintenance/continue-conversation.md"
                    echo ""
                    ;;
                "export-conversation")
                    echo "→ Aktuelle Konversation exportieren"
                    echo "[SYSTEM: Export wird durchgeführt]"
                    log_info "ACTION" "Export conversation initiated"
                    echo "## EXPORT-CONVERSATION"
                    cat "$PROJECT_ROOT/kernel/prompts/memory/maintenance/export-conversation.md"
                    echo ""
                    ;;
            esac
        done <<< "$QUEUE_CONTENT"
        
        echo ""
        echo "WICHTIG: Nach Ausführung wird Queue automatisch geleert."
        echo ""
        
        # Queue leeren für nächsten Durchlauf
        echo "# QUEUE" > "$QUEUE_FILE"
        log_info "QUEUE" "Action queue cleared after execution"
    fi
fi

# 3. Pre-Response-Router mit API - Intelligente Route-Setzung
# Exportiere den letzten User-Input für den Router
export LAST_USER_MESSAGE="${USER_INPUT:-}"

# Verwende den neuen API-basierten Router
echo "## ROUTING DECISION"
# Führe Router aus und logge Fehler
if ! python3 "$PROJECT_ROOT/kernel/hooks/pre-response-router-api.py" 2>/tmp/router_error.tmp; then
    # Bei Fehler: Logge und zeige Notfall-Box (auf einer Zeile für Log)
    ERROR_MSG=$(cat /tmp/router_error.tmp | tr '\n' ' | ' | sed 's/| $//')
    log_error "ROUTER" "Router failed: $ERROR_MSG"
    
    # Zeige Notfall-Box für User
    echo ""
    cat "$PROJECT_ROOT/kernel/prompts/system/system-error-box.txt"
    echo ""
    
    rm -f /tmp/router_error.tmp
    
    # Stoppe weitere Verarbeitung - User soll Notfall-Befehl nutzen
    exit 1
else
    rm -f /tmp/router_error.tmp
fi

# Exit 0 = Erfolg
exit 0