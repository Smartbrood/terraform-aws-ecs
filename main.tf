resource "aws_ecs_cluster" "this" {
    name = "${var.cluster_name}"
}

data "template_file" "user_data_public" {
  template = "${file("${path.module}/templates/user_data.sh.tpl")}"

  vars {
    cluster_name = "${var.cluster_name}"
    efs_volume   = "${var.efs_volume}"
    efs_dir      = "${var.efs_dir}"
    frontend     = "true"
    application  = "true"
    database     = "true"
    spot         = "false"    
  }
}

module "ecs_ami" {
    source = "Smartbrood/data-ami/aws"
    distribution = "ecs"
}

module "ec2_iam_role" {
   source = "Smartbrood/ec2-iam-role/aws"
   name        = "terraform-ecs-${var.pet_name}"
   path        = "/"
   description = "This IAM Role generated by Terraform."
   force_detach_policies = false

   policy_arn = [
        "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role",
   ]
}

module "ecs_public_a" {
    source = "Smartbrood/ec2-instance/aws"
    name                 = "ecs_public_a"
    count                = "${var.count_public_a}" 
    instance_type        = "${var.instance_type}"
    key_name             = "${var.key_name}"
    subnet_id            = "${var.subnet_public_zone_a}"

    ami                  = "${module.ecs_ami.ami_id}"
    iam_instance_profile = "${module.ec2_iam_role.profile_name}"
    vpc_security_group_ids      = ["${var.security_group}"]

    associate_public_ip_address = true
    monitoring                  = false

    root_block_device      = [{ delete_on_termination = false }]
    ebs_block_device       = [{ delete_on_termination = false 
                                device_name = "/dev/xvdcz"
                              }]

    user_data            = "${data.template_file.user_data_public.rendered}"

    tags = "${var.tags}"
}

module "ecs_public_b" {
    source = "Smartbrood/ec2-instance/aws"
    name                 = "ecs_public_b"
    count                = "${var.count_public_b}" 
    instance_type        = "${var.instance_type}"
    key_name             = "${var.key_name}"
    subnet_id            = "${var.subnet_public_zone_b}"

    ami                  = "${module.ecs_ami.ami_id}"
    iam_instance_profile = "${module.ec2_iam_role.profile_name}"
    vpc_security_group_ids      = ["${var.security_group}"]

    associate_public_ip_address = true
    monitoring                  = false

    root_block_device      = [{ delete_on_termination = false }]
    ebs_block_device       = [{ delete_on_termination = false 
                                device_name = "/dev/xvdcz"
                              }]

    user_data            = "${data.template_file.user_data_public.rendered}"

    tags = "${var.tags}"
}

module "ecs_public_c" {
    source = "Smartbrood/ec2-instance/aws"
    name                 = "ecs_public_c"
    count                = "${var.count_public_c}" 
    instance_type        = "${var.instance_type}"
    key_name             = "${var.key_name}"
    subnet_id            = "${var.subnet_public_zone_c}"

    ami                  = "${module.ecs_ami.ami_id}"
    iam_instance_profile = "${module.ec2_iam_role.profile_name}"
    vpc_security_group_ids      = ["${var.security_group}"]

    associate_public_ip_address = true
    monitoring                  = false

    root_block_device      = [{ delete_on_termination = false }]
    ebs_block_device       = [{ delete_on_termination = false 
                                device_name = "/dev/xvdcz"
                              }]

    user_data            = "${data.template_file.user_data_public.rendered}"

    tags = "${var.tags}"
}


data "null_data_source" "values" {
  inputs = {
    zone_a_public_ip  = "${join(",", module.ecs_public_a.public_ip)}"
    zone_b_public_ip  = "${join(",", module.ecs_public_b.public_ip)}"
    zone_c_public_ip  = "${join(",", module.ecs_public_c.public_ip)}"
  }
}
