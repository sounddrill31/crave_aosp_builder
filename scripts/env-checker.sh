#!/bin/bash

# Check if crave.conf.sample exists
if [ ! -f "crave.conf.sample" ]; then
  echo "crave.conf.sample doesn't exist!"
  exit 1
fi

# Check if file name is correct
if [ -f "crave.conf" ]; then
  echo "Don't change crave.conf.sample! Exiting..."
  exit 1
fi

# Check if username has been altered
if ! grep -q "\"username\": \"\${CRAVE_USERNAME}\"" "crave.conf.sample"; then
  echo "Don't add your username to crave.conf, use github secrets! Exiting..."
  exit 1
fi

# Check if Authorization has been altered
if ! grep -q "\"Authorization\": \"\${CRAVE_TOKEN}\"" "crave.conf.sample"; then
  echo "Don't add your token to crave.conf, use github secrets! Exiting..."
  exit 1
fi

# Check if server is set to devspace.crave.io
if grep -q "\"server\": \"https://devspace.crave.io/api\"" "crave.conf.sample"; then
  echo "Devspace.crave.io is the public instance and does not support building android!"
  echo "Get a foss.crave.io account. To know more, read the docs: https://opendroid.pugzarecute.com/wiki/Crave_Devspace#getting-a-fosscraveiohttpsfosscraveio-account"
  echo "Exiting..."
  exit 1
fi

echo "crave.conf looks okay! Continuing..."