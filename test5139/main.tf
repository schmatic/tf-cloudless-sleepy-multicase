
terraform {
  required_providers {
    ibm = {
      source = "IBM-Cloud/ibm"
      version = "1.37.0"
    }
  }
}
data "ibm_database" "cluster" {
  name = "Error: Get \"http://localhost/api/v1/namespaces/vedoc-core-cicd\": dial tcp [::1]:80: connect: connection refused"
}
