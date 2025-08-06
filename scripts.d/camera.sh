#!/bin/bash

# FIXME: This script works, but it's relatively slow because it runs several commands in succession. Ideally, we'd be
# able to set these options in a single command with each `-c` option on its own line, but that doesn't work with
# cameractrls because only the last `-c` option is applied with multiple `-c` options

video_device="/dev/video0"
cameractrls -d $video_device -c "zoom_absolute=                4"
cameractrls -d $video_device -c "brightness=                 125"
cameractrls -d $video_device -c "contrast=                     3"
cameractrls -d $video_device -c "saturation=                  37"
cameractrls -d $video_device -c "sharpness=                    1"
cameractrls -d $video_device -c "white_balance_automatic=    off"
cameractrls -d $video_device -c "white_balance_temperature= 2800"
