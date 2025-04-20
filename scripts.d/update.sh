#!/bin/bash

set -e

print_banner() {
	CHAR="="
	REGEX="s/./$CHAR/g"
	LINE="$CHAR $1 $CHAR"
	echo ""
	echo ""
	echo $LINE | sed $REGEX
	echo $LINE
	echo $LINE | sed $REGEX
	echo ""
}

# no need for `sudo snap refresh` because snapd should keep snaps automatically up-to-date

print_banner "flatpak"
flatpak update

print_banner "Arch repos and the AUR"
yay --needed

