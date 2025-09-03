#!/usr/bin/env bash

# Clone my dotfiles
git clone git@github.com:AutofillMe/Dotfiles.git ~/.dotfiles
cd ~/.dotfiles
stow . --adopt
git restore .
cd ~
