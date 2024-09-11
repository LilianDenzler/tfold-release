#!/bin/zsh

# set -e

# init conda
conda init zsh

# source .zshrc to activate conda
source $HOME/.zshrc

# turn off conda auto-activate base
conda config --set auto_activate_base false

# keep a copy of current working directory
cwd=$(pwd)

# define the environment name e.g. "esm2", "wwpdb", etc.
envname="tfold-env"

# if conda env doesn't exist, create it
conda env update -f $HOME/tfold-env.yml

# cleanup
conda clean -a -y && \
pip cache purge && \
sudo apt autoremove -y
