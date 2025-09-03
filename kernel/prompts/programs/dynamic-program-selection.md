# Dynamic Program Selection

## Aufgabe
Erkenne Programm-Namen in User-Input und aktiviere das entsprechende Programm automatisch.

## Programm-Erkennung
Suche im User-Input nach:
- Direkten Programm-Namen: "beispiel", "assistent", etc.
- Umschreibungen: "Beispielprogramm", "Assistenten-Programm"
- Start-Befehle: "starte beispiel", "aktiviere assistent"

## Verfügbare Programme
Dynamische Erkennung basierend auf programs/-Verzeichnis:
- Alle Unterverzeichnisse mit boot.md sind gültige Programme
- Ignoriere _shared-Verzeichnis

## Automatische Weiterleitung
Bei erkanntem Programm-Namen:
```
Read("programs/{PROGRAM_NAME}/boot.md")
```

## Beispiele
- "Starte das Beispielprogramm" → Read("programs/beispiel/boot.md")
- "Aktiviere den Assistent" → Read("programs/assistent/boot.md") 
- "beispiel" → Read("programs/beispiel/boot.md")
- "Starte das Programm Testprogramm" → Read("programs/test-program/boot.md")
- "lade test-program" → Read("programs/test-program/boot.md")

## Fehlerbehandlung
Falls Programm nicht gefunden:
- Zeige verfügbare Programme über list-programs
- Erkläre korrekte Programm-Namen

## Wichtig
- NIEMALS start.sh verwenden
- IMMER boot.md für Programm-Aktivierung
- Programme sind case-insensitive erkennbar