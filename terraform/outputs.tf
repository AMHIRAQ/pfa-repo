output "master_public_ip" {
  description = "IP publique du master"
  value       = aws_instance.k8s_nodes["k8s-master"].public_ip
}

output "master_private_ip" {
  description = "IP privée du master"
  value       = aws_instance.k8s_nodes["k8s-master"].private_ip
}

output "worker1_public_ip" {
  description = "IP publique du worker1"
  value       = aws_instance.k8s_nodes["k8s-worker1"].public_ip
}

output "worker2_public_ip" {
  description = "IP publique du worker2"
  value       = aws_instance.k8s_nodes["k8s-worker2"].public_ip
}

output "ssh_master" {
  description = "Commande SSH pour le master"
  value       = "ssh -i ${var.private_key_path} ubuntu@${aws_instance.k8s_nodes["k8s-master"].public_ip}"
}

output "ssh_worker1" {
  description = "Commande SSH pour worker1"
  value       = "ssh -i ${var.private_key_path} ubuntu@${aws_instance.k8s_nodes["k8s-worker1"].public_ip}"
}

output "ssh_worker2" {
  description = "Commande SSH pour worker2"
  value       = "ssh -i ${var.private_key_path} ubuntu@${aws_instance.k8s_nodes["k8s-worker2"].public_ip}"
}

output "inventory_path" {
  description = "Chemin du fichier inventory Ansible généré"
  value       = "../ansible/inventory.ini"
}
