# Switch to Base Context

## Zweck
Wechselt vom Program-Kontext zurück zum Base-System.

## Ablauf

### 1. Aktuellen Program-Context sichern
```bash
# Lese aktuellen Context
CURRENT_PROGRAM=$(grep "ACTIVE_PROGRAM=" programs/context-state.txt | cut -d'=' -f2)

if [ "$CURRENT_PROGRAM" != "none" ]; then
    echo "💾 Sichere ${CURRENT_PROGRAM}-Context..."
    # Optional: Trigger Memory-Map Update für das Program
fi
```

### 2. Context-State zurücksetzen
```bash
Write("programs/context-state.txt", "# PROMOS Context State
# Diese Datei trackt welches Program gerade aktiv ist
# NICHT MANUELL EDITIEREN - wird vom System verwaltet

CURRENT_CONTEXT=base
ACTIVE_PROGRAM=none
LAST_UPDATE=$(date '+%Y-%m-%d %H:%M:%S')")
```

### 3. Base-Memory wieder voll verfügbar
```bash
# Base-Memory hat wieder vollen Zugriff
echo "📂 Base-Storage wieder mit vollem Zugriff"
Read("storage/memories/memory-map.md")
```

### 4. User-Feedback
```
🏠 Zurück im Base-System!

Du bist jetzt wieder im Standard-Modus:
✅ Base-Storage aktiv (read/write)
🔧 Alle System-Funktionen verfügbar
📦 Programme können jederzeit gestartet werden

Was möchtest du tun?

💡 Tipp: Mit "zeige programme" siehst du alle verfügbaren Programme.
```

## Navigation
Im Base-Context sind wieder alle Standard-Routes verfügbar:
- Memory-Operationen
- System-Befehle
- Export-Funktionen
- Program-Verwaltung

## Cleanup
```bash
# Stelle sicher dass keine Program-spezifischen States zurückbleiben
unset CURRENT_PROGRAM
echo "✅ Program-Context erfolgreich beendet"
```