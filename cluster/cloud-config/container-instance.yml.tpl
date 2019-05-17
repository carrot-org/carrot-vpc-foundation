#cloud-config

repo_update: true
repo_upgrade: all

packages:
- amazon-efs-utils

bootcmd:
  - sudo dd if=/dev/zero of=/swapfile bs=512M count=2
  - chmod 600 /swapfile
  - mkswap /swapfile
  - swapon /swapfile
  - echo "/swapfile swap swap defaults 0 0" >> /etc/fstab
  - mkdir -p /etc/ecs
  - echo 'ECS_CLUSTER=${ecs_cluster_name}' >> /etc/ecs/ecs.config

runcmd:
  - file_system_id_01=${efs_file_system_id_01}
  - efs_directory=/mnt/efs/${efs_file_system_path_01}

  - mkdir -p $${efs_directory}
  - echo "$${file_system_id_01}:/ $${efs_directory} efs tls,_netdev" >> /etc/fstab
  - mount -a -t efs defaults