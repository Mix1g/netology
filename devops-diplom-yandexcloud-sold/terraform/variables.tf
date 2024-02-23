variable "yandex_cloud_id" {
  default = "b1ghme7t6uk3m7g7rp0b"
}

variable "ssh_public_key" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQD2xEUMjBA5SV94qV1/JCrTTH0idoRejDmXasP5/MLPFpTenhqdycWoLKm0CTgF4cJJSiSDHixjxURB6gN5lALQ2FgGK4LdAU5IGkf0nzQugDa6VsK46kPLYIbxk/vHlqIbH9dz26VKeKVCp9gURkBXWFdTTG+spK2e/goZTSWCQkbSyedqslYFOXxN47986OzAyHQ1BTJKOulweM3T8Y2hjruJxuham/qfQ6NXGQ7wJECLuQkfJzhTDcT21TZMRlYO5+MyrWlUQKwBEL4w/Njv/Ic+Q+Rv7+ATYiPi6CY1AYkf8aLljE/GlamCLyVSlTYr0ofbSJltcnhTGrO2vKk6ZzTUtMD0F0QOYLWilifwUpXxr/4IeQUR/53iW0PZJf8kquQrewog33NonyodXq4MdkQDEYPrXLh5NxkFUTmnOHypmjf/94ksnrkoHQFYfGfTSxPSGHc8aLF8sLFBv59zHaCq+oXVz3rWf0qCacNTIbuQ8+Z8pBRmaOz3+G0DK1E= f1omactep@DESKTOP-BMQBR92"
}

variable "yandex_folder_id" {
  default = "b1g3gts5dab90lp4q56g"
}

variable "ubuntu-22" {
  default = "fd8pecdhv50nec1qf9im"
}

variable "subnet-zones" {
  type    = list(string)
  default = ["ru-central1-a", "ru-central1-b", "ru-central1-c"]
}

variable "cidr" {
  type    = map(list(string))
  default = {
    stage = ["10.10.5.0/24", "10.10.6.0/24", "10.10.7.0/24"]
  }
}