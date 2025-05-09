#!/bin/bash
# setup.sh

# Now configure the systemd service
bash Codebase/Setup/configure_systemctl.sh
bash Codebase/Setup/install_python.sh
bash Codebase/Setup/create_config.sh
bash Codebase/Setup/create_venv.sh
bash Codebase/Setup/download_tvws_webscraper.sh

bash Codebase/TVWS/setup.sh