#!/bin/bash
optspec=":hvmai-:"
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
        vim)
          echo "Parsing option: '--${OPTARG}', value: '${val}'" >&2;
          vim ~/.sync/sync.sh -c ":NERDTreeFind"
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

      git config credential.helper "cache --timeout=3600"

      # create DIRS
      while read m; do
        eval dirpath=${m}
        if [ ! -d "$dirpath" ]; then
          mkdir -p $dirpath
        fi
      done <~/.conf/sync/dir.init.conf

      # SYNC OR CLONE
      while read p; do
        parray=($p)
        eval dirpath=${parray[1]}
        if [ -d "$dirpath" ]; then
          bash $DIR/scripts/git-sync.sh "$dirpath" "$val"
        else
          eval dirpath=${parray[1]}
          eval gitpath=${parray[0]}
          echo
          echo "CLONING" $gitpath $dirpath
          echo "======================================================================="
          git clone $gitpath $dirpath
        fi
      done <~/.conf/sync/git.init.conf
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
