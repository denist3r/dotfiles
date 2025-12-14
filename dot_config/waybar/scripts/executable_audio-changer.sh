#!/bin/bash

# USAGE: ./audio-changer.sh [output|input]

MODE="$1" # Set to "output" or "input"
MENU="wofi --show dmenu --prompt 'Select Audio Device'"
# If using Rofi, change to: MENU="rofi -dmenu -i -p 'Select Audio Device'"

if [[ "$MODE" == "output" ]]; then
    # Get sinks (speakers/headphones)
    # We use jq to parse JSON for robustness
    DEVICES=$(pactl -f json list sinks | jq -r '.[] | "\(.index) \(.description)"')
    COMMAND="set-default-sink"
    
elif [[ "$MODE" == "input" ]]; then
    # Get sources (microphones)
    DEVICES=$(pactl -f json list sources | jq -r '.[] | select(.monitor_source == null) | "\(.index) \(.description)"')
    COMMAND="set-default-source"
else
    echo "Usage: $0 [output|input]"
    exit 1
fi

# Show menu and get selection
SELECTED=$(echo "$DEVICES" | eval "$MENU")

# Exit if cancelled
if [[ -z "$SELECTED" ]]; then
    exit 0
fi

# Extract the Index (first word) and Description
INDEX=$(echo "$SELECTED" | awk '{print $1}')
NAME=$(echo "$SELECTED" | cut -d ' ' -f 2-)

# Set the device
pactl $COMMAND "$INDEX"

# Optional: Move currently playing streams to the new device
# This ensures music playing NOW switches immediately
if [[ "$MODE" == "output" ]]; then
    INPUTS=$(pactl list short sink-inputs | cut -f1)
    for INPUT in $INPUTS; do
        pactl move-sink-input "$INPUT" "$INDEX"
    done
fi

# Send notification (optional, requires libnotify)
notify-send "Audio Switched" "Changed to: $NAME"
