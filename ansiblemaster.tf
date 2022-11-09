resource "aws_instance" "web01" {
  ami                    = var.ami-var
  instance_type          = var.instance_type-var
  key_name               = aws_key_pair.ec2loginkey.key_name
  user_data              = file("ansibleMaster.sh")
  vpc_security_group_ids = [aws_security_group.sg.id]


  provisioner "remote-exec" {
    inline = [
      "echo '[ansible]' >> /home/ec2-user/inventory",
      "echo 'ansible-engine ansible_host=${aws_instance.web01.private_dns} ansible_connection=local' >> /home/ec2-user/inventory",
      "echo '[nodes]' >> /home/ec2-user/inventory",
      "echo 'ansible-nodes-1 ansible_host=${aws_instance.web02.private_dns} ansible_connection=local' >> /home/ec2-user/inventory",
      "echo '' >> /home/ec2-user/inventory",
      "echo '[all:vars]' >> /home/ec2-user/inventory",
      "echo 'ansible_user=ansadmin' >> /home/ec2-user/inventory",
      "echo 'ansible_password=ansadmin' >> /home/ec2-user/inventory",
      "echo 'ansible_connection=ssh' >> /home/ec2-user/inventory",
      "echo '#ansible_python_interpreter=/usr/bin/python3' >> /home/ec2-user/inventory",
      "echo 'ansible_ssh_private_key_file=/home/ansadmin/.ssh/id_rsa' >> /home/ec2-user/inventory",
      "echo \"ansible_ssh_extra_args=' -o StrictHostKeyChecking=no -o PreferredAuthentications=password '\" >> /home/ec2-user/inventory",
      "echo '[defaults]' >> /home/ec2-user/ansible.cfg",
      "echo 'inventory = ./inventory' >> /home/ec2-user/ansible.cfg",
      "echo 'host_key_checking = False' >> /home/ec2-user/ansible.cfg",
      "echo 'remote_user = ansadmin' >> /home/ec2-user/ansible.cfg",
    ]
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("C:/Users/ASUS PRO/devops project/anskp.pem")
      host        = self.public_ip
    }
  }


  provisioner "file" {
    source      = "config.yaml"
    destination = "/home/ec2-user/engine-config.yaml"
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("C:/Users/ASUS PRO/devops project/anskp.pem")
      host        = self.public_ip
    }
  }


  provisioner "remote-exec" {
    inline = [
      "sleep 120; ansible-playbook config.yaml"
    ]
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("C:/Users/ASUS PRO/devops project/anskp.pem")
      host        = self.public_ip
    }
  }

  tags = {
    Name = "ansible-master"
  }
}
