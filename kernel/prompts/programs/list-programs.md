# List Programs

## Aufgabe
Zeige alle verfügbaren Programme in benutzerfreundlicher Form an.

## Programme scannen
1. Durchsuche programs/-Verzeichnis
2. Finde alle Unterverzeichnisse mit boot.md
3. Ignoriere _shared-Verzeichnis
4. Extrahiere Versionen aus boot.md (erste Zeile)

## Anzeige-Format
```
📦 Verfügbare Programme:

  📋 beispiel v0.1
     Beispiel-Programm für Tests und Demonstration
     Start: "Starte das Beispielprogramm" oder "beispiel"
  
  🤖 assistent v0.2  
     Persönlicher Assistent mit Memory-System
     Start: "Aktiviere den Assistent" oder "assistent"
```

## Informationen pro Programm
- **Icon**: Aus README.md oder Standard-Fallback
- **Name**: Verzeichnisname
- **Version**: Aus erster Zeile boot.md extrahiert
- **Beschreibung**: Aus README.md erste Zeile nach Titel
- **Start-Beispiele**: Verschiedene Aktivierungs-Möglichkeiten

## Technische Details
- Dynamische Erkennung zur Laufzeit
- Keine hardcodierten Programm-Listen
- Robust gegen fehlende oder beschädigte Programme
- Sortierung alphabetisch

## Ausgabe-Hinweise
- Freundliche, einladende Sprache
- Klare Start-Anweisungen
- Emojis für bessere Orientierung
- Kompakte aber informative Darstellung