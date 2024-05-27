# Copyright (C) 2024 Souhrud Reddy
# SPDX-License-Identifier: Apache-2.0

# Needs testing!
# Usage: 
# (Part 1) Inside Devspace:
#   crave ssh -- "mkdir /tmp/src/android/.android-certs";
#    find .android-certs/ -type f | while read filename; do
#     echo "Processing $filename"
#     crave push "$filename" -d /tmp/src/android/"$filename"
#    done

# (Part 2) Inside crave run command, before building section:
# export SIGNING_PREFERENCE=true
# curl https://raw.githubusercontent.com/sounddrill31/crave_aosp_builder/signing/scripts/signing-script.sh | bash

#!/bin/bash

# Define the directory path
dir_path=".android-certs"

# Read Signing Preference from Environmental Variables and set a default if it is blank

: ${SIGNING_PREFERENCE:=false}
echo "Signing Preference: $SIGNING_PREFERENCE"

# Check if the directory exists
if [ -d "$dir_path" && ${{SIGNING_PREFERENCE}} != "false" ]; then
  echo "Keys provided, setting them up"
  mkdir -p vendor/extra
  mkdir -p vendor/lineage-priv
  cp -R .android-certs vendor/extra/keys
  cp -R .android-certs vendor/lineage-priv/keys
  echo "PRODUCT_DEFAULT_DEV_CERTIFICATE := vendor/extra/keys/releasekey" > vendor/extra/product.mk
  echo "PRODUCT_DEFAULT_DEV_CERTIFICATE := vendor/lineage-priv/keys/releasekey" > vendor/lineage-priv/keys/keys.mk
  
  echo "filegroup(
    name = \"android_certificate_directory\",
    srcs = glob([
        \"*.pk8\",
        \"*.pem\",
    ]),
    visibility = [\"//visibility:public\"],
)" > vendor/lineage-priv/keys/BUILD.bazel
cp vendor/lineage-priv/keys/BUILD.bazel 

else
  echo "No Keys Provided, skipping signing"
fi
