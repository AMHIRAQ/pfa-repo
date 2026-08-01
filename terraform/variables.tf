variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-3" # Paris — change selon ta préférence
}

variable "aws_profile" {
  description = "AWS CLI profile"
  type        = string
  default     = "default"
}

variable "key_name" {
  description = "Nom de la clé SSH dans AWS"
  type        = string
  default     = "k8s-key"
}

variable "private_key_path" {
  description = "Chemin local vers ta clé SSH privée"
  type        = string
  default     = "~/.ssh/k8s-key.pem"
}

variable "instance_type" {
  description = "Type d'instance EC2 (Free Tier = t3.micro)"
  type        = string
  default     = "t3.small"
}

variable "ami_id" {
  description = "Ubuntu 22.04 LTS — à adapter selon la région"
  type        = string
  default     = "ami-015cabafc8f6249fe" # Ubuntu 22.04 eu-west-3
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "subnet_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "project_name" {
  type    = string
  default = "k8s-mairmed"
}
