# Memory Reorganization Prompt

## Zweck
Automatische Verarbeitung und Sortierung von Gedanken und Fakten.
**Context-aware**: Arbeitet mit Base-Memory ODER Program-Memory je nach aktivem Context.

## Trigger
- Nach jedem Export (manuell oder durch Scheduler)
- Alle 30 Messages (durch Scheduler-Config)

## Ablauf

### 1. Context bestimmen und Memory-Pfad setzen
```bash
# Lese Context-State
Read("programs/context-state.txt")

# Setze Memory-Basis abhängig vom Context
if ACTIVE_PROGRAM != "none":
    MEMORY_BASE = "programs/{ACTIVE_PROGRAM}/storage/memories"
else:
    MEMORY_BASE = "storage/memories"
```

### 2. Thoughts.md verarbeiten (EINZIGE Quelle)
**WICHTIG:** Keine Facts-Extraktion aus Konversationen! 
Die exportierten Konversationen sind das natürliche Kurzzeitgedächtnis.

### 3. Thoughts.md analysieren
```bash
Read("{MEMORY_BASE}/thoughts.md")
```

**Thoughts.md enthält nur bewusste Speicherungen vom User ("merke dir...").**

Analysiere jeden Gedanken-Eintrag und kategorisiere:

**Kategorisierung:**
- **Core** → Aufteilen in zwei Dateien:
  
  `core/preferences.md` - NUR Persönlichkeit & Arbeitsstil:
  - Wie möchte User angesprochen werden?
  - Grundlegender Arbeitsstil (praktisch, theoretisch, etc.)
  - Dauerhafte Charaktereigenschaften
  - Kommunikationspräferenzen
  - Test: "Gilt das auch noch in 5 Jahren?"
  - NICHT: Technische Details, Versionen, Ports, Projekte
  
  `core/user.md` - Persönliche Informationen:
  - Name, Beruf, Rolle
  - Familie, Kollegen, wichtige Personen
  - Arbeitsumgebung, Firma
  - Persönliche Umstände
  - NICHT: Technische Konfigurationen

- **Existierendes Topic** → `topics/[thema].md`
  - NUR wenn die Topic-Datei bereits existiert
  - ODER wenn es sich um ein klar definiertes, zusammenhängendes Projekt handelt (z.B. PROMOS)
  - Prüfe mit: `ls storage/memories/topics/`

- **Alles andere** → `topics/unsorted-YYYY-MM.md`
  - Technische Konfigurationen (Ports, Versionen)
  - Einzelne Gedanken und Ideen
  - Thematische Notizen OHNE existierendes Topic
  - Tool-Installationen und Settings
  - TODOs ohne klaren Projektbezug
  - WICHTIG: Hier sammeln sich Fakten bis Muster erkennbar werden!
  - MONATSBASIERT: Neue Datei jeden Monat für bessere Übersicht

### 4. In Speicher schreiben

Alle Schreibvorgänge nutzen den context-abhängigen MEMORY_BASE Pfad:

#### Für {MEMORY_BASE}/core/preferences.md:
```markdown
# User Präferenzen

## Arbeitsstil
- [Wie arbeitet User am liebsten?]

## Kommunikation
- [Wie möchte User angesprochen werden?]

## Grundprinzipien
- [Dauerhafte Präferenzen]
```

#### Für core/user.md:
```markdown
# User Informationen

## Persönliche Daten
- Name: [falls bekannt]
- Beruf: [falls erwähnt]
- Rolle: [z.B. Entwickler, Designer]

## Soziales Umfeld
- Familie: [erwähnte Personen]
- Kollegen: [Arbeitsbeziehungen]
- Kontext: [Firma, Team, etc.]
```

#### Für topics/[thema].md:
```markdown
# [Thema] Topic

## Beschreibung
[Kurze Beschreibung des Themenbereichs]

## Notizen
- [Relevante Information aus Konversation]
- [Gedanke aus thoughts.md]

## TODOs/Ideen
- [Geplante Aktionen zu diesem Thema]

## Referenzen
- [Verwandte Themen oder Projekte]

*Letzte Aktualisierung: YYYY-MM-DD*
```

**Beispiele für Topics:**
- `topics/docker.md` - Alles zu Container-Technologie
- `topics/python.md` - Python-spezifische Notizen  
- `topics/psychologie.md` - Psychologie-Erkenntnisse
- `topics/promos.md` - PROMOS-Projekt spezifisch
- `topics/vim.md` - Vim-Editor Tipps und Configs

#### Für topics/unsorted-YYYY-MM.md:
```markdown
# Unsortierte Gedanken - Januar 2025

## YYYY-MM-DD
- [Gedanke 1 vom User]
- [Gedanke 2 vom User]
- [Notiz die noch kein Topic hat]
```

### 5. Gedanken-Analyse für Topic-Erkennung
```bash
# Durchsuche alle unsortierten Gedanken nach Themen-Mustern
grep -h "^- " {MEMORY_BASE}/topics/unsorted*.md | sort
```

**Muster erkennen:**
- Zähle Erwähnungen von Themen (Docker, Python, Vim, etc.)
- Lese TOPIC_CREATION_THRESHOLD aus memory-config.txt (Standard: 5)
- Bei Schwellwert-Erreichen:
  - Melde: "Erkannt: X Gedanken zu [Thema]"
  - Erstelle `topics/[thema].md`
  - Migriere relevante Einträge ins neue Topic
  - **LÖSCHE migrierte Einträge aus unsorted-YYYY-MM.md**

**Beispiel:**
Wenn in topics/unsorted steht:
- "Docker-Compose für Multi-Container"
- "Docker Desktop auf macOS installiert"
- "Docker-Integration für PROMOS geplant"
- "Docker vs Podman Vergleich"
- "Docker Registry bei :5000"

→ Erstelle `topics/docker.md`, migriere diese Einträge und LÖSCHE sie aus unsorted

### 6. Thoughts.md leeren
Nach erfolgreicher Sortierung:
```bash
Write("{MEMORY_BASE}/thoughts.md", "# Thoughts (Unverarbeitete Gedanken-Sammlung)\n\nHier sammeln sich alle extrahierten und manuell notierten Gedanken, bevor sie automatisch sortiert werden.\n")
```

### 7. Bestätigung ausgeben
```
✓ Memory-Reorganisation abgeschlossen:
  - Context: {BASE oder ACTIVE_PROGRAM}
  - Memory-Pfad: {MEMORY_BASE}
  - Y Gedanken aus thoughts.md verarbeitet
  - Z Einträge → topics/unsorted-YYYY-MM.md
  - Neue Topics erkannt: [Liste falls erstellt]
  - Bestehende Topics aktualisiert: [Liste]
  - thoughts.md geleert
  
Gedanken-Analyse:
  - Aktuelle unsortierte Einträge: [Anzahl]
  - Themen mit 3+ Erwähnungen: [Liste mit Counts]
  - Bei [THRESHOLD]+ Erwähnungen → automatisch Topic erstellt
  - Migrierte Einträge aus unsorted gelöscht: [Anzahl]
```

## Beispiel-Durchlauf

**Gegeben:**
- thoughts.md mit 3 User-Einträgen: "Merke dir: Dashboard bauen", "Merke dir: Docker nutzen", "Merke dir: Doku schreiben"
- Noch keine topics/ vorhanden (leeres System)

**Verarbeitung:**
1. Aus thoughts.md (EINZIGE Quelle):
   - "Dashboard für PROMOS bauen" → topics/unsorted-2025-01.md
   - "Docker-Integration prüfen" → topics/unsorted-2025-01.md
   - "Memory-System dokumentieren" → topics/unsorted-2025-01.md

2. Gedanken-Analyse:
   - PROMOS: 1 Erwähnung
   - Docker: 1 Erwähnung
   - Memory: 1 Erwähnung
   → Noch keine kritische Masse für automatische Topics

**Nach mehreren Sessions (Beispiel):**
Wenn topics/unsorted-2025-01.md nach mehreren "Merke dir" Anfragen enthält:
- Docker-Compose installiert
- Docker für PROMOS geplant
- Docker vs Podman verglichen
- Docker Registry konfiguriert
- Docker-Integration getestet
- Docker Performance optimiert

→ System erkennt: 6 Docker-Erwähnungen (≥ Schwellwert 5)
→ Erstellt automatisch `topics/docker.md`
→ Migriert alle Docker-Einträge dorthin
→ LÖSCHT migrierte Einträge aus topics/unsorted-2025-01.md

## Wichtige Regeln

1. **Keine Duplikate** - Prüfe ob Information bereits existiert bevor du sie hinzufügst
2. **Kontext bewahren** - Datum und Ursprung (Konversation/Thought) notieren
3. **Minimal invasiv** - Nur ANHÄNGEN zu bestehenden Dateien, nicht überschreiben
4. **Thematisch gruppieren** - Zusammengehöriges in gleiche Topics
5. **Thoughts hat Priorität** - Explizite User-Gedanken wichtiger als extrahierte Fakten
6. **Thema erkennen** - Versuche das passende Thema zu identifizieren, nicht alles ist projektbezogen

## Fehlerbehandlung

Falls Schreiben fehlschlägt:
- Gedanken in thoughts.md belassen
- User informieren welche Dateien nicht aktualisiert wurden
- Grund angeben (z.B. "topics/docker.md konnte nicht erstellt werden")

## Integration mit Export

Dieser Prompt wird automatisch nach dem Export aufgerufen. Die Reihenfolge ist:
1. Export-Conversation durchführen
2. Memory-Reorganization ausführen (dieser Prompt)
3. Context-Reset (passiert beim Session-Neustart)

### 8. Memory Map generieren
Nach erfolgreicher Reorganisation erstelle eine strukturierte Übersicht:

**Context-aware Aufruf des Memory Map Generators:**
- Für Base-Memory: `generate-memory-map.md`
- Für Program-Memory: `generate-memory-map.md "{MEMORY_BASE}"`

Der Memory Map Generator ist bereits parameter-basiert und funktioniert für beide Contexte!

**WICHTIG:** Führe alle Schritte durch, auch wenn einzelne fehlschlagen. Sammle alle Fehler und berichte sie am Ende gesammelt.