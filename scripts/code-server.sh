#!/bin/bash

# Check if config file exists, download it if not
if [ ! -f ~/.config/code-server/config.yaml ]; then
  curl -o ~/.config/code-server/config.yaml https://raw.githubusercontent.com/sounddrill31/crave_aosp_builder/main/configs/code-server/config.yaml
fi

# Check if code-server command is available, install it if not
if ! command -v code-server &> /dev/null; then
  curl -fsSL https://code-server.dev/install.sh | sh
fi

# Create a tmux window called "code-session" and run code-server inside it
tmux new-window -n "code-session" "code-server"
