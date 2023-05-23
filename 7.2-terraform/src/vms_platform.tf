  ### ---- vm_web ----

  variable "vm_web_name" {
  type    = string
  default = "netology-develop-platform-web"
  description = "Instance name"
  }

 variable "vm_web_platform_id" {
 type    = string
 default = "standard-v1"
 description = "Instance platform ID"
  }

 variable "vm_web_cores" {
 type    = string
 default = "2"
 description = "Cores"
  }

 variable "vm_web_memory" {
 type    = string
 default = "1"
 description = "Memory size"
 }

 variable "vm_web_core_fraction" {
 type    = string
 default = "5"
 description = "Core fraction"
  }


 ### ---- vm_db ----

variable "vm_db_name" {
type    = string
default = "netology-develop-platform-db"
description = "Instance name"
 }

variable "vm_db_platform_id" {
type    = string
default = "standard-v1"
description = "Instance platform ID"
 }

variable "vm_db_cores" {
type    = string
default = "2"
description = "Cores"
 }

variable "vm_db_memory" {
type    = string
default = "2"
description = "Memory size"
 }

variable "vm_db_core_fraction" {
type    = string
default = "20"
description = "Core fraction"
}