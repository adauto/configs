#!/bin/bash

VIMRC=~/.vimrc
TMUXCONF=~/.tmux.conf

function is_bin_in_path {
  if [[ -n $ZSH_VERSION ]]; then
    builtin whence -p "$1" &> /dev/null
  else  # bash:
    builtin type -P "$1" &> /dev/null
  fi
}

function install_homebrew() {
  if [[ ! is_bin_in_path brew ]]; then
    echo "Installing homebrew"
    curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh
  else 
    echo "homebrew detected"
  fi 
}

function install_zsh() {
  if [[ ! -n $ZSH_VERSION ]]; then
    echo "Installing zsh and oh-my-zsh"
    brew install zsh \ 
      && sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \ 
      && cp -r .oh-my-zsh/ ~ \
      #Disabling terminal auto title
      && sed -i'.zshrc' 's/# DISABLE_AUTO_TITLE="false"/DISABLE_AUTO_TITLE="true"/g' ~/.zshrc
  else 
    echo "zsh detected"
  fi
}

function install_vim() {
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
  cp -r .vim/ ~
}

function install_fzf() {
  if [[ ! is_bin_in_path fzf ]]; then
    echo "Installing fzf"
    brew install fzf \
      && $(brew --prefix)/opt/fzf/install
  else 
    echo "fzf detected"
  fi
  if [[ ! is_bin_in_path bat ]]; then
      # Bat is rquired for syntax highlighting in fzf file preview
      echo "Installing bat"
      brew install bat
  else 
    echo "bat detected"
  fi
}

function install_tmux() {
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

install_homebrew && install_zsh && install_vim && install_fzf && install_tmux
