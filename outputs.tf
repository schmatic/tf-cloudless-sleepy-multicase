output "tokens" {
  value = data.ibm_iam_auth_token.tokendata.id
}

output "iamtoken_length" {
  value = length(data.ibm_iam_auth_token.tokendata.iam_access_token)
}
