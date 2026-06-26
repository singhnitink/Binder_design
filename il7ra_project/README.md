# De Novo Binder Design for IL-7Ralpha (CD127)

This directory contains a complete computational pipeline for designing de novo protein binders targeting the human Interleukin-7 Receptor alpha (IL-7Ralpha) ectodomain, mimicking the benchmark target in Watson et al. 2023 (Nature).

The workflow is consolidated into the Jupyter notebook: `il7ra_binder_design.ipynb`.

## Workflow Overview
1. **Target Preparation**: Isolating Chain B (IL-7Ralpha ectodomain) from the IL-7/IL-7Ralpha structure (PDB: 3DI3), resolving missing sidechains, and mapping interface contacts and guide hotspots.
2. **Backbone Generation**: Using RFdiffusion guided by target hotspots (B58, B80, B139) to generate scaffold backbones of 60-70 residues.
3. **Sequence Design**: Running ProteinMPNN to design sidechains for the generated backbones while keeping the receptor chain fixed.
4. **Structure Validation**: Predicting binder-receptor complexes using Boltz-2 to calculate ipTM, pLDDT, and pTM.
5. **Physical Scoring**: Relaxing the complexes and calculating interface delta G using PyRosetta.
6. **Literature Benchmarking**: Screening candidates using thresholds derived from the Nature paper (ipTM > 0.75, pLDDT > 80).

## Environment Setup

This project uses a single consolidated conda environment called **`proteindesigntutorial`**. It contains all dependencies for RFdiffusion, ProteinMPNN, Boltz-2 structure prediction, and PyRosetta scoring.

### One-Click Environment Setup
To set up this environment from scratch on a new machine, simply run the setup script:
```bash
./setup_env.sh
```
This script will:
1. Create a conda environment named `proteindesigntutorial` with Python 3.9.
2. Install PyTorch with CUDA 12.1.
3. Install DGL, e3nn, BioPython, and standard science packages.
4. Compile and install `se3-transformer` and `rfdiffusion` locally in editable mode.
5. Install `boltz[cuda]` for complex structural validation.
6. Download and install PyRosetta (2026 release) directly from RosettaCommons.
7. Register the environment as a Jupyter notebook kernel.

## Running the Pipeline

Activate the unified environment and launch the notebook:
```bash
conda activate proteindesigntutorial
jupyter notebook il7ra_binder_design.ipynb
```
Select the **`Python (ProteinDesignTutorial)`** kernel from the kernel menu in Jupyter to run the cells.


## Parameter Tuning Guide

### 1. RFdiffusion
- **Scaffold Lengths**: Defined under `contigmap.contigs`. Changing this range (e.g. from `60-70` to `70-90` or `50-60`) allows you to explore different molecular sizes. Larger binders can cover a broader interface patch, but smaller binders are generally easier to express.
- **Hotspots**: Guided by `ppi.hotspot_res=[B58,B80,B139]`. If you want to target a different pocket on the receptor, inspect the PDB structure in PyMOL, identify coordinates of target residues, and update the list.
- **Noise Scale**: Standard is `0.0` for maximum backbone quality. Set `denoiser.noise_scale_ca` and `denoiser.noise_scale_frame` to `0.5` to generate a more structurally diverse set of backbones.
- **Compaction**: If the backbones contain extended unstructured loops or tails, add `potentials.guiding_potentials=["type:binder_ROG,weight:5.0"]` to apply a radius of gyration penalty.

### 2. ProteinMPNN
- **Sampling Temperature**: Set to `0.1` by default for high-confidence sequence recovery. Increase to `0.2` or `0.3` to design more sequence variation for experimental library screening.
- **Sequences per Scaffold**: Set to `8` in this demo. For production runs, increase this to `32` or `64` to sample a wider range of interface sidechain packing configurations.

### 3. Boltz-2
- **Recycling Steps**: Set to `3` by default. Increasing this to `6` or `12` can improve the structural accuracy of difficult interfaces.
