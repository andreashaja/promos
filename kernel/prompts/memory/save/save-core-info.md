# Save Core Info Prompt

## Zweck
Speichert fundamentale User-Informationen und dauerhafte Präferenzen direkt in den Core-Memory-Dateien.

## Entscheidungslogik

### 1. Analysiere die Information
Prüfe: Ist das eine Core-Information die dauerhaft gespeichert werden sollte?

**Core-User-Daten** (→ `storage/memories/core/user.md`):
- Name, Alter, Geburtsdatum
- Familie (Partner, Kinder, Eltern)
- Beruf, Position, Firma
- Wohnort, Herkunft
- Ausbildung, Abschlüsse

**Core-Präferenzen** (→ `storage/memories/core/preferences.md`):
- Kommunikationsstil (keine Emojis, Deutsch, formell/informell)
- Arbeitsweise (praktisch, theoretisch, explorativ)
- Technische Präferenzen (Tools, Sprachen, Frameworks)
- Grundsätzliche Vorlieben/Abneigungen

### 2. Anwende die 5-Jahres-Regel
Frage: "Wäre diese Information in 5 Jahren noch relevant?"
- JA → Core-Info, direkt speichern
- NEIN → Nicht hier, sondern als Thought parken

### 3. Speichere die Information

**Bei User-Daten:**
1. Lade: Read("storage/memories/core/user.md")
2. Prüfe ob Information schon vorhanden
3. Ergänze/Aktualisiere die entsprechende Sektion
4. Speichere mit Edit()
5. Bestätige: "✓ Persönliche Daten gespeichert: [was wurde gespeichert]"

**Bei Präferenzen:**
1. Lade: Read("storage/memories/core/preferences.md")
2. Prüfe ob Präferenz schon vorhanden
3. Ergänze/Aktualisiere die entsprechende Sektion
4. Speichere mit Edit()
5. Bestätige: "✓ Präferenz notiert: [was wurde gespeichert]"

## Beispiele

**Eindeutige Core-Infos:**
- "Ich bin 47 Jahre alt" → user.md/Persönliche Daten
- "Meine Frau heißt Petra" → user.md/Familie
- "Ich mag keine Emojis" → preferences.md/Kommunikation
- "Ich arbeite als Softwareentwickler" → user.md/Berufliches

**KEINE Core-Infos (→ als Thought parken):**
- "Ich arbeite gerade an Projekt X" → temporär
- "Heute bin ich müde" → Momentaufnahme
- "Vielleicht sollten wir..." → Idee/Vorschlag
- "Das gefällt mir bei diesem Code" → kontextspezifisch

## Fehlerbehandlung

- **Datei existiert nicht:** Erstelle sie mit Grundstruktur
- **Information unklar:** Frage nach: "Soll ich das als [Kategorie] speichern?"
- **Widersprüchliche Info:** Weise darauf hin und frage welche gilt

## Wichtig

- Speichere NUR wenn sicher dass es Core-Info ist
- Bei Unsicherheit → lieber als Thought parken
- Keine Interpretationen, nur explizite Aussagen speichern
- Immer Speicherung bestätigen mit genauer Angabe was wo gespeichert wurde