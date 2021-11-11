resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = false
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.latest
  //count = 2
  name  = "nginx-server"
  ports {
    internal = 80
    external = "8080"
  }
  volumes {
    container_path = "/usr/share/nginx/html"
    host_path      = "/tmp/tutorial/www"
    read_only      = true
  }
}

# output "aws-nginx-ip" {
#   value = aws_instance.webservers.public_ip
# }

resource "aws_instance" "webservers" {
	count = 2 
	ami = var.webservers_ami
	instance_type = "${var.instance_type}"
	security_groups = ["${aws_security_group.webservers.id}"]
	subnet_id = "${aws_subnet.private-subnet-1.id}"
	user_data = file("install_httpd.sh")
}
