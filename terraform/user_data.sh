#!/bin/bash
# user_data.sh — Préparation minimale des VMs au boot
# Le gros de la config sera fait par Ansible

set -e

# Mise à jour silencieuse
apt-get update -qq
apt-get upgrade -y -qq

# Paquets de base nécessaires pour Ansible et la suite
apt-get install -y -qq \
  curl \
  wget \
  gnupg \
  apt-transport-https \
  ca-certificates \
  software-properties-common \
  python3 \
  python3-pip

# Désactivation du swap (requis par kubeadm)
swapoff -a
sed -i '/swap/d' /etc/fstab

# Modules noyau pour containerd / Kubernetes
cat <<EOF > /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

modprobe overlay
modprobe br_netfilter

# Paramètres sysctl pour le réseau K8s
cat <<EOF > /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

sysctl --system

echo "✅ user_data.sh terminé — VM prête pour Ansible"
