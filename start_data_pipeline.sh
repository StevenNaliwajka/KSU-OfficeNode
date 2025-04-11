#!/bin/bash

set -euo pipefail

# Load config
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/Config/config.env"

log() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') -- $1"
}

wait_for_pi() {
    log "Waiting for Raspberry Pi to come back online..."
    until ping -c1 "$PI_IP" &>/dev/null; do sleep 5; done
    sleep 15  # Give it a bit of time to fully boot
    log "Raspberry Pi is back online."
}

# --- Start Sequence ---

log "Step 1: SSH into Pi to stop sensors and transfer atmospheric data"
ssh -t "$PI_USER@$PI_IP" <<EOF
    bash $PI_HOME/scripts/transfer_atmo_data.sh
    bash $PI_HOME/scripts/stop_soil_sensor.sh
    sudo reboot
EOF

wait_for_pi

log "Step 2: Pull data from Raspberry Pi"
rsync -avz "$PI_USER@$PI_IP:$REMOTE_DATA_DIR/" "$LOCAL_DATA_DIR/"

log "Step 3: Restart soil sensor script"
ssh -t "$PI_USER@$PI_IP" "bash $PI_HOME/scripts/start_soil_sensor.sh"


# log "Step 4: Transfer collected data to final destination"
# rsync -avz "$LOCAL_DATA_DIR/" "$FINAL_DESTINATION/"

log "Step 5: Archive and cleanup old files"
mkdir -p "$OLD_FOLDER"
mv "$LOCAL_DATA_DIR"/*.csv "$OLD_FOLDER/" 2>/dev/null || true
find "$OLD_FOLDER" -type f -mtime +14 -delete

log "Step 6: Start the webscraper"
bash "$SCRAPER_CMD" &
echo $! > "$SCRAPER_PID_FILE"

log "Step 7: Wait until midnight to restart"
SECONDS_UNTIL_MIDNIGHT=$(( $(date -d 'tomorrow 00:00' +%s) - $(date +%s) ))
sleep $SECONDS_UNTIL_MIDNIGHT

log "Stopping webscraper"
if [[ -f "$SCRAPER_PID_FILE" ]]; then
    kill "$(cat "$SCRAPER_PID_FILE")" || true
    rm "$SCRAPER_PID_FILE"
fi

log "Restarting Machine A to start the loop again"
sudo reboot
