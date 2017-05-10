#!/bin/bash

# [START]
CURRENT_WORKING_DIR=$PWD

# snycGit
function syncGit() {
  DIR=$1
  if [ -n "$2" ]; then
    COMMIT_MESSAGE=$2
    COMMIT_MESSAGE_EXISTENT=1
  fi
  cd $DIR
  if [[ -d "$DIR/.git" ]]; then
    echo &&
      echo "SYNCING $PWD" &&
      echo "======================================================================="
    if [[ ! -z $(git status -s) ]]; then
      GIT_DELETED=$(git ls-files --deleted --exclude-standard) &&
        GIT_MODIFIED=$(git ls-files --modified --exclude-standard) &&
        GIT_OTHERS=$(git ls-files --others --exclude-standard) &&
        rm -f /tmp/commit_msg.txt &&
        touch /tmp/commit_msg.txt &&
        if [ $COMMIT_MESSAGE_EXISTENT == 1 ]; then
          echo $COMMIT_MESSAGE >> /tmp/commit_msg.txt
        fi
        echo 'automatic sync at '$(date +%Y.%m.%d)' '$(date +%H:%M:%S)' by '$(git config user.name) >> /tmp/commit_msg.txt &&
          echo ' DELETED: '$GIT_DELETED >> /tmp/commit_msg.txt &&
          echo ' MODIFIED: '$GIT_MODIFIED >> /tmp/commit_msg.txt &&
          echo ' ADDED: '$GIT_OTHERS >> /tmp/commit_msg.txt
        git add -A &&
          git commit -F /tmp/commit_msg.txt &&
          rm /tmp/commit_msg.txt
      fi
      git pull &&
        git push -u origin HEAD
    fi
  }

  # [RUN]
  eval SEARCH_PATH=$1
  DIRS=$(find $SEARCH_PATH -maxdepth 1 ! -path $SEARCH_PATH -type d)
  echo $SEARCH_PATH
  if [ -d "$SEARCH_PATH/.git" ]; then
    if [ -n "$2" ]; then
      syncGit $SEARCH_PATH "$2"
    else
      syncGit $SEARCH_PATH
    fi
  else
    for D in $DIRS
    do
      if [ -n "$2" ]; then
        syncGit $D "$2"
      else
        syncGit $D
      fi
    done
  fi

  # [END]
  cd $CURRENT_WORKING_DIR
