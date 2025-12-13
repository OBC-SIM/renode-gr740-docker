#!/bin/bash

apt-get update -y

mkdir renode_portable
wget https://github.com/renode/renode/releases/download/v1.16.0/renode_1.16.0_amd64.deb
wget https://builds.renode.io/renode-latest.linux-portable.tar.gz
tar xf  renode-latest.linux-portable.tar.gz -C renode_portable --strip-components=1

echo 'export PATH="$PATH:/opt/renode_portable"' >> ~/.bashrc
dpkg -i renode_1.16.0_amd64.deb

