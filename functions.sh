#!/bin/sh

function create_bin_directory() {
  if [[ -d "$HOME/.bin" ]]; then
    echo "[No action] $HOME/.bin already exists"
  else
    if [ $DRY_RUN ]; then
      echo "Would create $HOME/.bin"
    else
      echo "Creating $HOME/.bin"
      mkdir $HOME/.bin
    fi
  fi

  echo
}

function update_path_variable() {
  local DOT_FILES=("${@}")
  for DOT_FILE in ${DOT_FILES[@]}; do
    if grep -sq '$HOME/.bin' "$DOT_FILE"; then
      echo "[No action] $HOME/.bin is added to the PATH variable in ${DOT_FILE##*/} already"
    else
      if [ $DRY_RUN ]; then
        echo "Would update $DOT_FILE to add $HOME/.bin to the PATH variable"
      else
        echo "Updating $DOT_FILE to add $HOME/.bin to the PATH variable"
        echo 'export PATH="$PATH:$HOME/.bin"' >>"$DOT_FILE"
      fi
    fi
  done

  echo
}

function create_symlinks() {
  local SCRIPT_DIR_LOCATION=$1

  local SCRIPTS=("$SCRIPT_DIR_LOCATION/commands"/*.sh)
  for FULL_SCRIPT_NAME in ${SCRIPTS[@]}; do
    local SCRIPT_FILE_NAME=${FULL_SCRIPT_NAME##*/}
    local SCRIPT=${SCRIPT_FILE_NAME%.*}

    if [[ -L "$HOME/.bin/${SCRIPT}" ]]; then
      echo "[No action] symlink for ${SCRIPT} is already present"
    else
      if [ $DRY_RUN ]; then
        echo "Would create a symlink for $SCRIPT"
      else
        echo "Creating a symlink for $SCRIPT"
        ln -s "$SCRIPT_DIR_LOCATION/commands/$SCRIPT_FILE_NAME" "$HOME/.bin/$SCRIPT"
      fi
    fi
  done

  echo
}

function update_alias_sourcing() {
  local SCRIPT_DIR_LOCATION=$1
  local PROFILE_FILE_LOCATION=$2

  local SCRIPTS=("$SCRIPT_DIR_LOCATION/aliases"/*.sh)
  for SCRIPT in ${SCRIPTS[@]}; do
    local SCRIPT_NAME=${SCRIPT##*/}
    local PROFILE_FILE_NAME=${PROFILE_FILE_LOCATION##*/}

    if grep -sq "source $SCRIPT" "$PROFILE_FILE_LOCATION"; then
      echo "[No action] $SCRIPT_NAME has already been sourced in $PROFILE_FILE_NAME"
    else
      if [ $DRY_RUN ]; then
        echo "Would add the aliases from $SCRIPT_NAME to $PROFILE_FILE_NAME"
      else
        echo "Adding the aliases from $SCRIPT_NAME to $PROFILE_FILE_NAME"
        echo "source $SCRIPT" >>$PROFILE_FILE_LOCATION
      fi
    fi
  done

  echo
}
