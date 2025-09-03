# PROMOS - Prompt Operating System

Ein Framework für konsistentere und verlässlichere Interaktionen mit Large Language Models (LLMs)

## Überblick

PROMOS (Prompt Operating System) ist ein Framework, das grundlegende Probleme von LLMs löst: Inkonsistenz, Vergesslichkeit und mangelnde Nachvollziehbarkeit. Es nutzt Betriebssystem-Konzepte, um LLMs verlässlicher und vorhersagbarer zu machen.

Die Idee zu PROMOS entstand aus der praktischen Erfahrung mit LLMs im Arbeitsalltag. Wer regelmäßig mit KI-Assistenten arbeitet, kennt die Frustration: Man erklärt dem System ausführlich Projektdetails, technische Spezifikationen oder Teamstrukturen, nur um festzustellen, dass diese Informationen nach wenigen Nachrichten wieder vergessen sind. PROMOS löst dieses Problem durch einen systematischen Ansatz, der Mechanismen klassischer Betriebssysteme auf die Welt der Sprachmodelle überträgt.

## 🎯 Kernprobleme, die PROMOS löst

Moderne LLMs sind beeindruckende Werkzeuge, leiden aber unter fundamentalen Einschränkungen, die ihre Zuverlässigkeit Einsatz beeinträchtigen können:

- **Vergesslichkeit**: LLMs vergessen wichtige Informationen im Laufe längerer Konversationen
- **Inkonsistenz**: Antwortqualität und Verhalten schwanken ohne erkennbares Muster
- **Fehlende Persistenz**: Wissen geht zwischen Sessions verloren
- **Kontextvermischung**: Private und berufliche Informationen vermischen sich
- **Intransparenz**: Entscheidungen des LLMs sind nicht nachvollziehbar

Diese Probleme zwingen Nutzer dazu, ständig Informationen zu wiederholen und Ergebnisse zu korrigieren - ein zeitaufwändiger Prozess, der die Effizienzgewinne durch KI-Assistenz teilweise wieder zunichte macht.

## 🚀 Schnellstart

Detaillierte Installationsanweisungen finden sich in der **[INSTALL.md](./INSTALL.md)**.

**Systemvoraussetzungen:**
- macOS (getestet), Linux/Windows (ungetestet, benötigt ggf. WSL)
- Python 3.8+, Bash, Git
- Claude Code CLI
- Anthropic API Key

## 🏗️ Architektur

PROMOS überträgt bewährte Betriebssystem-Konzepte auf LLMs. Wie ein OS verwaltet es Ressourcen, koordiniert Prozesse und sorgt für konsistentes Verhalten. Das LLM selbst ist dabei der "Prozessor", PROMOS die Steuerungsebene.

### Routing-System

Das Routing-System analysiert Benutzeranfragen und aktiviert passende Arbeitsanweisungen. Es versteht verschiedene Formulierungen für dieselbe Aktion - "Speichere das" und "Merk dir das" führen zum gleichen Ergebnis.

- Semantische Analyse von Benutzeranfragen
- Automatische Aktivierung passender Prompts
- Flexibel erweiterbar ohne Systemänderungen

### Scheduler

Wie ein Betriebssystem-Scheduler koordiniert diese Komponente zeitgesteuerte Aufgaben und sorgt dafür, dass wichtige Systemfunktionen automatisch ausgeführt werden. Der besondere Clou: Der "Takt" wird durch Benutzernachrichten bestimmt, nicht durch eine Systemuhr.

- Automatisierte Wartungsaufgaben
- Regelmäßiges Neuladen von Policies
- Token-basiertes Monitoring
- Asynchrone, nachrichtengetriebene Ausführung

### Speichersystem

Das hierarchische Speichersystem löst eines der größten Probleme von LLMs: das fehlende Langzeitgedächtnis. Informationen werden intelligent organisiert und bleiben über Session-Grenzen hinweg erhalten. Dabei setzt PROMOS bewusst auf Transparenz - alle Daten liegen als lesbare Markdown-Dateien vor.

- Hierarchische Wissensspeicherung
- Thoughts → Topics Workflow
- Transparente Markdown-Dateien
- Session-übergreifende Persistenz

### Programme

Programme sind isolierte Arbeitskontexte, vergleichbar mit Anwendungen in einem klassischen Betriebssystem. Ein Tagebuch-Programm weiß nichts von Projektdaten, das Fitness-Programm bleibt getrennt von beruflichen Informationen. Diese Isolation verhindert ungewollte Kontextvermischungen und ermöglicht fokussiertes Arbeiten.

- Isolierte Arbeitskontexte
- Eigener Speicher pro Anwendung
- Spezialisierte Verhaltensweisen
- Keine Kontextvermischung

## 📚 Dokumentation

Eine detaillierte Beschreibung der Konzepte, Architektur und Implementierung findet sich in der wissenschaftlichen Ausarbeitung. Das Paper diskutiert nicht nur die technischen Aspekte, sondern auch die zugrundeliegenden Herausforderungen im Umgang mit LLMs und wie PROMOS diese systematisch adressiert.

- [PROMOS - Ein Prompt-Betriebssystem für mehr Determinismus und konsistentere Ergebnisse bei der Arbeit mit LLMs](./documentation/components/promos-overview-tex/promos-overview-latex.pdf)

## 🛠️ Installation & Nutzung

Der vollständige Quellcode ist nun verfügbar! Siehe **[INSTALL.md](./INSTALL.md)** für detaillierte Installationsanweisungen.

**Hinweis**: PROMOS ist eine Alpha-Version - funktionsfähig aber noch in aktiver Entwicklung. Das System basiert auf Claude Code (Anthropic) für die Hook-Funktionalität, ist aber konzeptionell auf andere LLM-Plattformen übertragbar.

## 💡 Anwendungsbeispiele

PROMOS eignet sich für vielfältige Einsatzszenarien, bei denen konsistente und nachvollziehbare KI-Interaktionen wichtig sind:

- **Persönliches Tagebuch**: Emotionale Reflexion mit Mustererkennung über Wochen und Monate
- **Projekt-Management**: Strukturierte Aufgabenverwaltung ohne Kontextvermischung zwischen verschiedenen Projekten
- **Technische Dokumentation**: Konsistente Wissensspeicherung mit automatischer Kategorisierung
- **Fitness-Tracking**: Isolierte Gesundheitsdaten mit Fortschrittsverfolgung und personalisierten Empfehlungen

Jedes Programm arbeitet in seinem eigenen Kontext, wodurch Datenschutz und Fokussierung gewährleistet sind. Das Tagebuch-Beispiel im Paper demonstriert eindrucksvoll, wie aus einem generischen LLM ein spezialisierter, einfühlsamer Begleiter wird.

## 🤝 Mitwirkung

PROMOS wird ein offenes Projekt, das von der Community leben soll. Ideen für neue Programme, Architekturerweiterungen oder Fehlerberichte sind herzlich willkommen! Nach der Codeveröffentlichung werden hier detaillierte Informationen zur Mitarbeit bereitgestellt.

## 📧 Kontakt

Für Fragen, Anregungen oder wissenschaftliche Kooperationen:

Prof. Dr. Andreas Haja  
andreas.haja@uni-oldenburg.de  
[github.com/andreashaja](https://github.com/andreashaja)

## 📄 Lizenz & Haftungsausschluss

PROMOS wird unter der MIT-Lizenz veröffentlicht - siehe [LICENSE](./LICENSE) für Details.

**HAFTUNGSAUSSCHLUSS**: Diese Software wird ohne Gewährleistung bereitgestellt. Die Nutzung erfolgt auf eigenes Risiko. Der Autor übernimmt keine Haftung für eventuelle Schäden oder Datenverluste, die durch die Nutzung dieser Software entstehen könnten.

**Sicherheitshinweis**: Bewahren Sie Ihren Anthropic API Key sicher auf und committen Sie ihn niemals in ein Repository!

---

*PROMOS - Bringing Operating System Principles to Large Language Models*
