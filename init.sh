#!/bin/sh

# If a command fails then the deploy stops
set -e

printf "\033[0;32mstart init submodules...\033[0m\n"

git clone https://github.com/Bittree/Bittree.github.io public
git submodule init
git submodule update