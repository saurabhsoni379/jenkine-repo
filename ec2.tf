resource "aws_key_pair" "ss_key" {
  key_name = "jenkins-key-1"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEvr/v/PlFRzwoMIc2wP5CZAZQU7L+3H6bt1iVA+BluR mac@Macs-MacBook-Pro.local"
}

resource "aws_instance" "ec2-server" {
  ami = "ami-04a81a99f5ec58529"
  instance_type = "t2.micro"
  subnet_id = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  tags = {
    Name = "jenkins-server"
  }
  key_name = aws_key_pair.ss_key.key_name
  vpc_security_group_ids = [aws_security_group.sg.id]

}
