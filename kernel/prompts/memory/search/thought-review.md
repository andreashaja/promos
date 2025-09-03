# Thought Review Prompt

## Zweck
Systematisches Durchgehen und Priorisieren der gesammelten Gedanken und Ideen.

## Trigger-Phrasen
- "Was haben wir für Ideen gesammelt?"
- "Zeige geparkte Gedanken"
- "Review Gedanken"
- "Was steht im Backlog?"
- "Welche TODOs haben wir?"

## Ablauf

### 1. Gedanken laden
Lade die zentrale Gedanken-Sammlung:
```bash
Read("storage/memories/thoughts.md")
```

### 2. Einträge parsen
Durchsuche die Datei nach allen Gedanken-Einträgen (Format: ## Datum Zeit)

### 3. Strukturierte Ausgabe erstellen

**Format:**
```markdown
# Gedanken-Review

## Statistik
- Gesamt: [Anzahl] Gedanken
- Zeitraum: [Ältester] bis [Neuester]
- Häufigste Kontexte: [Top 3]

## Nach Datum (neueste zuerst)

### [Datum]
**Kontext:** [Thema]
**Gedanke:** [Inhalt]
---

### [Datum]
**Kontext:** [Thema]
**Gedanke:** [Inhalt]
---

## Gruppiert nach Kontext

### [Kontext-Name] ([Anzahl] Einträge)
1. [Gedanke 1]
2. [Gedanke 2]

## Empfohlene Aktionen
Basierend auf den Gedanken schlage ich vor:
1. [Häufigste Themen zu Topics machen]
2. [Zusammenhängende Ideen gruppieren]
3. [Alte Gedanken archivieren]
```

### 4. Interaktive Optionen anbieten

Nach dem Review fragen:
```
Möchtest du:
1. Einen Gedanken zu einem Topic ausbauen?
2. Mehrere Gedanken zusammenführen?
3. Gedanken als erledigt markieren?
4. Alte Gedanken archivieren?
```

### 5. Optional: Gedanken bearbeiten

Wenn User einen Gedanken auswählt:
- In aktives Topic umwandeln
- Als Fakt speichern
- Als erledigt markieren
- Löschen

## Beispiel-Output

```markdown
# Gedanken-Review

## Statistik
- Gesamt: 5 Gedanken
- Zeitraum: 2025-01-15 bis 2025-01-17
- Häufigste Kontexte: Export-System (2), Memory (2), UI (1)

## Nach Datum (neueste zuerst)

### 2025-01-17 15:00
**Kontext:** Export-System
**Gedanke:** Dashboard für Metriken bauen
---

### 2025-01-17 14:30
**Kontext:** Memory
**Gedanke:** Automatische Kategorisierung mit KI
---

### 2025-01-16 10:00
**Kontext:** Export-System
**Gedanke:** Versionierung von Exports
---

## Gruppiert nach Kontext

### Export-System (2 Einträge)
1. Dashboard für Metriken bauen
2. Versionierung von Exports

### Memory (2 Einträge)
1. Automatische Kategorisierung mit KI
2. Gedächtnis-Kompression für alte Daten

Möchtest du einen dieser Gedanken weiter bearbeiten?
```

## Wichtige Regeln

1. **Nicht automatisch bearbeiten** - nur zeigen und Optionen anbieten
2. **Kontext bewahren** - zeige wann und wobei die Idee entstand
3. **Gruppierung** - hilft Muster zu erkennen
4. **Keine Bewertung** - alle Gedanken sind gleichwertig bis User priorisiert