#!/bin/bash

set -e

conda_yml_file="conda.yml"
detectron2_repo_dir="detectron2_repo"

echo "Initializing conda environment"
conda init bash
source "$(conda info --base)/etc/profile.d/conda.sh"

env_name=$(echo $(head -n 1 $conda_yml_file) | awk '{print $NF}')

if conda env list | grep -qE "^\s*$env_name\s"; then
  echo "Environment '$env_name' already exists. Remove it, or edit the conda.yml file to change the conda environment name."
  exit 1
fi

conda env create -f $conda_yml_file
conda activate $env_name

python -c "import torch; print('PyTorch Version:', torch.__version__); print('CUDA Available:', torch.cuda.is_available())"
python -c "import torchvision; print('Torchvision Version:', torchvision.__version__)"
python -c "import pytorchvideo; print('PyTorchVideo Version:', pytorchvideo.__version__)"
gcc --version
rm -rf $detectron2_repo_dir
git clone https://github.com/facebookresearch/detectron2 $detectron2_repo_dir
pip install -e $detectron2_repo_dir

echo "Installing SlowFast"
export PYTHONPATH="$(pwd)/slowfast:$PYTHONPATH"

python setup.py clean
rm -rf build/ dist/ torch.egg-info

python setup.py build develop
