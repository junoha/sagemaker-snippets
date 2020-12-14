#!/bin/bash

set -e
sudo -u ec2-user -i <<'EOF'
unset SUDO_UID

WORKING_DIR=/home/ec2-user/SageMaker/.miniconda-py38-custom
KERNEL_NAME="miniconda-py38-custom"
PYTHON="3.8"

# Install a separate conda installation via Miniconda
mkdir -p "$WORKING_DIR"
wget https://repo.anaconda.com/miniconda/Miniconda3-4.6.14-Linux-x86_64.sh -O "$WORKING_DIR/miniconda.sh"
bash "$WORKING_DIR/miniconda.sh" -b -u -p "$WORKING_DIR/miniconda" 
rm -rf "$WORKING_DIR/miniconda.sh"

# Create a custom conda environment
source "$WORKING_DIR/miniconda/bin/activate"
conda create --yes --name "$KERNEL_NAME" python="$PYTHON"
conda activate "$KERNEL_NAME"
pip install --quiet ipykernel

# Customize these lines as necessary to install the required packages
conda install --yes pandas numpy pytorch transformers pyarrow
pip install --quiet boto3 fugashi ipadic elasticsearch requests requests-aws4auth requests beautifulsoup4 lxml tqdm

EOF