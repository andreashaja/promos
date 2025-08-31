# PROMOS - Prompt Operating System

Ein Framework für konsistentere und verlässlichere Interaktionen mit Large Language Models (LLMs)

## Überblick

PROMOS (Prompt Operating System) ist ein innovatives Framework, das die grundlegenden Herausforderungen im Umgang mit großen Sprachmodellen adressiert: Inkonsistenz, Vergesslichkeit und mangelnde Nachvollziehbarkeit. Inspiriert von bewährten Betriebssystem-Konzepten, transformiert PROMOS LLMs in verlässliche, deterministische Arbeitspartner.

Die Idee zu PROMOS entstand aus der praktischen Erfahrung mit LLMs im Arbeitsalltag. Wer regelmäßig mit KI-Assistenten arbeitet, kennt die Frustration: Man erklärt dem System ausführlich Projektdetails, technische Spezifikationen oder Teamstrukturen, nur um festzustellen, dass diese Informationen nach wenigen Nachrichten wieder vergessen sind. PROMOS löst dieses Problem durch einen systematischen Ansatz, der Mechanismen klassischer Betriebssysteme auf die Welt der Sprachmodelle überträgt.

## 🎯 Kernprobleme, die PROMOS löst

Moderne LLMs sind beeindruckende Werkzeuge, leiden aber unter fundamentalen Einschränkungen, die ihre Zuverlässigkeit im produktiven Einsatz beeinträchtigen:

- **Vergesslichkeit**: LLMs vergessen wichtige Informationen im Laufe längerer Konversationen
- **Inkonsistenz**: Antwortqualität und Verhalten schwanken ohne erkennbares Muster
- **Fehlende Persistenz**: Wissen geht zwischen Sessions verloren
- **Kontextvermischung**: Private und berufliche Informationen vermischen sich
- **Intransparenz**: Entscheidungen des LLMs sind nicht nachvollziehbar

Diese Probleme zwingen Nutzer dazu, ständig Informationen zu wiederholen und Ergebnisse zu korrigieren - ein zeitaufwändiger Prozess, der die Effizienzgewinne durch KI-Assistenz teilweise wieder zunichte macht.

## 🏗️ Architektur

PROMOS nutzt eine durchdachte Betriebssystem-Analogie, um strukturierte und vorhersagbare Interaktionen mit LLMs zu ermöglichen. Wie ein klassisches OS verwaltet PROMOS Ressourcen, koordiniert Prozesse und sorgt für konsistentes Systemverhalten. Das LLM selbst fungiert dabei als "Prozessor", während PROMOS die Steuerungsebene darüber bildet.

### Routing-System

Das Herzstück von PROMOS ist ein intelligentes Routing-System, das Benutzeranfragen semantisch analysiert und automatisch die passenden Arbeitsanweisungen aktiviert. Statt starrer Kommandos versteht das System die Intention hinter verschiedenen Formulierungen - ob jemand "Speichere das" oder "Merk dir das" sagt, PROMOS erkennt die gewünschte Aktion.

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

## 🚀 Verfügbarkeit

**Der Quellcode für PROMOS wird in Kürze veröffentlicht.**

Das System basiert derzeit auf Claude Code (Anthropic) für die Hook-Funktionalität, ist aber konzeptionell grundsätzlich auf andere LLM-Plattformen übertragbar. Die Veröffentlichung wird alle notwendigen Komponenten enthalten, um PROMOS in eigenen Umgebungen zu installieren und anzupassen.

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

## 📄 Lizenz

Die Lizenzinformationen werden mit der Codeveröffentlichung bekannt gegeben. PROMOS wird unter einer Open-Source-Lizenz veröffentlicht, die sowohl akademische als auch kommerzielle Nutzung ermöglicht.

---

*PROMOS - Bringing Operating System Principles to Large Language Models*
