#!/bin/bash

BASE_DIR=$HOME/src/lenovo-x1-carbon
cd $BASE_DIR

find . -path ./.git -prune -o -type f -print | while read file ; do
  file=${file#.} 
  [ -e $file ] && continue
  [ "$file" == $(basename -- "$0") ] && continue
  full_path=$BASE_DIR/$file 
  cd / 
  echo "[ln -svi $full_path $file]"
  sudo ln -svi $full_path $file 
  cd - 
done
