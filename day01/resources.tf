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
}

/*
output port0{
    value = docker_container.cointainer-app[0].ports[0].external
}

output port1{
    value = docker_container.cointainer-app[1].ports[0].external
}*/
/*
resource docker_container dov-app {
    name = var.name
    image = docker_image.dov-bear.latest
    ports {
        internal = 3000
        external = 8080
    }
    env = [
        "INSTANCE_NAME=dov-app",
        "INSTANCE_HASH=abc123"
    ]
}*/


//docker run -d -p 8081:3000 --name app1 stackupiss/fortune:v2
/*
resource docker_image fortune {
    name = "stackupiss/fortune:v2"
    keep_locally = true
}

resource docker_container fortune-app {
    name = "app1"
    image = docker_image.fortune.latest
    ports {
        internal = 3000
        external = 8081
    }
}*/