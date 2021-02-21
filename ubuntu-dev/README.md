# Ubuntu-Dev

Default Ubuntu 20.04 Image Definition File (usually, a starting point for future projects), with sane defaults, geared
towards heavy development (install everything you need, coloring, vim plugins, multiple Python tools, etc.). For a 
lighter-weight image geared for fast runs, you can use `ubuntu-core`, but unclear if necessary.

Relevant Information:
- Pulled from Singularity Library: `ubuntu:20.04`
    + For fixed version/full reproducibility use: 
    `library/default/ubuntu:sha256.cb37e547a14249943c5a3ee5786502f8db41384deb83fa6d2b62f3c587b82b17`
- Anaconda (Full) and Poetry installed by default with Python 3.8

## Multiple CUDA/GPU Version Support

Work in progress - this link might be useful: 
[Creating Portable GPU-Enabled Singularity Images](https://gpucomputing.shef.ac.uk/education/creating_gpu_singularity/)