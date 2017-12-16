#!/usr/bin/env bash

{
  echo "ECS_CLUSTER=${cluster_name}"
} >> /etc/ecs/ecs.config


{
  echo "ECS_INSTANCE_ATTRIBUTES={\"FRONTEND\": \"${frontend}\", \"APPLICATION\": \"${application}\", \"DATABASE\": \"${database}\", \"SPOT\": \"${spot}\"}"
} >> /etc/ecs/ecs.config

yum install -y nfs-utils
mkdir ${efs_dir}
mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 ${efs_volume} ${efs_dir}


