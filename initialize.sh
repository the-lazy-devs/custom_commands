#!/bin/bash

function create_bin_directory () {
    if [[ -d "$HOME/.bin" ]]; then
        echo "$HOME/.bin already exists. nothing to do"
    else
        echo "creating $HOME/.bin"
        mkdir $HOME/.bin
    fi
}

function update_path_variable () {
    DOTFILES=(.bash_profile .bashrc)
    for FILE in ${DOTFILES[@]}; do
        if grep -q '$HOME/.bin' "$HOME/$FILE" ; then
            echo "$HOME/.bin is added to the PATH variable in $FILE already. nothing to do". 
        else
            echo "updating ~/$FILE to add $HOME/.bin to the PATH variable"
            echo 'export PATH="$PATH:$HOME/.bin"' >> "$HOME/$FILE"
        fi
    done
}

function create_symlinks () {
    SCRIPTS=(gis gl gd)
    for SCRIPT in ${SCRIPTS[@]}; do
        if [[  -L "$HOME/.bin/${SCRIPT}" ]]; then
            echo "symlink for ${SCRIPT} is already present. nothing to do."
        else
            echo "creating a symlink for ${SCRIPT}"
            ln -s "$HOME/.custom_git/${SCRIPT}.sh" "$HOME/.bin/${SCRIPT}"
        fi
    done
}

create_bin_directory
update_path_variable
create_symlinks
