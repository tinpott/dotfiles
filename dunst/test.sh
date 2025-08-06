#!/bin/bash

TIMEOUT_MS=5000
notify-send -t $TIMEOUT_MS -u low      "Urgency: low"
notify-send -t $TIMEOUT_MS -u normal   "Urgency: normal"
notify-send -t $TIMEOUT_MS -u critical "Urgency: critical"

