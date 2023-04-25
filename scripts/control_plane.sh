#!/bin/bash

whoami
sudo -i -u cor bash << EOF
echo "In"
whoami
mkdir -p /home/cor/.kube
EOF
echo "Out"
whoami