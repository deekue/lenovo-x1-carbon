#!/bin/bash

BASE_DIR=$(dirname -- "$0")
cd $BASE_DIR

find . -path ./.git -prune -o -type f -print | while read file ; do
  file=${file#.} 
  [ -e $file ] && continue
  [ "$file" == $(basename -- "$0") ] && continue
  [ -d "$(dirname $file)" ] || sudo mkdir -p $(dirname $file)
  full_path=$BASE_DIR/$file 
  cd / 
  echo "[ln -svi $full_path $file]"
  sudo ln -svi $full_path $file 
  cd - 
done
