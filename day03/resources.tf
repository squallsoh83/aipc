resource "digitalocean_droplet" "web" {
  image  = var.DO_image //"ubuntu-20-04-x64"
  name   = "web-1"
  region = var.DO_region //"sgp1"
  size   = var.DO_size //"s-1vcpu-1gb"
  ssh_keys = [
      //fill this part in
      data.digitalocean_ssh_key.mykey.fingerprint
  ]
  //povision connection object
  connection {
      type = "ssh"
      user = "root"
      private_key = file(var.private_key)
      host = self.ipv4_address
  }
}
data digitalocean_ssh_key mykey {
    name = "mykey"
}
