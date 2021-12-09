
data digitalocean_ssh_key mykey {
    name = "mykey"
}
resource "digitalocean_droplet" "myserver" {
  image  = var.DO_image //"ubuntu-20-04-x64"
  name   = "myserver"
  region = var.DO_region //"sgp1"
  size   = var.DO_size //"s-1vcpu-1gb"
  ssh_keys = [
      data.digitalocean_ssh_key.mykey.fingerprint
  ]
  //povision connection object
  connection {
      type = "ssh"
      user = "root"
      private_key = file("../../mykey")
      host = self.ipv4_address
  }
}
resource local_file inventory-yaml {
    filename = "inventory.yaml"
    file_permission = 0644
    content = templatefile("inventory.yaml.tpl", {
        host_name = digitalocean_droplet.myserver.name
        host_ip = digitalocean_droplet.myserver.ipv4_address
        private_key = "${var.private_key}"
        public_key = "${var.public_key}"
    })
}

output mykey-fingerprint {
    value = data.digitalocean_ssh_key.mykey.fingerprint
}

