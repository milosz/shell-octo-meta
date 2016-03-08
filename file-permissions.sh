#!/bin/sh
# check file permissions

# stat command
stat_cmd=$(which stat)

# file to be verified
file=$1

if [ -e "$file" ]; then
  if [ "$($stat_cmd --format="%a" $file | xargs printf "%04d")" = "0755" ]; then
   echo "$file 0755 proper permission confirmed"
  fi
else
  echo "File does not exist"
fi