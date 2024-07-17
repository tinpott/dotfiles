#!/bin/bash

echo '####################################'
echo '# Updating packages from neovim... #'
echo '####################################'
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

echo '##################################'
echo '# Updating packages from snap... #'
echo '##################################'
snap refresh

echo '#####################################'
echo '# Updating packages from flatpak... #'
echo '#####################################'
flatpak update

echo '####################################################'
echo '# Updating packages from Arch repos and the AUR... #'
echo '####################################################'
yay -Syu --needed
