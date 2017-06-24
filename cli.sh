#!/bin/sh

function setup_colors() {
  PBLACK=$(tput setaf 0)
  PRED=$(tput setaf 1)
  PGREEN=$(tput setaf 2)
  PYELLOW=$(tput setaf 3)
  PBLUE=$(tput setaf 4)
  PMAGENTA=$(tput setaf 5)
  PCYAN=$(tput setaf 6)
  PWHITE=$(tput setaf 7)
  PREV=$(tput rev)
  PBOLD=$(tput bold)
  PRESET=$(tput sgr0)
}

function unset_colors() {
  PBLACK=$(tput sgr0)
  PRED=$(tput sgr0)
  PGREEN=$(tput sgr0)
  PYELLOW=$(tput sgr0)
  PBLUE=$(tput sgr0)
  PMAGENTA=$(tput sgr0)
  PCYAN=$(tput sgr0)
  PWHITE=$(tput sgr0)
  PREV=$(tput sgr0)
  PBOLD=$(tput sgr0)
  PRESET=$(tput sgr0)
}

function print_help() {
  print_usage
  CURRENT_WORKING_DIRECTORY="$(pwd)"
  cat <<EOH

${PCYAN}Install custom commands and aliases into shell profile files${PRESET}

    ${PGREEN}-c${PRESET}, ${PGREEN}--no-color              ${PBLUE}strip color out of the output

    ${PGREEN}-d${PRESET}, ${PGREEN}--dry-run               ${PBLUE}don't change anything, show what would be done.

    ${PGREEN}-h${PRESET}, ${PGREEN}--help                  ${PBLUE}display this help and exit

    ${PGREEN}-p${PRESET}, ${PGREEN}--profile ${PYELLOW}PROFILE_FILE  ${PBLUE}shell profile file to be updated
                                  Default: $HOME/.bash_profile${PRESET}

    ${PGREEN}-q${PRESET}, ${PGREEN}--quiet                 ${PBLUE}switches off all output

    ${PGREEN}-r${PRESET}, ${PGREEN}--rc ${PYELLOW}STARTUP_FILE       ${PBLUE}shell startup file to be updated
                                  Default: $HOME/.bashrc${PRESET}

    ${PGREEN}-s${PRESET}, ${PGREEN}--scripts ${PYELLOW}DIRECTORY     ${PBLUE}alternate parent directory of scripts to be linked
                                  Default: $CURRENT_WORKING_DIRECTORY/scripts${PRESET}

    ${PGREEN}-a${PRESET}, ${PGREEN}--aliases ${PYELLOW}DIRECTORY     ${PBLUE}alternate parent directory of aliases to be linked
                                  Default: $CURRENT_WORKING_DIRECTORY/aliases${PRESET}

    ${PGREEN}-b${PRESET}, ${PGREEN}--bin ${PYELLOW}DIRECTORY         ${PBLUE}alternate parent directory of symlinks
                                  Default: $HOME/.bin${PRESET}

${PBOLD}Recommended commands${PRESET}:
    ${PCYAN}For bash users${PRESET}: ${PMAGENTA}./${0##*/}${PRESET}
    ${PCYAN}For zsh users${PRESET}:  ${PMAGENTA}./${0##*/} ${PGREEN}-p ${PYELLOW}~/.zshrc ${PGREEN}-r ${PYELLOW}~/.zshrc${PRESET}
EOH
}

function print_usage() {
  cat <<EOU
${PBOLD}Usage${PRESET}: ${PMAGENTA}$0 ${PRESET}\
[${PRESET}${PGREEN}-c${PRESET}|${PGREEN}--no-color${PRESET}${PBOLD}] \
[${PRESET}${PGREEN}-d${PRESET}|${PGREEN}--dry-run${PRESET}] \
[${PRESET}${PGREEN}-h${PRESET}|${PGREEN}--help${PRESET}] \
[${PRESET}${PGREEN}-p${PRESET}|${PGREEN}--profile ${PYELLOW}file${PRESET}] \
[${PRESET}${PGREEN}-q${PRESET}|${PGREEN}--quiet-mode${PRESET}] \
[${PRESET}${PGREEN}-r${PRESET}|${PGREEN}--rc ${PYELLOW}file${PRESET}] \
[${PRESET}${PGREEN}-s${PRESET}|${PGREEN}--scripts ${PYELLOW}directory${PRESET}] \
[${PRESET}${PGREEN}-a${PRESET}|${PGREEN}--aliases ${PYELLOW}directory${PRESET}] \
[${PRESET}${PGREEN}-b${PRESET}|${PGREEN}--bin ${PYELLOW}directory${PRESET}]
EOU
}

setup_colors

while getopts ":cdhp:qr:s:a:b:-:" OPT; do
  [[ - == $OPT ]] && OPT=${OPTARG%%=*} OPTARG=${OPTARG#*=}

  case $OPT in
    c | no-color) NO_COLOR=true ;;
    d | dry-run) DRY_RUN=true ;;
    h | help)
      print_help
      exit 0
      ;;
    p | profile)
      PROFILE_FILE_LOCATION=$OPTARG
      ;;
    q | quiet) QUIET=true ;;
    r | rc)
      RC_FILE_LOCATION=$OPTARG
      ;;
    s | scripts)
      SCRIPT_DIR_LOCATION=$OPTARG
      ;;
    a | aliases)
      ALIAS_DIR_LOCATION=$OPTARG
      ;;
    b | bin)
      BIN_DIR_LOCATION=$OPTARG
      ;;
    \?)
      ARG_NUM=$(($OPTIND - 1))
      echo "${PRED}Unknown argument ${!ARG_NUM}${PRESET}"
      echo
      print_usage
      exit 2
      ;;
    :)
      echo "${PRED}Expected value for argument -$OPTARG${PRESET}"
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
    echo "${PRED}Unknown arguments [${*}] found${PRESET}"
    print_usage >&2
    exit 3
    ;;
esac

if [[ "$NO_COLOR" = true ]]; then
  unset_colors
fi
