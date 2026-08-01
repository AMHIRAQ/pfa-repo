[master]
k8s-master ansible_host=${master_ip} ansible_user=ubuntu ansible_ssh_private_key_file=${key_path} ansible_ssh_common_args='-o StrictHostKeyChecking=no'

[workers]
k8s-worker1 ansible_host=${worker1_ip} ansible_user=ubuntu ansible_ssh_private_key_file=${key_path} ansible_ssh_common_args='-o StrictHostKeyChecking=no'
k8s-worker2 ansible_host=${worker2_ip} ansible_user=ubuntu ansible_ssh_private_key_file=${key_path} ansible_ssh_common_args='-o StrictHostKeyChecking=no'

[k8s_cluster:children]
master
workers
