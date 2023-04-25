packer {
  required_plugins {
    hcloud = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/hcloud"
    }
  }
}

variable "base_image" {
  type = string
}

variable "location" {
  type = string
}

variable "ssh_username" {
  type    = string
  default = "root"
}


variable "server_type" {
  type = string
}

variable snapshot_labels {
  type = map(string)
}

variable "hcloud_token" {
  type = string
  default = "${env("HCLOUD_TOKEN")}"
}

variable "COR_MASTER_SSH_PUB_KEY" {
  type    = string
  default = "${env("COR_MASTER_SSH_PUB_KEY")}"
}

variable "commit_hash" {
  type    = string
}


source "hcloud" "builder" {
  token           = var.hcloud_token
  image           = var.base_image
  location        = var.location
  server_type     = var.server_type
  ssh_username    = var.ssh_username
  snapshot_name = "control-plane-${substr(var.commit_hash, 0, 7)}"
  snapshot_labels = {
    "commit_hash" = "${substr(var.commit_hash, 0, 7)}"
    "type"        = "control-plane"
  }
}

build {
  sources = ["source.hcloud.builder"]

  # Add the COR user
  provisioner "shell" {
    environment_vars = [
      "SSH_PUB_KEY=${var.COR_MASTER_SSH_PUB_KEY}",
    ]
    scripts = ["scripts/create_user.sh"]
  }

  # Install CRI-O
  provisioner "shell" {
    scripts = ["scripts/crio.sh"]
  }

  # Install kubeadm, kubelet and kubectl
  provisioner "shell" {
    scripts = ["scripts/kube_tools_control_plane.sh"]
  }

  # Upload the 20-hcloud.conf
  provisioner "file" {
    source      = "files/20-hcloud.conf"
    destination = "/tmp/20-hcloud.conf"
  }

  provisioner "shell" {
    inline = [
      "mv /tmp/20-hcloud.conf /etc/systemd/system/kubelet.service.d/20-hcloud.conf",
      "chmod 644 /etc/systemd/system/kubelet.service.d/20-hcloud.conf",
    ]
  }
}


