
# Configure the DigitalOcean Provider
provider "digitalocean" {}

data "digitalocean_image" "packer-test" {
  name = "packer-demo"
}

resource "digitalocean_droplet" "packer-test" {
  image  = "${data.digitalocean_image.packer-test.image}"
  name   = "nginx-server"
  region = "fra1"
  size   = "s-1vcpu-1gb"
}

#resource "digitalocean_domain" "default" {
#  name       = "www.packer-test.com"
#  ip_address = "${digitalocean_droplet.packer-test.ipv4_address}"
#}
