resource "aws_s3_bucket" "lambda-artifact-storage" {
    bucket = "systemiphus-lambda-artifact-storage"
 
    versioning {
      enabled = true
    }
 
    lifecycle {
      prevent_destroy = false
    }
 
    tags = {
      Name = "S3 Lambda Artifact Store"
    }      
}

output "lambda-artifact-storage" {
    value = "${aws_s3_bucket.lambda-artifact-storage.arn}"
}