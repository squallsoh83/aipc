data digitalocean_ssh_key mykey {
    name = "mykey"
}

// Docker
data docker_image dov-image {
    name = var.app_image
}

resource docker_container dov-container {
    count = var.app_count
    name = "dov-${count.index}"
    image = data.docker_image.dov-image.id
    ports {
        internal = 3000
    }
    env = [ "INSTANCE_NAME=dov-${count.index}" ]
}

resource local_file nginx-conf {
    filename = "nginx.conf"
    file_permission = 0644
    content = templatefile("nginx.conf.tpl", {
        docker_host = var.docker_host
        ports = flatten(docker_container.dov-container[*].ports[*].external)
    })
}

// Server - Nginx
resource digitalocean_droplet my-droplet {
    name = "my-droplet"
    image = var.DO_image
    size = var.DO_size
    region = var.DO_region
    ssh_keys = [ data.digitalocean_ssh_key.mykey.fingerprint ]

    // provisioner connection object
    connection {
        type = "ssh"
        user = "root"
        private_key = var.private_key
        host = self.ipv4_address
    }

    provisioner remote-exec {
        inline = [
            "apt update -y",
            "apt upgrade -y",
            "apt install nginx -y",
            "systemctl enable nginx",
            "systemctl start nginx",
        ]
    }

    provisioner file {
        source = local_file.nginx-conf.filename
        destination = "/etc/nginx/nginx.conf"
    }

    provisioner remote-exec {
        inline = [
            "nginx -s reload"
        ]
    }
}

resource local_file "at_ipv4" {
    filename = "@${digitalocean_droplet.my-droplet.ipv4_address}"
    content = "${data.digitalocean_ssh_key.mykey.fingerprint}\n"
    file_permission = "0644"
}

resource local_file droplet_info {
    filename = "info.txt"
    content = templatefile("info.txt.tpl", {
        ipv4 = digitalocean_droplet.my-droplet.ipv4_address
        fingerprint = data.digitalocean_ssh_key.mykey.fingerprint
    })
    file_permission = "0644"
}

// Cloudflare
data cloudflare_zone myzone {
    name = var.CF_zone
}

resource cloudflare_record a-dov {
    zone_id = data.cloudflare_zone.myzone.zone_id
    name = "dov"
    type = "A"
    value = digitalocean_droplet.my-droplet.ipv4_address
    proxied = true
}

output ipv4 {
    value = digitalocean_droplet.my-droplet.ipv4_address
}

output mykey-fingerprint {
    value = data.digitalocean_ssh_key.mykey.fingerprint
}

output app-ports {
    value = flatten(docker_container.dov-container[*].ports[*].external)
}



/*

# Create a new Web Droplet in the singapoe region
//Server section
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
      private_key = file("../../mykey")
      host = self.ipv4_address
  }
data docker_image dov-image {
      name = var.app_image
  }

  resource docker-container dov-container {
      count = var.app_count
      name = "dov=${count.index}"
      image = data.docker_image.dov-image.id
      ports {
        internal = 3000
      }
      env = [ "INSTANCE_NAME=dov-${count.index}"]
  }

  resource local_file nginx-conf {
      filename = "nginx.conf"
      file_permission = 0644
      content = templatefile("nginx.conf.tpl",{
          docker_host = var.docker_host
          ports = flatten(docker_container.dov-container[*].ports[*].external)
      })
  }

  provisioner remote-exec {
      inline = [
        "apt update -y",
        "apt upgrade -y",
        "apt install nginx -y",
        "systemctl enable nginx",
        "systemctl start nginx"
      ]
  }

  provisioner file {
    source = local_file.nginx-conf.filename
    destination = "etc/nginx/nginx.conf"
    }

  provisioner remote-exec {
      inline = [
        "nginx -s reload"
      ]
  }
}



resource local_file "at_ipv4"{
    filename = "@${digitalocean_droplet.web.ipv4_address}"
    file_permission = "0644"
    content = "${data.digitalocean_ssh_key.mykey.fingerprint}\n"
}

output IPv4{
    value = digitalocean_droplet.web.ipv4_address
 
}

resource local_file droplet_info{
    filename =  "info.txt"
    file_permission = "0644"
    content = templatefile("info.txt.tpl",{
        ipv4 = digitalocean_droplet.web.ipv4_address
        fingerprint = data.digitalocean_ssh_key.mykey.fingerprint
    })
}

data digitalocean_ssh_key mykey {
    name = "mykey"
}

output mykey-fingerprint {
    value = data.digitalocean_ssh_key.mykey.fingerprint
}

output app-ports{
    value = flatten(docker_container.dov-container[*].ports[*].external)
}
/*
//docker run -d -p 8080:3000 --name app0 stackupiss/dov-bear:v2
resource docker_image container-image {
    count = length(var.containers)
    name = var.containers[count.index].imageName
    keep_locally = var.containers[count.index].keepImage


    //name = "stackupiss/dov-bear:${var.tagversion}"
    //keep_locally = var.keep_image //true
}


resource docker_container cointainer-app {
    count = length(var.containers)
    image = docker_image.container-image[count.index].latest
    name = var.containers[count.index].containerName
    ports {
        internal = var.containers[count.index].containerPort
        //external = var.containers[count.index].externalPort
    }
    env = var.containers[count.index].envVariables
}

output externalPorts{
    value = flatten(docker_container.cointainer-app[*].ports[*].external)
    sensitive = true
}*/

