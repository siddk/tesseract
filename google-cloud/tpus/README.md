# Multi-TPU On-Demand Setup

Quick & easy setup for spinning up a small number (manually) of TPU instances, with a shared Cloud Filestore attached
disk.

# Spinning up a TPU VM

TPUs can be spun up using an old, complex multi-VM protocol (you'll see this referred to as "TPU Node") vs. a cleaner,
more streamlined "TPU VM" approach. 

Differences ([in detail](https://cloud.google.com/tpu/docs/system-architecture-tpu-vm#tpu-node)):
+ **TPU Nodes** require spinning up a "host" node on Compute Engine, and attaching a separate TPU accelerator. 
  Communication to the TPU accelerator happens via gRPC.
+ **TPU VMs** are a one-stop shop... but because you don't have control over the "host" node, it defaults to giving you a
   node with 334 GB of RAM and 96 CPUs; this might or might not be expensive depending on how the TPU Research Cloud
   [TRC] does their accounting... will report back!
   
## Setting up a TPU Node

TBD

## Setting up a TPU VM

Using the GCP Cloud Console, under the TPUs tab, initialize a TPU VM with the image `tpu-vm-pt-1.11` (base PyTorch 1.11)
instance.

# Setting up Cloud Filestore

Note: I'll probably script this later...

We want a group read/writeable filestore for reading data, and writing logs/checkpoints.

[Follow these instructions to spin up a Filestore Instance](https://cloud.google.com/filestore/docs/create-instance-console#create-filestore-instance).
Create an instance, make sure the following are set:
- `Instance ID`: `<project>-nfs-server`
- `Instance Type`: Basic
- `Storage Type`: SSD (because it's better!)
- `Capacity`: Project dependent (for Voltron, set to 10 TB)
- `Region`: Same region as TPU nodes
- `Zone`: Same zone as TPU nodes (but shouldn't matter as much?)
- `File share name`: `vol1` (doesn't really matter)

**Make sure to note the *internal* IP address for use later!**

# Bind NFS Filesystem to each Client Node

## Bind NFS to TPU Node 

TBD

## Bind NFS to TPU VM

In the fresh `tpu-vm-pt-1.11` instance, run the commands (or just run) `startup.sh` to initialize the environment. The
first few lines just set Python and XLA, but the final lines install the NFS packages, and mount the drive created in
the last step to the instance. Be sure to replace the `10.0.0.1` dummy IP in `startup.sh` with the actual filestore IP
(otherwise it'll just hang forever). You should be able to write to the NFS drive, and see live changes on other nodes.

*(Optional): You can now verify that the XLA installation works as follows:*
```bash
# Create a python file called `test.py` with the following contents:
import torch
import torch_xla.core.xla_model as xm

dev = xm.xla_device()
t1 = torch.randn(3,3,device=dev)
t2 = torch.randn(3,3,device=dev)
print(t1 + t2)

# Run the following
> python test.py

# Might take a bit... and will print out two `OpKernel` lines you can safely ignore. But then... expect:
tensor([[-0.2121,  1.5589, -0.6951],
        [-0.7886, -0.2022,  0.9242],
        [ 0.8555, -1.8698,  1.4333]], device='xla:1')

# Important bit is the `device='xla:1'`
```

And you're off to the races -- happy experimenting!
