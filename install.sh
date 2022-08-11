#!/bin/bash

set -e

VIMVERSION="IMproved 9"
VIMRC=~/.vimrc
TMUXCONF=~/.tmux.conf
FONT_FILE=/Libray/Fonts/SFMono\ Regular\ Nerd\ Font.otf

is_bin_in_path() {
  if [[ -n $(echo $ZSH_VERSION) ]]; then
    echo $(builtin whence -p "$1")
  else  # bash:
    echo $(builtin type -p "$1")
  fi
}

install_homebrew() {
  if ! [[ -n $(is_bin_in_path brew) ]]; then
    echo "Installing homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  else 
    echo "homebrew detected"
  fi 
}

install_zsh() {
  if ! [[ -n $ZSH ]]; then
    echo "Installing zsh and oh-my-zsh"
    brew install zsh
  else 
    echo "zsh detected"
  fi

  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  echo "copying the zsh theme"
  cp .oh-my-zsh/themes/adauto.zsh-theme ~/.oh-my-zsh/themes/adauto.zsh-theme
  echo "setting zsh theme"
  sed -i'.zshrc' 's/ZSH_THEME="robbyrussell"/ZSH_THEME="adauto"/g' ~/.zshrc
  echo "disabling zsh auto title"
  sed -i'.zshrc' 's/# DISABLE_AUTO_TITLE="true"/DISABLE_AUTO_TITLE="true"/g' ~/.zshrc
}

install_vim() {
  if ! [[ "$(vim --version)" == *"$VIMVERSION"* ]]; then
    echo "Installing vim"
    brew install vim
    echo "Creating the vimrc file"
    cp .vimrc ~
  else
    echo "vim9 detected"	  
    echo "Updating the vimrc file content"
    cat .vimrc > ~/.vimrc
  fi

  if ! [[ -n $(is_bin_in_path node) ]]; then
    # Some vim plugins depends on Node
    echo "Installing node"
    brew install node
  fi

  rm -rf ~/.vim
  cp -r .vim ~

  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  vim -c 'PlugInstall' -c 'q' -c 'q'
}

install_fzf() {
  if ! [[ -n $(is_bin_in_path fzf) ]]; then
    echo "Installing fzf"
    brew install fzf
  else 
    echo "fzf detected"
  fi

  $(brew --prefix)/opt/fzf/install

  if ! [[ -n $(is_bin_in_path bat) ]]; then
    # Bat is rquired for syntax highlighting in fzf file preview
    echo "Installing bat"
    brew install bat
  else 
    echo "bat detected"
  fi
}

install_tmux() {
  if ! [[ -n $(is_bin_in_path tmux) ]]; then
    echo "Installing tmux"
    brew install tmux
    echo "Creating the tmux conf file"
    cp .tmux.conf ~
  else
    echo "tmux detected"
    echo "Updating the tmux conf file content"
    cat .tmux.conf > ~/.tmux.conf
  fi
}

install_golang() {
  if ! [[ -n $(is_bin_in_path go) ]]; then
    echo "Installing golang"
    brew install go
  else
    echo "golang detected"
  fi
}

install_fonts() {
    echo "Installing patched font file"

    if [ -f "$FONT_FILE" ]; then
        echo "Font file detected"
    else
        cp ./fonts/SFMono\ Regular\ Nerd\ Font.otf  /Libray/Fonts/
    fi
}

configure() {
  install_homebrew && \
    install_zsh && \
    install_vim && \
    install_fonts && \
    install_fzf && \
    install_tmux && \
    install_golang && \
    echo "** All of the tools were successfully installed  **"
}

while true; do
  read -p "This script will override all Vim configs. Do you want to proceed? (y/n)" yn
    case $yn in
        [Yy]* ) configure; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
