# Switch to Program Context

## Parameter
**PROGRAM_NAME**: ${1:-"[PROGRAM_NAME_REQUIRED]"}

## Zweck
Wechselt vom Base-System zum spezifizierten Program mit automatischem Memory-Loading.

## Ablauf

### 1. Context-State Update
```bash
Write("programs/context-state.txt", "# PROMOS Context State
# Diese Datei trackt welches Program gerade aktiv ist
# NICHT MANUELL EDITIEREN - wird vom System verwaltet

CURRENT_CONTEXT=${PROGRAM_NAME}
ACTIVE_PROGRAM=${PROGRAM_NAME}
LAST_UPDATE=$(date '+%Y-%m-%d %H:%M:%S')")
```

### 2. Program-Memory laden
```bash
# Lade Program-spezifisches Memory
Read("programs/${PROGRAM_NAME}/storage/memories/memory-map.md")
Read("programs/${PROGRAM_NAME}/storage/memories/core/user.md")
Read("programs/${PROGRAM_NAME}/storage/memories/core/preferences.md")

# Prüfe auf existierende thoughts
if [ -f "programs/${PROGRAM_NAME}/storage/memories/thoughts.md" ]; then
    Read("programs/${PROGRAM_NAME}/storage/memories/thoughts.md")
fi

# Base-Memory im Read-Only Modus verfügbar machen
echo "📖 Base-Memory verfügbar (read-only)"
```

### 3. Program-Routes aktivieren
```bash
# Program-spezifische Routes sind jetzt aktiv
echo "🔀 Program-Routes aktiviert: programs/${PROGRAM_NAME}/routing/program-routes.txt"
```

### 4. User-Feedback
```
🚀 ${PROGRAM_NAME} Program aktiviert!

Du befindest dich jetzt im ${PROGRAM_NAME}-Kontext:
✅ Program-Storage aktiv (read/write)
📖 Base-Memory verfügbar (read-only)  
🔀 Program-spezifische Routes geladen

Was möchtest du im ${PROGRAM_NAME}-Kontext tun?

💡 Tipp: Mit "zurück zum basis" kommst du ins Base-System zurück.
```

## Memory-Zugriffsregeln
- **Program-Storage**: Vollzugriff (programs/${PROGRAM_NAME}/storage/*)
- **Base-Storage**: Read-Only (storage/memories/*)
- **Program-Results**: Vollzugriff (programs/${PROGRAM_NAME}/results/*)

## Fehlerbehandlung
Falls Program nicht existiert:
```bash
if [ ! -f "programs/${PROGRAM_NAME}/boot.md" ]; then
    echo "❌ Program '${PROGRAM_NAME}' nicht gefunden!"
    Read("kernel/prompts/programs/list-programs.md")
    return 1
fi
```