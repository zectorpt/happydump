#!/bin/bash
wget -q http://www.brainyquote.com/link/quotebr.js -O -|grep -o "\"[A-Z].*\."
kubectl create namespace happydump
sleep 1
kubectl create deployment --image=nginx nginxtodelete --namespace=happydump
sleep 1
kubectl get pods -o wide --namespace=happydump


kubectl get nodes| awk '{print $1}'| grep -wv NAME > ALLNODES.var
mapfile < ALLNODES.var

for ((i = 0; i < ${#MAPFILE[@]}; ++i)); do
    position=$(( $i ))
    echo "$position - ${MAPFILE[$i]}"
done
echo "Please chose the NODE number to TCP DUMP: "

#sleep 1

read node
newnode=${MAPFILE[$node]}
newnode=${newnode::-1}

DEFINITIONS="$(cat <<EOF
{
  "spec": {
    "nodeName": "$newnode",
    "hostPID": true,
    "containers": [
      {
        "securityContext": {
          "privileged": true
        },
        "image": "alpine",
        "name": "nsenter",
        "stdin": true,
        "stdinOnce": true,
        "tty": true,
        "command": [ "nsenter", "--target", "1", "--mount", "--uts", "--ipc", "--net", "--pid", "--", "bash", "-l" ]
      }
    ]
  }
}
EOF
)"

echo $DEFINITIONS

sleep 1
kubectl run --rm --image alpine --overrides="$DEFINITIONS" -ti ${MAPFILE[$node]} --namespace=happydump

rm -f ALLNODES.var
kubectl delete namespaces happydump
