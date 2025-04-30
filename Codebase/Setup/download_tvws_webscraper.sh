#!/bin/bash

set -euo pipefail

# Define paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CODEBASE_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
TARGET_DIR="$CODEBASE_DIR/TVWS"
REPO_URL="https://github.com/StevenNaliwajka/TVWSDataScraper.git"
VENV_DIR="$CODEBASE_DIR/../venv"

echo "Downloading TVWS webscraper..."

# If folder exists, remove or update
if [[ -d "$TARGET_DIR" ]]; then
    echo "TVWS directory already exists. Pulling latest changes..."
    cd "$TARGET_DIR"
    git pull
else
    echo "Cloning into $TARGET_DIR..."
    git clone "$REPO_URL" "$TARGET_DIR"
fi

# Setup TVWS
source "$VENV_DIR/bin/activate"
bash $TARGET_DIR/setup.sh
deactivate

echo "TVWS webscraper is downloaded and ready in: $TARGET_DIR"
