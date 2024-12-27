#!/bin/bash

cameractrls -d /dev/video0 \
	-c zoom_absolute=4,brightness=125,contrast=3,saturation=37,sharpness=2,white_balance_automatic=off,white_balance_temperature=2800

