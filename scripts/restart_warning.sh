#!/bin/bash

minutesleft=$((60-$(date +"%M")))
echo $minutesleft
iceconpass="fr517"
serverports=(5070)
for i in "${serverports[@]}"
do
    /home/fivem/icecon -c 'say ^1Redémarrage du serveur dans '$minutesleft' minute(s).' localhost:$i $iceconpass
done
