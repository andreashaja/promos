#!/bin/bash
# Log-Rotation Script
# Kann manuell oder automatisch aufgerufen werden

# Finde das Projekt-Root dynamisch
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/find-project-root.sh"
PROJECT_ROOT="$(find_project_root)"

# Log-Funktionen laden
source "$SCRIPT_DIR/log-function.sh"

LOG_FILE="$PROJECT_ROOT/logs/system.log"
CONFIG_FILE="$PROJECT_ROOT/kernel/config/logging-config.txt"

# Lade Konfiguration
MAX_SIZE_MB=10
MAX_BACKUPS=5

if [ -f "$CONFIG_FILE" ]; then
    config_max_size=$(grep "^MAX_LOG_SIZE_MB=" "$CONFIG_FILE" | cut -d= -f2)
    config_max_backups=$(grep "^MAX_LOG_BACKUPS=" "$CONFIG_FILE" | cut -d= -f2)
    [ -n "$config_max_size" ] && MAX_SIZE_MB=$config_max_size
    [ -n "$config_max_backups" ] && MAX_BACKUPS=$config_max_backups
fi

# Pr\u00fcfe ob Log-Datei existiert
if [ ! -f "$LOG_FILE" ]; then
    exit 0
fi

# Pr\u00fcfe Dateigr\u00f6\u00dfe (in Bytes)
MAX_SIZE_BYTES=$((MAX_SIZE_MB * 1024 * 1024))
CURRENT_SIZE=$(stat -f%z "$LOG_FILE" 2>/dev/null || stat -c%s "$LOG_FILE" 2>/dev/null || echo 0)

if [ "$CURRENT_SIZE" -ge "$MAX_SIZE_BYTES" ]; then
    log_info "LOG_ROTATE" "Log rotation needed: $(($CURRENT_SIZE / 1024 / 1024))MB >= ${MAX_SIZE_MB}MB"
    
    # Verschiebe alte Backups
    for i in $(seq $((MAX_BACKUPS - 1)) -1 1); do
        if [ -f "$LOG_FILE.$i" ]; then
            mv "$LOG_FILE.$i" "$LOG_FILE.$((i + 1))"
        fi
    done
    
    # Rotiere aktuelle Log-Datei
    mv "$LOG_FILE" "$LOG_FILE.1"
    
    # Erstelle neue Log-Datei mit Header
    cat > "$LOG_FILE" << EOF
# PROMOS System Log
# Format: [YYYY-MM-DD HH:MM:SS] [COMPONENT] [LEVEL] Message
# Rotated at: $(date "+%Y-%m-%d %H:%M:%S")

EOF
    
    # L\u00f6sche \u00e4ltestes Backup wenn n\u00f6tig
    if [ -f "$LOG_FILE.$((MAX_BACKUPS + 1))" ]; then
        rm "$LOG_FILE.$((MAX_BACKUPS + 1))"
    fi
    
    log_info "LOG_ROTATE" "Log rotation completed"
fi