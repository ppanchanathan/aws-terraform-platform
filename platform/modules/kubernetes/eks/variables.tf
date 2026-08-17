variable "name" {
  type = string
}

variable "kubernetes_version" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "access_principals" {
  description = "EKS access principals"

  type = object({
    cluster_admins = list(string)
  })
}