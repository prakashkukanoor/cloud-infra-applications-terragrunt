{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "${arn}"
        ]},
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
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
