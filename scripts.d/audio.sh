#!/bin/bash

if [[ $# != 2 ]]; then
	>&2 echo "Illegal number of arguments. Must have 2"
	exit 1
fi


channel_param=$1
if [[ $channel_param = "sink" ]]; then
	channel_id="@DEFAULT_SINK@"
elif [[ $channel_param = "source" ]]; then
	channel_id="@DEFAULT_SOURCE@"
else
	>&2 echo "Illegal channel param: $channel_param"
	exit 1
fi
echo "Channel: $channel_param"

volume_diff=5
action_param=$2
if [[ $action_param = "inc" ]]; then
	wpctl set-volume $channel_id $volume_diff%+
	if [[ ping = true && $channel_param = "sink" ]]; then
		play "$HOME/Music/ping.aiff" 2> /dev/null &
	fi
elif [[ $action_param = "dec" ]]; then
	wpctl set-volume $channel_id $volume_diff%-
	if [[ ping = true && $channel_param = "sink" ]]; then
		play "$HOME/Music/ping.aiff" 2> /dev/null &
	fi
elif [[ $action_param = "toggle" ]]; then
	wpctl set-mute $channel_id toggle
else
	>&2 echo "Illegal action: $action_param"
	exit 1
fi
echo "Action: $action_param"

volume=$(wpctl get-volume $channel_id | awk '{printf("%d\n", 100 * $2)}')
muted=$(wpctl get-volume $channel_id | awk '{print $3}' | grep "[MUTED]")
echo "Volume: $volume $muted"
if [[ $channel_param = "sink" ]]; then
	icon_prefix="audio-volume"
else
	icon_prefix="microphone-sensitivity"
fi
icon_string="${icon_prefix}-muted"
urgency="low"
if [[ -z $muted ]]; then
	if [[ $channel_param = "sink" && $action_param != "toggle" ]]; then
		play "$HOME/Music/ping.aiff" 2> /dev/null &
	fi
	# Icon
	if [[ $volume -gt  0 ]]; then icon_string="${icon_prefix}-low";    fi
	if [[ $volume -gt 33 ]]; then icon_string="${icon_prefix}-medium"; fi
	if [[ $volume -gt 66 ]]; then icon_string="${icon_prefix}-high";   fi
	# Urgency
	if [[ $volume -gt 100 ]]; then
		urgency="critical"
	fi
fi

msg_tag="myvolume"
dunstify \
	-a "changeVolume" \
	-u $urgency \
	-t 3000 \
	-i $icon_string \
	-h string:x-dunst-stack-tag:$msg_tag \
	-h int:value:"$volume" "${volume}%"
