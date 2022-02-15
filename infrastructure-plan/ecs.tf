module "ecs_cluster" {
    tags = {
        enviroment = "Foo"
    }
}

resource "aws_security_group_rule" "allow_inbound_http_from_anywhere" {
  type = "ingress"
  from_port = 8080
  to_port = 8080
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${module.ecs_cluster.ecs_instance_security_group_id}"
}