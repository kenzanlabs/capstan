
resource "random_integer" "spin_bucket_prtb" {
  min     = 1
  max     = 99999
}

resource "random_integer" "spin_bucket_prta" {
  min     = 1
  max     = 99999
}


resource "aws_s3_bucket" "spin_bucket" {
  bucket = "spin-${var.gen_solution_name}-${random_integer.spin_bucket_prta.result}-${random_integer.spin_bucket_prtb.result}"
  acl    = "private"

  tags {
    Name        = "spin-${var.gen_solution_name}-${random_integer.spin_bucket_prta.result}-${random_integer.spin_bucket_prtb.result}"
    Environment = "${var.gen_project_name}"
  }
}