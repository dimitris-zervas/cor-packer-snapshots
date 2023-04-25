#!/bin/bash

# Set the username and public key environment variable name
username=cor
cor_pubkey_env_var=${SSH_PUB_KEY}

# Create the user "cor" with home directory and set Bash as default shell
useradd -m -s /bin/bash $username

# Set the password for the user "cor" to blank (passwordless)
passwd -d $username

# Add the user "cor" to the sudo group with passwordless sudo
echo "$username ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$username

# Add the SSH public key for the user "cor"
mkdir -p /home/$username/.ssh
# echo "$cor_pubkey_env_var" >> /home/$username/.ssh/authorized_keys
echo "$cor_pubkey_env_var" >> /home/$username/.ssh/authorized_keys
chmod 600 /home/$username/.ssh/authorized_keys
chown -R $username:$username /home/$username/.ssh