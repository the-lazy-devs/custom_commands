#!/bin/sh

function create_bin_directory() {
  if [[ -d "$HOME/.bin" ]]; then
    print "[${PBOLD}No action$PRESET] $PBLUE$HOME/.bin ${PYELLOW}already exists$PRESET"
  else
    if [ "$DRY_RUN" = true ]; then
      print "${PYELLOW}Would create $PBLUE$HOME/.bin$PRESET"
    else
      print "${PGREEN}Creating $PBLUE$HOME/.bin$PRESET"
      mkdir $HOME/.bin
    fi
  fi

  print
}

function update_path_variable() {
  local DOT_FILES=("${@}")
  for DOT_FILE in ${DOT_FILES[@]}; do
    if grep -sq '$HOME/.bin' "$DOT_FILE"; then
      print "[${PBOLD}No action$PRESET] $PBLUE$HOME/.bin ${PYELLOW}already exists in PATH in $PBLUE${DOT_FILE##*/}$PRESET"
    else
      if [ "$DRY_RUN" = true ]; then
        print "${PYELLOW}Would update $PBLUE$DOT_FILE$PYELLOW to add $PBLUE$HOME/.bin$PYELLOW to the PATH variable$PRESET"
      else
        print "${PGREEN}Updating ${PBLUE}$DOT_FILE${PGREEN} to add ${PBLUE}$HOME/.bin${PBLUE} to the PATH variable${PRESET}"
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
      print "[${PBOLD}No action$PRESET]$PYELLOW symlink for $PBLUE$SCRIPT$PYELLOW is already present$PRESET"
    else
      if [ "$DRY_RUN" = true ]; then
        print "${PYELLOW}Would create a symlink for $PBLUE$SCRIPT$PRESET"
      else
        print "${PGREEN}Creating a symlink for $PBLUE$SCRIPT$PRESET"
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
      print "[${PBOLD}No action$PRESET] $PBLUE$SCRIPT_NAME$PYELLOW has already been sourced in $PBLUE$PROFILE_FILE_NAME$PRESET"
    else
      if [ "$DRY_RUN" = true ]; then
        print "${PYELLOW}Would add the aliases from $PBLUE$SCRIPT_NAME$PYELLOW to $PBLUE$PROFILE_FILE_NAME$PRESET"
      else
        print "${PGREEN}Adding the aliases from $PBLUE$SCRIPT_NAME$PGREEN to $PBLUE$PROFILE_FILE_NAME$PRESET"
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
