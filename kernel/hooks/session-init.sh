#!/bin/bash
# Hook: Session-Initialisierung
# Wird durch SessionStart getriggert

# Finde das Projekt-Root dynamisch
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/find-project-root.sh"
PROJECT_ROOT="$(find_project_root)"

# Log-Funktionen laden
source "$SCRIPT_DIR/log-function.sh"

# Session-Start loggen
log_info "SESSION_INIT" "Hook triggered with matcher: startup"

# ═══════════════════════════════════════
# SYSTEM HEALTH CHECK
# ═══════════════════════════════════════
echo "."
echo ""
echo "⚙️  System-Check läuft..."

SYSTEM_BROKEN=false
WARNINGS=""

# 1. Python3 Verfügbarkeit prüfen
if ! command -v python3 &> /dev/null; then
    echo "❌ KRITISCH: Python3 nicht gefunden - System kann nicht starten!"
    log_error "HEALTH_CHECK" "Python3 not found in PATH"
    SYSTEM_BROKEN=true
else
    python_version=$(python3 --version 2>&1 | cut -d' ' -f2)
    log_debug "HEALTH_CHECK" "Python3 found: $python_version"
fi

# 2. Kritische Verzeichnisse prüfen
CRITICAL_DIRS="kernel kernel/hooks kernel/config kernel/prompts kernel/scheduler storage logs programs"
for dir in $CRITICAL_DIRS; do
    if [ ! -d "$PROJECT_ROOT/$dir" ]; then
        echo "❌ KRITISCH: Verzeichnis fehlt: $dir"
        log_error "HEALTH_CHECK" "Critical directory missing: $dir"
        SYSTEM_BROKEN=true
    fi
done

# 3. Shell-Skripte auf Ausführbarkeit prüfen
NON_EXEC_SCRIPTS=""
for script in "$PROJECT_ROOT"/kernel/hooks/*.sh; do
    if [ -f "$script" ] && [ ! -x "$script" ]; then
        script_name=$(basename "$script")
        NON_EXEC_SCRIPTS="$NON_EXEC_SCRIPTS $script_name"
        # Automatisch fixen
        chmod +x "$script"
        if [ $? -eq 0 ]; then
            log_info "HEALTH_CHECK" "Fixed permissions for: $script_name"
        else
            log_warn "HEALTH_CHECK" "Could not fix permissions for: $script_name"
            WARNINGS="$WARNINGS\n⚠️  Skript nicht ausführbar: $script_name"
        fi
    fi
done

if [ -n "$NON_EXEC_SCRIPTS" ]; then
    echo "✅ Skript-Berechtigungen automatisch korrigiert für:$NON_EXEC_SCRIPTS"
fi

# 4. Schreibrechte in logs/ prüfen
if ! touch "$PROJECT_ROOT/logs/.write_test" 2>/dev/null; then
    echo "❌ KRITISCH: Keine Schreibrechte in logs/ - Logging nicht möglich!"
    log_error "HEALTH_CHECK" "No write permissions in logs/"
    SYSTEM_BROKEN=true
else
    rm -f "$PROJECT_ROOT/logs/.write_test"
    log_debug "HEALTH_CHECK" "Write permissions OK for logs/"
fi

# 5. Schreibrechte in storage/ prüfen
if ! touch "$PROJECT_ROOT/storage/.write_test" 2>/dev/null; then
    WARNINGS="$WARNINGS\n⚠️  WARNUNG: Keine Schreibrechte in storage/ - Memory nicht speicherbar!"
    log_warn "HEALTH_CHECK" "No write permissions in storage/"
else
    rm -f "$PROJECT_ROOT/storage/.write_test"
    log_debug "HEALTH_CHECK" "Write permissions OK for storage/"
fi

# 6. Kritische Config-Dateien prüfen
CRITICAL_CONFIGS="kernel/config/routing-config.txt kernel/config/scheduler-config.txt"
for config in $CRITICAL_CONFIGS; do
    if [ ! -r "$PROJECT_ROOT/$config" ]; then
        WARNINGS="$WARNINGS\n⚠️  Config-Datei nicht lesbar: $config"
        log_warn "HEALTH_CHECK" "Config file not readable: $config"
    fi
done

# 7. Python-Skripte syntax-prüfen
PYTHON_SCRIPTS="kernel/hooks/pre-response-router-api.py kernel/smart-path-search.py"
for pyscript in $PYTHON_SCRIPTS; do
    if [ -f "$PROJECT_ROOT/$pyscript" ]; then
        if ! python3 -m py_compile "$PROJECT_ROOT/$pyscript" 2>/dev/null; then
            echo "❌ KRITISCH: Python-Syntax-Fehler in: $(basename $pyscript)"
            log_error "HEALTH_CHECK" "Python syntax error in: $pyscript"
            SYSTEM_BROKEN=true
        fi
    fi
done

# Health Check Ergebnis ausgeben
if [ "$SYSTEM_BROKEN" = true ]; then
    echo ""
    echo "════════════════════════════════════════"
    echo "❌ SYSTEM NICHT STARTBEREIT"
    echo "════════════════════════════════════════"
    echo "Behebe die kritischen Fehler oben,"
    echo "dann starte das System neu."
    echo "════════════════════════════════════════"
    log_error "HEALTH_CHECK" "System health check failed - aborting startup"
    exit 1
fi

# Warnungen ausgeben falls vorhanden
if [ -n "$WARNINGS" ]; then
    echo -e "$WARNINGS"
    log_info "HEALTH_CHECK" "System check completed with warnings"
else
    log_info "HEALTH_CHECK" "System check completed successfully"
fi

echo "✅ System-Check erfolgreich"
echo ""
log_debug "SESSION_INIT" "Working directory: $(pwd)"
log_debug "SESSION_INIT" "Project root detected: $PROJECT_ROOT"

# Reset Message-Counter auf 0 für neue Session
MONITOR_FILE="$PROJECT_ROOT/kernel/scheduler/system-monitor.txt"
if [ -f "$MONITOR_FILE" ]; then
    log_info "SESSION_INIT" "Resetting system monitor (MSG:0)"
    cat > "$MONITOR_FILE" << EOF
# SYSTEM MONITOR - Aktueller System-Status
# NICHT EDITIEREN - Wird vom System verwaltet
MSG:0
TOKENS:0
EOF
    if [ $? -eq 0 ]; then
        log_debug "SESSION_INIT" "System monitor reset successful"
    else
        log_error "SESSION_INIT" "Failed to reset system monitor"
    fi
else
    log_warn "SESSION_INIT" "System monitor file not found: $MONITOR_FILE"
    # Versuche die Datei zu erstellen
    mkdir -p "$(dirname "$MONITOR_FILE")"
    cat > "$MONITOR_FILE" << EOF
# SYSTEM MONITOR - Aktueller System-Status
# NICHT EDITIEREN - Wird vom System verwaltet
MSG:0
TOKENS:0
EOF
    if [ $? -eq 0 ]; then
        log_info "SESSION_INIT" "Created new system monitor file"
    else
        log_error "SESSION_INIT" "Failed to create system monitor file"
    fi
fi

# ═══════════════════════════════════════
# CONTEXT-STATE RESET
# ═══════════════════════════════════════
# Bei jedem Session-Start wird der Context auf Base zurückgesetzt
CONTEXT_STATE_FILE="$PROJECT_ROOT/programs/context-state.txt"
if [ -f "$CONTEXT_STATE_FILE" ]; then
    cat > "$CONTEXT_STATE_FILE" << EOF
# PROMOS Context State
# Diese Datei trackt welches Program gerade aktiv ist
# NICHT MANUELL EDITIEREN - wird vom System verwaltet

CURRENT_CONTEXT=base
ACTIVE_PROGRAM=none
LAST_UPDATE=$(date '+%Y-%m-%d %H:%M:%S')
EOF
    if [ $? -eq 0 ]; then
        log_info "SESSION_INIT" "Context-state reset to base"
    else
        log_error "SESSION_INIT" "Failed to reset context-state"
    fi
else
    log_warn "SESSION_INIT" "Context-state file not found, creating new one"
    mkdir -p "$(dirname "$CONTEXT_STATE_FILE")"
    cat > "$CONTEXT_STATE_FILE" << EOF
# PROMOS Context State
# Diese Datei trackt welches Program gerade aktiv ist
# NICHT MANUELL EDITIEREN - wird vom System verwaltet

CURRENT_CONTEXT=base
ACTIVE_PROGRAM=none
LAST_UPDATE=$(date '+%Y-%m-%d %H:%M:%S')
EOF
fi

# Benutzerfreundliche Session-Auswahl  
echo "."
echo ""
echo "═══════════════════════════════════════"
echo "    🤖 PROMOS v0.2 - BEREIT"
echo "═══════════════════════════════════════"
echo ""
echo "✅ Basis-System aktiv"
echo ""

# Program-Discovery (vollständig dynamisch)
if [ -d "$PROJECT_ROOT/programs" ]; then
    log_info "SESSION_INIT" "Starting program discovery in $PROJECT_ROOT/programs"
    echo "📦 Programm starten:"
    program_count=0
    
    # Program-List für Router erstellen
    PROGRAM_LIST_FILE="$PROJECT_ROOT/programs/program-list.txt"
    > "$PROGRAM_LIST_FILE"  # Datei leeren
    echo "# PROGRAM-LIST - Automatisch generiert bei Session-Start" >> "$PROGRAM_LIST_FILE"
    echo "# Format: PROGRAM_NAME→BESCHREIBUNG" >> "$PROGRAM_LIST_FILE"
    
    for program_dir in "$PROJECT_ROOT/programs"/*; do
        if [ -d "$program_dir" ]; then
            program_name=$(basename "$program_dir")
            # Ignoriere Programme mit _ am Anfang
            if [[ "$program_name" == _* ]]; then
                continue
            fi
            
            if [ -f "$program_dir/boot.md" ]; then
                # Version aus boot.md extrahieren
                version=""
                if [ -f "$program_dir/boot.md" ]; then
                    # Erste Zeile lesen und Version extrahieren (z.B. "# PROGRAMM_NAME v0.1")
                    first_line=$(head -n 1 "$program_dir/boot.md")
                    version=$(echo "$first_line" | grep -oE 'v[0-9]+\.[0-9]+' | head -1)
                fi
                
                # Beschreibung aus README.md extrahieren
                description=""
                if [ -f "$program_dir/README.md" ]; then
                    # Erste nicht-leere Zeile nach dem Titel als Beschreibung
                    description=$(awk 'NF && !/^#/ && !/^[🤖🌱🧪📋🔧⚡🎯📊💡🚀]/ {print; exit}' "$program_dir/README.md")
                    if [ -z "$description" ]; then
                        # Fallback: Zweite Zeile wenn erste Zeile ein Icon ist
                        description=$(sed -n '3p' "$program_dir/README.md" | sed 's/^ *//')
                    fi
                fi
                
                # Fallback Beschreibung
                if [ -z "$description" ]; then
                    description="$program_name Programm"
                fi
                
                # In program-list.txt schreiben
                echo "${program_name}→${description}" >> "$PROGRAM_LIST_FILE"
                
                # Dynamische Icon-Auswahl basierend auf README.md oder Fallback
                icon="📋"
                if [ -f "$program_dir/README.md" ]; then
                    # Suche nach Icon-Definition in README.md
                    readme_icon=$(head -5 "$program_dir/README.md" | grep -oE '[🤖🌱🧪📋🔧⚡🎯📊💡🚀]' | head -1)
                    if [ -n "$readme_icon" ]; then
                        icon="$readme_icon"
                    fi
                fi
                
                # Display mit oder ohne Version
                if [ -n "$version" ]; then
                    echo "    $icon $program_name $version"
                    log_info "SESSION_INIT" "Found program: $program_name $version"
                else
                    echo "    $icon $program_name"
                    log_info "SESSION_INIT" "Found program: $program_name (no version)"
                fi
                ((program_count++))
            fi
        fi
    done
    echo ""
    if [ $program_count -eq 0 ]; then
        log_warn "SESSION_INIT" "No valid programs found in programs directory"
    else
        log_info "SESSION_INIT" "Program discovery complete: $program_count programs found"
        log_info "SESSION_INIT" "Created program-list.txt with $program_count entries"
    fi
else
    log_warn "SESSION_INIT" "Programs directory not found: $PROJECT_ROOT/programs"
fi

echo "💡 Tipp: Sage 'Neues Programm erstellen' für eigene Arbeitskontexte"
echo ""

# Routing-Status prüfen
ROUTING_CONFIG="$PROJECT_ROOT/kernel/config/routing-config.txt"
if [ -f "$ROUTING_CONFIG" ]; then
    if grep -q "ROUTING_ENABLED=false" "$ROUTING_CONFIG" 2>/dev/null; then
        echo "⚠️  Routing ist pausiert - sage 'Router einschalten' zum Reaktivieren"
        echo ""
    fi
fi

echo "Sage einfach was du möchtest - ich verstehe natürliche Sprache! 😊"
echo ""
echo "."

log_info "SESSION_INIT" "Initialization complete - System ready"

# Exit 0 = Erfolg
exit 0