#!/bin/bash

set -e

echo "Initializing conda environment"
conda init bash
source "$(conda info --base)/etc/profile.d/conda.sh"

echo "Enter new conda environment name:"
read conda_name
conda create -n $conda_name python=3.8 -y
conda activate $conda_name

echo "Installing dependencies"
conda install -y pytorch==1.13.0 torchvision==0.14.0 torchaudio==0.13.0 pytorch-cuda=11.7 -c pytorch -c nvidia
python -c "import torch; print('PyTorch Version:', torch.__version__); print('CUDA Available:', torch.cuda.is_available())"
python -c "import torchvision; print('Torchvision Version:', torchvision.__version__)"
conda install -y -c conda-forge ffmpeg=4.2
pip install numpy
pip install "git+https://github.com/facebookresearch/pytorchvideo.git"
python -c "import pytorchvideo; print('PyTorchVideo Version:', pytorchvideo.__version__)"
pip install simplejson
conda install -y -c conda-forge iopath
pip install psutil
pip install opencv-python
conda install -y tensorboard
pip install scikit-learn
pip install pandas
conda install -y -c conda-forge moviepy
pip install 'git+https://github.com/facebookresearch/fairscale'
gcc --version
pip install cython
pip install -U 'git+https://github.com/facebookresearch/fvcore.git' \
                'git+https://github.com/cocodataset/cocoapi.git#subdirectory=PythonAPI'
detectron2_repo_dir='detectron2_repo'
rm -rf $detectron2_repo_dir
git clone https://github.com/facebookresearch/detectron2 $detectron2_repo_dir
pip install -e $detectron2_repo_dir
pip install -U pyasn1 pyasn1-modules

echo "Installing SlowFast"
export PYTHONPATH="$(pwd)/slowfast:$PYTHONPATH"

python setup.py clean
rm -rf build/ dist/ torch.egg-info

python setup.py build develop
