bin/sh
# check file permissions

# stat command
stat_cmd=$(which stat)

# file to be verified
file=$1

if [ -e "$file" ]; then
  # parse "0755" format, convert "755" to "0755"
  rights=$($stat_cmd --format="%a" $file | xargs printf "%04d")
  for class in $(seq 0 3); do                                 #
    case $class in                                            # 0 7 5 5
      0)                                                      # s o g o
       echo " * special"                                      # p w r t
       ;;                                                     # e n o h
      1)                                                      # c e u e
       echo " * owner"                                        # i r p r
       ;;                                                     # a
      2)                                                      # l
       echo " * group"                                        #
       ;;
      3)
       echo " * other"
       ;;
    esac

    class_pos=$(expr $class + 1)                   # class position 1..4
    class_perm=$(echo $rights | cut -c $class_pos) # octal class rep

    perm_bin=$(echo "obase=2; $class_perm" | bc | xargs printf "%03d")
    # convert it to binary
    # 1st step 111 (7), 2nd step 101 (5), 3rd step 101 (5)

    # parse binary representation
    for pos in $(seq 1 3); do
      mode=$(echo $perm_bin | cut -c $pos)
      if [ "$class" = "0" ]; then                      # special
        if   [ "$mode" = 1 -a "$pos" = "1" ]; then     # [1]XX
          echo "   SUID";
        elif [ "$mode" = 1 -a "$pos" = "2" ]; then     # X[1]X
          echo "   SGID";
        elif [ "$mode" = 1 -a "$pos" = "3" ]; then     # XX[1]
          echo "   sticky bit";
        fi
      else                                             # regular
        if   [ "$mode" = 1 -a "$pos" = "1" ]; then     # [1]XX
          echo "   read";
        elif [ "$mode" = 1 -a "$pos" = "2" ]; then     # X[1]X
          echo "   write";
        elif [ "$mode" = 1 -a "$pos" = "3" ]; then     # XX[1]
          echo "   execute";
        fi
      fi
    done
  done
else
  echo "File does not exist"
fi