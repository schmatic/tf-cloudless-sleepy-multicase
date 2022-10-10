#!/bin/bash
# Reads the content of the filename given 
# Proceeds if the file contains shouldcontain in a separate line. 
# Fails if not. Then,
# Writes the writecontent to the file and exits
# This script can be used to check if schematics is storing 
# a file for subsequent actions.
# Also updates the number of times this filename file is written to
filename=$1
if [ "$4" == "write_only" ]; then #handling special case where no 'contains check' but just write
    writecontent=$2
else
    shouldcontain=$2
    writecontent=$3
fi
n=1
m=1
found="fail"
regexpat="no_of_times: ([0-9]+)"

GO_OS=${GO_OS:-"linux"}

# For some handlings
function detect_os {
    # Detect the OS name
    case "$(uname -s)" in
      Darwin)
        host_os=darwin
        ;;
      Linux)
        host_os=linux
        ;;
      *)
        echo "Unsupported host OS. Must be Linux or Mac OS X." >&2
        exit 1
        ;;
    esac

   GO_OS="${host_os}"
}

detect_os

# create the file if it doesn't exist
if [ ! -e "$filename" ] ; then
    touch "$filename"
fi

if [ ! -w "$filename" ] ; then
    echo "Cannot write to $filename"
    exit 1
fi

while read line; do
    echo "Line No. $n : $line"  # reading each line
    if [ $n -eq 1 ]
    then
        echo "Checking the first line"
        [[ $line =~ $regexpat ]]
        if [ "${BASH_REMATCH[1]}" != "" ]
        then
            echo "Found the match in first line no_of_times: ${BASH_REMATCH[1]}"
            m=`expr ${BASH_REMATCH[1]} + 1`
            echo "To Add no_of_times: $m"
        fi
    fi
    if [ "$shouldcontain" != "" ]
    then
        if [ "$shouldcontain" = "$line" ]
        then
            found="success"
        fi
    fi
    n=$((n+1))
done < $filename

# change the first line in the file
echo "Adding/Replacing no_of_times: $m in the first line"
if [ $n -eq 1 ]
then
    echo "no_of_times: ${m}" >> $filename
else
    if [ "${GO_OS}" == "darwin" ]; then
        sed -i '' "1s/.*/no_of_times: ${m}/" $filename
    else
        sed -i "1s/.*/no_of_times: ${m}/" $filename
    fi
fi

if [ "$writecontent" != "" ]
then
    echo "Writing $writecontent to the file at the end"
    echo "${writecontent}" >> $filename
fi

if [ "$found" = "success" ]
then
    echo "The string ${shouldcontain} is present in the ${filename}"
    exit 0
else
    if [ "$shouldcontain" == "" ]
    then 
    echo "Done"
    exit 0
    else
        echo "Failed, string ${shouldcontain} is not present in the ${filename}"
        exit 1
    fi
fi