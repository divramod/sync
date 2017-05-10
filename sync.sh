#!/bin/bash
optspec=":hvm-:"
while getopts "$optspec" optchar; do
  case "${optchar}" in
    -)
      case "${OPTARG}" in
        loglevel)
          val="${!OPTIND}"; OPTIND=$(( $OPTIND + 1 ))
          echo "Parsing option: '--${OPTARG}', value: '${val}'" >&2;
          ;;
        loglevel=*)
          val=${OPTARG#*=}
          opt=${OPTARG%=$val}
          echo "Parsing option: '--${opt}', value: '${val}'" >&2
          ;;
        makerspace)
          echo "Parsing option: '--${OPTARG}', value: '${val}'" >&2;
          DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
          bash $DIR/scripts/git-sync.sh "~/_me/code/makerspace-eberswalde"
          ;;
        makerspace=*)
          val=${OPTARG#*=}
          echo "Parsing option: '--${OPTARG}', value: '${val}'" >&2;
          DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
          bash $DIR/scripts/git-sync.sh "~/_me/code/makerspace-eberswalde" "$val"
          ;;
        sync)
          echo "Parsing option: '--${OPTARG}', value: '${val}'" >&2;
          DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
          bash $DIR/scripts/git-sync.sh "~/.sync"
          ;;
        sync=*)
          val=${OPTARG#*=}
          echo "Parsing option: '--${OPTARG}', value: '${val}'" >&2;
          DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
          bash $DIR/scripts/git-sync.sh "~/.sync" "$val"
          ;;
        *)
          if [ "$OPTERR" = 1 ] && [ "${optspec:0:1}" != ":" ]; then
            echo "Unknown option --${OPTARG}" >&2
          fi
          ;;
      esac;;
    h)
      echo "usage: $0 [-v] [--loglevel[=]<value>]" >&2
      exit 2
      ;;
    v)
      echo "Parsing option: '-${optchar}'" >&2
      ;;
    *)
      if [ "$OPTERR" != 1 ] || [ "${optspec:0:1}" = ":" ]; then
        echo "Non-option argument: '-${OPTARG}'" >&2
      fi
      ;;
  esac
done
