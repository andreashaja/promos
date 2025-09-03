# Generate Results Map Prompt (Program-spezifisch)

## Zweck
Generiert eine strukturierte Übersicht über alle verfügbaren Results im aktuellen Program-Kontext.
Funktioniert analog zum Memory-Map Generator, aber für Results-Ordner.

## Parameter
- `PROGRAM_PATH`: Pfad zum aktuellen Program-Verzeichnis (wird automatisch ermittelt)
- `RESULTS_PATH`: `$PROGRAM_PATH/results/` 
- `OUTPUT_PATH`: `$RESULTS_PATH/results-map.md`

## Ausführung

### 1. Program-Kontext ermitteln
```bash
# Ermittle aktuelles Program aus Context oder Routing-State
# Beispiele:
# - programs/{CURRENT_PROGRAM}/results/
# - programs/{ANY_PROGRAM}/results/
PROGRAM_PATH=${1:-$(pwd | grep -o "programs/[^/]*" | head -1)}
RESULTS_PATH="$PROGRAM_PATH/results"
OUTPUT_PATH="$RESULTS_PATH/results-map.md"
```

### 2. Results-Struktur scannen
```bash
# Scanne alle Dateien im Results-Verzeichnis
if [ -d "$RESULTS_PATH" ]; then
    find "$RESULTS_PATH" -type f | sort
else
    echo "Results-Ordner nicht gefunden: $RESULTS_PATH"
    exit 1
fi
```

### 3. Results-Map erstellen
Erstelle eine strukturierte Übersicht mit folgenden Informationen pro Datei/Ordner:
- **Vollständiger Pfad**: Relativ zu results/
- **Dateityp**: .md, .pdf, .txt, etc.
- **Größe**: Dateigröße in KB
- **Inhaltsbeschreibung**: Erste Zeilen oder Titel extrahieren
- **Letzte Änderung**: Modification date

### 4. Ordnerstruktur erfassen

#### User-definierte Ordner
Scanne alle Unterordner in results/ und erfasse:
- Ordnername
- Anzahl Dateien
- Gesamtgröße
- Kurzbeschreibung basierend auf Inhalten

#### Einzeldateien
Für jede Datei direkt in results/:
- Dateiname und Typ
- Größe
- Erste Zeile als Beschreibung (für .md Dateien)

### 5. Results-Map Struktur
```markdown
# Results Map - [PROGRAM_NAME]

**Letzte Aktualisierung**: YYYY-MM-DD  
**Results Pfad**: programs/{CURRENT_PROGRAM}/results/  
**Generierungsgrund**: Session-Export / Results-Reorganisation

## Ordnerstruktur

### [user-ordner-1]/
- **[datei1.md]**: Beschreibung, 5.2 KB
- **[datei2.pdf]**: Beschreibung, 15.3 KB
- **Gesamt**: 3 Dateien, 25.8 KB

### [user-ordner-2]/
- **[bericht.md]**: Analysebericht, 8.1 KB
- **Gesamt**: 1 Datei, 8.1 KB

## Einzeldateien in results/

### results-map.md
- **Typ**: Automatisch generierte Übersicht
- **Größe**: 2.1 KB  
- **Status**: Diese Datei

### [andere-datei.md]
- **Beschreibung**: [Erste Zeile der Datei]
- **Größe**: X.X KB
- **Letzte Änderung**: YYYY-MM-DD

## Statistiken
- **Ordner gesamt**: X
- **Dateien gesamt**: Y  
- **Gesamtspeicher**: Z KB
- **Results-Map generiert**: YYYY-MM-DD (Session-Export)

## Schnellzugriff
- **Neueste Datei**: [dateiname] (YYYY-MM-DD)
- **Größte Datei**: [dateiname] (XX KB)
- **Häufigste Dateitypen**: .md (X), .pdf (Y), .txt (Z)

---
*Auto-generiert durch PROMOS Results-System*
```

### 6. Results-Map schreiben
Schreibe das Ergebnis nach: `$OUTPUT_PATH`
- Program-spezifisch: `programs/{CURRENT_PROGRAM}/results/results-map.md`
- Überschreibt vorherige Version vollständig

## Wichtige Regeln
1. **Program-Isolation**: Nur Results des aktuellen Programs scannen
2. **Größen realistisch messen**: Verwende `du -h` für Genauigkeit
3. **User-Struktur respektieren**: Keine Umorganisation der User-Ordner
4. **Fehlerbehandlung**: Falls Ordner leer oder nicht existent → leere Map erstellen
5. **Sicherheit**: Nur lesende Zugriffe auf Results-Dateien

## Integration & Aufrufbeispiele

### Bei Session-Export:
```bash
# In export-conversation.md nach Memory-Reorganisation:
Read("kernel/prompts/generate-results-map.md")
```

### Via Program-Routes (optional):
```bash
# In programs/{CURRENT_PROGRAM}/routing/routes.txt:
8.1:results-map→../../../kernel/prompts/generate-results-map.md
```

### Manual über Config:
```bash
# User-Command: "Aktualisiere Results-Map"
→ Route zu generate-results-map.md
```

## Fehlerbehandlung
- **Kein results/ Ordner**: Erstelle leere Map mit Hinweis
- **Leerer results/ Ordner**: Map mit "Noch keine Results erstellt"
- **Lesefehler**: Datei in Map markieren als "Nicht lesbar"
- **Schreibfehler**: User informieren, alte Map beibehalten

Dieser Prompt wird automatisch nach Export-Conversation und Memory-Reorganisation ausgeführt.