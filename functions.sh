#!/bin/sh

function create_bin_directory() {
  local BIN_DIR_LOCATION=$1
  if [[ -d "$BIN_DIR_LOCATION" ]]; then
    print "[${PBOLD}No action$PRESET] $PBLUE$BIN_DIR_LOCATION ${PYELLOW}already exists$PRESET"
  else
    if [ "$DRY_RUN" = true ]; then
      print "${PYELLOW}Would create $PBLUE$BIN_DIR_LOCATION$PRESET"
    else
      print "${PGREEN}Creating $PBLUE$BIN_DIR_LOCATION$PRESET"
      mkdir $BIN_DIR_LOCATION
    fi
  fi

  print
}

function update_path_variable() {
  local BIN_DIR_LOCATION=$1
  local DOT_FILES=("${@:2}")
  for DOT_FILE in ${DOT_FILES[@]}; do
    if grep -sq '$BIN_DIR_LOCATION' "$DOT_FILE"; then
      print "[${PBOLD}No action$PRESET] $PBLUE$BIN_DIR_LOCATION ${PYELLOW}already exists in PATH in $PBLUE${DOT_FILE##*/}$PRESET"
    else
      if [ "$DRY_RUN" = true ]; then
        print "${PYELLOW}Would update $PBLUE$DOT_FILE$PYELLOW to add $PBLUE$BIN_DIR_LOCATION$PYELLOW to the PATH variable$PRESET"
      else
        print "${PGREEN}Updating ${PBLUE}$DOT_FILE${PGREEN} to add ${PBLUE}$BIN_DIR_LOCATION${PBLUE} to the PATH variable${PRESET}"
        echo 'export PATH=$PATH:'$BIN_DIR_LOCATION >> "$DOT_FILE"
      fi
    fi
  done

  print
}

function create_symlinks() {
  local BIN_DIR_LOCATION=$1
  local SCRIPT_DIR_LOCATION=$2

  shopt -s nullglob
  local SCRIPTS=$(find "$SCRIPT_DIR_LOCATION" -name '*.sh')
  shopt -u nullglob
  for FULL_SCRIPT_NAME in ${SCRIPTS[@]}; do
    local SCRIPT_FILE_NAME=${FULL_SCRIPT_NAME##*/}
    local SCRIPT=${SCRIPT_FILE_NAME%.*}

    if [[ -L "$BIN_DIR_LOCATION/${SCRIPT}" ]]; then
      print "[${PBOLD}No action$PRESET]$PYELLOW symlink for script $PBLUE$SCRIPT$PYELLOW is already present$PRESET"
    else
      if [ "$DRY_RUN" = true ]; then
        print "${PYELLOW}Would create a symlink for script $PBLUE$SCRIPT$PRESET"
      else
        print "${PGREEN}Creating a symlink for script $PBLUE$SCRIPT$PRESET"
        ln -s "$SCRIPT_DIR_LOCATION/$SCRIPT_FILE_NAME" "$BIN_DIR_LOCATION/$SCRIPT"
      fi
    fi
  done

  if [[ -z ${SCRIPTS[@]} ]]; then
    print "[${PBOLD}Warning$PRESET]$PYELLOW No scripts found$PRESET"
  fi

  print
}

function update_alias_sourcing() {
  local ALIAS_DIR_LOCATION=$1
  local PROFILE_FILE_LOCATION=$2

  shopt -s nullglob
  local ALIAS_FILES=$(find "$ALIAS_DIR_LOCATION" -name '*.sh')
  shopt -u nullglob
  for ALIAS_FILE in ${ALIAS_FILES[@]}; do
    local ALIAS_FILE_NAME=${ALIAS_FILE##*/}
    local PROFILE_FILE_NAME=${PROFILE_FILE_LOCATION##*/}

    if grep -sq "source $ALIAS_FILE" "$PROFILE_FILE_LOCATION"; then
      print "[${PBOLD}No action$PRESET] $PBLUE$ALIAS_FILE_NAME$PYELLOW has already been sourced in $PBLUE$PROFILE_FILE_NAME$PRESET"
    else
      if [ "$DRY_RUN" = true ]; then
        print "${PYELLOW}Would add the aliases from $PBLUE$ALIAS_FILE_NAME$PYELLOW to $PBLUE$PROFILE_FILE_NAME$PRESET"
      else
        print "${PGREEN}Adding the aliases from $PBLUE$ALIAS_FILE_NAME$PGREEN to $PBLUE$PROFILE_FILE_NAME$PRESET"
        echo "source $ALIAS_FILE" >> $PROFILE_FILE_LOCATION
      fi
    fi
  done

  if [[ -z ${ALIAS_FILES[@]} ]]; then
    print "[${PBOLD}Warning$PRESET]$PYELLOW No aliases found$PRESET"
  fi

  print
}

function print() {
  if [[ -z $QUIET || "$QUIET" = false ]]; then
    echo $1
  fi
}
