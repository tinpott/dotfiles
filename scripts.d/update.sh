#!/bin/bash

yay -Syu
flatpak update
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
