#!/bin/bash
OUTPUT=`ps -ef |grep 'kubelet --kubeconfig'|grep -v grep`
cmd1="cd /home/rangapv08/quikfix; nohup sudo kubelet --kubeconfig /home/rangapv08/.kube/config --cluster-dns 10.96.0.10 2>&1 &"
if [ -z "$OUTPUT" ]
then
  echo $(eval "$cmd1")
else
  echo "the process is running"
fi
