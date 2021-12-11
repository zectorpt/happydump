#!/bin/bash
echo "First step to the moon! And welcome! ;)"
kubectl create namespace happydump
kubectl get pods -o wide --namespace=happydump


kubectl get nodes| awk '{print $1}'| grep -wv NAME > ALLNODES.var
mapfile < ALLNODES.var
printf '%s' "${MAPFILE[@]}"

