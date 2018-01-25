#!/bin/bash

serverNames=("realife")
for i in "${serverNames[@]}"
do
   dt=$(date '+%d/%m/%Y %H:%M:%S');
   screen -X -S $i quit
   sleep 2
   mysqldump -u root -p669FdwLr $i > /home/saves/$i/$i_$(date +%Y-%m-%d-%H.%M.%S).sql
   sleep 2
   screen -dmS $i bash -c 'sleep 1; cd "/home/fivem/$0"; rm -rf cache/; ./run.sh; exec sh' $i
   echo "$i : Server restart @ $dt"
done
