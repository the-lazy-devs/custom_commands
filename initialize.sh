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
    local SCRIPT_DIR_LOCATION=$1
    local SCRIPTS=( "$SCRIPT_DIR_LOCATION/commands"/*.sh )
    for FULL_SCRIPT_NAME in ${SCRIPTS[@]}; do
        local SCRIPT_FILE_NAME=${FULL_SCRIPT_NAME##*/}
        local SCRIPT=${SCRIPT_FILE_NAME%.*}

        if [[  -L "$HOME/.bin/${SCRIPT}" ]]; then
            echo "symlink for ${SCRIPT} is already present. nothing to do."
        else
            echo "creating a symlink for $SCRIPT"
            ln -s "$SCRIPT_DIR_LOCATION/commands/$SCRIPT_FILE_NAME" "$HOME/.bin/$SCRIPT"
        fi
    done
}

function update_alias_sourcing () {
    local SCRIPT_DIR_LOCATION=$1
    local PROFILE_FILE_LOCATION=$2

    local SCRIPTS=( "$SCRIPT_DIR_LOCATION/aliases"/*.sh )
    for SCRIPT in ${SCRIPTS[@]}; do
        if grep -q "source $SCRIPT" "$PROFILE_FILE_LOCATION"; then
            echo "${SCRIPT} has already been sourced. nothing to do."
        else
            echo "adding the aliases from $SCRIPT to .bash_profile"
            echo "source $SCRIPT" >> $PROFILE_FILE_LOCATION
        fi
    done
}

SCRIPT_DIR_LOCATION="$(cd -P -- "$(dirname -- "$0")" && pwd -P)"
PROFILE_FILE_LOCATION=$HOME/.bash_profile

create_bin_directory
update_path_variable
create_symlinks $SCRIPT_DIR_LOCATION
update_alias_sourcing $SCRIPT_DIR_LOCATION $PROFILE_FILE_LOCATION
