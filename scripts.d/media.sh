#!/bin/bash

if [[ $# != 1 ]]; then
	>&2 echo "Illegal number of arguments. Must have 1"
	exit 1
fi

action=$1
toggle="toggle"
next="next"
prev="prev"

if [[ $action == $toggle ]]; then
	playerctl play-pause
elif [[ $action == $next ]]; then
	playerctl next
elif [[ $action == $prev ]]; then
	playerctl previous
else
	>&2 echo "Unknown arguments: $action"
	exit 1
fi