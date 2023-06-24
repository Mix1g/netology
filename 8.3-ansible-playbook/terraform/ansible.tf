resource "local_file" "prod_yml" {
  depends_on = [yandex_compute_instance.vm-each]
  content = templatefile("${path.module}/prod.tftpl",
    { wm-each = yandex_compute_instance.vm-each
     }
  )

  filename = "${abspath(path.module)}/../inventory/prod.yml"
}
