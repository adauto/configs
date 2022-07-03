#!/bin/bash

curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh;

brew install vim;

brew install tmux;

VIMRC=~/.vimrc

if [ ! -f "$VIMRC" ]; then
  echo "creating the vimrc file"
  cp .vimrc ~/.vimrc
else
  echo "replacing the vimrc file content"
  cat .vimrc > ~/.vimrc
fi
