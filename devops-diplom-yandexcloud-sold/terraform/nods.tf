resource "yandex_compute_instance" "cluster-k8s" {
  count                     = 3
  name                      = "node-${count.index}"
  zone                      = "${var.subnet-zones[count.index]}"
  hostname                  = "node-${count.index}"
  allow_stopping_for_update = true
  labels                    = {
    index = "${count.index}"
  }

  scheduling_policy {
    preemptible = true
  }

  resources {
    cores  = 4
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "${var.ubuntu-22}"
      type     = "network-ssd"
      size     = "20"
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.subnet-zones[count.index].id}"
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${var.ssh_public_key}"
  }
}
