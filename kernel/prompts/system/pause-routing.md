# Routing pausieren

## Aufgabe
Pausiere das automatische Routing für ungestörte Dialoge.

## Durchführung

### 1. Routing deaktivieren
Bash("sed -i '' 's/ROUTING_ENABLED=true/ROUTING_ENABLED=false/' kernel/config/routing-config.txt")

### 2. Bestätigung anzeigen
```
✅ Routing pausiert!

Was das bedeutet:
• Keine automatischen Prompt-Ladungen
• Direkter Dialog ohne Unterbrechungen
• Perfekt für Wizards oder längere Gespräche

Zum Reaktivieren sage z.B.:
• Router einschalten
• Routing aktivieren
• Normale Navigation

Das System erkennt diese Befehle auch im pausierten Zustand.
```

### 3. Wichtiger Hinweis
Die Pausierung bleibt über Sessions hinweg aktiv, bis sie explizit wieder aktiviert wird.