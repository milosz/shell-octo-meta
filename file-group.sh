#!/bin/sh
# print and verify file group

# stat command
stat_cmd=$(which stat)

# file to be verified
file=$1

if [ -e "$file" ]; then
  group_id="$($stat_cmd --format="%g" $file)"
  group_name="$($stat_cmd --format="%G" $file)"

  echo "$file group is $group_name ($group_id)"

  # verify GID
  if [ "$group_id" -ge "1000" ]; then
    echo "This file belongs to regular group"
  else
    echo "This file belongs to system group"
  fi

  # verify group name
  if [ "$group_name" = "root" ]; then
    echo "This file belongs to root group"
  else
    echo "This file does not belong to root group"
  fi
else
  echo "File does not exist"
fi