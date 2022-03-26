#Creating security group to allow ssh and jenkins
resource "aws_security_group" "allow_ssh_jenkins" {
  name        = "instance_sg_airbus"
  description = "Allow all jenkins and ssh inbound traffic for security group"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
   egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

}

resource "aws_security_group_rule" "allow_ssh_jenkins" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.allow_ssh_jenkins.id
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "airbus-instance1"

  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  monitoring             = false
  vpc_security_group_ids = [aws_security_group.allow_ssh_jenkins.id]
  subnet_id              = var.subnet_id

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
