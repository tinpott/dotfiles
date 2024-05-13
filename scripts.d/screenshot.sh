#!/bin/bash

#fileName="grimshot_$(date +%Y-%m-%d_%H-%M-%S).png"
#savePath="$HOME/Pictures/screenshots"
#mkdir -p $savePath
#wl-copy < $(grimshot --notify save area "$savePath/$fileName")

pids=$(pgrep -f grimshot)
if [ -z $pids ]; then
	grimshot --notify copy area
fi
