#!/bin/bash

# Check if config file exists, download it if not
if [ ! -f ~/.config/code-server/config.yaml ]; then
  echo "Config not found! Downloading..."
  curl -o ~/.config/code-server/config.yaml https://raw.githubusercontent.com/sounddrill31/crave_aosp_builder/main/configs/code-server/config.yaml
else
  echo "Config found! Skipping..."
fi

# Check if code-server command is available, install it if not
if ! command -v code-server &> /dev/null; then
  echo "Code-server not found! Downloading..."
  curl -fsSL https://code-server.dev/install.sh | sh
else
  echo "Code-server found! Skipping..."
fi

# Create a tmux window called "code-session" and run code-server inside it
tmux new-session -AD -s "code-session"
tmux send-keys -t "code-session" 'killall code-server ; code-server' Enter
echo "Created code-session!"
