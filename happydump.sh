#!/bin/bash
echo "First step to the moon! And welcome! ;)"
kubectl create namespace happydump
kubectl get pods -o wide --namespace=happydump
