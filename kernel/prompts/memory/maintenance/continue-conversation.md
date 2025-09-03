# Continue Conversation Prompt

## Zweck
Setzt die zuletzt exportierte Konversation nahtlos fort.
**Context-aware**: Funktioniert mit Base-Memory und Program-Memory.

## Ablauf

### 1. Context bestimmen
Prüfe zuerst ob ein Program aktiv ist:
- Lies `programs/context-state.txt`
- Bei aktivem Program: Suche in `programs/{ACTIVE_PROGRAM}/storage/conversations/`
- Sonst: Suche in `storage/conversations/`

### 2. Letzte Konversation finden
```bash
# Finde die neueste exportierte Konversation im richtigen Verzeichnis
# Bei aktivem Program:
ls -t programs/{ACTIVE_PROGRAM}/storage/conversations/*.md 2>/dev/null | head -1
# Oder bei Base-Context:
ls -t storage/conversations/*.md 2>/dev/null | head -1
```

Falls keine gefunden → "Keine vorherige Konversation gefunden"

### 2. Letzte Konversation laden
```bash
Read("[gefundene-datei]")
```

### 3. Kontext extrahieren
Aus der geladenen Datei:
- **Letztes Thema** aus der Zusammenfassung
- **Letzte 3-5 Nachrichten** aus dem Dialog
- **Offene Punkte** falls erkennbar

### 4. Fortsetzung anbieten
```
Letzte Konversation: [Thema] vom [Datum]

Zusammenfassung:
[Kurze Zusammenfassung]

Letzter Stand:
**User:** [Letzte User-Nachricht]
**Assistant:** [Letzte Assistant-Antwort]

Möchtest du dort fortsetzen oder etwas Neues beginnen?
```

## Beispiel-Ausgabe
```
Letzte Konversation: "PROMOS Memory-System" vom 2025-01-24

Zusammenfassung:
Wir haben das Memory-System vereinfacht - thoughts.md nur für bewusste Speicherung,
keine Facts-Extraktion aus Konversationen, monatsbasierte unsorted-Dateien.

Letzter Stand:
**User:** Ist das Memory-System nun komplett fertig?
**Assistant:** Noch nicht ganz, es fehlen noch...

Möchtest du dort fortsetzen oder etwas Neues beginnen?
```

## Integration
- Kann manuell aufgerufen werden: `/read continue-conversation`
- Oder automatisch bei Session-Start wenn gewünscht
- Arbeitet mit exportierten Konversationen als "Kurzzeitgedächtnis"