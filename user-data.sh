#!/bin/bash
# Enable password authentication
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
systemctl restart sshd

# Set password for ubuntu user
echo 'ubuntu:Password123' | chpasswd

# Update system and install Docker (optional)
apt update -y
