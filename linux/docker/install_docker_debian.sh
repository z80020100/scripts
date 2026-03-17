#!/bin/bash

set -e

# Reference:
# - https://docs.docker.com/engine/install/ubuntu/
# - https://docs.docker.com/engine/install/debian/

# Detect distro (ubuntu or debian)
. /etc/os-release
if [[ "$ID" == "ubuntu" || "$ID_LIKE" == *"ubuntu"* ]]; then
    DISTRO="ubuntu"
    CODENAME="${UBUNTU_CODENAME:-$VERSION_CODENAME}"
elif [[ "$ID" == "debian" || "$ID_LIKE" == *"debian"* ]]; then
    DISTRO="debian"
    CODENAME="$VERSION_CODENAME"
else
    echo "Unsupported distro: $ID" >&2
    exit 1
fi

if [[ -z "$CODENAME" ]]; then
    echo "Failed to detect version codename" >&2
    exit 1
fi

echo "Detected distro: $DISTRO ($CODENAME)"

# Clean up old-format Docker repo files
sudo rm -f /etc/apt/sources.list.d/docker.list /usr/share/keyrings/docker-archive-keyring.gpg

# Set up the repository
sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL "https://download.docker.com/linux/${DISTRO}/gpg" -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

sudo tee /etc/apt/sources.list.d/docker.sources >/dev/null <<EOF
Types: deb
URIs: https://download.docker.com/linux/${DISTRO}
Suites: ${CODENAME}
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF

# Install Docker Engine
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Manage Docker as a non-root user
sudo gpasswd -a "$USER" docker
