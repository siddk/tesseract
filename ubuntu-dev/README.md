# Ubuntu-Dev

Default Ubuntu 20.04 Image Definition File (usually, a starting point for future projects), with sane defaults, geared
towards heavy development (install everything you need, coloring, vim plugins, multiple Python tools, etc.). For a 
lighter-weight image geared for fast runs, you can use `ubuntu-core`, but unclear if necessary.

Relevant Information:
- Pulled from Singularity Library: `ubuntu:20.04`
    + For fixed version/full reproducibility use: 
    `library/default/ubuntu:sha256.cb37e547a14249943c5a3ee5786502f8db41384deb83fa6d2b62f3c587b82b17`
- MiniConda installed by default with Python 3.8

# Running Python Code w/ Conda Environments

Due to a weird bug with `conda init` in Singularity/Docker containers (WIP), make sure to run 
`. /usr/local/miniconda/etc/profile.d/conda.sh` to enable the use of `conda activate` in all scripts!

## Multiple CUDA/GPU Version Support

For the time being, it's recommended to create separate Conda environments in your container for various different GPUs
and CUDA versions (10.1, 10.2, 11 seem to be the ones mostly used). This is mostly relevant for `PyTorch` and install
is best done via `pip` with the appropriate CUDA Toolkit. Helpers for sourcing the appropriate Conda environment 
(by automatically reading `nvidia-smi`) is forthcoming.

Automating Conda environment creation on a per-GPU/CUDA Version basis is currently a work in progress - this link might 
be useful: 
[Creating Portable GPU-Enabled Singularity Images](https://gpucomputing.shef.ac.uk/education/creating_gpu_singularity/)