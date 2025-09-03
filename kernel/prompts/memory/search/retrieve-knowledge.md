# Retrieve Knowledge Prompt

## Zweck
Durchsucht das organisierte Gedächtnis-System nach relevanten Informationen zu einem Thema.

## Trigger-Phrasen
- "Was weißt du über [Thema]?"
- "Zeige Infos zu [Thema]"
- "Was haben wir zu [Thema] gespeichert?"
- "Gibt es Notizen zu [Thema]?"
- "Suche Wissen über [Thema]"

## Ablauf

### 1. Thema identifizieren
Extrahiere das Thema/Keyword aus der User-Anfrage.

### 2. Systematische Suche

**Reihenfolge der Durchsuchung:**

#### a) Kontext-Memory prüfen (IMMER ZUERST)
```bash
# Durchsuche aktuellen Conversation-Context
# Das LLM hat Zugriff auf den gesamten Chat-Verlauf
# Suche nach Erwähnungen des Themas in den letzten Nachrichten
```
**WICHTIG**: Auch wenn nichts im permanenten Memory gefunden wird, prüfe IMMER den aktuellen Conversation-Context auf relevante Informationen!

#### b) Core Memory prüfen
```bash
# User-Informationen und Präferenzen
Read("storage/memories/core/user.md")      # Persönliche Daten, Familie, Beruf
Read("storage/memories/core/preferences.md") # Arbeitsstil, Kommunikation
```
Suche nach Bezügen zum Thema in permanenten User-Infos und Präferenzen.

#### b) Topics durchsuchen
```bash
# Liste alle Topic-Dateien
ls storage/memories/topics/*.md

# Prüfe Dateinamen auf Thema
# z.B. wenn Thema="Docker" → docker.md oder container.md

# Lese relevante Topic-Dateien
Read("storage/memories/topics/[relevant].md")
```

#### c) Facts durchsuchen
```bash
# Durchsuche chronologische Facts
grep -i "[thema]" storage/memories/topics/unsorted*.md
```
Suche nach Einzelfakten, die das Thema erwähnen.

### 3. Ergebnisse strukturieren

**Ausgabeformat:**
```markdown
# Gespeichertes Wissen zu: [Thema]

## Gefunden in Topics
### [topic-name.md]
- [Relevante Inhalte]
- [...]

## Gefunden in Facts
### [YYYY-MM.md]
- [Relevante Fakten mit Datum]
- [...]

## Gefunden in Core
- [Falls User-Präferenzen zum Thema existieren]

## Zusammenfassung
[Kurze Synthese des gefundenen Wissens]

---
*Durchsuchte Bereiche: core (2 Dateien), topics (X Dateien), facts (Y Dateien)*
```

### 4. Keine Treffer

Falls nichts gefunden:
```markdown
# Kein gespeichertes Wissen zu: [Thema]

Ich habe keine spezifischen Informationen zu "[Thema]" in deinem Gedächtnis gefunden.

Durchsucht wurden:
- Core Memory (user.md, preferences.md)
- Topics (X Dateien)
- Facts (Y Monate)

Möchtest du etwas zu diesem Thema speichern?
```

## Beispiel

**User:** "Was weißt du über Docker?"

**System durchsucht:**
1. core/preferences.md → findet "bevorzugt Docker über Podman"
2. topics/docker.md → findet komplette Docker-Notizen
3. topics/unsorted2025-01.md → findet "Docker-Compose Version 2.23 installiert"

**Ausgabe:**
```markdown
# Gespeichertes Wissen zu: Docker

## Gefunden in Topics
### docker.md
- Standard Docker-Compose Setup für Projekte
- Bevorzugte Base-Images: alpine, debian-slim
- Multi-stage Build Pattern für Go-Apps

## Gefunden in Facts
### 2025-01.md
- Docker-Compose Version 2.23 installiert (2025-01-15)
- Portainer läuft auf Port 9000

## Gefunden in Core
- Präferenz: Docker über Podman für Container
- Verwendet Docker Desktop auf macOS

## Zusammenfassung
Du arbeitest regelmäßig mit Docker, bevorzugst Alpine-basierte Images und nutzt Docker-Compose für Multi-Container-Setups. Portainer ist als Management-UI installiert.
```

## Wichtige Regeln

1. **Nur GESPEICHERTES Wissen** - keine allgemeinen Infos über das Thema
2. **Quellenangabe** - zeige immer, wo die Info gefunden wurde
3. **Vollständigkeit** - durchsuche ALLE relevanten Bereiche
4. **Relevanz** - filtere nur wirklich themenbezogene Inhalte

## Integration mit Memory-System

Diese Funktion liest NUR aus dem organisierten Wissen:
- `core/` - dauerhaft wichtige User-Infos
- `topics/` - thematisch gruppierte Informationen  
- `topics/unsorted` - chronologische Einzelfakten

Sie greift NICHT auf `thoughts.md` zu (das sind unverarbeitete Gedanken).