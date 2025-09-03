# Generate Memory Map Prompt (Parameter-basiert)

## Zweck
Generiert eine strukturierte Übersicht über alle verfügbaren Memory-Bereiche.  
**Parameter-basiert**: Funktioniert sowohl für Base-Memory als auch Program-Memory.

## Parameter
- `MEMORY_PATH`: Pfad zum Memory-Verzeichnis (Default: "storage/memories")
- `OUTPUT_PATH`: Pfad für Memory-Map Output (wird automatisch gesetzt)

## Ausführung

### 1. Parameter initialisieren
```bash
# Parameter aus Aufruf oder Default setzen
MEMORY_PATH=${1:-"storage/memories"}    # Default: Base-Memory
OUTPUT_PATH="$MEMORY_PATH/memory-map.md"  # Output-Datei im Memory-Verzeichnis

# Beispiele:
# generate-memory-map.md                              → storage/memories/
# generate-memory-map.md "programs/{CURRENT_PROGRAM}/memory" → programs/{CURRENT_PROGRAM}/memory/
```

### 2. Memory-Struktur scannen
```bash
# Scanne alle Memory-Dateien im angegebenen Pfad
find "$MEMORY_PATH" -name "*.md" -type f | sort
```

### 3. Memory Map erstellen
Erstelle eine strukturierte Übersicht mit folgenden Informationen pro Datei:
- **Vollständiger Pfad**: $MEMORY_PATH/topics/docker.md
- **Themenbereich**: Was behandelt diese Datei
- **Größe**: Dateigröße in Bytes/KB
- **Fakten-Anzahl**: Zähle Bullet-Points oder Einträge
- **Letzte Änderung**: Wenn erkennbar aus Inhalt

### 4. Kategorien strukturieren (pfad-agnostisch)

#### Core Memory (Immer verfügbar)
- user.md: Persönliche Basisdaten  
- preferences.md: Arbeitsstil und Kommunikation

#### Topics (Kontextsensitiv)
Für jede Datei in $MEMORY_PATH/topics/:
- Thema erkennen aus Dateiname und Inhalt
- Kurzbeschreibung (max 10 Wörter)
- Einträge zählen
- Dateigröße

#### Short-term Memory
- day.md: Heutige/aktuelle Aktivitäten
- week.md: Wochenkontext 
- month.md: Monatsübersicht

#### Conversations
- Anzahl exportierter Gespräche
- Neueste Datei und Datum

### 5. Statistiken berechnen
- Gesamtzahl Topics
- Gesamtzahl Facts (Bullet-Points)
- Gesamtspeicher
- Letzte Reorganisation (aus system.log wenn verfügbar)

### 6. Memory Map schreiben
Schreibe das Ergebnis nach: `$OUTPUT_PATH`
- Base-Memory: `storage/memories/memory-map.md`
- Program-Memory: `programs/{CURRENT_PROGRAM}/memory/memory-map.md`

Format wie im Beispiel oben - strukturiert nach Verzeichnissen, mit Pfaden und Größenangaben.

## Wichtige Regeln
1. **Pfade immer vollständig** angeben ($MEMORY_PATH/...)
2. **Größen realistisch** messen (nicht schätzen)
3. **Kategorien beibehalten** (Core, Topics, Short-term, Conversations)
4. **Leer-Einträge handhaben** (falls Dateien leer sind)
5. **Fehler dokumentieren** (falls Dateien nicht lesbar)
6. **Parameter respektieren** (Base vs Program Memory)

## Integration & Aufrufbeispiele

### Base-Memory (Default):
```bash
Read("kernel/prompts/generate-memory-map.md")  # → storage/memories/
```

### Program-Memory (Parameter):
```bash
Read("kernel/prompts/generate-memory-map.md programs/{CURRENT_PROGRAM}/memory")  # → programs/{CURRENT_PROGRAM}/memory/
```

### Via Program-Routes:
```bash
# In programs/{CURRENT_PROGRAM}/routing/program-routes.txt:
5.8:map→../../../kernel/prompts/generate-memory-map.md programs/{CURRENT_PROGRAM}/memory
```

Dieser Prompt wird automatisch ausgeführt nach memory-reorganization.md oder durch Route-Aufruf.