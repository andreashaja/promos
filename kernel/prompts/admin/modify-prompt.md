# Bestehenden Prompt modifizieren

## ⚠️ ADMIN-WARNUNG
**DU MUSST ZUERST DIESE DATEI LADEN UND ANZEIGEN:**
→ Read("kernel/prompts/admin/admin-warning.md")
→ Zeige den Inhalt dem User unverändert im Chat an

### 1. Backup erstellen

**ZUERST:** Sichere den aktuellen Prompt
```bash
# Backup mit Timestamp
cp [prompt-pfad] [prompt-pfad].backup-$(date +%Y%m%d-%H%M%S)
```

### 2. Änderungen planen

**Beschreibe genau:**
- Welcher Prompt soll geändert werden?
- Was ist das Problem mit der aktuellen Version?
- Welche Änderungen sind geplant?
- Welche Auswirkungen werden erwartet?

### 3. Validierung vor Änderung

**Prüfe:**
- [ ] Prompt wird von aktiven Routes referenziert?
- [ ] Prompt wird vom Scheduler getriggert?
- [ ] Andere Prompts hängen davon ab?
- [ ] Format und Struktur bleiben kompatibel?

### 4. Änderungen durchführen

**Best Practices:**
- Behalte die Grundstruktur bei
- Ändere keine Pfad-Referenzen ohne Route-Update
- Teste kleine Änderungen iterativ
- Dokumentiere Änderungen im Prompt selbst

### 5. Test-Protokoll

**Nach der Änderung:**
1. Trigger den geänderten Prompt manuell
2. Prüfe Expected vs. Actual Output
3. Teste abhängige Workflows
4. Monitoring auf Fehler

## Rollback-Plan

**Falls Probleme auftreten:**
```bash
# Rollback zum Backup
cp [prompt-pfad].backup-[timestamp] [prompt-pfad]
```

## Typische Änderungsszenarien

### A. Verhalten anpassen
- Ändere Formulierungen für klarere Anweisungen
- Füge Beispiele hinzu
- Präzisiere Ausgabeformat

### B. Pfade aktualisieren
- **WICHTIG:** Auch Routes anpassen!
- Teste alle Verlinkungen
- Prüfe relative vs. absolute Pfade

### C. Integration erweitern
- Neue Scheduler-Trigger
- Zusätzliche Route-Keywords
- Hook-Integration

## STOP - Sicherheitscheck

**Bevor du fortfährst:**
1. Hast du ein Backup erstellt? 
2. Verstehst du alle Abhängigkeiten?
3. Ist ein Rollback-Plan vorhanden?

**Beschreibe jetzt:**
- Welchen Prompt möchtest du ändern?
- Was genau soll geändert werden?
- Warum ist diese Änderung nötig?