#!/bin/sh

for i in {0..7}
do
    PORT=$((63100+i))
    python2.6 ../demokit/repy.py ../demokit/restrictions.default main.repy 127.0.0.1 $PORT &
    sleep 0.1
    #firefox -new-window 127.0.0.1:$PORT &
done 

