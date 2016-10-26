#!/bin/sh

function create_bin_directory () {
    if [[ -d "$HOME/.bin" ]]; then
        echo "[No action] $HOME/.bin already exists"
    else
        echo "creating $HOME/.bin"
        mkdir $HOME/.bin
    fi
}

function update_path_variable () {
    FILE=$1
    if grep -q '$HOME/.bin' "$FILE" ; then
        echo "[No action] $HOME/.bin is added to the PATH variable in ${FILE##*/} already"
    else
        echo "updating $FILE to add $HOME/.bin to the PATH variable"
        echo 'export PATH="$PATH:$HOME/.bin"' >> "$FILE"
    fi
}

function create_symlinks () {
    local SCRIPT_DIR_LOCATION=$1
    local SCRIPTS=( "$SCRIPT_DIR_LOCATION/commands"/*.sh )
    for FULL_SCRIPT_NAME in ${SCRIPTS[@]}; do
        local SCRIPT_FILE_NAME=${FULL_SCRIPT_NAME##*/}
        local SCRIPT=${SCRIPT_FILE_NAME%.*}

        if [[  -L "$HOME/.bin/${SCRIPT}" ]]; then
            echo "[No action] symlink for ${SCRIPT} is already present"
        else
            echo "creating a symlink for $SCRIPT"
            ln -s "$SCRIPT_DIR_LOCATION/commands/$SCRIPT_FILE_NAME" "$HOME/.bin/$SCRIPT"
        fi
    done
}

function update_alias_sourcing () {
    local SCRIPT_DIR_LOCATION=$1
    local PROFILE_FILE_LOCATION=$2
    local PROFILE_FILE_NAME=${2##*/}

    local SCRIPTS=( "$SCRIPT_DIR_LOCATION/aliases"/*.sh )
    for SCRIPT in ${SCRIPTS[@]}; do
        local SCRIPT_NAME=${SCRIPT##*/}
        if grep -q "source $SCRIPT" "$PROFILE_FILE_LOCATION"; then
            echo "[No action] $SCRIPT_NAME has already been sourced in $PROFILE_FILE_NAME"
        else
            echo "adding the aliases from $SCRIPT_NAME to $PROFILE_FILE_NAME"
            echo "source $SCRIPT" >> $PROFILE_FILE_LOCATION
        fi
    done
}

SCRIPT_DIR_LOCATION="$(cd -P -- "$(dirname -- "$0")" && pwd -P)"
PROFILE_FILE_LOCATION=${1:-$HOME/.bash_profile}

create_bin_directory
update_path_variable $PROFILE_FILE_LOCATION
create_symlinks $SCRIPT_DIR_LOCATION
update_alias_sourcing $SCRIPT_DIR_LOCATION $PROFILE_FILE_LOCATION
