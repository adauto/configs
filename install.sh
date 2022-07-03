#!/bin/bash

VIMRC=~/.vimrc
TMUXCONF=~/.tmux.conf

install_homebrew() {
  echo "Installing homebrew"
  curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh;
}

install_vim() {
  echo "Installing vim"
  brew install vim

  if [ ! -f "$VIMRC" ]; then
    echo "Creating the vimrc file"
    cp .vimrc ~
  else
    echo "Updating the vimrc file content"
    cat .vimrc > ~/.vimrc
    rm -rf ~/.vim
  fi
  cp -r .vim ~
}

install_tmux() {
  echo "Installing tmux"
  brew install tmux;

  if [ ! -f "$TMUXCONF" ]; then
    echo "Creating the tmux conf file"
    cp .tmux.conf ~
  else
    echo "Updating the tmux conf file content"
    cat .tmux.conf > ~/.tmux.conf
  fi
}

while true; do
    read -p "This script will override all Vim configs. Do you want to proceed?" yn
    case $yn in
        [Yy]* ) make install; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

install_homebrew && install_vim && install_tmux
