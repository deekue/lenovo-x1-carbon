#!/bin/bash 

DEBUG=echo
BASE_DIR=$(readlink -f $(dirname -- "$0"))
cd $BASE_DIR

find . -path ./.git -prune -o -type f -print | while read file ; do
  file="${file#.}"
  [ "$file" == /$(basename -- "$0") ] && continue
  full_path="$BASE_DIR/$file"
  $DEBUG sudo install --backup=off -v -b -D -g root -o root -m 755 "$full_path" "$file"
done
