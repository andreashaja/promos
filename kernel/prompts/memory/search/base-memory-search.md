# Base-Memory Search - Kernel

## Zweck
Durchsucht das Base-Memory (storage/memories/*) nach Informationen. Program-agnostisch und universell verwendbar.

## Anwendung
Wird von Program-Memory-Search aufgerufen wenn im Program-Memory nichts gefunden wurde.

## Search-Hierarchie
```bash
# Base-Memory Structure durchsuchen
SEARCH_TERM="$1"

# 1. Core User-Info
if [ -f "storage/memories/core/user.md" ]; then
    grep -i "$SEARCH_TERM" storage/memories/core/user.md
fi

# 2. Topics durchsuchen
for topic_file in storage/memories/topics/*.md; do
    if [ -f "$topic_file" ]; then
        grep -i "$SEARCH_TERM" "$topic_file"
    fi
done

# 3. Unsorted Memory
if [ -f "storage/memories/unsorted.md" ]; then
    grep -i "$SEARCH_TERM" storage/memories/unsorted.md
fi
```

## Sicherheit
- **Read-only Zugriff** auf Base-Memory
- **Keine Program-spezifische Logik**
- **Universell verwendbar** von allen Kontexten

## Rückgabe-Format
```bash
# Bei Fund:
echo "📂 Base-Memory: $SEARCH_TERM gefunden in $FILE"
echo "📄 Content: $MATCHED_CONTENT"

# Bei leerem Ergebnis:
echo "❌ $SEARCH_TERM nicht im Base-Memory gefunden"
```

## Integration
```bash
# Aufruf von anderen Prompts:
Read("kernel/prompts/base-memory-search.md") "$SEARCH_TERM"
```