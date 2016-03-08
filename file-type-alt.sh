#!/bin/sh
# alternative way to print file type

# stat command
stat_cmd=$(which stat)

# file to be verified
file=$1

if [ -e "$file" ]; then
  type=$($stat_cmd --format="%A" $file | cut -c 1)

  echo -n "$file type is "
  case $type in
    "-") echo "regular file";;
    "d") echo "directory";;
    "l") echo "symbolic link";;
    "p") echo "fifo";;
    "c") echo "character special file";;
    "b") echo "block special file";;
    "s") echo "socket";;
    *)   echo "unknown"
  esac
else
  echo "File does not exist"
fi