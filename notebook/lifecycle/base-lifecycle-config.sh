#!/bin/bash

# Sample repo
# https://github.com/aws-samples/amazon-sagemaker-notebook-instance-lifecycle-config-samples/blob/master/README.md

set -e

sudo -u ec2-user -i <<'EOF'

################
# runtime
################
echo "[INFO] Terminal setting"
sudo yum install -y zsh, tmux
echo "[INFO] Status: Completed"

echo "[INFO] Setting Up: Git Config"
git config --global user.name junoha
git config --global user.email jun.ohashi.42@gmail.com
echo "[INFO] Status: Completed"

################
# pip
################
echo "[INFO] Upgrading pip"
pip install --upgrade pip
echo "[INFO] Status: Completed"

echo "[INFO] Installing PyPI packages"
pip install tqdm
echo "[INFO] Status: Completed"

################
# jupyter lab extension
################
echo "[INFO] Activating: JupyterSystemEnv"
source /home/ec2-user/anaconda3/bin/activate JupyterSystemEnv

echo "[INFO] Install Jupyter Lab Extension"
jupyter labextension install jupyterlab-tailwind-theme
echo "[INFO] Status: Completed"

source /home/ec2-user/anaconda3/bin/deactivate
echo "[INFO] Deactivating: JupyterSystemEnv"


EOF