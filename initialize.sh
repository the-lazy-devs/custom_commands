#!/bin/sh

source ./cli.sh
if [ -z $PROFILE_FILE_LOCATION ]; then
  PROFILE_FILE_LOCATION=$HOME/.bash_profile
fi

if [ -z $RC_FILE_LOCATION ]; then
  RC_FILE_LOCATION=$HOME/.bashrc
fi

if [ -z $SCRIPT_DIR_LOCATION ]; then
  SCRIPT_DIR_LOCATION="$(cd -P -- "$(dirname -- "$0")" && pwd -P)"/scripts
fi

if [ -z $ALIAS_DIR_LOCATION ]; then
  ALIAS_DIR_LOCATION="$(cd -P -- "$(dirname -- "$0")" && pwd -P)"/aliases
fi

if [ -z $BIN_DIR_LOCATION ]; then
  BIN_DIR_LOCATION="$(cd -P -- "$(dirname -- "$0")" && pwd -P)"/.bin
fi

if [ "$DRY_RUN" = true ]; then
  echo "${PGREEN}Executing in dry run mode. No changes will be made.${PRESET}"

  if [ "$QUIET" = true ]; then
    QUIET=false
    echo "${PYELLOW}Quiet mode was switched off since dry-run was enabled${PRESET}"
  fi

  echo
fi

source ./functions.sh
create_bin_directory $BIN_DIR_LOCATION
update_path_variable $BIN_DIR_LOCATION $PROFILE_FILE_LOCATION $RC_FILE_LOCATION
create_symlinks $BIN_DIR_LOCATION $SCRIPT_DIR_LOCATION
update_alias_sourcing $ALIAS_DIR_LOCATION $PROFILE_FILE_LOCATION
