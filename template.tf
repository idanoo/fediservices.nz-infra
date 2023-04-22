# Userdata
data "template_file" "userdata" {
  template = file("${path.module}/templates/userdata.tpl")

  vars = {
    region    = data.aws_region.current.name
    data_root = "/data"
    volume    = aws_ebs_volume.ebs.id
    domain    = var.domain
  }
}
