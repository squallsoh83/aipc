terraform {
    required_version = ">1.0.0"
    required_providers {
        digitalocean = {
          source = "digitalocean/digitalocean"
          version = "2.16.0"
        }
        docker = {
            source  = "kreuzwerker/docker"
            version = "2.15.0"
        }
        cloudflare = {
          source = "cloudflare/cloudflare"
          version = "3.4.0"
        }
        local = {
            source = "hashicorp/local"
            version = "2.1.0"
        }
  }
}

provider "digitalocean" {
    token = var.DO_token
}

provider "docker" {
    host = "unix:///var/run/docker.sock"
}
provider "cloudflare" {
  email = var.CF_email
  api_token = var.CF_api_token
}


/*
terraform {
  //terraform version
  required_version = ">1.0.0"
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "2.16.0"
    }
    docker = {
      source = "kreuzwerker/docker"
      version = "2.15.0"
    }
    local = {
        source = "hashicorp/local"
        version = "2.1.0"
    }
  }
}

# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = var.DO_token
}

provider "docker" {
  # Configuration options
  host="unix:///var/run/docker.sock"
}

/*terraform {
  //terraform version
  required_version = ">1.0.0"
  //one or more providers  
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "2.15.0"
    }
    local = {
        source = "hashicorp/local"
        version = "2.1.0"
    }
  }
}

//configure the provider - specific to the provider
provider "docker" {
  # Configuration options
  host="unix:///var/run/docker.sock"
}

provider "local" {}*/