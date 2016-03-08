#!/bin/sh
# compare file last access and modification date with contrived date values

# stat command
stat_cmd=$(which stat)

# file to be verified
file=$1

if [ -e "$file" ]; then
  mod_time=$($stat_cmd --format="%Y" $file)
  acc_time=$($stat_cmd --format="%X" $file)

  if [ "$mod_time" -ge "$(date -d "00:00" +"%s")" ]; then
    echo "$file was modified today"
  fi

  if [ "$acc_time" -ge "$(date -d "last day" +"%s")" ]; then
    echo "$file was accessed at least yesterday"
  fi

  if [ "$mod_time" -ge "$(date -d "2014-11-09 19:00" +"%s")" -a  "$mod_time" -le "$(date -d "2014-11-09 20:00" +"%s")" ]; then
    echo "$file was modified 2014-11-09 between 19:00 and 20:00"
  fi

  if [ "$acc_time" -lt "$(date -d "-3 days" +"%s")" ]; then
    echo "$file was accessed more then three days ago"
  fi
else
  echo "File does not exist"
fi