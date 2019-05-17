output "container_instance_security_group_id" {
  value = "${module.container_service_cluster.container_instance_security_group_id}"
}

output "cluster_name" {
  value = "${module.container_service_cluster.name}"
}
