terraform {
  required_version = ">= 1.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

# ──────────────────────────────────────────
# KEY PAIR — génération automatique
# ──────────────────────────────────────────

resource "tls_private_key" "k8s" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "k8s" {
  key_name   = var.key_name
  public_key = tls_private_key.k8s.public_key_openssh
}

# Sauvegarde la clé privée localement
resource "local_file" "private_key" {
  content         = tls_private_key.k8s.private_key_pem
  filename        = pathexpand(var.private_key_path)
  file_permission = "0600"
}

# ──────────────────────────────────────────
# VPC
# ──────────────────────────────────────────

resource "aws_vpc" "k8s" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name    = "${var.project_name}-vpc"
    Project = var.project_name
  }
}

resource "aws_internet_gateway" "k8s" {
  vpc_id = aws_vpc.k8s.id

  tags = {
    Name    = "${var.project_name}-igw"
    Project = var.project_name
  }
}

resource "aws_subnet" "k8s_public" {
  vpc_id                  = aws_vpc.k8s.id
  cidr_block              = var.subnet_cidr
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags = {
    Name    = "${var.project_name}-subnet-public"
    Project = var.project_name
  }
}

resource "aws_route_table" "k8s_public" {
  vpc_id = aws_vpc.k8s.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.k8s.id
  }

  tags = {
    Name    = "${var.project_name}-rt-public"
    Project = var.project_name
  }
}

resource "aws_route_table_association" "k8s_public" {
  subnet_id      = aws_subnet.k8s_public.id
  route_table_id = aws_route_table.k8s_public.id
}

# ──────────────────────────────────────────
# EC2 INSTANCES
# ──────────────────────────────────────────

locals {
  nodes = {
    "k8s-master"  = { role = "master" }
    "k8s-worker1" = { role = "worker" }
    "k8s-worker2" = { role = "worker" }
  }
}

resource "aws_instance" "k8s_nodes" {
  for_each = local.nodes

  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.k8s.key_name
  subnet_id              = aws_subnet.k8s_public.id
  vpc_security_group_ids = [aws_security_group.k8s_common.id]

  # Désactive la vérification source/dest pour le routing Calico
  source_dest_check = false

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 20 # Go — Free Tier = 30 Go max total
    delete_on_termination = true
  }

  user_data = file("${path.module}/user_data.sh")

  tags = {
    Name    = each.key
    Role    = each.value.role
    Project = var.project_name
  }
}

# ──────────────────────────────────────────
# INVENTORY ANSIBLE — généré automatiquement
# ──────────────────────────────────────────

resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/inventory.tpl", {
    master_ip  = aws_instance.k8s_nodes["k8s-master"].public_ip
    worker1_ip = aws_instance.k8s_nodes["k8s-worker1"].public_ip
    worker2_ip = aws_instance.k8s_nodes["k8s-worker2"].public_ip
    key_path   = var.private_key_path
  })
  filename = "../ansible/inventory.ini"
}
