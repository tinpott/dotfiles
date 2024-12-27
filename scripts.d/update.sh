#!/bin/bash

set -e

banner() {
	STR="Updating packages from $1..."
	echo -e "\n*** $STR ***\n"
}

banner "snap"
sudo snap refresh

banner "flatpak"
flatpak update

banner "Arch repos and the AUR"
yay --needed

