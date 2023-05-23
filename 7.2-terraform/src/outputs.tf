output "web_ip_address" {
value = yandex_compute_instance.platform.network_interface.0.nat_ip_address
description = "vm_web external ip"
}

output "db_ip_address" {
value = yandex_compute_instance.platform-db.network_interface.0.nat_ip_address
description = "vm_db external ip"
}
