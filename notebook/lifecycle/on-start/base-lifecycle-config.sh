#!/bin/bash

# Sample repo
# https://github.com/aws-samples/amazon-sagemaker-notebook-instance-lifecycle-config-samples/blob/master/README.md

set -e

sudo -u ec2-user -i <<'EOF'

################
# runtime
################
echo "[INFO] Terminal setting"
sudo yum install -y zsh tmux tree

echo "[INFO] Setting Up: Git Config"
git config --global user.name junoha
git config --global user.email jun.ohashi.42@gmail.com

################
# pip
################
echo "[INFO] Upgrading pip"
pip install --upgrade pip

# I already added PyPI packages in ~/SageMaker/<conda-custome-runtime> by conda, please comment out if you want additional package
# echo "[INFO] Installing PyPI packages"
# pip install tqdm

################
# jupyter lab extension
################
echo "[INFO] Activating: JupyterSystemEnv"
source /home/ec2-user/anaconda3/bin/activate JupyterSystemEnv

echo "[INFO] Install Jupyter Lab Extension"
jupyter labextension install jupyterlab-tailwind-theme

conda deactivate

################
# Install custom conda environment persisted on EBS
################
echo "[INFO] Install custom conda environment persisted on EBS"
WORKING_DIR=/home/ec2-user/SageMaker/.miniconda-py38-custom
source "$WORKING_DIR/miniconda/bin/activate"
for env in $WORKING_DIR/miniconda/envs/*; do
    BASENAME=$(basename "$env")
    source activate "$BASENAME"
    python -m ipykernel install --user --name "$BASENAME" --display-name "Custom ($BASENAME)"
done
# Optionally, uncomment these lines to disable SageMaker-provided Conda functionality.
# echo "c.EnvironmentKernelSpecManager.use_conda_directly = False" >> /home/ec2-user/.jupyter/jupyter_notebook_config.py
# rm /home/ec2-user/.condarc
EOF

echo "Restarting the Jupyter server.."
restart jupyter-server
