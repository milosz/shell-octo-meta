#!/bin/sh
# print file type

# stat command
stat_cmd=$(which stat)

# file to be verified
file=$1

if [ -e "$file" ]; then
  type=$(LC_ALL=C $stat_cmd --format="%F" $file)

  echo -n "$file type is "
  case $type in
    "regular file"|"directory"|"symbolic link"|"fifo"|"character special file"|"block special file"|"socket")
      echo $type
      ;;
    *)
      echo "unknown"
  esac
else
  echo "File does not exist"
fi