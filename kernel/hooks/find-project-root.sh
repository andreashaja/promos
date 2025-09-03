#!/bin/bash
# Zentrale Funktion zur Ermittlung des PROJECT_ROOT
# Sucht PROMOS-Strukturen vom aktuellen Arbeitsverzeichnis aus

find_project_root() {
    local current_dir="$(pwd)"
    local script_dir="$(cd "$(dirname "$0")" && pwd)"
    
    # Strategie 1: Aktuelles Arbeitsverzeichnis ist bereits promos-dev
    if [ -d "$current_dir/kernel" ] && [ -d "$current_dir/storage" ] && [ -d "$current_dir/logs" ]; then
        echo "$current_dir"
        return 0
    fi
    
    # Strategie 2: Aktuelles Arbeitsverzeichnis enthält promos-dev Unterordner
    if [ -d "$current_dir/promos-dev" ]; then
        if [ -d "$current_dir/promos-dev/kernel" ] && [ -d "$current_dir/promos-dev/storage" ]; then
            echo "$current_dir/promos-dev"
            return 0
        fi
    fi
    
    # Strategie 3: Nach oben suchen (falls in Unterordner gestartet)
    local search_dir="$current_dir"
    for i in {1..5}; do  # Max 5 Ebenen nach oben
        if [ -d "$search_dir/kernel" ] && [ -d "$search_dir/storage" ] && [ -d "$search_dir/logs" ]; then
            echo "$search_dir"
            return 0
        fi
        if [ -d "$search_dir/promos-dev" ]; then
            if [ -d "$search_dir/promos-dev/kernel" ] && [ -d "$search_dir/promos-dev/storage" ]; then
                echo "$search_dir/promos-dev"
                return 0
            fi
        fi
        search_dir="$(dirname "$search_dir")"
        [ "$search_dir" = "/" ] && break
    done
    
    # Strategie 4: Fallback - relative Navigation vom Hook-Verzeichnis
    echo "$(cd "$script_dir/../.." && pwd)"
}

# Exportiere die Funktion für Verwendung in anderen Skripten
export -f find_project_root