#!/bin/sh
# analyse file permissions

# stat command
stat_cmd=$(which stat)

# file to be verified
file=$1

if [ -e "$file" ]; then
  # parse "-rwxr-xr-x" format
  # skip first character (file type)
  rights=$($stat_cmd --format="%A" $file | cut -c 2-)     #
  for class in $(seq 1 3); do                             # rwx r-x r-x
    case $class in                                        # o   g   o
      1)                                                  # w   r   t
       echo " * owner"                                    # n   o   h
       ;;                                                 # e   u   e
      2)                                                  # r   p   r
       echo " * group"                                    #
       ;;
      3)
       echo " * other"
       ;;
    esac

    # range to cut for each class
    from=$(expr 3 \* $class - 2)    #   (1) 1   (2) 4   (3) 7
    to=$(expr 3 \* $class)          #       3       6       9

    # 1st step rwx, 2nd step r-x, 3rd step r-x
    class_perm=$(echo $rights | cut -c ${from}-${to})
    for pos in $(seq 1 3); do
      mode=$(echo $class_perm | cut -c $pos)
      case $mode in
        "r")
           echo "   read"
           ;;
        "w")
           echo "   write"
           ;;
        "x")
           echo "   execute"
           ;;
        "s")
           if [ "$class" = 1 ]; then
             echo "   execute and SUID"
           else
             echo "   execute and SGID"
           fi
           ;;
        "S")
           if [ "$class" = 1 ]; then
             echo "   SUID"
           else
             echo "   SGID"
           fi
           ;;
        "t")
           echo "   execute and sticky bit"
           ;;
        "T")
           echo "   sticky bit"
           ;;
      esac
    done
  done
else
  echo "File does not exist"
fi