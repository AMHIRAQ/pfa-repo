# Security Group commun à tous les nœuds K8s
resource "aws_security_group" "k8s_common" {
  name        = "${var.project_name}-sg"
  description = "Security group pour le cluster Kubernetes"
  vpc_id      = aws_vpc.k8s.id

  # ── SSH ──────────────────────────────────
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Restreins à ton IP en prod : ["X.X.X.X/32"]
  }

  # ── API SERVER (master seulement, mais SG commun pour simplifier) ──
  ingress {
    description = "Kubernetes API Server"
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ── ETCD ─────────────────────────────────
  ingress {
    description = "etcd server client API"
    from_port   = 2379
    to_port     = 2380
    protocol    = "tcp"
    self        = true # seulement entre nœuds du même SG
  }

  # ── KUBELET ──────────────────────────────
  ingress {
    description = "Kubelet API"
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    self        = true
  }

  # ── KUBE-SCHEDULER & CONTROLLER-MANAGER ──
  ingress {
    description = "kube-scheduler + controller-manager"
    from_port   = 10257
    to_port     = 10259
    protocol    = "tcp"
    self        = true
  }

  # ── NODEPORT RANGE ────────────────────────
  ingress {
    description = "NodePort services (Grafana, ArgoCD...)"
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ── CALICO CNI ───────────────────────────
  ingress {
    description = "Calico BGP"
    from_port   = 179
    to_port     = 179
    protocol    = "tcp"
    self        = true
  }

  ingress {
    description = "Calico VXLAN / IP-in-IP"
    from_port   = 0
    to_port     = 0
    protocol    = "4" # IP-in-IP
    self        = true
  }

  ingress {
    description = "Calico VXLAN UDP"
    from_port   = 4789
    to_port     = 4789
    protocol    = "udp"
    self        = true
  }

  # ── TRAFIC INTERNE ───────────────────────
  ingress {
    description = "all internal trafic allowed"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  # ── EGRESS ───────────────────────────────
  egress {
    description = "Tout trafic sortant autorised"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.project_name}-sg"
    Project = var.project_name
  }
}
