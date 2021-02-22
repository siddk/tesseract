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