# Name
variable "function_name" {
  type        = string
  description = "name"
}

# azure region
variable "location" {
  type        = string
  description = "Azure region where the resources will be created"
  default     = "West US 2"
}

# SC_EXT vnet cidr
variable "network-vnet-cidr" {
  type        = string
  description = "VNET"
}

# SC_EXT vnet cidr
variable "network-subnet-cidr" {
  type        = string
  description = "Subnet"
}

# SC_EXT private ip
variable "internal-private-ip" {
  type        = string
  description = "Subnet"
}

# Allowed IP Addres
variable "allowed-IP" {
  type        = string
  description = "IP address where management station can be accessed"
}

# Github Address
variable "github-address" {
  type        = string
  description = "Github repo where Smart Console extention is stored."
}

# environment
variable "environment" {
  type        = string
  description = "Staging or Production"
}

# Web Server Name
variable "vm-name" {
  type        = string
  description = "Name VM"
}

# username
variable "username" {
  type        = string
  description = "Username"
}

# password
variable "password" {
  type        = string
  description = "Password"
}


