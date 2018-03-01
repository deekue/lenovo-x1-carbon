#!/bin/bash 

DEBUG=echo
SKIP_FILE="/$(basename -- "$0")"
BASE_DIR=$(readlink -f $(dirname -- "$0"))
cd $BASE_DIR

find . -path ./.git -prune -o -type f -print | while read file ; do
  file="${file#.}"
  [ "$file" == "$SKIP_FILE"  ] && continue
  src="$BASE_DIR/$file"
  $DEBUG sudo install --backup=off -v -b -D -g root -o root -m 755 "$src" "$file"

  # enable systemd service files
  if [ "X${file##*.}" == "Xservice" ] ; then
   if ! sudo systemctl list-unit-files | grep -qw $(basename -- "$file") ; then
     echo "enabling systemd service $file"
     $DEBUG systemctl enable $file
   fi
  fi

done
