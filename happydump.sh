#!/bin/bash
wget -q http://www.brainyquote.com/link/quotebr.js -O -|grep -o "\"[A-Z].*\."
kubectl create namespace happydump
sleep 1
kubectl create deployment --image=nginx nginxtodelete --namespace=happydump
sleep 3
kubectl get pods -o wide --namespace=happydump


kubectl get nodes| awk '{print $1}'| grep -wv NAME > ALLNODES.var
mapfile < ALLNODES.var
# printf '%s' "${MAPFILE[@]}"

for ((i = 0; i < ${#MAPFILE[@]}; ++i)); do
    position=$(( $i + 1 ))
    echo "$position - ${MAPFILE[$i]}"
done
echo "Please chose the NODE to TCP DUMP"
sleep 3

kubectl debug node/${MAPFILE[0]} -it --image=ubuntu --namespace=happydump
#kubectl debug node/aks-nodepool4-92987211-vmss000031 -it --image=ubuntu --namespace=happydump

sleep 3
kubectl delete namespaces happydump
