# Save to Thoughts Prompt

## Zweck
Speichert bewusste "Merke dir" Anfragen vom User in thoughts.md.
Diese werden später bei der Memory-Reorganisation in Topics sortiert.
**Context-aware**: Speichert automatisch im aktiven Program-Memory oder Base-Memory.

## Trigger
- "Merke dir..."
- "Denk daran..."
- "Notiere..."
- "Speichere..."
- Explizite Speicher-Anfragen

## Ablauf

### 1. Context bestimmen und Memory-Pfad setzen
```bash
# Lese Context-State
Read("programs/context-state.txt")

# Setze Memory-Pfad abhängig vom Context
if ACTIVE_PROGRAM != "none":
    MEMORY_PATH = "programs/{ACTIVE_PROGRAM}/storage/memories/thoughts.md"
else:
    MEMORY_PATH = "storage/memories/thoughts.md"
```

### 2. Thoughts.md laden
```bash
Read("{MEMORY_PATH}")
```

### 3. Neuen Gedanken anhängen
Format:
```markdown
## YYYY-MM-DD HH:MM
- [User-Gedanke hier]
```

### 4. Datei aktualisieren
```bash
Edit("{MEMORY_PATH}", ...)
```

### 5. Context-spezifische Bestätigung
```bash
if ACTIVE_PROGRAM != "none":
    echo "✅ Gespeichert im {ACTIVE_PROGRAM} Memory!"
    echo "📂 Speicherort: programs/{ACTIVE_PROGRAM}/storage/memories/thoughts.md"
    echo "🔒 Diese Info ist nur im {ACTIVE_PROGRAM} verfügbar"
else:
    echo "✅ Gespeichert in Thoughts!"
    echo "Der Gedanke wird bei der nächsten Memory-Reorganisation"
    echo "automatisch in die passende Kategorie einsortiert."
fi
```

## Beispiele

**User:** "Merke dir dass ich morgen Pillen-Sortierboxen kaufen muss"
**Speichern als:**
```
## 2025-01-24 14:30
- Morgen Pillen-Sortierboxen in der Apotheke kaufen
```

**User:** "Denk daran dass meine Katze Luna heißt"
**Speichern als:**
```
## 2025-01-24 14:31
- Katze heißt Luna
```

## Wichtig
- NUR bewusste Speicher-Anfragen
- KEINE automatische Extraktion
- Thoughts.md ist der Eingang für alle User-Gedanken
- Bei Reorganisation → Sortierung in Topics
- Im Program-Context → Automatisch im Program-Memory
- Für explizites Base-Memory → "Speichere im Basisspeicher"