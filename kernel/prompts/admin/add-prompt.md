# Neuen Prompt hinzufügen

## Voraussetzungen prüfen

Bevor du einen neuen Prompt hinzufügst, stelle sicher:
1. Der User hat die Admin-Warnung bestätigt
2. Der gewünschte Prompt-Name und Zweck sind klar

## Prompt-Struktur

Jeder neue Prompt muss folgende Struktur haben:

```markdown
# [Prompt-Titel]

## Zweck
[Kurze Beschreibung was dieser Prompt tut]

## Ablauf
1. [Schritt 1]
2. [Schritt 2]
3. ...

## Wichtige Regeln
- [Regel 1]
- [Regel 2]
```

## Umsetzungsschritte

### 1. Prompt-Datei erstellen
Erstelle die neue Prompt-Datei im passenden Verzeichnis:
- Memory-Prompts: `kernel/prompts/memory/`
- System-Prompts: `kernel/prompts/system/`
- Admin-Prompts: `kernel/prompts/admin/`
- Program-Prompts: `kernel/prompts/programs/`

### 2. Routing-Integration
Füge den neuen Prompt zur passenden Route hinzu:

**Für Memory-Prompts:**
```bash
Edit("kernel/routing/routes/route-memory.txt")
# Füge neue Zeile hinzu:
prompt-name→kernel/prompts/memory/prompt-name.md
```

**Für andere Kategorien:**
Passe die entsprechende route-*.txt Datei an.

### 3. Dokumentation aktualisieren
Informiere den User über:
- Wo der Prompt erstellt wurde
- Wie er aufgerufen werden kann
- Welche Route verwendet wird

## Beispiel

User möchte einen "backup-create" Prompt:

1. **Datei erstellen**: `kernel/prompts/system/backup-create.md`
2. **Route hinzufügen** in `route-help.txt`:
   ```
   backup→kernel/prompts/system/backup-create.md
   ```
3. **Bestätigung**: "Prompt 'backup' wurde erstellt und kann über 'help/backup' aufgerufen werden"

## Fehlerbehandlung

Falls der Prompt-Name bereits existiert:
- Informiere den User
- Schlage Alternative vor
- Frage ob überschreiben gewünscht ist

## Nach Abschluss

Bestätige dem User:
- ✓ Prompt erstellt in: [Pfad]
- ✓ Route hinzugefügt: [Route]
- ✓ Aufruf über: "[Kategorie]/[Name]"