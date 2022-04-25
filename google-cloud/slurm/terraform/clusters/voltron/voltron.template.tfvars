cluster_name = "voltron"
project      = "<project>"
zone         = "europe-west4-a"

controller_machine_type = "n1-standard-2"
controller_image        = "projects/schedmd-slurm-public/global/images/family/schedmd-slurm-21-08-6-debian-10"
controller_disk_type    = "pd-ssd"
controller_disk_size_gb = 10000
controller_labels = {
  project = "voltron"
}

login_machine_type = "n1-standard-2"
login_image        = "projects/schedmd-slurm-public/global/images/family/schedmd-slurm-21-08-6-debian-10"
login_disk_type    = "pd-standard"
login_disk_size_gb = 20
login_labels = {
  project = "voltron"
}

# Optional network storage fields
# network_storage is mounted on all instances
# login_network_storage is mounted on controller and login instances
network_storage = [{
  server_ip     = "$controller"
  remote_mount  = "/home"
  local_mount   = "/home"
  fs_type       = "nfs"
  mount_options = null
}]

# login_network_storage = [{
#   server_ip     = "<storage host>"
#   remote_mount  = "/net_storage"
#   local_mount   = "/shared"
#   fs_type       = "nfs"
#   mount_options = null
# }]

# compute_node_service_account = "default"
# compute_node_scopes          = [
#   "https://www.googleapis.com/auth/monitoring.write",
#   "https://www.googleapis.com/auth/logging.write"
# ]

# We want three partitions -->
partitions = [

  # 1) Download :: N2 (128 GB RAM) -- Download Nodes are "on-demand" (not spot/preemptible!)
  { name                 = "download-n2"
    machine_type         = "n2-highmem-16"
    static_node_count    = 0
    max_node_count       = 4
    zone                 = "europe-west4-a"
    image                = "projects/hai-gcp-models/global/images/voltron-gpu-v100"
    image_hyperthreads   = true
    compute_disk_type    = "pd-standard"
    compute_disk_size_gb = 20
    compute_labels       = {}
    cpu_platform         = "Intel Skylake"
    gpu_count            = 0
    gpu_type             = "nvidia-tesla-v100"
    network_storage      = []
    preemptible_bursting = false
    vpc_subnet           = null
    exclusive            = false
    enable_placement     = false
    regional_capacity    = false
    regional_policy      = {}
    instance_template    = null
    labels = {
      project = "voltron"
    }
  },

  # 2) Basic :: N2 (52 GB RAM) + 1 V100 (Spot instance!)
  { name                 = "basic-n1-v100"
    machine_type         = "n1-highmem-8"
    static_node_count    = 0
    max_node_count       = 16
    zone                 = "europe-west4-a"
    image                = "projects/hai-gcp-models/global/images/voltron-gpu-v100"
    image_hyperthreads   = true
    compute_disk_type    = "pd-standard"
    compute_disk_size_gb = 20
    compute_labels       = {}
    cpu_platform         = "Intel Skylake"
    gpu_count            = 1
    gpu_type             = "nvidia-tesla-v100"
    network_storage      = []
    preemptible_bursting = "spot"
    vpc_subnet           = null
    exclusive            = false
    enable_placement     = false
    regional_capacity    = false
    regional_policy      = {}
    instance_template    = null
    labels = {
      project = "voltron"
    }
  },

  # 3) On-Demand :: N2 (52 GB RAM) + 1 V100 (On-Demand)
  { name                 = "reserved-n1-v100"
    machine_type         = "n1-highmem-8"
    static_node_count    = 0
    max_node_count       = 16
    zone                 = "europe-west4-a"
    image                = "projects/hai-gcp-models/global/images/voltron-gpu-v100"
    image_hyperthreads   = true
    compute_disk_type    = "pd-standard"
    compute_disk_size_gb = 20
    compute_labels       = {}
    cpu_platform         = "Intel Skylake"
    gpu_count            = 1
    gpu_type             = "nvidia-tesla-v100"
    network_storage      = []
    preemptible_bursting = false
    vpc_subnet           = null
    exclusive            = false
    enable_placement     = false
    regional_capacity    = false
    regional_policy      = {}
    instance_template    = null
    labels = {
      project = "voltron"
    }
  },

  # 4) Ultra :: A2 (85 GB RAM + 1 A100) (Spot Instance!)
  { name                 = "ultra-a100"
    machine_type         = "a2-highgpu-1g"
    static_node_count    = 0
    max_node_count       = 8
    zone                 = "europe-west4-a"
    image                = "projects/hai-gcp-models/global/images/voltron-gpu-v100"
    image_hyperthreads   = true
    compute_disk_type    = "pd-standard"
    compute_disk_size_gb = 20
    compute_labels       = {}
    cpu_platform         = "Intel Skylake"
    gpu_count            = 0
    gpu_type             = false
    network_storage      = []
    preemptible_bursting = "spot"
    vpc_subnet           = null
    exclusive            = false
    enable_placement     = false
    regional_capacity    = false
    regional_policy      = {}
    instance_template    = null
    labels = {
      project = "voltron"
    }
  },

  # 5) Intense :: A2-MegaGPU (16 A100s) (Spot Instance!)
  { name                 = "intense-a100"
    machine_type         = "a2-megagpu-16g"
    static_node_count    = 0
    max_node_count       = 8
    zone                 = "europe-west4-a"
    image                = "projects/hai-gcp-models/global/images/voltron-gpu-v100"
    image_hyperthreads   = true
    compute_disk_type    = "pd-standard"
    compute_disk_size_gb = 20
    compute_labels       = {}
    cpu_platform         = "Intel Skylake"
    gpu_count            = 0
    gpu_type             = false
    network_storage      = []
    preemptible_bursting = "spot"
    vpc_subnet           = null
    exclusive            = false
    enable_placement     = false
    regional_capacity    = false
    regional_policy      = {}
    instance_template    = null
    labels = {
      project = "voltron"
    }
  },
]

