output "private_ip" {
  description = "list private ip on compute instance"
  value       = ["${google_compute_instance.sekolahlinux.*.network_interface.0.network_ip}"]
}

output "public_ip" {
  description = "list private ip on compute instance"
  value       = ["${google_compute_instance.sekolahlinux.*.network_interface.0.access_config.0.nat_ip}"]
}
