# Provisioning Custom Images on Google Cloud Platform

This README documents (mis-)adventures in specifying custom images for GCP virtual machines; specifically, targeting the
distributed training and HPC-in-the-cloud usecases.

It's my hope to replace these very manual (and not very reproducible) steps with Packer templates and Ansible playbooks,
but for now, just going to document the images for various projects.

## Voltron - SLURM on GCP

We're going to attempt the following: launch the SLURM Login & Controller nodes using the custom HPC images provided by
SchedMD, but provision a large NFS store which will get mounted at `/home` on each compute node.

Then, on each compute node, we'll load up a slightly revised Deep Learning VM with `conda` installed to `/home`, which
should enable shareable environments + directory mounts.

### Setting up the Image

From the [GCP MarketPlace](https://console.cloud.google.com/marketplace/details/click-to-deploy-images/deeplearning?_ga=2.148091633.71373488.1650829892-1025676277.1648663266&_gac=1.188790105.1648683036.Cj0KCQjw_4-SBhCgARIsAAlegrUpR9gEWLvL2rHFZWLlkAGow1zph8U-YLhPi4pXxtTYAhVZpbg9gjwaApiUEALw_wcB&authuser=6&project=hai-gcp-models) find
the Deep Learning VM images. Select `Launch` and punch in details for a single V100 GPU installation, on an N1 machine.
For the initial image, I selected an `n1-highmem-8` instance with a single V100, the `PyTorch 1.11` image, and selected
the option to install the NVIDIA GPU driver automatically on first startup.

Then... launch the instance! I ran through the following steps:

```
# Image has `conda` installed at /opt/ by default... let's get rid of this
sudo rm -rf /opt/conda

# Reinstall Miniconda at /home/<something>
sudo mkdir /home/utilities
chmod 777 /home/utilities
wget <Miniconda Installer>
bash <Miniconda Installer>   # Make sure to set install location properly... 

# Clean up the .bashrc & /etc/profile.d/env.sh
vi .bashrc
sudo vi /etc/profile.d/env.sh

# Run through installing PyTorch & Testing Install
conda install torch ...
ipython ...
> import torch
> torch.ones(1000).cuda()  # Should succeed 
```

After this, close out the instance, stop it, and [create a custom image from disk using these instructions.](https://cloud.google.com/compute/docs/images/create-delete-deprecate-private-images)

This should result in a path as follows: `/projects/<GCP-PROJECT>/global/images/<NAME YOU GAVE>`. Use this for
spinning up your VMs. 
