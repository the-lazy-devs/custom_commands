#!/bin/sh

function create_bin_directory() {
  if [[ -d "$HOME/.bin" ]]; then
    print "${PYELLOW}${PBOLD}[No action]${PRESET}${PYELLOW} $HOME/.bin already exists${PRESET}"
  else
    if [ "$DRY_RUN" = true ]; then
      print "${PYELLOW}Would create $HOME/.bin${PRESET}"
    else
      print "${PGREEN}Creating $HOME/.bin${PRESET}"
      mkdir $HOME/.bin
    fi
  fi

  print
}

function update_path_variable() {
  local DOT_FILES=("${@}")
  for DOT_FILE in ${DOT_FILES[@]}; do
    if grep -sq '$HOME/.bin' "$DOT_FILE"; then
      print "${PYELLOW}${PBOLD}[No action]${PRESET}${PYELLOW} $HOME/.bin is added to the PATH variable in ${DOT_FILE##*/} already${PRESET}"
    else
      if [ "$DRY_RUN" = true ]; then
        print "${PYELLOW}Would update $DOT_FILE to add $HOME/.bin to the PATH variable${PRESET}"
      else
        print "${PGREEN}Updating $DOT_FILE to add $HOME/.bin to the PATH variable${PRESET}"
        echo 'export PATH="$PATH:$HOME/.bin"' >>"$DOT_FILE"
      fi
    fi
  done

  print
}

function create_symlinks() {
  local SCRIPT_DIR_LOCATION=$1

  local SCRIPTS=("$SCRIPT_DIR_LOCATION/commands"/*.sh)
  for FULL_SCRIPT_NAME in ${SCRIPTS[@]}; do
    local SCRIPT_FILE_NAME=${FULL_SCRIPT_NAME##*/}
    local SCRIPT=${SCRIPT_FILE_NAME%.*}

    if [[ -L "$HOME/.bin/${SCRIPT}" ]]; then
      print "${PYELLOW}${PBOLD}[No action]${PRESET}${PYELLOW} symlink for ${SCRIPT} is already present${PRESET}"
    else
      if [ "$DRY_RUN" = true ]; then
        print "${PYELLOW}Would create a symlink for $SCRIPT${PRESET}"
      else
        print "${PGREEN}Creating a symlink for $SCRIPT${PRESET}"
        ln -s "$SCRIPT_DIR_LOCATION/commands/$SCRIPT_FILE_NAME" "$HOME/.bin/$SCRIPT"
      fi
    fi
  done

  print
}

function update_alias_sourcing() {
  local SCRIPT_DIR_LOCATION=$1
  local PROFILE_FILE_LOCATION=$2

  local SCRIPTS=("$SCRIPT_DIR_LOCATION/aliases"/*.sh)
  for SCRIPT in ${SCRIPTS[@]}; do
    local SCRIPT_NAME=${SCRIPT##*/}
    local PROFILE_FILE_NAME=${PROFILE_FILE_LOCATION##*/}

    if grep -sq "source $SCRIPT" "$PROFILE_FILE_LOCATION"; then
      print "${PYELLOW}${PBOLD}[No action]${PRESET}${PYELLOW} $SCRIPT_NAME has already been sourced in $PROFILE_FILE_NAME${PRESET}"
    else
      if [ "$DRY_RUN" = true ]; then
        print "${PYELLOW}Would add the aliases from $SCRIPT_NAME to $PROFILE_FILE_NAME${PRESET}"
      else
        print "${PGREEN}Adding the aliases from $SCRIPT_NAME to $PROFILE_FILE_NAME${PRESET}"
        echo "source $SCRIPT" >> $PROFILE_FILE_LOCATION
      fi
    fi
  done

  print
}

function print() {
  if [[ -z $QUIET || "$QUIET" = false ]]; then
    echo $1
  fi
}
