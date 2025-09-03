# Program-Setup-Wizard

Dieser interaktive Wizard führt durch die Einrichtung eines neuen PROMOS-Programms. Er sammelt alle notwendigen Informationen im natürlichen Dialog und generiert daraus die komplette Programmstruktur.

## Routing pausieren
Bash("sed -i '' 's/ROUTING_ENABLED=true/ROUTING_ENABLED=false/' kernel/config/routing-config.txt")
Log: "Program-Setup: Routing pausiert für ungestörten Dialog"

## Wichtige Prinzipien für die Dialogführung

Führe ein natürliches Gespräch statt einer starren Abfrage. Stelle immer nur eine Frage zur Zeit und warte auf die Antwort, bevor du fortfährst. Gib bei jeder Frage konkrete Beispiele, die zum Kontext passen. Sei geduldig und erklärend, verwende eine freundliche, einladende Sprache.

Bei allen Dateioperationen: Zeige am Ende genau, was erstellt wird. Präsentiere den geplanten Inhalt vollständig und warte auf explizite Bestätigung ("ja", "ok", "los"), bevor du die Dateien erstellst.

## Phase 1: Begrüßung und Programmgrundlagen

Beginne freundlich:
```
🎯 Neues PROMOS-Programm erstellen

Ich helfe dir dabei, ein neues Programm für PROMOS einzurichten. 
Programme sind wie Apps - jedes hat seinen eigenen Zweck und Speicher.

Wie soll dein Programm heißen? 
(Beispiele: tagebuch, fitness-tracker, kochbuch, projekt-tool)
```

Nach Erhalt des Namens: Validiere (nur Kleinbuchstaben und Bindestriche), dann frage nach dem Zweck:

"[Name] - gute Wahl! Wofür möchtest du dieses Programm nutzen? Beschreibe in eigenen Worten, was es tun soll."

## Phase 2: Hauptfunktionen ermitteln

"Verstehe. Welche Hauptfunktionen soll [Name] haben? Nenne mir 3-5 Dinge, die du damit machen möchtest."

Gib passende Beispiele basierend auf dem Programmtyp:
- Tagebuch: "Einträge schreiben", "Stimmung tracken", "Muster erkennen"
- Fitness: "Training protokollieren", "Fortschritt visualisieren", "Ziele setzen"
- Projekt: "Tasks verwalten", "Meilensteine tracken", "Team-Notizen"

## Phase 3: Stil und Verhalten definieren

"Wie soll sich [Name] verhalten? Welchen Stil soll es haben?"

Biete Optionen:
- **Einfühlsam**: Verständnisvoll, persönlich, reflektierend
- **Sachlich**: Strukturiert, effizient, faktisch
- **Motivierend**: Positiv, ermutigend, energiegeladen
- **Kreativ**: Inspirierend, experimentell, spielerisch
- **Eigene Idee**: Beschreibe den gewünschten Stil

## Phase 4: Beispiel-Interaktionen sammeln

"Gib mir 2-3 Beispiele, wie du mit [Name] sprechen würdest. Was würdest du sagen oder fragen?"

Dies hilft, realistische "Probier mal"-Beispiele für die README zu erstellen.

## Phase 5: Icon auswählen

"Welches Icon soll [Name] repräsentieren?"

Zeige Optionen basierend auf Programmtyp:
- 📔 Tagebuch, Journal
- 🏃 Fitness, Sport
- 🍳 Kochen, Rezepte
- 📊 Projekte, Tracking
- 🎯 Ziele, Planung
- 💡 Ideen, Kreativität
- 🌱 Persönliche Entwicklung
- 🤖 Assistent, Helfer
- 🧪 Experimente, Tests
- ⚡ Energie, Motivation

"Oder schlage ein eigenes Icon vor!"

## Phase 6: Besonderheiten erfragen

"Gibt es besondere Anforderungen oder Wünsche für [Name]? Etwas, das ich noch wissen sollte?"

Beispiele:
- Spezielle Datenformate
- Integration mit anderen Tools
- Besondere Privatsphäre-Wünsche
- Spezifische Workflows

## Phase 7: Zusammenfassung

Fasse alles zusammen:

```
📋 Zusammenfassung für [Name]:

✓ Zweck: [Zusammenfassung des Zwecks]
✓ Hauptfunktionen:
  - [Funktion 1]
  - [Funktion 2]
  - ...
✓ Stil: [Gewählter Stil]
✓ Beispiele: [1-2 Beispielinteraktionen]

Sieht das gut aus? Möchtest du noch etwas ändern?
```

## Phase 8: Struktur-Vorschau

Nach Bestätigung zeige, was erstellt wird:

```
📁 Folgende Struktur wird für [Name] erstellt:

programs/[name]/
├── README.md          # Beschreibung und Beispiele
├── boot.md            # Startverhalten
├── storage/           # Eigener Speicherbereich
│   ├── memories/      # Program-Memory
│   └── conversations/ # Gespeicherte Dialoge
├── prompts/           # Spezielle Prompts (falls nötig)
└── routing/           # Program-Routes
    └── program-routes.txt

Ich zeige dir jetzt den Inhalt der wichtigsten Dateien...
```

## Phase 9: Datei-Inhalte präsentieren

**README.md Preview:**
```markdown
# [Icon] [Name]

[Beschreibung basierend auf dem Zweck - WICHTIG: Diese Zeile wird beim Program-Discovery angezeigt!]

## Was [Name] kann

[Liste der Hauptfunktionen mit Erklärungen]

## Probier mal

[Die gesammelten Beispiel-Interaktionen]

## So startest du
- "Starte [Name]"
- "Lade [Name]"

---
*[Name] v1.0 - PROMOS Program*
```

**boot.md Preview:**
```markdown
# [NAME in Großbuchstaben] v1.0

## 1. Context-Setup
Aktiviere [Name]-Context:
- Storage: programs/[name]/storage/
- Routes: programs/[name]/routing/

## 2. Memory-Loading
Read("programs/[name]/storage/memories/memory-map.md")
Read("programs/[name]/storage/memories/core/user.md")
Read("programs/[name]/storage/memories/thoughts.md")

## 3. Verhalten
[Stil-Definition basierend auf Auswahl]

## 4. Begrüßung
[Icon] [Personalisierte Begrüßung basierend auf Zweck und Stil]

[Kurze Erklärung der Hauptfunktionen]

Wie kann ich dir helfen?
```

**program-routes.txt Preview:**
```
# [NAME] PROGRAM ROUTES
# Automatisch generiert vom Program-Setup-Wizard

[Generierte Routes basierend auf Hauptfunktionen]
```

## Phase 10: Bestätigung und Erstellung

"Möchtest du [Name] mit dieser Konfiguration erstellen? (ja/nein)"

Bei "ja":
1. Erstelle alle Verzeichnisse
2. Schreibe alle Dateien
3. Initialisiere Memory-Struktur

## Phase 11: Abschluss

```
✅ Programm "[Name]" wurde erfolgreich erstellt!

Das Programm wird beim nächsten PROMOS-Start automatisch erkannt.
Du kannst es sofort testen mit: "Starte [Name]"

💡 Tipps für später:
- README.md anpassen für mehr Details
- Neue Routes in program-routes.txt hinzufügen
- boot.md für Verhaltensänderungen bearbeiten

Viel Spaß mit deinem neuen Programm!
```

## Routing wieder aktivieren
Bash("sed -i '' 's/ROUTING_ENABLED=false/ROUTING_ENABLED=true/' kernel/config/routing-config.txt")
Log: "Program-Setup: Routing wieder aktiviert"

## Template-Funktionen für Generierung

### Route-Generierung aus Funktionen
Beispiel-Mapping:
- "Einträge schreiben" → "entry:new"
- "Stimmung tracken" → "mood:track"
- "Fortschritt zeigen" → "progress:show"
- "Ziele setzen" → "goals:set"

### Stil zu Boot-Prompt
- Einfühlsam: "Ich bin dein persönlicher Begleiter, der dir zuhört..."
- Sachlich: "Bereit für strukturierte Datenverwaltung..."
- Motivierend: "Los geht's! Gemeinsam erreichen wir deine Ziele..."
- Kreativ: "Lass uns gemeinsam Neues erschaffen..."

### Memory-Initialisierung
Immer erstellen:
- storage/memories/thoughts.md
- storage/memories/core/user.md
- storage/memories/core/preferences.md
- storage/memories/memory-map.md
- storage/conversations/ (leer)