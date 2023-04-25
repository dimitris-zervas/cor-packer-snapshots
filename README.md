# cor-packer-snapshots

Packer builds for Hetzner snapshots

This repo builds to Hetzner server snapshots of nodes for a Kubernetes cluster. 

The cluster should be created using `kubeadm`. All the dependencies are already installed and configured in the snapshots.

One snapshot is for the control-plane node(s) and the other is for the worker nodes.

> Note: The snapshots are built with github actions workflows where the necessary variables are set there. If you want to build the snapshots locally, you need to set the variables on your own behalf.

