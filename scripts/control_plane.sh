#!/bin/bash

# sudo kubeadm init --pod-network-cidr=192.168.0.0/16 >> /home/cor/cluster_initialized.txt

whoami
sudo -i -u cor bash << EOF
echo "In"
whoami
mkdir -p /home/cor/.kube
EOF
echo "Out"
whoami


# sudo cp -i /etc/kubernetes/admin.conf /home/cor/.kube/config
# sudo chown 1000:1000 /home/cor/.kube/config