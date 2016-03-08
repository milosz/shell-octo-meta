#!/bin/sh
# print and verify file owner

# stat command
stat_cmd=$(which stat)

# file to be verified
file=$1

if [ -e "$file" ]; then
  user_id="$($stat_cmd --format="%u" $file)"
  user_name="$($stat_cmd --format="%U" $file)"

  echo "$file owner is $user_name ($user_id)"

  # verify UID
  if [ "$user_id" -ge "1000" ]; then
    echo "This file belongs to regular user"
  else
    echo "This file belongs to system user"
  fi

  # verify user name
  if [ "$user_name" = "milosz" ]; then
    echo "This file belongs to milosz user"
  else
    echo "This file does not belong to milosz user"
  fi
else
  echo "File does not exist"
fi