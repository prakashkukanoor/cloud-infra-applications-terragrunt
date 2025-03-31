[
    {
    Version = "2012-10-17",
    Statement = [
      # Allow access from a specific VPC Gateway Endpoint
      {
        Effect = "Allow"
        Principal = "*"
        Action = "s3:*"
        Resource = [
          "arn:aws:s3:::${bucket_id}",
          "arn:aws:s3:::${bucket_id}/*"
        ]
        Condition = {
          StringEquals = {
            "aws:SourceVpce" = "vpce-xxxxxxxxxxxxxxxxx" # Replace with your Gateway Endpoint ID
          }
        }
      },
      # Deny any request that does not use HTTPS (enforces TLS)
      {
        Effect = "Deny"
        Principal = "*"
        Action = "s3:*"
        Resource = [
          "arn:aws:s3:::${bucket_id}",
          "arn:aws:s3:::${bucket_id}/*"
        ]
        Condition = {
          Bool = {
            "aws:SecureTransport" = "false"
          }
        }
      }
    ]
  }
]