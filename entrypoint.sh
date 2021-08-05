#!/bin/bash

set -x
set -m

/entrypoint.sh couchbase-server &

sleep 15

# Setup index and memory quota
curl -v http://127.0.0.1:8091/pools/default -d memoryQuota=300 -d indexMemoryQuota=300

# Setup services
curl -v http://127.0.0.1:8091/node/controller/setupServices -d services=kv%2Cn1ql%2Cindex

# Setup credentials
curl -v http://127.0.0.1:8091/settings/web -d port=8091 -d username=${USERNAME} -d password=${PASSWORD}

# Setup Memory Optimized Indexes
curl -i -u ${USERNAME}:${PASSWORD} http://127.0.0.1:8091/settings/indexes -d 'storageMode=memory_optimized'

# Load todo bucket
curl -v -u ${USERNAME}:${PASSWORD} http://127.0.0.1:8091/pools/default/buckets -d authType=none -d name=${BUCKET} -d bucketType=couchbase -d ramQuotaMB=256

echo "Type: $TYPE"

if [ "$TYPE" = "WORKER" ]; then
  echo "Sleeping ..."
  sleep 15

  #IP=`hostname -s`
  IP=`hostname -I | cut -d ' ' -f1`
  echo "IP: " $IP

  echo "Auto Rebalance: $AUTO_REBALANCE"
  if [ "$AUTO_REBALANCE" = "true" ]; then
    couchbase-cli rebalance --cluster=$COUCHBASE_MASTER:8091 --user=${USERNAME} --password=${PASSWORD} --server-add=$IP --server-add-username=${USERNAME} --server-add-password=${PASSWORD}
  else
    couchbase-cli server-add --cluster=$COUCHBASE_MASTER:8091 --user=${USERNAME} --password=${PASSWORD} --server-add=$IP --server-add-username=${USERNAME} --server-add-password=${PASSWORD}
  fi;
fi;

fg 1