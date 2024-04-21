#!/bin/bash

CURRENT_DIR=$(pwd)

# is a command exists? call like isCmdExist vim
function isCmdExist() {
	local cmd="$1"
	if [ -z "$cmd" ]; then
		echo "Usage isCmdExist yourCmd"
		return 1
	fi
	which "$cmd" >/dev/null 2>&1
	if [ $? -eq 0 ]; then
		return 0
	fi
	return 2
}

# 1. git and zsh
if ! isCmdExist git; then
  echo "please install git"
  exit
fi
if ! isCmdExist zsh; then
  echo "install zsh now"
  if [ `whoami` != "root" ]; then
    # install zsh for non-root user (enable change theme)
    mkdir -p $HOME/.local
    cd zsh
    tar xvJf zsh-5.8.tar.xz
    cd zsh-5.8
    ./configure --prefix="$HOME/.local"
    make
    make install
    cd ..
    rm -rf zsh-5.8
    cd ..
  else
    echo "root user is not supported"
    exit
  fi
fi
export PATH=$HOME/.local/bin:/usr/bin:$PATH
export LD_LIBRARY_PATH=$HOME/.local/lib:/usr/lib:$LD_LIBRARY_PATH
./zsh/fonts/install.sh
# chsh -s $HOME/.local/bin/zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "install oh-my-zsh via zsh/install_oh_my_zsh_079e7bb5e0a79171f3356d55d3f6302a82645a39.sh"
  sh zsh/install_oh_my_zsh_079e7bb5e0a79171f3356d55d3f6302a82645a39.sh
fi
cp -R zsh/zsh-autosuggestions  $HOME/.oh-my-zsh/custom/plugins/
cp -R zsh/zsh-syntax-highlighting  $HOME/.oh-my-zsh/custom/plugins/

# 2. vim && vim-plug, tmux && tmux-plug
mkdir -p $HOME/.vim/colors
mkdir -p $HOME/.vim/backup
cp vim/color/*.vim $HOME/.vim/colors/
mkdir -p $HOME/.vim/autoload
cp $CURRENT_DIR/vim/vim-plug/plug.vim $HOME/.vim/autoload
mkdir -p $HOME/.tmux
mkdir -p $HOME/.tmux/plugins
if [ ! -e "$HOME/.tmux/plugins/tpm" ]; then
  ln -s $CURRENT_DIR/tmux/tpm $HOME/.tmux/plugins/tpm
else
  echo "tmp exists: $HOME/.tmux/plugins/tpm"
fi

# 3. python3-pip clang ctags
# see scripts/install_pkg.sh

# 4. set paths
ln -sf $CURRENT_DIR/vim/vimrc $HOME/.vimrc
ln -sf $CURRENT_DIR/zsh/zshrc $HOME/.zshrc
ln -sf $CURRENT_DIR/bash/bashrc $HOME/.bashrc
ln -sf $CURRENT_DIR/bash/bashrc $HOME/.bash_profile
ln -sf $CURRENT_DIR/bash/bashrc $HOME/.profile
ln -sf $CURRENT_DIR/tmux/tmux.conf $HOME/.tmux.conf
ln -sf $CURRENT_DIR/tmux/mylayout $HOME/.mylayout 
ln -sf $CURRENT_DIR/git/gitconfig $HOME/.gitconfig
ln -sf $CURRENT_DIR/./zsh/avit.zsh-theme $HOME/.oh-my-zsh/themes/avit.zsh-theme
if [ ! -e "$HOME/.vim/UltiSnips" ]; then
  ln -s $PWD/vim/snippets $HOME/.vim/UltiSnips
else
  echo "UltiSnips exists: $HOME/.vim/UltiSnips"
fi

echo "DONE"
