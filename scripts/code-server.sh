# Copyright (C) 2024-2025 Souhrud Reddy
# SPDX-License-Identifier: Apache-2.0

#!/bin/bash

# Look for whether there's a supervisor configuration that has the code-server setup
if [ -f /etc/supervisor/conf.d/vscode.conf ] ; then
    sudo supervisorctl start vscode
    # always succeed!
    exit 0
fi

# Check if config file exists and contains the correct bind address, download it if not
if [ ! -f ~/.config/code-server/config.yaml ] || ! grep -q "bind-addr: 0.0.0.0:5899" ~/.config/code-server/config.yaml; then
  read -p "Config not found or incorrect! Download? (y/n) " -n 1 -r
  echo    # (optional) move to a new line
  if [[ $REPLY =~ ^[Yy]$ ]] || [[ $1 == "--quiet" ]]; then
    echo "Downloading..."
    rm ~/.config/code-server/config.yaml 2> /dev/null
    curl -o ~/.config/code-server/config.yaml https://raw.githubusercontent.com/${{ github.repository }}/main/configs/code-server/config.yaml
  else
    echo "Skipping..."
    exit 1
  fi
else
  echo "Config found and correct! Skipping..."
fi

# Check if code-server command is available, install it if not
if ! command -v code-server &> /dev/null; then
  read -p "Code-server not found! Download? (y/n) " -n 1 -r
  echo    # (optional) move to a new line
  if [[ $REPLY =~ ^[Yy]$ ]] || [[ $1 == "--quiet" ]]; then
    echo "Downloading..."
    curl -fsSL https://code-server.dev/install.sh | sh
  else
    echo "Skipping..."
    exit 1
  fi
else
  echo "Code-server found! Skipping..."
fi

# Create a tmux window called "code-session" and run code-server inside it
tmux kill-session -t "code-session" 2> /dev/null
tmux new-session -d -s "code-session" 
tmux send-keys -t "code-session" 'code-server' Enter
echo "Created code-session!"
