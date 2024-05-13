#!/bin/bash

if [[ $# != 2 ]]; then
	>&2 echo "Illegal number of arguments. Must have 2"
	exit 1
fi

volumeDiff=5

channel=$1
sink="sink"
src="source"

action=$2
inc="inc"
dec="dec"
toggle="toggle"

if [[ $channel == $sink && $action == $inc ]]; then
	wpctl set-volume @DEFAULT_AUDIO_SINK@ $volumeDiff%+
elif [[ $channel == $sink && $action == $dec ]]; then
	wpctl set-volume @DEFAULT_AUDIO_SINK@ $volumeDiff%-
elif [[ $channel == $sink && $action == $toggle ]]; then
	wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
elif [[ $channel == $src && $action == $inc ]]; then
	wpctl set-volume @DEFAULT_AUDIO_SOURCE@ $volumeDiff%+
elif [[ $channel == $src && $action == $dec ]]; then
	wpctl set-volume @DEFAULT_AUDIO_SOURCE@ $volumeDiff%-
elif [[ $channel == $src && $action == $toggle ]]; then
	wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
else
	>&2 echo "Unknown arguments: $channel $action"
	exit 1
fi
