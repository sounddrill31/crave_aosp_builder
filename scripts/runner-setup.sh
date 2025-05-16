# Copyright (C) 2024-2025 Souhrud Reddy
# SPDX-License-Identifier: Apache-2.0

#!/bin/bash

#Zip download
rm -rf actions-runner || true

  echo "Installing Runner!" #Create folder and download zip
  echo "Downloading Zip"
  version=$(curl -s "https://api.github.com/repos/actions/runner/releases/latest" | grep -oP '"tag_name": "\K[^"]*' | sed 's/^v//')
  url=$(echo "$response" | grep -oP '"browser_download_url": "\K[^"]*' | grep 'linux-x64.tar.gz')
  
  if [[ -z "${version}" ]]; then
    echo "Failed to retrieve the version number"
    exit 1
  fi # Fetch version
  
  url=https://github.com/actions/runner/releases/download/v${version}/actions-runner-linux-x64-${version}.tar.gz # Fetch URL
  url=$(echo "$url" | xargs) # Remove leading/trailing whitespace
  if ! wget -O actions-runner-linux-x64.tar.gz "${url}"; then
    echo "Failed to download the runner package"
  exit 1
  fi
  
  echo "Extracting Zip"
    mkdir -p actions-runner
    tar -xvf actions-runner-linux-x64.tar.gz -C actions-runner
  echo "Removing Leftovers"
    rm -rf actions-runner-linux-x64.tar.gz # Extract package and remove leftovers
