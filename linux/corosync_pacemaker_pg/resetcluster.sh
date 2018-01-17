#!/bin/bash
NODES="node1 node2"
for i in $NODES; do ssh $i systemctl start pcsd.service; done
for i in $NODES; do ssh $i pcs cluster destroy; done
pcs cluster auth $NODES  -u hacluster -p manager
pcs cluster setup --name pgcluster $NODES
pcs cluster start --all
pcs property set stonith-enabled="false"
