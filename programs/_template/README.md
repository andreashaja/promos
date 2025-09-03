# 🚀 Neues PROMOS-Programm erstellen

## Schnellstart

1. **Kopiere diesen ganzen `_template` Ordner**
   ```bash
   cp -r _template mein-programm
   ```

2. **Benenne `boot.template.md` zu `boot.md` um**
   ```bash
   cd mein-programm
   mv boot.template.md boot.md
   ```

3. **Passe die Dateien an:**
   - `boot.md` - Name, Version und Beschreibung
   - `README.md` - Diese Datei hier ersetzen
   - `routing/program-routes.txt` - Deine Routes definieren

4. **Fertig!** 
   Dein Programm erscheint beim nächsten Session-Start

## Ordner-Struktur

```
mein-programm/
├── boot.md                 # Program-Bootstrap (PFLICHT!)
├── README.md              # Dokumentation (optional)
├── storage/               # Program-Storage (wie Base-System)
│   ├── conversations/     # Program-spezifische Konversationen
│   └── memories/          # Program-Memory
│       ├── thoughts.md    # Unverarbeitete Gedanken
│       ├── topics/        # Thematisch sortierte Infos
│       ├── core/          # Essenzielle Program-Infos
│       └── memory-map.md  # Memory-Übersicht
├── prompts/               # Program-spezifische Prompts
│   └── *.md              # Deine eigenen Prompts
├── results/               # Arbeitsergebnisse
│   └── *                 # Beliebige Struktur
└── routing/               # Navigation
    └── program-routes.txt # Route-Definitionen
```

## Icon festlegen

In der ersten Zeile deiner README.md kannst du ein Icon definieren:
- 🤖 Roboter
- 🌱 Wachstum
- 🧪 Experiment
- 📋 Standard
- 🔧 Werkzeug
- ⚡ Energie
- 🎯 Ziel
- 📊 Analyse
- 💡 Idee
- 🚀 Rakete

Das erste gefundene Icon wird beim Session-Start angezeigt.

## Tips

- Programme mit `_` am Anfang werden NICHT gelistet
- Ohne `boot.md` wird das Programm ignoriert
- Storage ist isoliert vom Base-System
- Results sind program-spezifisch geschützt
- Conversations bleiben im Program-Kontext

---
*PROMOS Program Template v1.0*