#!/bin/bash
# Gemeinsame Log-Funktion für alle Hooks
# Kann von anderen Skripten mit 'source' eingebunden werden

# Log-Funktion mit Level-Prüfung
log_action() {
    local component="$1"
    local level="$2"
    local message="$3"
    
    # Finde das Projekt-Root
    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local project_root="$(cd "$script_dir/../.." && pwd)"
    local log_file="$project_root/logs/system.log"
    local config_file="$project_root/kernel/config/logging-config.txt"
    
    # Lade Log-Level aus Config (Default: INFO)
    local configured_level="INFO"
    if [ -f "$config_file" ]; then
        configured_level=$(grep "^LOG_LEVEL=" "$config_file" | cut -d= -f2)
    fi
    
    # Definiere numerische Werte für Log-Level
    case "$configured_level" in
        DEBUG) min_level=0 ;;
        INFO)  min_level=1 ;;
        WARN)  min_level=2 ;;
        ERROR) min_level=3 ;;
        *)     min_level=1 ;; # Default zu INFO
    esac
    
    case "$level" in
        DEBUG) current_level=0 ;;
        INFO)  current_level=1 ;;
        WARN)  current_level=2 ;;
        ERROR) current_level=3 ;;
        *)     current_level=1 ;;
    esac
    
    # Nur loggen wenn Level hoch genug
    if [ $current_level -ge $min_level ]; then
        # Zeitstempel mit Datum und Uhrzeit
        local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
        
        # Schreibe Log-Eintrag (unbuffered für sofortige Sichtbarkeit)
        echo "[$timestamp] [$component] [$level] $message" >> "$log_file"
        
        # Pr\u00fcfe ob Rotation n\u00f6tig (nur bei ERROR Level, um Performance zu schonen)
        if [ "$level" = "ERROR" ] && [ -f "$script_dir/rotate-logs.sh" ]; then
            bash "$script_dir/rotate-logs.sh" 2>/dev/null
        fi
    fi
}

# Convenience-Funktionen
log_info() {
    log_action "${1:-SYSTEM}" "INFO" "$2"
}

log_debug() {
    log_action "${1:-SYSTEM}" "DEBUG" "$2"
}

log_warn() {
    log_action "${1:-SYSTEM}" "WARN" "$2"
}

log_error() {
    log_action "${1:-SYSTEM}" "ERROR" "$2"
}