#!/bin/bash

#mkdir -p $WALLPAPER_DEFAULT_PATH
#ln -sf "$WALLPAPER_DEFAULT_PATH/hypr$((RANDOM % 2)).png" "$WALLPAPER_DEFAULT_PATH/$WALLPAPER_DEFAULT_FILE"
#$HOME/proj/dotfiles/hypr/config/wallpaper.py

# system
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
waybar &
dunst &
swaync &
hyprpaper &
hypridle &
hyprpm reload -n &

# media
noisetorch -i &
wpctl set-default 159 &
wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 50% &
wpctl set-volume @DEFAULT_AUDIO_SINK@   50% &
wpctl set-mute   @DEFAULT_AUDIO_SOURCE@ 1 & # mute mic
wpctl set-mute   @DEFAULT_AUDIO_SINK@   0 & # unmute speakers/headphones
~/.scripts/camera.sh &

# user
steam &
discord &
