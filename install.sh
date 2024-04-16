#!/bin/sh

# Create symlinks
mkdir ~/.config
ln -s ~/.dotfiles/.zshrc ~/.zshrc
ln -s ~/.dotfiles/.nvim ~/.config/nvim
ln -s ~/.dotfiles/.gitconfig ~/.gitconfig

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Then pass in the Brewfile location...
brew bundle --file ~/.dotfiles/Brewfile

# add tex snippets for ultisnips
ln -s ~/.dotfiles/tex.snippets ~/.vim/Ultisnips/tex.snippets

# install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
