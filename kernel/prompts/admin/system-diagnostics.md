# System-Diagnostik

## ⚠️ ADMIN-WARNUNG
**DU MUSST ZUERST DIESE DATEI LADEN UND ANZEIGEN:**
→ Read("kernel/prompts/admin/admin-warning.md")
→ Zeige den Inhalt dem User unverändert im Chat an

## ⚠️ ADMIN-FUNKTION - SICHERHEITSABFRAGE

**Diese Funktion führt eine tiefe Systemanalyse durch!**  
Es werden alle Routes, Prompts und Konfigurationen geprüft.

Bist du sicher, dass du fortfahren möchtest?  
Falls nicht, sage "Abbruch" oder beschreibe, was du prüfen möchtest.

## Vollständige PROMOS-Systemprüfung

### 1. Route-Konsistenz prüfen

**Checking routing integrity...**
```bash
# Alle Route-Dateien durchgehen
for route_file in kernel/routing/routes/*.txt; do
    # Prüfe ob alle Ziel-Prompts existieren
    while IFS='→' read -r keyword target; do
        if [ ! -f "$target" ]; then
            echo "❌ Broken route: $keyword → $target"
        fi
    done < "$route_file"
done
```

### 2. Prompt-Verweise analysieren

**Checking prompt references...**
- Verwaiste Prompts (keine Route zeigt darauf)
- Zirkuläre Abhängigkeiten
- Fehlende Prompt-Dateien

### 3. Memory-System Status

**Checking memory health...**
```
storage/memories/
├── thoughts.md         [Check: Exists, Readable, <100 entries]
├── memory-map.md       [Check: Recently updated]
├── core/              [Check: Structure intact]
└── topics/            [Check: No corruption]
```

### 4. Scheduler-Funktionalität

**Checking scheduler status...**
- scheduler-config.txt: Syntax valid?
- system-monitor.txt: Updates working?
- action-queue.txt: Processing correctly?
- All actions defined?

### 5. Hook-System

**Checking hooks...**
- UserPromptSubmit: ✓ Active
- PreToolUse: ✓ Active  
- PreCompact: ✓ Active
- SessionStart: ✓ Active

### 6. Performance-Metriken

**Current metrics:**
- Messages in session: [MSG count]
- Token usage: [TOKENS estimate]
- Active topics: [Count]
- Memory size: [KB]
- Route response time: [ms]

### 7. Fehler-Log Analyse

**Recent errors (last 24h):**
```bash
grep "ERROR\|FAIL" logs/*.log | tail -20
```

### 8. Konfigurations-Integrität

**Configuration files:**
- [ ] policies.md - No syntax errors
- [ ] scheduler-config.txt - Valid rules
- [ ] .claude/settings.json - Valid JSON
- [ ] All paths use PROJECT_ROOT

## Diagnostik-Report

### ✅ Funktionsfähig:
[Liste der funktionierenden Komponenten]

### ⚠️ Warnungen:
[Nicht-kritische Probleme]

### ❌ Fehler:
[Kritische Probleme die Aufmerksamkeit brauchen]

### 📊 Empfehlungen:
[Optimierungsvorschläge basierend auf Analyse]

## Quick-Fix Aktionen

Falls Probleme gefunden wurden:
1. `fix-broken-routes` - Repariert fehlerhafte Route-Verweise
2. `cleanup-memory` - Bereinigt Memory-System
3. `reset-scheduler` - Setzt Scheduler zurück
4. `rebuild-indexes` - Erneuert System-Indizes

---

**Führe Diagnostik aus? (ja/nein)**