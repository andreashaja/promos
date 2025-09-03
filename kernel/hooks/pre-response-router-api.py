#!/usr/bin/env python3
"""
Pre-Response Router API v3 - Vollständig generischer Router
Lädt ALLE Informationen aus Textdateien - keine hardcodierten Routes
Flaches Routing für optimale LLM-Entscheidung
"""
import os
import sys
import json
import time
from pathlib import Path
from datetime import datetime

# Projekt-Root bestimmen
project_root = Path(__file__).parent.parent.parent

# Reaktivierungs-Phrasen (zentral definiert)
REACTIVATION_PHRASES = [
    "router einschalten",
    "routing aktivieren",
    "routing wieder an",
    "normale navigation",
    "zurück zum system"
]

# Environment laden
def load_env():
    """Lädt .env falls vorhanden"""
    env_file = project_root / '.env'
    if env_file.exists():
        with open(env_file) as f:
            for line in f:
                if '=' in line and not line.startswith('#'):
                    key, value = line.strip().split('=', 1)
                    os.environ[key] = value
        return True
    return False

# Lade Environment
env_loaded = load_env()

try:
    import anthropic
    api_available = True
except ImportError:
    api_available = False

def log_info(component, message):
    """Log INFO to system.log"""
    log_file = project_root / "logs" / "system.log"
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    
    with open(log_file, 'a') as f:
        f.write(f"[{timestamp}] [{component}] [INFO] {message}\n")

def log_error(component, message):
    """Log ERROR to system.log"""
    log_file = project_root / "logs" / "system.log"
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    
    with open(log_file, 'a') as f:
        f.write(f"[{timestamp}] [{component}] [ERROR] {message}\n")

def parse_route_line(line):
    """Parst eine Route-Zeile mit dem Format: ROUTE → TARGET # BESCHREIBUNG"""
    # Format: ROUTE → TARGET # BESCHREIBUNG
    parts = line.split('#')
    
    # Route und Target
    if '→' not in parts[0]:
        return None, None, None
        
    route_parts = parts[0].split('→')
    route = route_parts[0].strip()
    target = route_parts[1].strip()
    
    # Beschreibung (optional)
    description = parts[1].strip() if len(parts) > 1 else ""
    
    return route, target, description

def read_context_state():
    """Liest den aktuellen Program-Context"""
    context_file = project_root / "programs" / "context-state.txt"
    
    context = {
        'CURRENT_CONTEXT': 'base',
        'ACTIVE_PROGRAM': 'none'
    }
    
    if context_file.exists():
        try:
            with open(context_file, 'r') as f:
                for line in f:
                    line = line.strip()
                    if '=' in line and not line.startswith('#'):
                        key, value = line.split('=', 1)
                        context[key.strip()] = value.strip()
        except Exception as e:
            log_error("ROUTER_API", f"Error reading context-state: {e}")
    
    return context

def load_routes_from_file(file_path, routes, route_descriptions, prefix=""):
    """Lädt Routes aus einer einzelnen Datei"""
    try:
        # Bestimme das Basis-Verzeichnis für relative Pfade
        route_dir = Path(file_path).parent
        
        with open(file_path, 'r') as f:
            for line in f:
                line = line.strip()
                if not line or line.startswith('#'):
                    continue
                    
                route, target, description = parse_route_line(line)
                if route:
                    full_route = f"{prefix}{route}" if prefix else route
                    
                    # Löse relative Pfade relativ zur Route-Datei auf
                    if target and target.startswith('../'):
                        # Relativer Pfad - löse relativ zur Route-Datei auf
                        resolved_path = (route_dir / target).resolve()
                        # Konvertiere zu relativem Pfad vom project_root
                        try:
                            target = str(resolved_path.relative_to(project_root))
                        except ValueError:
                            # Falls außerhalb von project_root, behalte absoluten Pfad
                            target = str(resolved_path)
                    
                    routes[full_route] = target
                    if description:
                        route_descriptions.append(f"{full_route}: {description}")
    except Exception as e:
        log_error("ROUTER_API", f"Error loading routes from {file_path}: {e}")

def load_all_routes():
    """Lädt alle Routes flach aus den Textdateien - 4-stufiges Context-aware Loading"""
    routes = {}
    route_descriptions = []
    
    # 1. SYSTEM-ROUTEN (immer laden)
    # Lade entry-point.txt und alle Sub-Routes
    entry_point = project_root / "kernel" / "routing" / "entry-point.txt"
    
    try:
        with open(entry_point, 'r') as f:
            for line in f:
                line = line.strip()
                if not line or line.startswith('#'):
                    continue
                    
                route, target, description = parse_route_line(line)
                if route:
                    # Wenn es eine route-Datei ist, lade Sub-Routes
                    if target.endswith('.txt'):
                        subroute_file = project_root / target
                        if subroute_file.exists():
                            with open(subroute_file, 'r') as sf:
                                for sline in sf:
                                    sline = sline.strip()
                                    if not sline or sline.startswith('#'):
                                        continue
                                        
                                    sub_route, sub_target, sub_desc = parse_route_line(sline)
                                    if sub_route:
                                        full_route = f"{route}/{sub_route}"
                                        # Spezialbehandlung für SCAN_PROGRAMS
                                        if sub_target == 'SCAN_PROGRAMS':
                                            # Programme werden aus program-list.txt geladen
                                            continue
                                        routes[full_route] = sub_target
                                        if sub_desc:
                                            route_descriptions.append(f"{full_route}: {sub_desc}")
                    else:
                        # Direkte Route ohne Sub-Routes
                        routes[route] = target
                        if description:
                            route_descriptions.append(f"{route}: {description}")
    except Exception as e:
        log_error("ROUTER_API", f"Error loading system routes: {e}")
    
    # 2. PROGRAM-LISTE (immer laden)
    program_list_file = project_root / "programs" / "program-list.txt"
    if program_list_file.exists():
        try:
            with open(program_list_file, 'r') as f:
                for line in f:
                    line = line.strip()
                    if not line or line.startswith('#'):
                        continue
                    if '→' in line:
                        program_name, program_desc = line.split('→', 1)
                        program_route = f"programs/{program_name.strip()}"
                        routes[program_route] = f"programs/{program_name.strip()}/boot.md"
                        route_descriptions.append(f"{program_route}: {program_desc.strip()}")
            # Zähle Programme
            program_routes = [r for r in routes if r.startswith('programs/') and r != 'programs/list']
            program_count = len(program_routes)
            log_info("ROUTER_API", f"Loaded {program_count} programs from program-list.txt")
        except Exception as e:
            log_error("ROUTER_API", f"Error loading program list: {e}")
    
    # 3. & 4. CONTEXT-ABHÄNGIGES LADEN
    context = read_context_state()
    active_program = context.get('ACTIVE_PROGRAM', 'none')
    
    if active_program != 'none':
        log_info("ROUTER_API", f"Active program detected: {active_program}")
        
        # 3. SHARED ROUTES (bei aktivem Program)
        shared_routes_file = project_root / "programs" / "_shared" / "routing" / "shared-routes.txt"
        if shared_routes_file.exists():
            log_info("ROUTER_API", "Loading shared program routes")
            load_routes_from_file(shared_routes_file, routes, route_descriptions)
        
        # 4. PROGRAM-SPEZIFISCHE ROUTES
        program_routes_file = project_root / "programs" / active_program / "routing" / "program-routes.txt"
        if program_routes_file.exists():
            log_info("ROUTER_API", f"Loading routes for program: {active_program}")
            load_routes_from_file(program_routes_file, routes, route_descriptions)
    
    # Direct ist immer verfügbar
    routes['direct'] = None
    route_descriptions.append("direct: Normale Konversation ohne spezielle Route")
    
    log_info("ROUTER_API", f"Loaded {len(routes)} total routes")
    return routes, route_descriptions

def select_route(user_input, routes, route_descriptions, config):
    """Wählt die beste Route mit Claude API"""
    if not api_available or not os.environ.get('ANTHROPIC_API_KEY'):
        log_error("ROUTER_API", "API not available or no API key")
        return 'direct', 0.5
    
    prompt = f"""Du bist ein präziser Route-Selektor für PROMOS.

EINGABE-ANALYSE:
User-Input: "{user_input}"
Wort-Anzahl: {len(user_input.split())}

Verfügbare Routes:
{chr(10).join(sorted(route_descriptions))}

SCHLÜSSEL-PRINZIP:
Stelle dir jede Route als ein Schloss vor, das nur von bestimmten Schlüsseln (User-Eingaben) geöffnet werden kann.
Die Eingabe muss ein passender Schlüssel sein - nicht nur ähnlich aussehen.

WICHTIGE ROUTING-REGELN:
1. AKTIONSWÖRTER haben hohe Priorität:
   - "starte", "öffne", "lade", "zeige", "suche", "speichere" = klare Befehle
   - Kurze Eingaben MIT Aktionswort → hohe Confidence für passende Route
   - Kurze Eingaben OHNE Aktionswort → niedrige Confidence, meist 'direct'

2. KURZE EINGABEN (1-4 Wörter) differenziert bewerten:
   POSITIVE Beispiele (→ Route mit hoher Confidence):
   - "Starte Tagebuch" → 'programs/tagebuch' (Aktionswort + Programm)
   - "Speichere das" → 'memory/save' (klare Speicher-Anweisung)
   - "Zeige Befehle" → 'help/commands' (Aktionswort + Ziel)
   - "Hilfe" → 'help/help' (impliziter Befehl)
   - "Öffne mein-tagebuch" → 'programs/mein-tagebuch' (Aktionswort + Programm)
   
   NEGATIVE Beispiele (→ 'direct' mit niedriger Confidence):
   - "Mein Tagebuch" → 'direct' (nur Nennung, kein Befehl)
   - "Pizza ist gut" → 'direct' (allgemeine Aussage)
   - "Morgen vielleicht" → 'direct' (keine klare Aktion)
   - "Das war's" → 'direct' (Abschluss, keine Aktion)

3. SPEZIFISCHE ANFORDERUNGEN mit Beispielen:
   memory/* Routen:
   ✓ "Speichere dass ich Pizza mag" → 'memory/save'
   ✓ "Merke dir die Telefonnummer" → 'memory/remember'
   ✗ "Das ist wichtig" → 'direct' (keine explizite Speicher-Anweisung)
   
   programs/* Routen:
   ✓ "Starte test-program" → 'programs/test-program'
   ✓ "Lade mein Tagebuch" → 'programs/mein-tagebuch'
   ✗ "test-program" → 'direct' (nur Name ohne Aktion)
   
   admin/* Routen:
   ✓ "Führe System-Check durch" → 'admin/system-check'
   ✗ "Check mal das System" → 'direct' (zu umgangssprachlich für Admin)

4. IM ZWEIFEL:
   - Bei unklaren Eingaben → 'direct'
   - Aber: Klare Befehle verdienen hohe Confidence!

CONFIDENCE-BERECHNUNG:
- 0.9-1.0: Perfekter Schlüssel - exakte Keywords + klare Intention
- 0.7-0.8: Guter Schlüssel - richtige Intention, andere Worte
- 0.5-0.6: Schwacher Schlüssel - könnte passen, aber unsicher
- < 0.5: Kein Schlüssel - wähle 'direct'

WICHTIG: Im Zweifel IMMER 'direct' wählen!

Antworte NUR mit JSON:
{{"route": "gewählte_route", "confidence": 0.00}}"""

    try:
        client = anthropic.Anthropic(api_key=os.environ.get('ANTHROPIC_API_KEY'))
        
        start_time = time.time()
        
        model_name = config.get('ROUTING_MODEL', 'claude-3-haiku-20240307')
        log_info("ROUTER_API", f"Using model: {model_name}")
        
        response = client.messages.create(
            model=model_name,
            max_tokens=50,
            temperature=0.2,
            messages=[{"role": "user", "content": prompt}]
        )
        
        elapsed = time.time() - start_time
        raw_response = response.content[0].text.strip()
        
        # Clean response - remove markdown code blocks if present
        if raw_response.startswith('```'):
            # Extract content between ``` markers
            lines = raw_response.split('\n')
            raw_response = '\n'.join(lines[1:-1]) if len(lines) > 2 else raw_response
        
        log_info("ROUTER_API", f"Raw API response: {raw_response}")
        result = json.loads(raw_response)
        route = result.get('route', 'direct')
        confidence = result.get('confidence', 0.5)
        
        # Validiere Route
        if route not in routes:
            log_error("ROUTER_API", f"Invalid route '{route}' from API, using 'direct'")
            route = 'direct'
            confidence = 0.5
            
        log_info("ROUTER_API", f"Selected: {route} (confidence: {confidence:.2f}, time: {elapsed:.2f}s)")
        return route, confidence
        
    except json.JSONDecodeError as e:
        log_error("ROUTER_API", f"Failed to parse API response: {e}")
        return 'direct', 0.5
    except Exception as e:
        log_error("ROUTER_API", f"API call failed: {e}")
        return 'direct', 0.5

def load_config():
    """Lädt Routing-Konfiguration"""
    config_file = project_root / "kernel" / "config" / "routing-config.txt"
    
    config = {
        'ROUTING_ENABLED': True,  # Master-Schalter
        'MIN_ROUTE_CONFIDENCE': 0.70,
        'MIN_PROGRAM_CONFIDENCE': 0.80  # Höhere Schwelle für Programme
    }
    
    if config_file.exists():
        with open(config_file) as f:
            for line in f:
                line = line.strip()
                if '=' in line and not line.startswith('#'):
                    key, value = line.split('=', 1)
                    key = key.strip()
                    value = value.strip()
                    if '#' in value:
                        value = value.split('#')[0].strip()
                    if key in ['MIN_ROUTE_CONFIDENCE', 'MIN_PROGRAM_CONFIDENCE']:
                        config[key] = float(value)
                    elif key == 'ROUTING_ENABLED':
                        config[key] = value.lower() == 'true'
                    elif key == 'ROUTING_MODEL':
                        config[key] = value
    
    return config

def update_config_value(key, value):
    """Updated einen Wert in routing-config.txt"""
    config_file = project_root / "kernel" / "config" / "routing-config.txt"
    lines = []
    
    with open(config_file, 'r') as f:
        for line in f:
            if line.strip().startswith(f'{key}='):
                # Erhalte Kommentare nach dem Wert
                if '#' in line:
                    comment = line.split('#', 1)[1]
                    lines.append(f'{key}={value}              #{comment}')
                else:
                    lines.append(f'{key}={value}\n')
            else:
                lines.append(line)
    
    with open(config_file, 'w') as f:
        f.writelines(lines)

def check_reactivation(user_input):
    """Prüft ob User das Routing reaktivieren möchte"""
    user_lower = user_input.lower()
    
    for phrase in REACTIVATION_PHRASES:
        if phrase in user_lower:
            return True
    return False

def main():
    """Hauptfunktion - Flaches Routing mit allen Routes"""
    
    # Konfiguration laden
    config = load_config()
    
    # User-Input aus Umgebung
    user_input = os.environ.get('LAST_USER_MESSAGE', '')
    if not user_input:
        log_error("ROUTER_API", "No user input available")
        sys.exit(0)
    
    log_info("ROUTER_API", f"Processing user input: '{user_input}'")
    
    # Prüfe ob Routing deaktiviert ist
    if not config.get('ROUTING_ENABLED', True):
        log_info("ROUTER_API", "Routing disabled - checking for reactivation")
        
        if check_reactivation(user_input):
            # Routing wieder aktivieren
            update_config_value('ROUTING_ENABLED', 'true')
            log_info("ROUTER_API", "Routing re-enabled by user request")
            print("\n✅ Routing wurde wieder aktiviert!\n")
        else:
            log_info("ROUTER_API", "No reactivation phrase found - continuing without routing")
        
        # In beiden Fällen: Exit ohne Routing
        sys.exit(0)
    
    # Lade ALLE Routes flach
    routes, route_descriptions = load_all_routes()
    
    # Wähle beste Route mit einem API-Call
    route, confidence = select_route(user_input, routes, route_descriptions, config)
    
    # Entscheide basierend auf Route-Typ und Konfidenz
    min_confidence = config['MIN_ROUTE_CONFIDENCE']
    
    # Höhere Schwelle für Programme
    if route.startswith('programs/') and route != 'programs/list':
        min_confidence = config.get('MIN_PROGRAM_CONFIDENCE', 0.80)
        log_info("ROUTER_API", f"Program route detected - using higher threshold: {min_confidence}")
    
    # Bei hoher Konfidenz: Prompt laden
    if confidence >= min_confidence and route != 'direct':
        target = routes.get(route)
        if target:
            log_info("ROUTER_API", f"High confidence - loading target: {target}")
            
            if target.endswith('.md'):
                prompt_file = project_root / target
                if prompt_file.exists():
                    with open(prompt_file, 'r') as f:
                        content = f.read()
                    print(content)
                    log_info("ROUTER_API", "Prompt content delivered")
                else:
                    log_error("ROUTER_API", f"Target file not found: {target}")
            elif target.endswith('/boot.md'):
                # Program-Start
                print(f"\n/read {target}\n")
                log_info("ROUTER_API", f"Program boot initiated: {target}")
        else:
            log_info("ROUTER_API", f"Route '{route}' has no target")
    else:
        # Niedrige Konfidenz
        if route == 'direct':
            log_info("ROUTER_API", "Direct conversation - no routing needed")
        else:
            log_info("ROUTER_API", f"Low confidence ({confidence:.2f} < {min_confidence}) - no action")
    
    sys.exit(0)

if __name__ == "__main__":
    main()