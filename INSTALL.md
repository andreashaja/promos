# PROMOS Installation Guide

## 🖥️ Systemvoraussetzungen

### Unterstützte Betriebssysteme

| OS | Status | Hinweise |
|---|---|---|
| **macOS** | ✅ Voll unterstützt | Getestet und entwickelt auf macOS |
| **Linux** | ⚠️ Ungetestet | Sollte kompatibel sein (Bash-native) |
| **Windows** | ⚠️ Ungetestet | Bash-Skripte benötigen WSL oder Git Bash |

**Wichtig**: 
- PROMOS benötigt zwingend Claude Code mit Hook-Support ([Installation](https://docs.anthropic.com/en/docs/claude-code/setup))
- Windows-Nutzer: Die Bash-Skripte wurden (noch) nicht auf Windows getestet. Möglicherweise ist WSL (Windows Subsystem for Linux) oder Git Bash erforderlich.

### Technische Anforderungen

- **Python 3.8+** (für Routing und Smart Search)
- **Bash Shell** (für Automation Scripts)
- **Git** (für Versionskontrolle)
- **Claude Code CLI** ([Installation](https://docs.anthropic.com/en/docs/claude-code/setup))
- **Anthropic API Key** ([Hier erhalten](https://console.anthropic.com/settings/keys))

## 📦 Installation

### 1. Repository klonen

```bash
git clone https://github.com/andreashaja/promos.git
cd promos
```

### 2. Konfigurationsdateien erstellen

```bash
# .env für API-Key
cp .env.example .env
# Bearbeite .env und füge deinen Anthropic API Key ein

# .gitignore für lokale Dateien
cp .gitignore.example .gitignore
```

### 3. Skripte ausführbar machen

**Wichtig**: Alle Shell-Skripte müssen ausführbar gemacht werden:

```bash
# Alle .sh Dateien ausführbar machen
find . -name "*.sh" -type f -exec chmod +x {} \;

# Alle .py Hook-Dateien ausführbar machen
find ./kernel/hooks -name "*.py" -type f -exec chmod +x {} \;
```

### 4. Python-Abhängigkeiten installieren

```bash
# Anthropic Python SDK installieren
pip install anthropic
```

### 5. Verzeichnisstruktur prüfen

Die notwendigen Verzeichnisse sind bereits im Repository vorhanden:

- `logs/` - Für System-Logs
- `storage/conversations/` - Für exportierte Konversationen  
- `programs/mein-tagebuch/storage/conversations/` - Für Tagebuch-Konversationen
- `.claude/` - Claude Code Konfiguration

## 🚀 Erste Schritte

### Mit Claude Code (alle Betriebssysteme)

1. Öffne Terminal/Konsole im PROMOS-Verzeichnis
2. Starte Claude Code:

   ```bash
   claude
   ```

3. PROMOS startet automatisch über die Hooks

## ✅ Installation verifizieren

Teste die Installation mit:

```bash
# Prüfe Python
python --version

# Prüfe Anthropic SDK
python -c "import anthropic; print('Anthropic SDK installiert')"

# Prüfe Hooks sind ausführbar
ls -la kernel/hooks/*.sh | grep -E "^-rwx"

# Prüfe API Key
grep ANTHROPIC_API_KEY .env
```

## 🔧 Fehlerbehebung

### "Permission denied" bei Skripten

```bash
chmod +x pfad/zum/skript.sh
```

### "Module anthropic not found"

```bash
pip install --upgrade anthropic
```

### API Key Fehler

- Prüfe ob `.env` existiert
- Prüfe ob der Key korrekt ist (beginnt mit `sk-ant-`)
- Stelle sicher, dass keine Leerzeichen um den Key sind

### Logs-Verzeichnis fehlt

```bash
mkdir -p logs
touch logs/.gitkeep
```

## 📝 Hinweise

- **Alpha Version**: PROMOS ist in aktiver Entwicklung
- **Backup**: Erstelle regelmäßig Backups deiner Daten
- **Updates**: Pull regelmäßig die neueste Version
- **Feedback**: Issues auf GitHub sind willkommen

## 🆘 Hilfe

Bei Problemen:

1. Prüfe die [GitHub Issues](https://github.com/andreashaja/promos/issues)
2. Schaue in `logs/system.log` für Fehlerdetails
3. Erstelle ein neues Issue mit Fehlerbeschreibung
4. Kontakt: Prof. Dr. Andreas Haja (ah@andreashaja.com)

---

PROMOS v0.2 Alpha - Installation Guide
