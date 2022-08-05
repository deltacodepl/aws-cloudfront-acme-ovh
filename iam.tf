# data source to generate bucket policy to let OAI get objects:
data "aws_iam_policy_document" "front_policy" {
  statement {
    actions = ["s3:GetObject"]

    resources = [
      aws_s3_bucket.s3_front_website_bucket.arn,
      "${aws_s3_bucket.s3_front_website_bucket.arn}/*"
    ]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn]
    }
  }
}