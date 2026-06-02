resource "aws_key_pair" "this" {
  key_name   = "${var.name}-key"
  public_key = file(var.key_path)
}

resource "aws_instance" "this" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  key_name               = aws_key_pair.this.key_name
  vpc_security_group_ids = [var.sg_id]
  tags = { Name = "${var.name}-ec2" }
}