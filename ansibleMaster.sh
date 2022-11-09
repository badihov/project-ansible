#!/bib/bash
sudo su --
yum update -y
yum install git -y
yum install vim
yum install python
yum install python3
yum install python-pip -y
pip install ansible
useradd ansadmin
passwd ansadmin
echo "ansadmin ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config
systemctl restart sshd.service

