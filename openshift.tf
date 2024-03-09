# Auther : Zubair Khan
# Version : 0.1
provider "aws" {
  region = "ap-south-1" # Change to your desired region
#  profile = "default"
#  shared_config_files      = ["/root/.aws/credentials"]
#  shared_credentials_files = ["/root/.aws/credentials"]
  access_key = "AKIA2ZWWRILZNLB4YZT6"
  secret_key = "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"
}
#1- Create VPC
resource "aws_vpc" "openshift-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "openshift-vpc"
  } 
}

#2- Create public subnets
resource "aws_subnet" "openshift-sub" {
  vpc_id        = aws_vpc.openshift-vpc.id
  cidr_block    = "10.0.0.0/16"
  availability_zone = "ap-south-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "openshift-subnet"
    
    
  }
}


#3- Create Internet Gateway
resource "aws_internet_gateway" "openshift_igw" {
  vpc_id = aws_vpc.openshift-vpc.id
  tags = {
    Name = "openshift-IGW"
  } 
}

#4- Create public route table
resource "aws_route_table" "openshift_route_table" {
  vpc_id = aws_vpc.openshift-vpc.id
  tags = {
    Name = "openshift-pub-RT"
  } 
}
# add routes in route table
resource "aws_route" "my_route" {
  route_table_id         = aws_route_table.openshift_route_table.id
  destination_cidr_block = "0.0.0.0/0"  # Default route
  gateway_id             = aws_internet_gateway.openshift_igw.id
}


# Associate public subnets with public route table
resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.openshift-sub.id
  route_table_id = aws_route_table.openshift_route_table.id

}
################### Security Group ###################
resource "aws_security_group" "openshift-sg" {
  name        = "openshift-sg"
  description = "Allow traffic from all"
  vpc_id      = aws_vpc.openshift-vpc.id
  depends_on = [
    aws_vpc.openshift-vpc
  ]

  ingress {
    from_port   = "0"
    to_port     = "65535"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
    
   egress {
    from_port = "0"
    to_port   = "65535"
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "openshift-ssecurity-group"
  }
}

################### create Key pair ###################
# RSA key of size 4096 bits
resource "tls_private_key" "rsa-4096" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "aws_key_pair" "aws_key_pair" {
  key_name   = "aws_key_pair"
  public_key = tls_private_key.rsa-4096.public_key_openssh
}

resource "local_file" "private_key" {
  content = tls_private_key.rsa-4096.private_key_pem
  filename = "key_pair.pem"
}
################### Create resources in public subnet ###################
resource "aws_instance" "public_instance" {
  ami           = "ami-0b6ef6629d4230b38"  # Replace with your desired AMI ID
  instance_type = "m6a.xlarge"
  subnet_id     = aws_subnet.openshift-sub.id
  vpc_security_group_ids = [aws_security_group.openshift-sg.id]
  key_name      = "aws_key_pair"
  depends_on = [aws_key_pair.aws_key_pair]
  source_dest_check = false
  tags = {
    Name = "openshift-master-instance"
    backup = "Yes"
    group = "web"
  }
}
resource "aws_route53_zone" "example_zone" {
  name = "sandbox2.acme2.com"
  comment = "Example hosted zone"
  tags = {
    Environment = "Production"
  }
}
 

