#!/bin/bash

# Get absolute path two levels up
TARGET_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)/Config"

# Ensure the target config directory exists
mkdir -p "$TARGET_DIR"

# Define the JSON content
read -r -d '' JSON_CONTENT << 'EOF'
# config.env

# Raspberry Pi config
PI_USER="pi"
PI_IP="192.168.1.100"
PI_HOME="/home/pi"

# File paths
LOCAL_DATA_DIR="/home/user/data_collected"
REMOTE_DATA_DIR="/home/pi/data"
FINAL_DESTINATION="/mnt/data/final"
OLD_FOLDER="/home/user/data_collected/old"

# Webscraper
SCRAPER_CMD="/home/user/start_scraper.sh"
SCRAPER_PID_FILE="/tmp/webscraper.pid"

EOF

# Write the JSON to the target path
echo "$JSON_CONTENT" > "$TARGET_DIR/config.env"

echo "Created $TARGET_DIR/config.env"
