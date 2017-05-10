#!/bin/bash
# http://stackoverflow.com/questions/14786984/best-way-to-parse-command-line-args-in-bash
args=$(getopt -l "searchpath:" -o "s:h" -- "$@")

eval set -- "$args"

while [ $# -ge 1 ]; do
        case "$1" in
                --)
                    # No more options left.
                    shift
                    break
                   ;;
                -s|--searchpath)
                        searchpath="$2"
                        shift
                        ;;
                -m|--makerspace)
                        searchpath="$2"
                        shift
                        ;;
                -h)
                        echo "Display some help"
                        exit 0
                        ;;
        esac

        shift
done

echo "searchpath: $searchpath"
echo "remaining args: $*"
