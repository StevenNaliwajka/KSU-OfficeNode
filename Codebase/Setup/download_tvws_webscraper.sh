#!/bin/bash

set -euo pipefail

# Define paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CODEBASE_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
TARGET_DIR="$CODEBASE_DIR/TVWS"
REPO_URL="https://github.com/StevenNaliwajka/TVWSDataScraper.git"

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

# If there’s a requirements.txt, install dependencies in a virtualenv
if [[ -f "$TARGET_DIR/requirements.txt" ]]; then
    echo "Setting up Python virtual environment..."
    python3 -m venv "$TARGET_DIR/venv"
    source "$TARGET_DIR/venv/bin/activate"
    pip install --upgrade pip
    pip install -r "$TARGET_DIR/requirements.txt"
    deactivate
fi

echo "TVWS webscraper is downloaded and ready in: $TARGET_DIR"
