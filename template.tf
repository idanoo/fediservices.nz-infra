# Userdata
data "template_file" "userdata" {
  template = file("${path.module}/templates/userdata.tpl")

  vars = {
    data_root = "/data"
    volume    = aws_ebs_volume.ebs.id
  }
}
