#!/bin/bash
# Keeps writing a lot of content into the log file to crowd it.
filename=$1
towrite=$2
numb=$3
loop=$4
a=0
b=0

function do_something {
    now=$(date +"%T")
    echo "Current time : $now"
    echo "${towrite/\%d/$a}"
    b=`expr $a % 5`
    if [ $b -eq 0 ]; then
        # create a file
        if [ ! -e "${filename}_${a}.txt" ] ; then
            touch "${filename}_${a}.txt"
            echo "Created file ${filename}_${a}.txt" >> "${filename}_${a}.txt" 
        fi

        if [ ! -w "${filename}_${a}.txt" ] ; then
            echo "Cannot write to ${filename}_${a}.txt"
            exit 1
        fi
        echo "Writing to file ${filename}_${a}.txt"
        echo "Writing some random content here" >> "${filename}_${a}.txt"
        echo "${towrite/\%d/$a}" >> "${filename}_${a}.txt"
        sleep 1
    fi
}

if [ "$loop" = "yes" ] 
then 
    #Iterate the loop until a less than 10 
    while [ $a -lt $numb ] 
    do 
        do_something
        # increment the value 
        a=`expr $a + 1` 
        echo "Next will be ${a}th time"
    done
else
    a=$numb
    do_something
fi
