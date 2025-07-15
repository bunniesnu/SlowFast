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
  echo "To remove the environment, run:"
  echo "conda env remove -n $env_name -y"
  exit 1
fi

conda env create -f $conda_yml_file
conda activate $env_name

pip install -r requirements.txt

python -c "import torch; print('PyTorch Version:', torch.__version__); print('CUDA Available:', torch.cuda.is_available())"
python -c "import torchvision; print('Torchvision Version:', torchvision.__version__)"
python -c "import pytorchvideo; print('PyTorchVideo Version:', pytorchvideo.__version__)"
gcc --version

echo "Installing SlowFast"
export PYTHONPATH="$(pwd)/slowfast:$PYTHONPATH"

python setup.py clean
rm -rf build/ dist/ torch.egg-info

python setup.py build develop
