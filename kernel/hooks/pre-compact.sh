#!/bin/bash
# PROMOS PreCompact Hook
# Wird VOR der Kompaktierung ausgeführt
# Sichert die aktuelle Konversation und bereitet nahtlose Fortsetzung vor

echo "🔄 PROMOS: Kompaktierung erkannt - sichere aktuelle Session..." >&2

# 1. Export der aktuellen Konversation triggern
echo "💾 Exportiere Konversation vor Kompaktierung..." >&2
echo ""
echo "/read kernel/prompts/memory/maintenance/export-conversation.md"

# 2. In Action-Queue schreiben für automatisches Laden nach Kompaktierung
QUEUE_FILE="kernel/scheduler/action-queue.txt"
echo "continue-conversation" >> "$QUEUE_FILE"
echo "✅ Continue-Action in Queue eingetragen" >&2

# 3. Benutzer informieren
echo ""
echo "📌 Das System wird nach der Kompaktierung mit dem aktuellen Wissensstand fortfahren."
echo ""