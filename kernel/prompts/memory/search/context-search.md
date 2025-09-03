# Context-Search - Kernel

## Zweck
Durchsucht den Conversation-Context nach Informationen. Nutzt die LLM-interne Kontext-Erinnerung.

## Konzept
Das LLM hat Zugriff auf den gesamten Chat-Verlauf der aktuellen Session. Diese Funktion strukturiert die Context-Suche.

## Search-Strategie
```bash
SEARCH_TERM="$1"

# 1. Conversation-History durchsuchen
echo "🔍 Durchsuche Conversation-Context nach: $SEARCH_TERM"

# Das LLM kann direkt auf seinen Context zugreifen
# Strukturierte Suche im Chat-Verlauf:

# Suche nach:
# - User-Eingaben mit dem Begriff
# - Assistant-Antworten mit relevanten Informationen  
# - Kontext-Verbindungen

echo "📝 Analysiere Chat-Verlauf auf relevante Informationen..."
```

## Priorität
**HÖCHSTE PRIORITÄT** - wird immer zuerst ausgeführt vor Memory-Searches.

## Anwendung
```bash
# Schritt 0 in jeder Memory-Search:
check_conversation_context "$SEARCH_TERM"

# Falls Information im Context gefunden:
if [ "$CONTEXT_RESULT" != "not_found" ]; then
    echo "✅ Information im Conversation-Context verfügbar"
    echo "💡 $CONTEXT_INFORMATION"
    return 0
fi
```

## Integration
```bash
# Immer zuerst aufrufen:
Read("kernel/prompts/context-search.md") "$SEARCH_TERM"

# Dann erst Memory-Searches wenn nötig
```

## Output-Format
```bash
# Bei Fund im Context:
echo "💭 Context: $SEARCH_TERM gefunden in vorherigen Nachrichten"
echo "📄 Information: $CONTEXT_INFO"

# Bei leerem Context:
echo "💭 Context: Keine relevanten Informationen zu $SEARCH_TERM im Chat-Verlauf"
```