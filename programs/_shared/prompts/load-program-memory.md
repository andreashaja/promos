# Load Program Memory - Universal Template

## Parameter
**PROGRAM_NAME**: ${1:-"[PROGRAM_NAME_REQUIRED]"}

## Zweck
Lädt kontextabhängig relevante Memory-Bereiche des **${PROGRAM_NAME}**-Programs basierend auf User-Input.

## Intelligente Analyse

### 1. User-Eingabe analysieren
Analysiere die aktuelle User-Eingabe auf ${PROGRAM_NAME}-spezifische Bezüge:

**Erkenne Program-Keywords für ${PROGRAM_NAME}:**
- **Aufgaben-Bezug**: aufgabe, task, todo, deadline, projekt, erledigen
- **Kalender-Bezug**: termin, datum, kalender, meeting, veranstaltung
- **Notizen-Bezug**: notiz, dokumentation, wissen, artikel, idee
- **Produktivität**: workflow, routine, automatisierung, effizienz
- **Memory-Bezug**: erinnerung, information, speichern, nachschlagen
- **Tool-Integration**: synchronisation, import, export, verbindung

### 2. Relevanz-Matching mit ${PROGRAM_NAME} Memory

**Core Memory (immer laden):**
- `programs/${PROGRAM_NAME}/memory/core/user.md`
- `programs/${PROGRAM_NAME}/memory/core/preferences.md`

**Kontextbasiertes Loading:**

**Aufgaben-Kontext:**
```bash
Read("programs/${PROGRAM_NAME}/memory/tools/aufgaben.md")  # falls vorhanden
Read("programs/${PROGRAM_NAME}/memory/topics/aufgaben.md")  # falls vorhanden
```

**Kalender-Kontext:**
```bash
Read("programs/${PROGRAM_NAME}/memory/tools/kalender.md")  # falls vorhanden
Read("programs/${PROGRAM_NAME}/memory/topics/termine.md")  # falls vorhanden
```

**Notizen-Kontext:**
```bash
Read("programs/${PROGRAM_NAME}/memory/tools/notizen.md")  # falls vorhanden
Read("programs/${PROGRAM_NAME}/memory/topics/notizen.md")  # falls vorhanden
```

**Zeitbezug erkannt:**
```bash
Read("programs/${PROGRAM_NAME}/memory/short-term/day.md")    # bei "heute", "jetzt"
Read("programs/${PROGRAM_NAME}/memory/short-term/week.md")   # bei "woche", "letzte woche"
Read("programs/${PROGRAM_NAME}/memory/short-term/month.md")  # bei "monat", "letzter monat"
```

**Memory-Management:**
```bash
Read("programs/${PROGRAM_NAME}/memory/thoughts.md")  # bei memory-operationen
```

### 3. Base-System Memory Integration

**Bei Bedarf auch Base-Memory laden:**
```bash
# Nur wenn Kontext auch base-system betrifft
Read("storage/memories/core/user.md")  # für übergreifende User-Info
Read("storage/memories/topics/[RELEVANTES_TOPIC].md")  # falls crossover
```

### 4. Tool-spezifisches Loading

**Intelligent Tool Detection:**
- Erkenne aus Eingabe welche Tools relevant sind
- Lade nur die benötigten Tool-Memory-Bereiche für **${PROGRAM_NAME}**
- Vermeide unnötiges Laden aller Tools

### 5. Feedback an User

```
📚 ${PROGRAM_NAME}-Memory geladen:
✓ Core Memory (User + Preferences)
✓ [SPEZIFISCHE_BEREICHE] für [ERKANNTEN_KONTEXT]
✓ [ANZAHL] relevante Dateien ([GRÖSSE]KB)

Bereit für ${PROGRAM_NAME}-Anfrage im Kontext: [KONTEXT]
```

## Memory-Loadings-Priorität

1. **Core Memory**: Immer laden für **${PROGRAM_NAME}**
2. **Tool-Memory**: Basierend auf erkannten Keywords  
3. **Topic-Memory**: Wenn thematische Übereinstimmung
4. **Short-term**: Bei Zeitbezug
5. **Base-Memory**: Nur bei system-übergreifenden Anfragen

## Fehlerbehandlung

Falls Memory-Dateien fehlen:
- Informiere über fehlende Bereiche in **programs/${PROGRAM_NAME}/memory/**
- Lade verfügbare Alternativen
- Schlage Memory-Initialisierung für **${PROGRAM_NAME}** vor

## Parameter-Verwendung

**Aufruf aus Program-Routes:**
```bash
# In programs/assistent/routing/program-routes.txt:
memory:load→../../_shared/prompts/load-program-memory.md assistent

# In programs/selbstfuersorge/routing/program-routes.txt:
memory:load→../../_shared/prompts/load-program-memory.md selbstfuersorge
```