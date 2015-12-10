#!/bin/sh

for i in {0..4}
do
    PORT=$((63100+i))
    python2.6 ../demokit/repy.py ../demokit/restrictions.default mainLab4.repy 127.0.0.1 $PORT &
    sleep 0.1
    #firefox -new-window 127.0.0.1:$PORT &
done 

