variable "regions" {
    default = "us-east-1"
}

variable "isntance_type" {
    default = "t2.micro"
}

variable "instance_ami" {
    default = "ami-020db2c14939a8efb"
    #default = "ami-01ac7d9c1179d7b74"
}

variable "vpc_id" {
    default = "vpc-0973bc7fa525e00bb"
}

variable "subnet_id_1" {
    default = "subnet-082a7e18d90f2782d"
}

variable "subnet_id_2" {
    default = "subnet-08c37abb518e661ee"
}
