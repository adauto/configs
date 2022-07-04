#!/bin/bash

VIMRC=~/.vimrc
TMUXCONF=~/.tmux.conf
VIMVERSION="IMproved 9"

function is_bin_in_path() {
  if [[ -n $(echo $ZSH_VERSION) ]]; then
    echo $(builtin whence -p "$1")
  else  # bash:
    echo $(builtin type -p "$1")
  fi
}

function install_homebrew() {
  if ! [[ -n $(is_bin_in_path brew) ]]; then
    echo "Installing homebrew"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  else 
    echo "homebrew detected"
    brew update
    brew upgrade
  fi 
}

function install_zsh() {
  if ! [[ -n $ZSH ]]; then
    echo "Installing zsh and oh-my-zsh"
    brew install zsh && \
      sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && \
      cp -r .oh-my-zsh/ ~ && \
      #Disabling terminal auto title
      sed -i'.zshrc' 's/# DISABLE_AUTO_TITLE="false"/DISABLE_AUTO_TITLE="true"/g' ~/.zshrc
  else 
    echo "zsh detected"
    brew reinstall zsh
  fi
}

function install_vim() {
  if ! [[ "$(vim --version)" == *"$VIMVERSION"* ]]; then
    echo "Installing vim"
    brew install vim
    echo "Creating the vimrc file"
    cp .vimrc ~
  else
    echo "vim9 detected"	  
    brew reinstall vim
    echo "Updating the vimrc file content"
    cat .vimrc > ~/.vimrc
  fi

  rm -rf ~/.vim
  cp -r .vim ~

  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  #vim -c 'PlugInstall'
}

function install_fzf() {
  if ! [[ -n $(is_bin_in_path fzf) ]]; then
    echo "Installing fzf"
    brew install fzf
  else 
    echo "fzf detected"
    brew reinstall fzf
  fi

  $(brew --prefix)/opt/fzf/install

  if ! [[ -n $(is_bin_in_path bat) ]]; then
    # Bat is rquired for syntax highlighting in fzf file preview
    echo "Installing bat"
    brew install bat
  else 
    echo "bat detected"
    brew reinstall bat
  fi
}

function install_tmux() {
  if ! [[ -n $(is_bin_in_path tmux) ]]; then
    echo "Installing tmux"
    brew install tmux;
    echo "Creating the tmux conf file"
    cp .tmux.conf ~
  else
    echo "tmux detected"
    brew reinstall tmux
    echo "Updating the tmux conf file content"
    cat .tmux.conf > ~/.tmux.conf
  fi
}

function configure() {
  while true; do
    read -p "This script will override all Vim configs. Do you want to proceed? (y/n)" yn
      case $yn in
          [Yy]* ) make install; break;;
          [Nn]* ) exit;;
          * ) echo "Please answer yes or no.";;
      esac
  done

  install_homebrew && install_zsh && install_vim && install_fzf && install_tmux

  echo "** You need to run PlugInstall vim command in order to install all its plugins **" 
  echo "** :CocInstall coc-rust-analyzer **" 
  echo "** :CocInstall coc-java **" 
}

configure
