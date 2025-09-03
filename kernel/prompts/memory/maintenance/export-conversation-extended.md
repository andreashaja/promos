# Export-Konversation Extended - Mit Program-Support

## Zweck
Erweiterte Version von export-conversation.md die auch Program-Konversationen exportiert.

## Context-Check
```bash
# Prüfe ob ein Program aktiv ist
CONTEXT_STATE=$(Read("programs/context-state.txt"))
ACTIVE_PROGRAM=$(echo "$CONTEXT_STATE" | grep "ACTIVE_PROGRAM=" | cut -d'=' -f2)

if [ "$ACTIVE_PROGRAM" != "none" ]; then
    echo "📦 Program-Context erkannt: $ACTIVE_PROGRAM"
    EXPORT_PATH="programs/$ACTIVE_PROGRAM/storage/conversations/"
else
    echo "🏠 Base-Context aktiv"
    EXPORT_PATH="storage/conversations/"
fi
```

## Export-Prozess

### 1. Verwende Standard-Export
```bash
# Nutze die bewährte Export-Logik
Read("kernel/prompts/memory/maintenance/export-conversation.md")
```

### 2. Anpasse Pfade für Program-Context
Wenn ACTIVE_PROGRAM gesetzt:
- Exportiere nach: `programs/$ACTIVE_PROGRAM/storage/conversations/`
- Dateiname: `YYYY-MM-DD-HHMM-$ACTIVE_PROGRAM-[thema].md`

### 3. Program-Memory reorganisieren
Nach erfolgreichem Export:
```bash
if [ "$ACTIVE_PROGRAM" != "none" ]; then
    echo "🔄 Reorganisiere $ACTIVE_PROGRAM-Memory..."
    # Trigger Program-spezifische Memory-Reorg
    Read("kernel/prompts/memory/maintenance/memory-reorganization.md") "programs/$ACTIVE_PROGRAM/storage/memories"
fi
```

## Isolation garantieren
- Program-Konversationen bleiben in Program-Ordner
- Keine Cross-Writes zwischen Programmen
- Base-Konversationen bleiben im Base-Storage

## Integration mit Scheduler
Diese erweiterte Version wird automatisch verwendet wenn:
- PreCompact Hook triggert
- Scheduler export-conversation auslöst
- User manuell exportiert

## Fehlerbehandlung
- Program-Ordner fehlt → Fallback zu Base-Export
- Keine Schreibrechte → Warnung + Skip
- Context-State korrupt → Default zu Base