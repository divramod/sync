#!/bin/bash

# [START]
CURRENT_WORKING_DIR=$PWD

# snycGit
function syncGit() {
  DIR=$1
  cd $DIR
  if [[ -d ".git" ]]; then
    echo &&
      echo "SYNCING $PWD" &&
      echo "======================================================================="
    if [[ ! -z $(git status -s) ]]; then
      GIT_DELETED=$(git ls-files --deleted --exclude-standard) &&
        GIT_MODIFIED=$(git ls-files --modified --exclude-standard) &&
        GIT_OTHERS=$(git ls-files --others --exclude-standard) &&
        rm -f /tmp/commit_msg.txt &&
        touch /tmp/commit_msg.txt
      if [ -n "$2" ]; then
        echo $2 >> /tmp/commit_msg.txt &&
          echo
      fi
      echo 'automatic sync at '$(date +%Y.%m.%d)' '$(date +%H:%M:%S)' by '$(git config user.name) >> /tmp/commit_msg.txt &&
        echo "now here"
      cat /tmp/commit_msg.txt
      echo ' DELETED: '$GIT_DELETED >> /tmp/commit_msg.txt &&
        echo "now here after"
      cat /tmp/commit_msg.txt
        echo ' MODIFIED: '$GIT_MODIFIED >> /tmp/commit_msg.txt &&
        echo ' ADDED: '$GIT_OTHERS >> /tmp/commit_msg.txt &&
        git add -A &&
        git commit -F /tmp/commit_msg.txt &&
        rm /tmp/commit_msg.txt
    fi
    git pull &&
      git push -u origin HEAD
  fi
}

# [RUN]
echo $2
eval SEARCH_PATH=$1
DIRS=$(find $SEARCH_PATH -maxdepth 1 ! -path $SEARCH_PATH -type d)
if [ -d "$SEARCH_PATH/.git" ]; then
  while true; do
    #echo
    #echo "You have a top level .git repo in $SEARCH_PATH !"
    #read -p "Do you wish that i try to sync in the subfolders first? [y|n] " yn
    yn=y
    case $yn in
      [Yy]* )
        for D in $DIRS
        do
          if [[ ! $D == *".git"* ]]; then
            if [ -n "$2" ]; then
              echo "in"
              syncGit $D "$2"
            else
              syncGit $D
            fi
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

# [END]
cd $CURRENT_WORKING_DIR
