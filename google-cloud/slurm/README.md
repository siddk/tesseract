# SLURM on Google Cloud Platform

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
gcloud components update                # Refresh entire `gcloud` CLI
gcloud auth login                       # Launches a browser for login...
gcloud set project <PROJECT-NAME>       # Default GCP Project for this session...
gcloud init                             # Follow steps, set default region to region launching cluster (see below)
gcloud auth application-default login   # Set default authentication for spinning up a cluster

``` 

You'll also need to install [Terraform](https://www.terraform.io/downloads); this should be straightforward.

---

## Startup from Localhost (Laptop)

Run the following (assuming you've already cloned this repository):

```bash
cd google-cloud/slurm/terraform/clusters/voltron

# Setup cluster name & zone
export CLUSTER_NAME="voltron"
export CLUSTER_ZONE="europe-west4-a"

# Copy template to "main" file
cp voltron.template.tfvars voltron.tfvars
```

I chose to limit zones to those that have A100 GPUs; I picked `europe-west4-a` even though I'm US-based, as it tends to
have more nodes available than `us-central1-a`. Full list of options:

+ `asia-southeast1-c` (Singapore)
+ `europe-west4-a` (Netherlands)
+ `europe-west4-b`
+ `us-central1-a` (Iowa)
+ `us-central1-c`


Next, issue the following commands -- these will just replace the first three lines of the Terraform file
`voltron.tfvars` with the environment variables you've specified, and the current working GCP project:

```bash
perl -i -p -e "s/\(cluster_name.*= \)\"\(.*\)\"/\1\"${CLUSTER_NAME}\"/" voltron.tfvars
perl -i -p -e "s/<project>/$(gcloud config get-value core/project)/" voltron.tfvars
perl -i -p -e "s/\(zone.*= \)\"\(.*\)\"/\1\"${CLUSTER_ZONE}\"/" voltron.tfvars
```

Double check `voltron.tfvars` to make sure the changes are good...

### Terraform Initialization

To spin up the actual cluster, we'll use Terraform. First, initialize the Terraform project:

```bash
terraform init

# Verify that the Terraform initialization is good...
terraform plan -var-file voltron.tfvars    # Should return a giant config, but no errors!
```

Let's actually spin-up the cluster (WARNING: This launches a cluster & WILL burn credits...):

```bash
terraform apply -var-file=voltron.tfvars -auto-approve

# After running the above and getting an `Apply Complete!` it'll take some time for the cluster to spin up.
#   > Run the following command to track progress... last line should be:
#   > "Started Google Compute Engine Startup Scripts."
#
# Note: Might ask for ssh-key creation; just play-along...

gcloud compute ssh ${CLUSTER_NAME}-controller \
    --command "sudo journalctl -fu google-startup-scripts.service" \
    --zone $CLUSTER_ZONE

# Ctrl-C to exit...
```

Once the above has completed, let's verify the cluster is operational...

```bash
export CLUSTER_LOGIN_NODE=$(gcloud compute instances list \
    --zones ${CLUSTER_ZONE} \
    --filter="name ~ .*login." \
    --format="value(name)" | head -n1)

# SSH into the SLURM Login Node
gcloud compute ssh ${CLUSTER_LOGIN_NODE} --zone $CLUSTER_ZONE

# Run 2 example jobs...
gcloud compute ssh ${CLUSTER_LOGIN_NODE} \
    --command 'sbatch -N2 --wrap="srun hostname"' --zone $CLUSTER_ZONE

gcloud compute ssh ${CLUSTER_LOGIN_NODE} \
    --command 'cat slurm-*.out'  --zone $CLUSTER_ZONE
```

Finally, whenever you're done -- destroy the cluster!
```bash
terraform destroy -var-file=voltron.tfvars -auto-approve
```
---


## Startup via GCP Cloud Shell

If you don't want to download Terraform/run into problems locally, all the above setup can be done via the GCP Cloud
Shell (on the Web GUI).
