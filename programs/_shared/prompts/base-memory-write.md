# Base-Memory Write - Route program:base-memory-write

## Zweck
Ermöglicht explizite Writes ins Base-Memory aus Program-Kontext heraus, wenn User dies explizit wünscht.

## Sicherheitskonzept
Diese Route ist **NUR** im Program-Kontext verfügbar und erfordert **explizite User-Anweisung**.

## Trigger-Wörter (Exact Match erforderlich)
- "Speichere im Basisspeicher"
- "Für alle Programme verfügbar machen"
- "Im Base-Memory speichern"  
- "Allgemein verfügbar speichern"
- "Basisspeicher:"

## Routing-Integration
Diese Route wird automatisch erkannt durch:
```bash
# In memory-router.md oder program-routing:
if echo "$USER_INPUT" | grep -qi "speichere im basisspeicher\|base.*memory.*speicher"; then
    echo "🔄 Route program:base-memory-write"
    Read("programs/_shared/prompts/base-memory-write.md")
fi
```

## Implementierung

### 1. Explizite User-Intention prüfen
```bash
# Beispiele für explizite Anweisungen:
USER: "Speichere im Basisspeicher, dass mein Schwiegervater Werner heißt"
USER: "Mache diese Info für alle Programme verfügbar: Telefonnummer 12345"
USER: "Im Base-Memory speichern: Geburtstag 15. März"
```

### 2. Sicherheitsprüfungen
```bash
# WICHTIG: Nur bei expliziter Anweisung
if [ "$CURRENT_CONTEXT" != "base" ] && [ "$EXPLICIT_BASE_WRITE" = "true" ]; then
    # Information ins Base-Memory schreiben
    echo "$INFO" >> storage/memories/topics/personal-info.md
    echo "✅ Information im Base-Memory gespeichert"
else
    echo "❌ Explizite Base-Memory Anweisung erforderlich"
fi
```

### 3. Information kategorisieren und speichern

Die Information sollte gemäß der PROMOS Memory-Hierarchie kategorisiert werden:

**Core-Memory** (storage/memories/core/):
- `user.md`: Persönliche Daten (Name, Familie, Besitz, dauerhafte Eigenschaften)
- `preferences.md`: Dauerhafte Präferenzen und Einstellungen

**Topics** (storage/memories/topics/):
- Projektbezogenes oder thematisches Wissen
- Nur wenn es NICHT zu Core gehört

**Thoughts** (storage/memories/thoughts.md):
- Temporäre Notizen und Ideen

Für die meisten expliziten Base-Memory Speicherungen ist `core/user.md` der richtige Ort.

### 4. Schreibvorgang ausführen

Speichere die Information standardmäßig in `storage/memories/core/user.md`:

```
Write("storage/memories/core/user.md", "
## [Aktuelles Datum]
- [Information aus der User-Eingabe]
", append=true)
```

Bestätige die Speicherung:
- 📝 Information erfolgreich im Base-Memory gespeichert
- 📂 Datei: storage/memories/core/user.md
- 🔄 Alle Programme haben jetzt Zugriff (read-only)

## Sicherheitsrichtlinien

### ✅ ERLAUBT:
- Explizite User-Anweisung "Speichere im Basisspeicher..."
- Allgemeine Informationen (Name, Geburtstag, Vorlieben)
- Kontaktdaten wenn explizit gewünscht

### ❌ VERBOTEN:
- Automatische Base-Memory Writes ohne explizite Anweisung
- Sensible Daten ohne klare User-Intention
- Bulk-Transfer von Program-Memory → Base-Memory

## Workflow-Integration

### In Program-Memory Prompts einbauen:
```bash
# Bei Memory-Operationen prüfen:
if echo "$USER_INPUT" | grep -qi "basisspeicher\|base.memory\|für alle programme"; then
    echo "🔄 Weiterleitung zu Route 5.13:base-memory-write"
    Read("programs/_shared/prompts/base-memory-write.md")
fi
```

### User-Experience:
```bash
USER: "Meine Katze Lilly ist 3 Jahre alt - speichere das im Basisspeicher"

SYSTEM: 
📝 Information im Base-Memory gespeichert
📂 Datei: storage/memories/topics/personal-info.md  
🔄 Information ist jetzt für alle Programme verfügbar
💡 Tipp: In anderen Programmen kannst du nach "Lilly" suchen
```

## Integration Points

1. **Memory-Router**: Erkennt explizite Base-Write Anfragen
2. **Cross-Memory-Search**: Findet später die geschriebenen Informationen  
3. **Program-Routes**: Route program:base-memory-write nur in Program-Kontext verfügbar
4. **Security**: Keine automatischen Writes, nur auf explizite Anweisung