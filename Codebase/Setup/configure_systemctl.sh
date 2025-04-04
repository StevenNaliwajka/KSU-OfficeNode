#!/bin/bash

# Get the full absolute path to the Codebase directory
CODEBASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
START_SCRIPT="$CODEBASE_DIR/start_data_pipeline.sh"

# Make sure the script is executable
chmod +x "$START_SCRIPT"

# Create systemd service
SERVICE_NAME="data-pipeline"
SERVICE_FILE="/etc/systemd/system/$SERVICE_NAME.service"

sudo tee "$SERVICE_FILE" > /dev/null <<EOF
[Unit]
Description=Start Data Pipeline on Boot
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
ExecStart=$START_SCRIPT
Restart=no

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd and enable the service
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable "$SERVICE_NAME.service"

echo "✅ Data pipeline service installed and will run on next boot."
echo "✅ Config Files Created."
echo "📝 Update all files in ./Config before restart."
