variable "name" {
  type = string
}

variable "cidr" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "map_public_ip_on_launch" {
  description = "Assign public IPs to instances launched in this subnet"
  type        = bool
  default     = false
}

variable "availability_zone" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}