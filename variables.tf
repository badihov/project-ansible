variable "ami-var" {
  description = "instance ami"
  type        = string
  default     = "ami-09d3b3274b6c5d4aa"

}
variable "instance_type-var" {
  description = "instance type"
  type        = string
  default     = "t2.micro"

}


variable "ssh_key_pair" {
  default = "~/.ssh/id_rsa"
}

variable "ssh_key_pair_pub" {
  default = "~/.ssh/id_rsa.pub"
}
