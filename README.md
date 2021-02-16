# Tesseract

> "The Tesseract is a doorway to the other end of space."

A collection of Singularity Definition Files and .sif Images for Reproducibility, each representing their
*own little pockets of space* for developing and running various experiments and applications.

Singularity `.def` files are defined interactively via the default Singularity `--sandbox` functionality, and stored 
here. 

## Building Singularity Containers

Note: Developing and Building Singularity Containers can currently only happen on Linux either through native root (`sudo`) access on a Linux machine, or via a privileged Virtual Machine (e.g., Vagrant on Mac OS/Windows). 

However, given a `.def` file, anyone can create an image using Singularity's [`Remote Builder`](https://cloud.sylabs.io/builder), which *does not* require root access. However, it does require creating a SyLabs Account and generating a Sylabs cloud token.

Where possible, I will also try to host `.sif` image/containers directly, either via this repository or via some external store.

**General Instructions for Prototyping Containers:** Follow instructions here: https://sylabs.io/guides/3.7/user-guide/build_a_container.html. 

### Prototyping Singularity Containers on Mac OS via Vagrant

Mac OS doesn't have a native Singularity builder yet, so if you really want to prototype containers (or don't have root access on a Linux machine), I suggest using Vagrant to spin up a Virtual Machine [as detailed here](https://sylabs.io/guides/3.7/admin-guide/installation.html#singularity-vagrant-box).

Specifically, to use this repository:

```bash
# Assuming Homebrew is already installed...
brew install virtualbox 
brew install vagrant 
brew install vagrant-manager

# Identify a Location to Create the VM
cd ~/Utilities
mkdir vm-singularity && cd vm-singularity

# Identify the Latest Singularity-Equipped: https://app.vagrantup.com/sylabs
export VM=sylabs/singularity-3.7-ubuntu-bionic64 
vagrant init $VM && vagrant up 

# Connect to VM (after this point, you're in an Ubuntu VM w/ Singularity Installed -- go wild!)
vagrant ssh
```

In the corresponding VM, I suggest cloning this repo, and bootstrapping future containers off of existing `.def` files (ubuntu-dev and ubuntu-core are both good starting points!).
