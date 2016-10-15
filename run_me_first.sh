#!/bin/bash

# TODO:
# - check for ~/.bin directory; create if not present
# - loop over scripts, creating links

if [[ -d "$HOME/.bin" ]]; then
    echo "$HOME/.bin already exists. nothing to do"
else
    echo "creating $HOME/.bin"
    mkdir $HOME/.bin
fi

if grep -q '$HOME/.bin' "$HOME/.bash_profile" ; then
    echo "$HOME/.bin is added to the PATH variable in .bash_profile already. nothing to do". 
else
    echo "updating ~/.bash_profile to add $HOME/.bin to the PATH variable"
    echo 'export PATH="$PATH:$HOME/.bin"' >> "$HOME/.bash_profile"
fi

if grep -q '$HOME/.bin' "$HOME/.bashrc" ; then
    echo "$HOME/.bin is added to the PATH variable in .bashrc already. nothing to do". 
else
    echo "updating ~/.bashrc to add $HOME/.bin to the PATH variable"
    echo 'export PATH="$PATH:$HOME/.bin"' >> "$HOME/.bashrc"
fi
