#!/bin/sh
bool=true

while $bool
do
    output=`ps aux | grep "m[a]in.repy 127.0.0.1"`
    set -- $output
    echo $output
    pid=$2
    if [[ $pid -eq "" ]] 
    then 
        break 
    fi
    echo $pid
    kill -9 $pid
done

