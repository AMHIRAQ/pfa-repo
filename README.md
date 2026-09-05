# PFA - Plateforme Kubernetes Sécurisée Observable

##  Projet Complètement Réalisé

Une plateforme **production-ready** Kubernetes avec infrastructure-as-code, GitOps, sécurité, et observabilité.

## Démo
https://drive.google.com/drive/folders/1x-XXUZZebkpq6dfuoC6xlKEEiiFkcs0I?usp=drive_link
##  Stack Complet

### Infrastructure
-  **Terraform** : AWS VPC, EC2 (1 master + 2 workers)
-  **Ansible** : Provisioning automatisé du cluster K8s
-  **Kubernetes** : v1.28.15, 3 nœuds, Flannel CNI

### Sécurité & Politiques
-  **Pod Security Admission (PSA)** : 3 niveaux (restricted, baseline, privileged)
-  **RBAC** : 2 ServiceAccounts, 2 Roles, 2 RoleBindings
-  **Kyverno** : 4 ClusterPolicies (no-privileged, readonly-rootfs, resource-limits, no-latest-tag)

### GitOps & CI/CD
-  **ArgoCD** : Sync automatique depuis GitHub
-  **GitHub Actions** : tfsec + Trivy sur chaque PR/push
-  **Helm Charts** : Prometheus, Grafana, Loki, Promtail

### Observabilité
-  **Prometheus** : Scrape Node Exporter + Prometheus
-  **Grafana** : Dashboards en temps réel (NodePort 32000)
-  **Loki** : Agrégation des logs
-  **Promtail** : Collection des logs (DaemonSet)
-  **Node Exporter** : Métriques des nœuds (DaemonSet)

## 🎯 Architecture
┌─────────────────────────────────────────┐
│ GitHub Repository │
│ - Terraform (Infrastructure) │
│ - Ansible (Provisioning) │
│ - Helm Charts (Applications) │
│ - K8s Manifests (PSA, RBAC, Kyverno) │
└─────────────────────┬───────────────────┘
↓
┌─────────────────────────────────────────┐
│ GitHub Actions CI/CD │
│ - tfsec (Terraform security) │
│ - Trivy (Container security) │
└─────────────────────┬───────────────────┘
↓
┌─────────────────────────────────────────┐
│ AWS Kubernetes Cluster │
│ - ArgoCD (GitOps) │
│ - Prometheus + Grafana (Monitoring) │
│ - Loki + Promtail (Logging) │
│ - Kyverno (Policy Enforcement) │
│ - PSA + RBAC (Security) │
└─────────────────────────────────────────┘
## Observabilité

### Accès
- **Prometheus** : http://WORKER_IP:30900
- **Grafana** : http://WORKER_IP:32000 (admin/admin)

### Métriques Collectées
- CPU, Memory, Disk (via Node Exporter)
- Pod metrics (via Prometheus)
- Kubernetes cluster health

### Logs Agrégés
- Tous les logs des pods
- Accessible via Grafana Loki Explorer

##  Sécurité

### PSA Policies
- **restricted** : No privileged containers, readonly filesystem, non-root user
- **baseline** : Blocks obvious exploits
- **privileged** : Pour pods système

### Kyverno Policies
- No privileged containers
- Readonly root filesystem required
- Resource limits required
- No latest image tags

### RBAC
- **app-deployer** : Can manage deployments
- **app-viewer** : Read-only access

##  Déploiement

### 1. Infrastructure
```bash
cd terraform/
terraform init
terraform apply
```

### 2. Provisioning
```bash
cd ansible/
ansible-playbook -i inventory.ini install-k8s.yml
```

### 3. GitOps (Automatique via ArgoCD)
ArgoCD lira le repo GitHub et déploiera automatiquement :
- PSA namespaces
- RBAC roles
- Kyverno policies
- Monitoring stack

##  Dashboards

Grafana contient les datasources :
- **Prometheus** : Métriques cluster
- **Loki** : Logs aggregés

##  Technologies

- Kubernetes 1.28.15
- Prometheus v2.45.0
- Grafana 10.0.0
- Loki 2.9.0
- Promtail 2.9.0
- Kyverno (latest)
- ArgoCD (latest)
- Terraform
- Ansible

##  Checklist Final

-  Infrastructure provionnée (Terraform)
-  Cluster K8s opérationnel (Ansible)
-  ArgoCD synchronisant depuis GitHub
-  PSA policies appliquées
-  RBAC configuré
-  Kyverno enforcement actif
-  Prometheus scraping métriques
-  Grafana dashboards accessibles
-  Loki agrégant les logs
-  Promtail collectant les logs
-  GitHub Actions scanant les vulnérabilités

##  Auteur
AMHIRAQ Abdelhakim

**Projet PFA** - Plateforme Kubernetes Sécurisée Observable
