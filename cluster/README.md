# Cluster

The purpose of this cluster is to provide a space to launch Jenkins and it's slaves into. Jenkins uses an EFS file system specified and configure on EC2 instances, and that filesystem is shared into containers.

## Using Modules

Using this module and sample: https://registry.terraform.io/modules/azavea/ecs-cluster/aws/2.0.0