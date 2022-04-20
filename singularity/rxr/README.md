# Room across Room (MatterPort3D Simulator)

Building the Matterport3D Simulator requires jumping through a few hoops. The Singularity definition in this directory
bootstraps off an official NVIDIA CUDA GL Image (as per the 
[Matterport3DSimulator Dockerfile](https://github.com/peteanderson80/Matterport3DSimulator/blob/master/Dockerfile)) and
spins up a Singularity Container with updated versions (just newer versions of CUDA).

Python is installed natively here; future work will shift this container to a more modular, Conda/Poetry-based setup,
and a native Ubuntu 20.04/Alpine base.

Relevant Information:
- Pulled from Docker Hub: `nvidia/cudagl:10.1-devel`
    + For fixed version/full reproducibility use: 
    `DIGEST:sha256:ded880fdae128a88b4dc3c1ec4f8eb586c470896ba70a108fe46729ed194efb5`
- Native Python (`apt-get python3-dev python3-pip`)

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