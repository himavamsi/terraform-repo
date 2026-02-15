# GCP Project
variable "project" {
  description = "The GCP project where the VM will be created"
  type        = string
}

# VM Name
variable "vm_name" {
  description = "Name of the VM to create"
  type        = string
}

# Region selected by user
variable "region" {
  description = "GCP region where the VM should be created"
  type        = string
}

# Operating System (Ubuntu or CentOS)
variable "os" {
  description = "Operating System of the VM (Ubuntu or CentOS)"
  type        = string
}

# Disk Type (pd-standard or pd-balanced)
variable "disk_type" {
  description = "Type of boot disk (pd-standard or pd-balanced)"
  type        = string
}

# Provisioning Model (Standard or Spot)
variable "provisioning_model" {
  description = "Provisioning model: Standard or Spot"
  type        = string
}

# Firewall Rules (ssh or webserver)
variable "firewall" {
  description = "Firewall rules to apply (ssh or webserver)"
  type        = string
}
