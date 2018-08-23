provider "google" {
  credentials = "${file("./credentials/sekolahlinux.json")}"
  project     = "sekolahlinux-110891"
  region      = "asia-southeast1"
}

############################################################################
############################################################################
############################################################################

module "compute_engine" {
# pilih module compute-engine-noip jika kamu ingin instance/compute yang kamu buat tanpa public ip
# pilih module compute-engine-ip jika kamu ingin instance/compute yang kamu buat mempunyai public ip
# source = "../modules/compute-engine-noip/"
  source = "../modules/compute-engine-ip/"

  count_compute	= 3
  count_start	= 1
  compute_name	= "java-prod"
  compute_type	= "n1-standard-1"
  compute_zones	= ["asia-southeast1-a", "asia-southeast1-b", "asia-southeast1-c"]
  
  tags_network		= ["allow-icmp", "allow-ssh"]
  images_name		= "ubuntu-1604-lts"
  size_root_disk	= 100
  type_root_disk	= "pd-standard" 			//pd-standard or pd-ssd
  startup_script	= "./provisioning/startup_script.sh"
  pub_key_file          = "../pubkey/id_sekolahlinux.pub"
  gce_ssh_user          = "ubuntu"

  compute_labels = {
    "createdby" = "terraform"
    "environment" = "development"
  }
}

############################################################################
############################################################################
############################################################################

output "compute_private_ip" {
  description = "List of private IP addresses assigned to the instances, if applicable"
  value       = "${module.compute_engine.private_ip}"
}

output "compute_public_ip" {
  description = "List of private IP addresses assigned to the instances, if applicable"
  value       = "${module.compute_engine.public_ip}"
}
