resource "aws_instance" "machine01" {
  ami                         = "ami-007fae589fdf6e955" // "ami-2757f631"
  instance_type               = "t2.medium" # medium = 4Gb, small = 2Gb, micro = 1Gb, nano= 0.5Gb   
  associate_public_ip_address = true
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.sg_acme.id]

  root_block_device {
    volume_size = 20 #20 Gb
  }

  tags = {
    Name        = "${var.author}.alea_jess"
    Author      = var.author
    Date        = "2022.03.11"
    Environment = "LAB"
    Location    = "Paris"
    Project     = "acme"
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file(var.key_path)
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y docker httpd-tools",
      "sudo usermod -a -G docker ec2-user",
      "sudo curl -L https://github.com/docker/compose/releases/download/1.22.0-rc2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose",
      "sudo chmod +x /usr/local/bin/docker-compose",
      "sudo chkconfig docker on",
      "sudo service docker start",
      "sudo docker run --name portainer -d -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock portainer/portainer-ce",
      "mkdir /home/ec2-user/random-app",
   ]
  }

  provisioner "file" {
    source      = "docker-compose.yml"
    destination = "/home/ec2-user/docker-compose.yml"
  }

  provisioner "file" {
    source      = "random-app/"
    destination = "/home/ec2-user/random-app/"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo /usr/local/bin/docker-compose up -d",
      "free"
    ]
  }
}
