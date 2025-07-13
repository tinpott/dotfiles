#!/bin/bash

if [[ $# != 2 ]]; then
	>&2 echo "Illegal number of arguments. Must have 2"
	exit 1
fi

volume_diff=5
ping=false # TODO: implement this and make it configurable

channel=$1
sink="sink"
src="source"
if [ $channel = "sink" ]; then
	channel="@DEFAULT_SINK@"
elif [ $channel = "source" ]; then
	channel="@DEFAULT_SOURCE@"
else
	>&2 echo "Illegal channel: $channel"
	exit 1
fi

action=$2
if [ $action = "inc" ]; then
	wpctl set-volume $channel $volume_diff%+
	if [[ ping = true && $channel = "@DEFAULT_SINK@" ]]; then
		play "$HOME/Music/ping.aiff" 2> /dev/null &
	fi
elif [ $action = "dec" ]; then
	wpctl set-volume $channel $volume_diff%-
	if [[ ping = true && $channel = "@DEFAULT_SINK@" ]]; then
		play "$HOME/Music/ping.aiff" 2> /dev/null &
	fi
elif [ $action = "toggle" ]; then
	wpctl set-mute $channel toggle
else
	>&2 echo "Illegal action: $action"
	exit 1
fi

if [ $channel = "@DEFAULT_SINK@" ]; then
	icon=""
else
	icon=""
fi
volume=$(wpctl get-volume $channel) # TODO: $(wpctl get-volume $channel | awk '{printf("%d%%\n", 100 * $2)}')
msg_tag="myvolume"
if [[ $action = "inc" || $action = "dec" ]]; then # FIXME: the icons don't work
	dunstify \
		-a "changeVolume" \
		-u low \
		-t 3000 \
		-i audio-volume-high \
		-h string:x-dunst-stack-tag:$msg_tag \
		-h int:value:"$volume" "${icon} ${volume}"
else
	dunstify \
		-a "changeVolume" \
		-u low \
		-t 3000 \
		-i audio-volume-muted \
		-h string:x-dunst-stack-tag:$msg_tag \
		-h int:value:"$volume" "${icon} ${volume}"
fi
