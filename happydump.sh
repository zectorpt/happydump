#!/bin/bash
echo "First step to the moon! And welcome! ;)"
kubectl create namespace happydump
kubectl get pods -o wide --namespace=happydump


kubectl get nodes| awk '{print $1}'| grep -wv NAME > ALLNODES.var
mapfile < ALLNODES.var
# printf '%s' "${MAPFILE[@]}"

for ((i = 0; i < ${#MAPFILE[@]}; ++i)); do
    position=$(( $i + 1 ))
    echo "$position - ${MAPFILE[$i]}"
done
echo "Please chose the NODE to TCP DUMP"

kubectl debug node/${MAPFILE[0]} -it --image=ubuntu --namespace=happydump
