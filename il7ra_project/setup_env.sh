#!/bin/bash
set -e

echo "Creating conda environment: proteindesigntutorial"
conda create -n proteindesigntutorial python=3.9 -y

# Get conda base path
CONDA_BASE=$(conda info --base)
source "$CONDA_BASE/etc/profile.d/conda.sh"

echo "Activating environment..."
conda activate proteindesigntutorial

echo "Installing PyTorch with CUDA..."
conda install pytorch torchvision torchaudio pytorch-cuda=12.1 -c pytorch -c nvidia -y

echo "Installing cudatoolkit 11.8 (for DGL CUDA compatibility)..."
conda install cudatoolkit=11.8 -c conda-forge --no-channel-priority -y

echo "Installing core dependencies..."
pip install e3nn biopython mdanalysis ipywidgets ipykernel pyyaml pandas matplotlib scipy pyrsistent

echo "Installing DGL for CUDA..."
conda install -c dglteam dgl-cuda11.7 -y --force-reinstall

echo "Installing SE3Transformer..."
pip install -e /home/nsingh/Desktop/github/Binder_design/RFdiffusion/env/SE3Transformer

echo "Installing RFdiffusion..."
pip install -e /home/nsingh/Desktop/github/Binder_design/RFdiffusion

echo "Installing Boltz..."
pip install "boltz[cuda]"

echo "Installing PyRosetta..."
pip install https://west.rosettacommons.org/pyrosetta/release/release/PyRosetta4.Release.python39.ubuntu.wheel/pyrosetta-2026.25%2Brelease.a31d9d50e2-cp39-cp39-linux_x86_64.whl

echo "Registering Jupyter kernel..."
python -m ipykernel install --user --name proteindesigntutorial --display-name "Python (ProteinDesignTutorial)"

echo "Environment setup complete."
