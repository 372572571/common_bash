#!/bin/bash

# Define the file to store the last known IP address
LAST_IP_FILE="/tmp/last_ip.txt"
# Define the script to run if the IP changes
# SCRIPT_TO_RUN=$(dirname "$0")/update_dns.sh
SCRIPT_TO_RUN="$1"

if [ -z "$SCRIPT_TO_RUN" ]; then
    echo "Usage: $0 <script_to_run>"
    exit 1
fi  

# Get the current external IP address
CURRENT_IP=$(curl -s http://checkip.amazonaws.com)

# If the IP address is not obtained, exit the script
if [ -z "$CURRENT_IP" ]; then
    echo "Failed to get the current IP address."
    exit 1
fi

# Check if the last IP file exists
if [ -f "$LAST_IP_FILE" ]; then
    # Read the last known IP address
    LAST_IP=$(cat "$LAST_IP_FILE")
else
    # If the file doesn't exist, initialize it with the current IP
    echo "$CURRENT_IP" > "$LAST_IP_FILE"
    LAST_IP="$CURRENT_IP"
fi

# Compare the current IP with the last known IP
if [ "$CURRENT_IP" != "$LAST_IP" ]; then
    echo "IP address has changed from $LAST_IP to $CURRENT_IP"
    # Update the last known IP address
    echo "$CURRENT_IP" > "$LAST_IP_FILE"
    # Run the specified script
    if [ -f "$SCRIPT_TO_RUN" ]; then
        bash "$SCRIPT_TO_RUN"
    else
        echo "Script not found: $SCRIPT_TO_RUN"
    fi
else
    echo "IP address has not changed."
fi

