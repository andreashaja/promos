# Program Memory Search - Universal Template

## Parameter
**PROGRAM_NAME**: ${1:-"[PROGRAM_NAME_REQUIRED]"}

## Zweck
Durchsucht hierarchisch Memory-Bereiche für das **${PROGRAM_NAME}**-Program mit Fallback-Strategy.

## Search-Hierarchie

### **Schritt 0: IMMER ZUERST - Conversation-Context**
```bash
SEARCH_TERM="$2"
echo "🔍 Hierarchische Memory-Search für: $SEARCH_TERM"

# Context hat höchste Priorität
Read("kernel/prompts/context-search.md") "$SEARCH_TERM"

# Falls im Context gefunden - STOP
if [ "$CONTEXT_FOUND" = "true" ]; then
    echo "✅ Information im Conversation-Context verfügbar"
    return 0
fi
```

### **Schritt 1: Program-Memory durchsuchen**
```bash
echo "📂 Durchsuche ${PROGRAM_NAME}-Memory..."

# Core Memory (immer durchsuchen)
if [ -f "programs/${PROGRAM_NAME}/memory/core/user.md" ]; then
    grep -i "$SEARCH_TERM" "programs/${PROGRAM_NAME}/memory/core/user.md"
fi

if [ -f "programs/${PROGRAM_NAME}/memory/core/preferences.md" ]; then
    grep -i "$SEARCH_TERM" "programs/${PROGRAM_NAME}/memory/core/preferences.md"
fi

# Topics durchsuchen
for topic_file in programs/${PROGRAM_NAME}/memory/topics/*.md; do
    if [ -f "$topic_file" ]; then
        if grep -qi "$SEARCH_TERM" "$topic_file"; then
            echo "📄 Gefunden in: $topic_file"
            grep -i "$SEARCH_TERM" "$topic_file"
            PROGRAM_FOUND=true
        fi
    fi
done

# Short-term Memory
for timeframe in day week month; do
    if [ -f "programs/${PROGRAM_NAME}/memory/short-term/$timeframe.md" ]; then
        if grep -qi "$SEARCH_TERM" "programs/${PROGRAM_NAME}/memory/short-term/$timeframe.md"; then
            echo "📅 Gefunden in $timeframe-Memory: $topic_file"
            grep -i "$SEARCH_TERM" "programs/${PROGRAM_NAME}/memory/short-term/$timeframe.md"
            PROGRAM_FOUND=true
        fi
    fi
done

# Tools Memory
for tool_file in programs/${PROGRAM_NAME}/memory/tools/*.md; do
    if [ -f "$tool_file" ]; then
        if grep -qi "$SEARCH_TERM" "$tool_file"; then
            echo "🛠️ Gefunden in Tool-Memory: $tool_file"
            grep -i "$SEARCH_TERM" "$tool_file"
            PROGRAM_FOUND=true
        fi
    fi
done
```

### **Schritt 2: Falls nicht gefunden - Base-Memory (read-only)**
```bash
if [ "$PROGRAM_FOUND" != "true" ]; then
    echo "🔄 Fallback: Durchsuche Base-Memory (read-only)..."
    Read("kernel/prompts/base-memory-search.md") "$SEARCH_TERM"
fi
```

## Sicherheits-Isolation

### **✅ ERLAUBT für ${PROGRAM_NAME}:**
- `programs/${PROGRAM_NAME}/memory/*` (read/write)
- `storage/memories/*` (read-only via kernel)
- Conversation-Context (via kernel)

### **❌ VERBOTEN:**
- `programs/[OTHER_PROGRAM]/memory/*` (kein Zugriff)
- Direkter storage/* Zugriff (nur via kernel)

## Integration

### **Aufruf aus Program-Routes:**
```bash
# In programs/assistent/routing/program-routes.txt:
memory:search→../../_shared/prompts/program-memory-search.md assistent

# In programs/selbstfuersorge/routing/program-routes.txt:
memory:search→../../_shared/prompts/program-memory-search.md selbstfuersorge
```

### **Parameter-Übergabe:**
```bash
# Suche nach "Katze Lilly":
program-memory-search.md assistent "Katze Lilly"
program-memory-search.md selbstfuersorge "Wellness Routine"
```

## Output-Format
```bash
# Erfolgreich:
echo "✅ '$SEARCH_TERM' gefunden in ${PROGRAM_NAME}-Memory"
echo "📂 Quelle: [GEFUNDEN_IN]"
echo "📄 Inhalt: [MATCHED_CONTENT]"

# Nicht gefunden:
echo "❌ '$SEARCH_TERM' nicht in ${PROGRAM_NAME}-Memory oder Base-Memory gefunden"
echo "💡 Tipp: Information möglicherweise noch nicht gespeichert"
```