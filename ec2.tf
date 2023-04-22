
# # Instance
# resource "aws_instance" "instance" {
#   ami           = data.aws_ami.ubuntu.id
#   instance_type = "t4g.micro"
#   iam_instance_profile = aws_iam_instance_profile.profile.name
#   availability_zone = element(aws_subnet.subnet.*.availability_zone, 1)
#   user_data = data.template_file.userdata.rendered
#   subnet_id = element(aws_subnet.subnet.*.id, 1)
#   key_name = var.ssh_key
#   vpc_security_group_ids = [aws_security_group.sg.id]
# }

# # Elastic IP
# resource "aws_eip" "eip" {
#   instance = aws_instance.instance.id
#   vpc      = true

#   tags = var.tags
# }


# # Create a new load balancer attachment
# resource "aws_elb_attachment" "attachment" {
#   elb      = aws_elb.lb.id
#   instance = aws_instance.instance.id
# }

# # EBS Vol for persistance
# resource "aws_ebs_volume" "instance" {
#   availability_zone = element(aws_subnet.subnet.*.availability_zone, 1)
#   size              = "8"
#   type              = "gp2"
#   encrypted         = true
# }