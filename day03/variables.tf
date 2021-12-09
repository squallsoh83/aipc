variable DO_token { 
    type = string
    sensitive = true
    #default = "9a243966ab54bf759ad3f50e9dae682f36ad860fc2a545ae49f2ab8a56df92e7"
}

variable DO_image {
  type = string
  default = "ubuntu-20-04-x64"
}

variable DO_size {
  type = string 
  default = "s-1vcpu-1gb"
}

variable DO_region {
  type = string 
  default = "sgp1"
}

variable private_key {
    type = string
    #default = "../../mykey"
}
