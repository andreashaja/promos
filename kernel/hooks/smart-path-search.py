#!/usr/bin/env python3
"""
Smart Path Search Hook für PROMOS v0.2
Intercepted Read-Tool-Aufrufe und führt automatische Pfad-Suche durch.
"""

import json
import sys
import os
import subprocess
import glob
from pathlib import Path
from datetime import datetime

def find_project_root():
    """Finde das Projekt-Root-Verzeichnis dynamisch"""
    current = Path.cwd()
    
    # Suche nach promos-dev Verzeichnis
    while current != current.parent:
        if current.name == "promos-dev" or (current / "kernel").exists():
            return str(current)
        current = current.parent
    
    # Fallback: CLAUDE_PROJECT_DIR
    return os.environ.get('CLAUDE_PROJECT_DIR', str(Path.cwd()))

def log_info(component, message):
    """Schreibe INFO-Level Log ins system.log"""
    project_root = find_project_root()
    log_file = os.path.join(project_root, "logs", "system.log")
    
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    log_line = f"[{timestamp}] [{component}] [INFO] {message}\n"
    
    try:
        os.makedirs(os.path.dirname(log_file), exist_ok=True)
        with open(log_file, "a") as f:
            f.write(log_line)
    except Exception:
        pass  # Silent fail

def log_error(component, message):
    """Schreibe ERROR-Level Log ins system.log"""
    project_root = find_project_root()
    log_file = os.path.join(project_root, "logs", "system.log")
    
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    log_line = f"[{timestamp}] [{component}] [ERROR] {message}\n"
    
    try:
        os.makedirs(os.path.dirname(log_file), exist_ok=True)
        with open(log_file, "a") as f:
            f.write(log_line)
    except Exception:
        pass

def log_debug(component, message):
    """Schreibe DEBUG-Level Log ins system.log"""
    project_root = find_project_root()
    log_file = os.path.join(project_root, "logs", "system.log")
    config_file = os.path.join(project_root, "logs", "config.txt")
    
    # Prüfe ob DEBUG aktiviert ist
    try:
        with open(config_file, 'r') as f:
            if "LOG_LEVEL=DEBUG" not in f.read():
                return  # DEBUG nicht aktiviert
    except:
        return  # Kein Config = kein DEBUG
    
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    log_line = f"[{timestamp}] [{component}] [DEBUG] {message}\n"
    
    try:
        with open(log_file, "a") as f:
            f.write(log_line)
    except Exception:
        pass

def smart_path_search(file_path, project_root):
    """
    PROAKTIVE Intelligente Pfad-Suche - sucht IMMER den besten Pfad
    Returns: (found_path, success, search_method)
    """
    
    # PROMOS-Konvention: start.sh → boot.md automatisch korrigieren
    original_path = file_path
    if file_path.endswith("start.sh"):
        file_path = file_path.replace("start.sh", "boot.md")
        log_debug("SMART_PATH", f"Automatische Korrektur: start.sh → boot.md")
    
    # Strategie 1: Absoluter Pfad
    if os.path.isabs(file_path) and os.path.exists(file_path):
        log_debug("SMART_PATH", f"Gefunden via absoluten Pfad: {file_path}")
        return file_path, True, "absolute"
    
    # Strategie 2: Relativ zu project_root
    test_path = os.path.join(project_root, file_path)
    if os.path.exists(test_path):
        log_debug("SMART_PATH", f"Gefunden relativ zu project_root: {test_path}")
        return test_path, True, "relative_to_root"
    
    # Strategie 3: Fuzzy-Suche nach Dateiname
    filename = os.path.basename(file_path)
    log_debug("SMART_PATH", f"Fuzzy-Suche nach: {filename}")
    
    # Wichtige Verzeichnisse priorisiert durchsuchen
    priority_dirs = [
        "kernel/prompts",
        "kernel/routing",
        "kernel/routing/routes", 
        "kernel/policies",
        "programs",
        "storage/memories",
        "storage/conversations"
    ]
    
    for dir_path in priority_dirs:
        full_dir = os.path.join(project_root, dir_path)
        if os.path.exists(full_dir):
            pattern = os.path.join(full_dir, "**", filename)
            matches = glob.glob(pattern, recursive=True)
            if matches:
                log_info("SMART_PATH", f"Fuzzy-Match gefunden in {dir_path}: {matches[0]}")
                return matches[0], True, "fuzzy_priority"
    
    # Strategie 4: Globale Suche als Fallback
    pattern = os.path.join(project_root, "**", filename)
    matches = glob.glob(pattern, recursive=True)
    if matches:
        log_info("SMART_PATH", f"Globale Suche erfolgreich: {matches[0]}")
        return matches[0], True, "global_search"
    
    # Nicht gefunden
    log_info("SMART_PATH", f"Datei nicht gefunden: {original_path}")
    return original_path, False, "not_found"

def main():
    """Hook Entry-Point"""
    try:
        # Lese Tool-Aufruf von stdin
        input_data = json.load(sys.stdin)
    except json.JSONDecodeError as e:
        log_error("SMART_PATH", f"Invalid JSON input: {e}")
        sys.exit(0)  # Fehler ignorieren, Tool normal ausführen
    
    # Nur bei Read-Tool aktiv werden
    tool_name = input_data.get("tool", "")
    if tool_name != "Read":
        # Nicht unser Tool - unverändert durchreichen
        print(json.dumps(input_data))
        sys.exit(0)
    
    # Hole den file_path Parameter
    params = input_data.get("parameters", {})
    file_path = params.get("file_path", "")
    
    if not file_path:
        # Kein Pfad - unverändert durchreichen
        print(json.dumps(input_data))
        sys.exit(0)
    
    # Project Root finden
    project_root = find_project_root()
    
    log_info("SMART_PATH", f"Hook aktiviert für Tool: {tool_name}")
    log_info("SMART_PATH", f"Prüfe Pfad: {file_path}")
    
    # Proaktive Suche starten
    log_info("SMART_PATH", f"Proaktive Suche startet für: {file_path}")
    found_path, success, method = smart_path_search(file_path, project_root)
    
    if success and found_path != file_path:
        # Pfad wurde korrigiert - Update im Tool-Aufruf
        log_info("SMART_PATH", f"Pfad korrigiert von '{file_path}' zu '{found_path}' (Methode: {method})")
        params["file_path"] = found_path
        input_data["parameters"] = params
        
        # Erweiterte Ausgabe mit Korrektur-Info
        error_output = {
            "tool": tool_name,
            "parameters": params,
            "_smart_path_correction": {
                "original": file_path,
                "corrected": found_path,
                "method": method
            }
        }
        print(json.dumps(error_output))
    else:
        log_info("SMART_PATH", f"Suche Ergebnis: {file_path} → {found_path} (gefunden: {success}, methode: {method})")
        # Original durchreichen
        print(json.dumps(input_data))
    
    # Optionales Debug-Logging
    if success:
        success_output = {
            "tool": tool_name,
            "parameters": params
        }
        log_debug("SMART_PATH", f"Erfolgreicher Hook-Durchlauf: {json.dumps(success_output)}")

if __name__ == "__main__":
    main()