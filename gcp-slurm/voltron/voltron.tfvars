cluster_name = "g1"
project      = "<project>"
zone         = "us-central1-a"

controller_machine_type = "n1-standard-2"
controller_image        = "projects/schedmd-slurm-public/global/images/family/schedmd-slurm-21-08-6-debian-10"
controller_disk_type    = "pd-ssd"
controller_disk_size_gb = 100
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
# 1) Basic :: N2
partitions = [
  { name                 = "basic"
    machine_type         = "n1-standard-16"
    static_node_count    = 0
    max_node_count       = 16
    zone                 = "us-central1-a"
    image                = "projects/schedmd-slurm-public/global/images/family/schedmd-slurm-21-08-6-hpc-centos-7"
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
  },

  #  { name                 = "partition2"
  #    machine_type         = "c2-standard-16"
  #    static_node_count    = 0
  #    max_node_count       = 20
  #    zone                 = "us-central1-a"
  #    image                = "projects/schedmd-slurm-public/global/images/family/schedmd-slurm-21-08-6-hpc-centos-7"
  #    image_hyperthreads   = true
  #
  #    compute_disk_type    = "pd-ssd"
  #    compute_disk_size_gb = 20
  #    compute_labels       = {
  #      key1 = "val1"
  #      key2 = "val2"
  #    }
  #    cpu_platform         = "Intel Skylake"
  #    gpu_count            = 8
  #    gpu_type             = "nvidia-tesla-v100"
  #    network_storage      = [{
  #      server_ip     = "none"
  #      remote_mount  = "<gcs bucket name>"
  #      local_mount   = "/data"
  #      fs_type       = "gcsfuse"
  #      mount_options = "file_mode=664,dir_mode=775,allow_other"
  #    }]
  #    preemptible_bursting = true
  #    vpc_subnet           = null
  #    exclusive            = false
  #    enable_placement     = false
  #
  #    # With regional_capacity : true, the region can be specified in the zone.
  #    # Otherwise the region will be inferred from the zone.
  #    zone = "us-central"
  #    regional_capacity    = true
  #    # Optional
  #    regional_policy      = {
  #        locations = {
  #            "zones/us-central-a" = {
  #                preference = "DENY"
  #            }
  #        }
  #    }
  #
  #    # When specifying an instance template, specified compute fields will
  #    # override the template properties.
  #    instance_template = "my-template"
  #  }
]

