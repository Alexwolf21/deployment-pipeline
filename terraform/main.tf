terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {}

# Declare a Docker network
resource "docker_network" "my_network" {
  name = "my_network"
}

# Declare a Docker image for Nginx
resource "docker_image" "nginx_image" {
  name         = "nginx:latest"
  keep_locally = false
}

# Run an Nginx container attached to the network
resource "docker_container" "nginx_container" {
  name  = "nginx_server"
  image = docker_image.nginx_image.name

  # Attach to the network so that it can reach the sample-app container
  networks_advanced {
    name = docker_network.my_network.name
  }

  # Map container port 80 to host port 88
  ports {
    internal = 80
    external = 88
  }

  # Mount our custom Nginx configuration(Specify the path to nginx.conf file on the system in host_path)
  volumes {
    host_path      = "/Users/I529008/Desktop/terraform/nginx.conf"
    container_path = "/etc/nginx/nginx.conf"
  }
}
