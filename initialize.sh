#!/bin/sh

source cli.sh
if [ -z $PROFILE_FILE_LOCATION ]; then
  PROFILE_FILE_LOCATION=$HOME/.bash_profile
fi

if [ -z $RC_FILE_LOCATION ]; then
  RC_FILE_LOCATION=$HOME/.bashrc
fi

SCRIPT_DIR_LOCATION="$(cd -P -- "$(dirname -- "$0")" && pwd -P)"

if [ "$DRY_RUN" = true ]; then
  echo "Executing in dry run mode. No changes will be made."

  if [ "$QUIET" = true ]; then
    QUIET=false
    echo "Quiet mode was switched off since dry-run was enabled"
  fi

  echo
fi

source functions.sh
create_bin_directory
update_path_variable $PROFILE_FILE_LOCATION $RC_FILE_LOCATION
create_symlinks $SCRIPT_DIR_LOCATION
update_alias_sourcing $SCRIPT_DIR_LOCATION $PROFILE_FILE_LOCATION
