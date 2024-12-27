#!/bin/bash

pids=$(pgrep -f grimshot)
if [ -z $pids ]; then
	grimshot --notify copy area
fi

