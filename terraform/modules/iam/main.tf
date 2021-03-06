resource "aws_iam_role" "banshee-44-mods-bot" {
  name               = "banshee-44-mods-bot"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": {
    "Action": "sts:AssumeRole",
    "Principal": {
        "Service": [
          "lambda.amazonaws.com"
        ]
      },
    "Effect": "Allow"
  }
}
POLICY
}

resource "aws_iam_policy" "banshee-44-mods-bot-logs" {
  name        = "banshee-44-mods-bot-logs"
  description = "Adds logging access"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach-logs" {
  role       = aws_iam_role.banshee-44-mods-bot.name
  policy_arn = aws_iam_policy.banshee-44-mods-bot-logs.arn
}

resource "aws_iam_policy" "banshee-44-mods-bot-sns" {
  name        = "banshee-44-mods-bot-sns"
  description = "Adds sns access"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sns:Publish",
      "Resource": "${var.error-sns-topic}"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach-sns" {
  role       = aws_iam_role.banshee-44-mods-bot.name
  policy_arn = aws_iam_policy.banshee-44-mods-bot-sns.arn
}

resource "aws_iam_policy" "banshee-44-mods-bot-parameter-store" {
  name        = "banshee-44-mods-bot-parameter-store"
  description = "Adds Parameter Store access"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "ssm:GetParametersByPath",
      "Resource": [
        "${var.parameter-store-twitter-auth-arn}"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach-parameter-store" {
  role       = aws_iam_role.banshee-44-mods-bot.name
  policy_arn = aws_iam_policy.banshee-44-mods-bot-parameter-store.arn
}

output "aws-iam-role-banshee-44-mods-bot-arn" {
  value = aws_iam_role.banshee-44-mods-bot.arn
}
