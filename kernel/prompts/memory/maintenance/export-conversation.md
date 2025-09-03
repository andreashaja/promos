# Export-Konversation Prompt

## WICHTIGSTE REGEL
**EXPORTIERE DEN EXAKTEN WORTLAUT!** Keine Zusammenfassung, keine Paraphrasierung, keine Kürzung. Jedes Wort von User und Assistant muss 1:1 übernommen werden.

## Context-Aware Export
Dieses System arbeitet sowohl mit Base-Memory als auch mit Program-Memory!

## Ablauf

### 1. Context bestimmen und Export-Pfad setzen
```bash
# Lese Context-State
Read("programs/context-state.txt")

# Setze Export-Pfad abhängig vom Context
if ACTIVE_PROGRAM != "none":
    EXPORT_PATH = "programs/{ACTIVE_PROGRAM}/storage/conversations"
else:
    EXPORT_PATH = "storage/conversations"
```

### 2. Letzten Export finden
```bash
# Finde die neueste Datei im context-spezifischen Verzeichnis
ls -t {EXPORT_PATH}/*.md 2>/dev/null | head -1
```
Falls keine Datei gefunden → Vollexport der kompletten Konversation

### 3. Letzten Export-Punkt identifizieren
Wenn eine Datei gefunden wurde:
- Lies die Datei mit `Read()`
- Finde die letzten 2-3 Nachrichten (User und Assistant)
- Merke dir den EXAKTEN Wortlaut als Marker

### 4. Überlappung im Context finden
- Durchsuche deinen aktuellen Context nach dem EXAKTEN Wortlaut des Markers
- **WICHTIG:** Der Text muss WORTWÖRTLICH übereinstimmen
- Gefunden → Exportiere alles NACH diesem Punkt
- Nicht gefunden → Exportiere ALLES (Vollexport)

### 5. Export erstellen
**FORMAT:**
```markdown
# Konversation: [Thema]
**Datum:** YYYY-MM-DD  
**Teilnehmer:** [User] & Claude
**Thema:** [Aus erster Nachricht ableiten]

---

## Zusammenfassung

[Kurze Zusammenfassung der Hauptthemen - maximal 5 Zeilen]

## Dialog

**User:** [EXAKTER WORTLAUT der Nachricht]

**Assistant:** [EXAKTER WORTLAUT der Antwort]

**User:** [EXAKTER WORTLAUT]

**Assistant:** [EXAKTER WORTLAUT]

[...und so weiter bis zum Ende]
```

### 6. Datei speichern

**WICHTIG: Bei Inkrement-Export IMMER NEUE DATEI erstellen!**

```bash
# Dateiname mit aktuellem Timestamp: YYYY-MM-DD-HHMM-thema.md
# NIEMALS die alte Datei überschreiben!
# Nutze den context-spezifischen Pfad:
Write("{EXPORT_PATH}/2025-01-17-1430-fortsetzung.md", content)
```

**Regel:**
- Erster Export: `2025-01-17-1430-promos-test.md`
- Zweiter Export: `2025-01-17-1435-promos-fortsetzung.md` (NEUE DATEI!)
- Dritter Export: `2025-01-17-1440-promos-fortsetzung-2.md` (WIEDER NEUE DATEI!)

## KRITISCHE PUNKTE

### Was MUSS beibehalten werden:
- **JEDES EINZELNE WORT** im Original (aber OHNE System-Informationen)
- Alle Satzzeichen, Zeilenumbrüche, Formatierungen
- Code-Beispiele die User oder Assistant geschrieben haben
- Fehler, Tippfehler, alles bleibt wie es war

### Was MUSS ENTFERNT werden:
- ⚠️ [ROUTE: X] Markierungen
- ⚠️ Navigation-Meldungen ("Navigation durch Sub-Routes...")
- ⚠️ System-Status-Meldungen
- ⚠️ Tool-Aufrufe und deren Ausgaben

### Was DARF NICHT passieren:
- ❌ Zusammenfassen ("User fragte nach X")
- ❌ Umformulieren ("Der User wollte wissen...")
- ❌ Kürzen oder Auslassen von echtem Dialog
- ❌ Interpretieren oder Erklären

### Beispiel FALSCH:
```
**User:** Der User fragte nach dem Export-Feature

**Assistant:** [ROUTE: 1] Ich erklärte die Funktionsweise
```

### Beispiel RICHTIG:
```
**User:** Wie funktioniert das mit dem Export?

**Assistant:** Der Export funktioniert so, dass ich die letzte gespeicherte Konversation...
```

### Beispiel: Routing-Info ENTFERNEN
**Im Context steht:**
```
**Assistant:** [ROUTE: 6] Direkte Antwort - keine Tools nötig

Das ist die Antwort auf deine Frage.
```

**Im Export schreiben:**
```
**Assistant:** Das ist die Antwort auf deine Frage.
```

## Fehlerbehandlung

- Ordner existiert bereits → KEIN mkdir ausführen! (storage/conversations/ ist immer da)
- Keine alte Konversation → Vollexport
- Context zu lang → Exportiere was verfügbar ist
- Unsicher über Überlappung → Lieber Vollexport als Datenverlust
- NIEMALS alte Export-Dateien überschreiben → Immer neue Datei mit neuem Timestamp

## Test-Kriterium

Nach dem Export muss man die Datei öffnen und es muss sich anfühlen, als würde man das ORIGINAL-GESPRÄCH lesen, nicht eine Nacherzählung.

**MERKE:** Du bist ein Kopierer, kein Geschichtenerzähler!

## Nach dem Export

**WICHTIG:** Keine weiteren Aktionen hier!
Die Scheduler-Config orchestriert die verkettete Ausführung:
- Export → Memory-Reorganisation → Results-Map Update

Siehe `kernel/config/scheduler-config.txt` für die Konfiguration.