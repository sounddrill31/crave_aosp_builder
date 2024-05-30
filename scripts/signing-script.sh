# Copyright (C) 2024 Souhrud Reddy
# SPDX-License-Identifier: Apache-2.0

# Needs testing!
# Usage: 
# (Part 1) Inside Devspace:
# If our current devspace folder is /crave-devspaces/Lineage20, we make /crave-devspaces/private/Lineage20/.android-certs with our certificates 
# curl https://raw.githubusercontent.com/sounddrill31/crave_aosp_builder/signing/scripts/signing-script.sh | bash


# (Part 2) Inside crave run command, before building section:
# export SIGNING_PREFERENCE=true
# curl https://raw.githubusercontent.com/sounddrill31/crave_aosp_builder/signing/scripts/signing-script.sh | bash

#!/bin/bash

set -x

# Define the directory path
dir_path=".android-certs"

# Read Signing Preference from Environmental Variables and set a default if it is blank
  : ${SIGNING_PREFERENCE:=false}
  echo "Signing Preference: $SIGNING_PREFERENCE"

# Check if we're running in devspace CLI or not
if [ "${DCDEVSPACE}" == "1" ]; then

#KEYS_DIR="../private/$(basename "$PWD")"
KEYS_DIR=$(realpath "../private/$(basename "$PWD")")

mkdir -p $dir_path

# Check if keys exist in the path. If they do, copy them to project folder
  if [ -d "../private/$(basename "$PWD")" ]; then
    echo "Keys found at ${KEYS_DIR}, copying to temporary project folder"
    cp -R $KEYS_DIR/* $dir_path
    crave push .android-certs -d /tmp/src/android/
  else
    echo "No Keys found. Please ensure they exist inside ${KEYS_DIR}"
    exit 0;
  fi

else # For when we're not running in devspace CLI

# Check if the directory exists
  if [ -d "$dir_path" ] && [ $SIGNING_PREFERENCE != "false" ]; then
    echo "Keys provided, setting them up"
    mkdir -p vendor/extra
    mkdir -p vendor/lineage-priv

# Copy certs
    cp -R .android-certs vendor/extra/keys
    cp -R .android-certs vendor/lineage-priv/keys

# Create makefiles
    echo "PRODUCT_DEFAULT_DEV_CERTIFICATE := vendor/extra/keys/releasekey" > vendor/extra/product.mk
    echo "PRODUCT_DEFAULT_DEV_CERTIFICATE := vendor/lineage-priv/keys/releasekey" > vendor/lineage-priv/keys/keys.mk
  
# Create BUILD.bazel
    curl -o vendor/lineage-priv/keys/BUILD.bazel https://raw.githubusercontent.com/sounddrill31/crave_aosp_builder/signing/configs/signing/BUILD.bazel
    cat vendor/lineage-priv/keys/BUILD.bazel # For debugging, this doesn't contain any sensitive stuff
  else
    echo "No Keys Provided, skipping signing"
  fi
fi
