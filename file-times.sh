#!/bin/sh
# print file last access and modification date

# stat command
stat_cmd=$(which stat)

# file to be verified
file=$1

if [ -f "$file" ]; then
  mod_time=$($stat_cmd --format="%y" $file)
  acc_time=$($stat_cmd --format="%x" $file)

  echo "$file last access is $acc_time, modification time is $mod_time"
else
  echo "File does not exist"
fi