CURRENT_WORKING_DIR=$PWD
cd ~/.sync
GIT_DELETED=$(git ls-files --deleted --exclude-standard)
GIT_MODIFIED=$(git ls-files --modified --exclude-standard)
GIT_OTHERS=$(git ls-files --others --exclude-standard)
MESSAGE='automatic sync at '$(date +%Y.%m.%d)' '$(date +%H:%M:%S)' by '$(git config user.name)'\n DELETED: '$GIT_DELETED'\n MODIFIED: '$GIT_MODIFIED'\n ADDED: '$GIT_OTHERS
echo $MESSAGE
cd $CURRENT_WORKING_DIR
