variable "network_name" {
  description = "The name of the network resources: should be generated by provider/universal/name-generator"
}

variable "bastion_ip" {
  description = "The IP to bastion host used for provisioning"
}

variable "location" {
  description = "The Azure location to deploy environment"
}

variable "resource_type" {
  description = "The resource type of the bastion instance"
}

variable "resource_count" {
  description = "The number of resources to create"
}

variable "resource_cluster_name" {
  description = "The name to assign the resource cluster"
}

variable "resource_root_volume_size" {
  description = "The size of resource root volume size"
}

variable "triggers" {
  default     = []
  description = "A trigger key that will initiate provisioning of scalardl resource"
}

variable "private_key_path" {
  description = "The path to the private key for SSH access"
}

variable "public_key_path" {
  description = "The path to the public key for SSH access"
}

variable "user_name" {
  description = "The user name of the remote hosts"
}

variable "subnet_id" {
  description = "The subnet ID to launch scalardl hosts"
}

variable "image_id" {
  description = "The image id to initiate"
}

variable "network_dns" {
  description = "The ID for the internal DNS zone"
}

variable "scalardl_image_name" {
  description = "The docker image for Scalar DL"
}

variable "scalardl_image_tag" {
  description = "The docker image tag for Scalar DL"
}

variable "replication_factor" {
  default     = 3
  description = "Set the replication factor for schema"
}

variable "availability_set_id" {
  default = ""
}

variable "enable_tdagent" {
  default     = true
  description = "A flag to install td-agent that forwards logs to the monitor host"
}

variable "internal_domain" {
  description = "Internal domain"
}
