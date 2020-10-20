resource "aws_ecr_repository" "repo" {
    name = "${local.prefix}-registry"
    image_tag_mutability = "MUTABLE"
}