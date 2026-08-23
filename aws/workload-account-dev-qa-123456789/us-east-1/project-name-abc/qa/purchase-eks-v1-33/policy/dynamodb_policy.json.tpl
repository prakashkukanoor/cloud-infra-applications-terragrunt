{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DynamoDBCrudAccess",
      "Principal": {
        "AWS": [
          "${arn}"
        ]},
      "Effect": "Allow",
      "Action": [
        "dynamodb:PutItem",
        "dynamodb:GetItem",
        "dynamodb:Query",
        "dynamodb:Scan",
        "dynamodb:UpdateItem",
        "dynamodb:DeleteItem"
      ],
      "Resource": "arn:aws:dynamodb:*:*:table/${name}"
    },
    {
        "Effect": "Deny",
        "Principal": "*",
        "Action": "*",
        "Resource": "arn:aws:dynamodb:*:*:table/${name}",
        "Condition": {
          "Bool": {
            "aws:SecureTransport": "false"
          }
        }
      }
  ]
}
