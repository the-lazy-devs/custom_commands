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
    if grep -q '$HOME/.bin' "$DOT_FILE"; then
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

    if grep -q "source $SCRIPT" "$PROFILE_FILE_LOCATION"; then
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

function check_invalid_args() {
  local arg=$1
  local value=$2

  if [[ "$value" =~ ^-[a-z] ]]; then
    echo "Option -$arg cannot accept value \"$value\""
    exit 1
  fi
}

function print_help() {
  print_usage
  cat <<EOH

Install custom commands and aliases into shell profile files

    -h                          display this help and exit
    -p, --profile PROFILE_FILE  shell profile file to be updated
                                  Default: $HOME/.bash_profile
    -r, --rc STARTUP_FILE       shell startup file to be updated
                                  Default: $HOME/.bashrc

Recommended commands:
    For bash users: ./${0##*/}
    For zsh users:  ./${0##*/} -p ~/.zshrc -r ~/.zshrc
EOH
}

function print_usage () {
    cat <<EOU
Usage: $0 [-h|--help][-d|--dry-run][-p|--profile path_to_profile_file][-r|--rc path_to_startup_file]
EOU
}

while getopts ":p:r:hd" opt; do
  case $opt in
    p | profile)
      check_invalid_args $opt $OPTARG
      PROFILE_FILE_LOCATION=$OPTARG
      ;;
    r | rc)
      check_invalid_args $opt $OPTARG
      RC_FILE_LOCATION=$OPTARG
      ;;
    h | help)
      print_help
      exit 0
      ;;
    d | dry-run) DRY_RUN=true ;;
    \?)
      ARG_NUM=$(($OPTIND - 1))
      echo "Unknown argument ${!ARG_NUM}"
      echo
      print_usage
      exit 2
      ;;
    :)
      echo "Expected value for argument -$OPTARG"
      echo
      print_usage
      exit 1
      ;;
  esac
done
shift $((OPTIND - 1))

case $# in
  0) ;;
  *)
    print_usage >&2
    exit 2
    ;;
esac

if [ -z $PROFILE_FILE_LOCATION ]; then
  PROFILE_FILE_LOCATION=$HOME/.bash_profile
fi

if [ -z $RC_FILE_LOCATION ]; then
  RC_FILE_LOCATION=$HOME/.bashrc
fi

SCRIPT_DIR_LOCATION="$(cd -P -- "$(dirname -- "$0")" && pwd -P)"

if $DRY_RUN; then
  echo "Executing in dry run mode. No changes will be made."
  echo
fi

create_bin_directory
update_path_variable $PROFILE_FILE_LOCATION $RC_FILE_LOCATION
create_symlinks $SCRIPT_DIR_LOCATION
update_alias_sourcing $SCRIPT_DIR_LOCATION $PROFILE_FILE_LOCATION
