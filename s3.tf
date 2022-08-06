
locals {
  mime_types = {
    "css"  = "text/css"
    "html" = "text/html"
    "ico"  = "image/vnd.microsoft.icon"
    "js"   = "application/javascript"
    "json" = "application/json"
    "map"  = "application/json"
    "png"  = "image/png"
    "svg"  = "image/svg+xml"
    "txt"  = "text/plain"
  }
}

resource "aws_s3_bucket" "promo-logs" {
  bucket = "${var.cert_domain_name}.logs"
}

# data "template_file" "front_policy"{
#     template = file("${path.module}/templates/s3policy.json")
#     vars = {
#         domain_name = var.cert_domain_name
#     }
# }

resource "aws_s3_bucket" "s3_front_website_bucket" {
  bucket = var.cert_domain_name

  tags = {
    project = var.domain_name
  }
}

resource "aws_s3_bucket_policy" "website-pl-website-policy" {
  bucket = aws_s3_bucket.s3_front_website_bucket.id
  policy = data.aws_iam_policy_document.front_policy.json
}

resource "aws_s3_bucket_acl" "front_website_bucket_acl" {
  bucket = aws_s3_bucket.s3_front_website_bucket.id
  acl    = "private"
}


resource "aws_s3_bucket_versioning" "s3_front_website_bucket-ver" {
    bucket = aws_s3_bucket.s3_front_website_bucket.id
    versioning_configuration {
      status = "Suspended"
    }
}

resource "aws_s3_bucket_website_configuration" "website-promo-pl-website-conf" {
  bucket = aws_s3_bucket.s3_front_website_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }

  routing_rule {
    condition {
      key_prefix_equals = "docs/"
    }
    redirect {
      replace_key_prefix_with = "documents/"
    }
  }
}

resource "aws_s3_object" "promo-website-pl-website" {
  for_each = fileset("./app/src", "**")
  acl = "private"
  bucket = aws_s3_bucket.s3_front_website_bucket.id
  key = each.key
  source = "${path.module}/app/src/${each.key}"
  # set content type for each file according to our mime_types local
  content_type = lookup(tomap(local.mime_types), element(split(".", each.key), length(split(".", each.key)) - 1))
  etag = filemd5("${path.module}/app/src/${each.key}")
}
