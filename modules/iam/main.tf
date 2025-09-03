data "aws_iam_policy_document" "assume_lambda" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }  
}

resource "aws_iam_role" "lambda_role" {
  name = var.role_name
  assume_role_policy = data.aws_iam_policy_document.assume_lambda.json
  tags = var.tags
}

data "aws_iam_policy_document" "lambda_policy" {
  statement {
    sid = "Logs"
    actions = ["logs:CreateLogGroup","logs:CreateLogStream","logs:PutLogEvents"]
    resources = ["*"]
  }

  statement {
    sid = "DynamoDBWrite"
    actions = ["dynamodb:PutItem","dynamodb:UpdateItem","dynamodb:DescribeTable"]
    resources = [var.dynamodb_table_arn]
  }  

  statement {
    sid = "S3ReadInput"
    actions = ["s3:GetObject"]
    resources = ["arn:aws:s3:::${var.input_bucket_name}/*"]
  }

  statement {
    sid = "RekognitionDetect"
    actions = ["rekognition:DetectModerationLabels","rekognition:DetectLabels"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "lambda_policy" {
  name = "${var.role_name}-policy"
  policy = data.aws_iam_policy_document.lambda_policy.json  
  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "attach" {
  role = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn  
}
