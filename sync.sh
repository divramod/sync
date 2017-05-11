#!/bin/bash
optspec=":hvma-:"
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
          val=${OPTARG#*=}
          echo "Parsing option: '--${OPTARG}', value: '${val}'" >&2;
          DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
          if [ -d ~/_me/code/makerspace-eberswalde ]; then
            bash $DIR/scripts/git-sync.sh "~/_me/code/makerspace-eberswalde" "$val"
          fi
          if [ -d ~/code/makerspace-eberswalde ]; then
            bash $DIR/scripts/git-sync.sh "~/code/makerspace-eberswalde" "$val"
          fi
          if [ -d /var/lib/tftpboot ]; then
            sudo bash $DIR/scripts/git-sync.sh "/var/lib/tftpboot"
          fi
          if [ -d ~/.sync ]; then
            sudo bash $DIR/scripts/git-sync.sh "~/.sync"
          fi
          ;;
        makerspace=*)
          val=${OPTARG#*=}
          echo "Parsing option: '--${OPTARG}', value: '${val}'" >&2;
          DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
          if [ -d "~/_me/code/makerspace-eberswalde" ]; then
            echo "me"
            #bash $DIR/scripts/git-sync.sh "~/_me/code/makerspace-eberswalde" "$val"
          fi
          if [ -d "~/code/makerspace-eberswalde" ]; then
            echo "code"
            #bash $DIR/scripts/git-sync.sh "~/code/makerspace-eberswalde" "$val"
          fi
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
    a)
      echo "Parsing option: '-${optchar}'" >&2
      DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
      bash $DIR/scripts/git-sync.sh "~/_me/code/makerspace-eberswalde" "$val"
      bash $DIR/scripts/git-sync.sh "~/code/makerspace-eberswalde" "$val"
      sudo bash $DIR/scripts/git-sync.sh "/var/lib/tftpboot"
      sudo bash $DIR/scripts/git-sync.sh "~/.sync"
      ;;
    h)
      HELP_TXT="
=================================================================================
================================ sync tool help =================================
=================================================================================
      
USAGE: snc [-SHORT] | [--LONG[=]<value>]

  [-a]: sync all
  [-h]: show help for the sync-tool
  [-v]: TODO

  [--sync]: synchronize the git repo of the sync-tool itself
  [--makerspace]: sycn every git repo in the makerspace-eberswalde folder
  [--loglevel[=]<value>]: TODO

EXAMPLES: 
  snc -a
  snc --loglevel
  snc --loglevel=1
"
      echo "$HELP_TXT" >&2
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
