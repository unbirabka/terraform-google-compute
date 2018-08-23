variable "gce_ssh_user" {
        default = ""
}

variable "pub_key_file" {
        default = ""
}

variable "network_interface" {
        default = {}
}

variable "compute_name" {
	default = ""
}

variable "count_compute" {
	default = ""
}

variable "count_start" {
        default = ""
}

variable "compute_labels" {
  type    = "map"
  default = {}
}

variable "compute_zones" {
        default = []
}

variable "tags_network" {
	default = []
}

variable "images_name" {
	default = ""
}

variable "size_root_disk" {
	default = ""
}

variable "type_root_disk" {
	default = ""
}

variable "compute_type" {
	default = ""
}

variable "startup_script" {
	default = ""
}
