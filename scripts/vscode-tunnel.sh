# Copyright (C) 2024-2025 Souhrud Reddy
# SPDX-License-Identifier: Apache-2.0

#!/bin/bash

if [ -d "code-tunnel" ]; then
  echo "skipping download!"
else
  echo "Installing Runner!" #Create folder and download zip
  echo "Downloading Zip"  
  curl -Lk 'https://code.visualstudio.com/sha/download?build=stable&os=cli-alpine-x64' --output vscode_cli_alpine_x64_cli.tar.gz
  echo "Extracting Zip"
    mkdir -p code-tunnel
    tar -xvf vscode_cli_alpine_x64_cli.tar.gz -C code-tunnel
  echo "Removing Leftovers"
    rm -rf vscode_cli_alpine_x64_cli.tar.gz # Extract package and remove leftovers
fi

tmux kill-session -t codetunnel || true
tmux new-session -d -s codetunnel
tmux send-keys -t codetunnel './code-tunnel/code tunnel --accept-server-license-terms' Enter 
echo "Runner Started"
