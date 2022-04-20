# GCP-SLURM

General setup notes for provisioning a SLURM on GCP cluster, with multiple partitions with different GPU capabilities.
Tries to be as comprehensive as possible in working through setup; just in case, linking the various resources below.

Note that this directory contains subdirectories for each "project cluster" that I work with; for example, the `voltron`
directory contains Terraform files related to the Voltron project. The following walkthough will use `voltron` as a 
specific example, but can be replaced with any other valid configuration.

### Resources

+ [GCP Official Guide](https://cloud.google.com/architecture/deploying-slurm-cluster-compute-engine)
+ [Official Codelab](https://codelabs.developers.google.com/codelabs/hpc-slurm-on-gcp)
+ [Sidd's Discussion Forum Thread](https://groups.google.com/g/google-cloud-slurm-discuss/c/Zh_bMCxjrJo)

### Setup (Local)

The above instructions assume setup through the online web-based console... you can use this, but I prefer to script
infrastructure setup from my laptop (or other local compute) via the `gcloud` CLI. To install the CLI, follow the
instructions here: [https://cloud.google.com/sdk/docs/install](https://cloud.google.com/sdk/docs/install).

Namely, you'll be required to login to your Google account, select the project, and default region you're operating
from:

```bash
gcloud components update             # Refresh entire `gcloud` CLI
gcloud auth login                    # Launches a browser for login...
gcloud set project <PROJECT-NAME>    # Default GCP Project for this session...
gcloud init                          # Follow steps, set default region to region launching cluster (see below)
``` 

You'll also need to install [Terraform](https://www.terraform.io/downloads) this should be straightforward.

---


From the GCP Cloud Shell -- execute the following commands, defining the appropriate environment variables:

```bash
git clone https://github.com/siddk/tesseract.git
cd tesseract/gcp-slurm/voltron

# To test, I'm building one GCP Cluster per Project -- cluster name = project name (voltron)
export CLUSTER_NAME="voltron"
export CLUSTER_ZONE="us-central1-a"	
```

I chose to limit zones to those that have A100 GPUs; I picked `us-central1-a` since I'm US-based, but realize that demand
is quite high here. Other possible zones:

+ `asia-southeast1-c` (Singapore)
+ `europe-west4-a` (Netherlands)
+ `europe-west4-b`
+ `us-central1-a` (Iowa)
+ `us-central1-c`

If demand is problematic, realistically will switch to the Netherlands (`europe-west4-a`), since we've seen success there
in the past.

Next, issue the following commands -- these will just replace the first three lines of the Terraform file
`voltron.tfvars` with the environment variables you've specified, and the current working GCP project:

```bash
sed -i "s/\(cluster_name.*= \)\"\(.*\)\"/\1\"${CLUSTER_NAME}\"/" voltron.tfvars
sed -i "s/<project>/$(gcloud config get-value core/project)/" voltron.tfvars
sed -i "s/\(zone.*= \)\"\(.*\)\"/\1\"${CLUSTER_ZONE}\"/" voltron.tfvars
```
