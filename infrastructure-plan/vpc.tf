resource "aws_vpc" "acuity" {
    tags = {
        "acuity:environment" = "Foo"
    }
}