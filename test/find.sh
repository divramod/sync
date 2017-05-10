#!/bin/bash

CURRENT_WORKING_DIR=$PWD
# snycGit
function syncGit() {
  DIR=$1
  echo "SYNCING $DIR"
  cd $DIR
  if [[ -d ".git" ]]; then
    echo &&
      echo $PWD &&
      echo "=======================================================================" &&
      git pull &&
      git pu "automatic sync at $(date +%Y%m%d_%H%M%S)"
  fi
}

# [RUN]
eval SEARCH_PATH=$1
DIRS=$(find $SEARCH_PATH -maxdepth 1 ! -path $SEARCH_PATH -type d)
if [ -d "$SEARCH_PATH/.git" ]; then
  while true; do
    echo
    echo "You have a top level .git repo in $SEARCH_PATH !"
    read -p "Do you wish that i try to sync in the subfolders first? [y|n] " yn
    case $yn in
      [Yy]* )
        for D in $DIRS
        do
          if [[ ! $D == *".git"* ]]; then
            syncGit $D
          fi
        done
        break;;
      [Nn]* )
        break;;
      * ) echo "Please answer yes or no.";;
    esac
  done
  syncGit $SEARCH_PATH
fi
cd $CURRENT_WORKING_DIR
