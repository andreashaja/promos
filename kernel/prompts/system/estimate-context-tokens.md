# Token-Schätzung für Context-Verbrauch

## Hintergrund-Task: Token-Schätzung

Diese Aktion läuft im Hintergrund ohne Benutzer-Feedback.

## Zweck
Schätze die aktuelle Token-Auslastung des Context-Windows für proaktives Memory-Management. Diese Aufgabe läuft automatisch im Hintergrund ohne Benutzerinteraktion.

## Token-Berechnung

### Was zählt zum Context:
- **User-Messages:** Die komplette Eingabe des Users
- **Assistant-Responses:** Deine vollständige Antwort  
- **Tool-Results:** Die Ausgaben der Tools (Read, Bash, etc.)
- **System-Reminders:** Injizierte System-Nachrichten
- **Hook-Outputs:** Ausgaben von Hooks (z.B. METRICS, POLICIES)

### Was zählt NICHT zum Context:
- Tool-Calls selbst (die JSON-Strukturen)
- Interne API-Calls
- Web-Search Zwischenschritte

## Token-Zählung aus deinem Kontext

### DU musst DIREKT in deinem Kontext nachschauen:
1. **Finde die letzte User-Message** - zähle alle Zeichen
2. **Finde deine letzte Antwort** - zähle alle Zeichen  
3. **Finde alle Tool-Results** - zähle deren Zeichen
4. **Finde alle System-Injections** (METRICS, POLICIES, etc.) - zähle deren Zeichen

### Umrechnung:
- **Gezählte Zeichen ÷ 4 = Tokens** (grobe Regel)
- KEINE Heuristik! KEINE Multiplikatoren! 
- Zähle was TATSÄCHLICH in deinem Kontext steht!

### Beispiel:
"Die letzte User-Message hatte 120 Zeichen"
"Meine Antwort hatte 480 Zeichen"
"Tool-Results hatten 2000 Zeichen"
"System-Injections hatten 4000 Zeichen"
= 6600 Zeichen ÷ 4 = 1650 Tokens

## Ablauf

### 1. Kontext analysieren (SILENT)
Analysiere den gesamten bisherigen Kontext intern:
- User-Messages seit Session-Start
- Assistant-Antworten
- Tool-Results  
- System-Injections

**Keine Ausgabe an User während der Analyse!**

### 2. Tokens berechnen
- Teile die GESAMT-Zeichenzahl durch 4
- Das ist deine aktuelle Token-Anzahl
- Diese Zahl ersetzt den alten Wert (keine Addition nötig!)

### 3. Ergebnis speichern (SILENT)

Schreibe das Ergebnis direkt in system-monitor.txt:
```bash
Write("kernel/scheduler/system-monitor.txt", content)
```

Die Datei MUSS beide Werte enthalten:
- MSG: [aktuelle Message-Anzahl aus der Datei]
- TOKENS: [neue akkumulierte Token-Summe]

## Beispiel

Nach 3 Messages in der Session:

**Gesamtkontext-Analyse:**
- ALLE User-Messages zusammen: 450 Zeichen
- ALLE Assistant-Antworten zusammen: 1.800 Zeichen  
- ALLE Tool-Results zusammen: 5.200 Zeichen
- ALLE System-Injections zusammen: 12.000 Zeichen
- **GESAMT: 19.450 Zeichen**

Berechnung:
19.450 ÷ 4 = **4.863 Tokens**

Update system-monitor.txt:
```text
MSG:3
TOKENS:4863
```

## Wichtige Regeln

- **Immer konservativ schätzen** (lieber zu hoch als zu niedrig)
- **Bei Tool-Heavy Interaktionen** besonders vorsichtig sein
- **File-Listings** können schnell 5000+ Tokens verbrauchen
- **Web-Results** typischerweise 1000-3000 Tokens

## Schwellwerte

- **150.000 Tokens:** Export-Warnung (75% von 200k)
- **180.000 Tokens:** Force-Export (90% von 200k)
- **190.000 Tokens:** KRITISCH - Sofort exportieren

## User-Ausgabe

**MAXIMAL EINE ZEILE an den User:**
- Bei normaler Schätzung: KEINE Ausgabe (komplett silent)
- Bei Warnschwelle (>75%): "⚠️ Context bei 75% - Export empfohlen"
- Bei kritisch (>90%): "🔴 Context kritisch - Export erforderlich"

**NIEMALS ausgeben:**
- Details der Zählung
- Zeichen-Berechnungen
- Analyse-Schritte
- Token-Summen (außer bei Warnung)

## Fehlerbehandlung

Falls system-monitor.txt nicht existiert:
```
MSG:1
TOKENS:0
```

Falls Schätzung unsicher: Addiere 20% Sicherheitsmarge.