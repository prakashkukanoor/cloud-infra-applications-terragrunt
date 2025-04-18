{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "arn:aws:iam::905418359995:user/cloud_user"
        ]},
      "Action": [
        "s3:GetObject",
        "s3:DeleteObject"
      ],
      "Resource": [
        "arn:aws:s3:::${bucket}/*"
      ]
    },
    {
        "Effect": "Deny",
        "Principal": "*",
        "Action": "*",
        "Resource": [
          "arn:aws:s3:::${bucket}",
          "arn:aws:s3:::${bucket}/*"
        ],
        "Condition": {
          "Bool": {
            "aws:SecureTransport": "false"
          }
        }
      }
  ]
}
