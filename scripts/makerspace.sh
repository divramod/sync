#!/bin/bash
CURRENT_WORKING_DIR=$PWD
for D in `find ~/_me/code/makerspace-eberswalde -maxdepth 1 ! -path ~/_me/code/makerspace-eberswalde -type d`
do
  cd $D &&
    echo &&
    echo $PWD &&
    echo "=======================================================================" &&
    git pull &&
    git pu "automatic sync at $(date +%Y%m%d_%H%M%S)" &&
    cd $CURRENT_WORKING_DIR
done
cd $CURRENT_WORKING_DIR
