# Program Router

## Zweck
Erkennt Program-bezogene Anfragen und leitet zur entsprechenden Aktion weiter.

## Routing-Logik

### 1. Program-Start erkennen
Suche nach Mustern wie:
- "lade programm [NAME]"
- "starte [NAME]"
- "aktiviere [NAME] programm"
- "[NAME] programm"

### 2. Basis-Wechsel erkennen
- "zurück zum basis"
- "basis system"
- "verlasse programm"
- "beende [NAME]"

### 3. Program-Liste
- "welche programme"
- "zeige programme"
- "liste programme"

## Aktions-Mapping

```bash
# Bei Program-Start
if [[ "$USER_INPUT" =~ (lade|starte|aktiviere).*(programm|program) ]]; then
    # Extrahiere Program-Name und lade dynamic-program-selection
    Read("kernel/prompts/programs/dynamic-program-selection.md")
fi

# Bei Basis-Wechsel  
if [[ "$USER_INPUT" =~ (zurück|back).*(basis|base) ]]; then
    Read("kernel/prompts/programs/switch-to-base.md")
fi

# Bei Program-Liste
if [[ "$USER_INPUT" =~ (welche|zeige|liste).*(programme|programs) ]]; then
    Read("kernel/prompts/programs/list-programs.md")
fi
```

## Fallback
Falls keine klare Program-Aktion erkannt wird, aber "programm" erwähnt wird:
- Zeige verfügbare Programme
- Erkläre wie man Programme startet

## Integration
Dieser Router wird über routing-config.txt getriggert bei Keywords:
- programm/programme
- lade/starte/aktiviere + programm
- zurück zum basis