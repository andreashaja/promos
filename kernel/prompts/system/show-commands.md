# 📚 VERFÜGBARE BEFEHLE UND ROUTEN

## 💾 MEMORY - Speicher-Operationen

### Häufige Befehle:
- **"Speichere [Information]"** → `memory/save-core`
  - Dauerhaft wichtige Informationen speichern
  - Beispiel: "Speichere dass mein Pferd Wallace heißt"

- **"Merke dir kurz [Info]"** → `memory/save-short`
  - Temporäre Informationen für aktuelle Session
  - Beispiel: "Merke dir kurz die Telefonnummer 0123456"

- **"Exportiere die Konversation"** → `memory/export`
  - Aktuelle Unterhaltung als Markdown exportieren
  - Beispiel: "Exportiere unsere Diskussion"

- **"Durchsuche [Begriff]"** → `memory/search`
  - Im Speicher nach Informationen suchen
  - Beispiel: "Durchsuche den Speicher nach Wallace"

- **"Reorganisiere den Speicher"** → `memory/reorganize`
  - Speicher aufräumen und strukturieren

## 📦 PROGRAMS - Programme

### Verfügbare Programme:
- **"Starte das Beispielprogramm"** → `programs/start`
- **"Liste alle Programme"** → `programs/list`
- **"Wechsel zu [Programm]"** → `programs/switch`

### Installierte Programme:
- `beispiel` - Demonstrationsprogramm
- `assistent` - KI-Assistent

## ⚙️ CONFIG - Einstellungen

- **"Zeige Einstellungen"** → `config/show-config`
- **"Routing an/aus"** → `config/toggle-routing`
- **"Memory an/aus"** → `config/toggle-memory`
- **"Reset Einstellungen"** → `config/reset-config`

## 🔧 DEVELOP - Entwicklung

- **"Erweitere das System"** → `develop/extend`
- **"Zeige Results Map"** → `develop/results-map`

## ❓ HELP - Hilfe

- **"Hilfe"** oder **"Was kannst du?"** → `help`
- **"Zeige alle Befehle"** → `help/commands` (diese Übersicht)
- **"Über das System"** → `help/about`

## 💬 DIRECT - Normale Konversation

Alles andere wird als normale Konversation behandelt:
- Fragen stellen
- Diskussionen führen
- Berechnungen
- Allgemeine Unterhaltung

---

## 🎯 ROUTING-TIPS

### Hohe Konfidenz (>90%):
Diese Befehle werden fast immer korrekt erkannt:
- "Starte [Programm]"
- "Speichere..."
- "Exportiere..."
- "Hilfe"

### Mittlere Konfidenz (70-90%):
Können manchmal mehrdeutig sein:
- "Merke dir..." (save-core oder save-short?)
- "Zeige..." (was genau zeigen?)

### Niedrige Konfidenz (<70%):
System fragt nach bei:
- Unklaren Anfragen
- Mehreren möglichen Routes
- Neuen/unbekannten Befehlen

---

## 🔄 SYSTEM-STATUS

Um den aktuellen System-Status zu sehen:
- Message-Counter: Siehe `kernel/scheduler/system-monitor.txt`
- Letzte Route: Siehe `kernel/state/routing-exchange.json`
- System-Logs: Siehe `logs/system.log`

---

*Diese Übersicht wird automatisch aus den verfügbaren Routes generiert.*