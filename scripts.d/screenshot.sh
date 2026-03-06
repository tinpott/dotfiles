#!/bin/bash

pids=$(pgrep -f grimshot)
if [ -z $pids ]; then
	grim -g "$(slurp)" - | wl-copy
	# TODO: Save screenshots by fixing this syntax: wl-paste "$HOME/Pictures/screenshots/screenshot_$(date +%Y-%m-%d_%H-%M-%S)"
fi
