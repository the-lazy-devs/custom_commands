#!/bin/sh

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

    -d, --dry-run               don't change anything, show what would be done.
    -h, --help                  display this help and exit
    -p, --profile PROFILE_FILE  shell profile file to be updated
                                  Default: $HOME/.bash_profile
    -r, --rc STARTUP_FILE       shell startup file to be updated
                                  Default: $HOME/.bashrc

Recommended commands:
    For bash users: ./${0##*/}
    For zsh users:  ./${0##*/} -p ~/.zshrc -r ~/.zshrc
EOH
}

function print_usage() {
  cat <<EOU
Usage: $0 [-h|--help][-d|--dry-run][-p|--profile path_to_profile_file][-r|--rc path_to_startup_file]
EOU
}

while getopts ":-:" opt; do
  [[ - == $opt ]] && opt=${OPTARG%%=*} OPTARG=${OPTARG%*=}

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
