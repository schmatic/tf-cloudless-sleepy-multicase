variable "ibmcloud_api_key" {
  
}

data "ibm_resource_group" "resource_group" {
  name = "pte-interns"
}
resource "ibm_is_vpc" "vpc" {
  name           = "timeout"
  resource_group = data.ibm_resource_group.resource_group.id
}
resource "ibm_is_subnet" "subnet" {
  name                     = "timeout"
  vpc                      = ibm_is_vpc.vpc.id
  zone                     = "us-south-1"
  total_ipv4_address_count = 256
  resource_group           = data.ibm_resource_group.resource_group.id
}
resource "ibm_is_subnet" "subnet2" {
  name                     = "timeout2"
  vpc                      = ibm_is_vpc.vpc.id
  zone                     = "us-south-2"
  total_ipv4_address_count = 256
  resource_group           = data.ibm_resource_group.resource_group.id
}

resource "ibm_container_vpc_cluster" "cluster" {
  name              = "timeout1"
  vpc_id            = ibm_is_vpc.vpc.id
  flavor            = "cx2.2x4"
  worker_count      = 3
  resource_group_id = data.ibm_resource_group.resource_group.id
  zones {
    subnet_id = ibm_is_subnet.subnet.id
    name      = "us-south-1"
  }
  zones {
    subnet_id = ibm_is_subnet.subnet2.id
    name      = "us-south-2"
  }
}
resource "ibm_container_vpc_cluster" "cluster2" {
  depends_on = [
    ibm_container_vpc_cluster.cluster
  ]
  name              = "timeout2"
  vpc_id            = ibm_is_vpc.vpc.id
  flavor            = "cx2.2x4"
  worker_count      = 3
  resource_group_id = data.ibm_resource_group.resource_group.id
  zones {
    subnet_id = ibm_is_subnet.subnet.id
    name      = "us-south-1"
  }
  zones {
    subnet_id = ibm_is_subnet.subnet2.id
    name      = "us-south-2"
  }
}
resource "ibm_container_vpc_cluster" "cluster3" {
  depends_on = [
    ibm_container_vpc_cluster.cluster2
  ]
  name              = "timeout3"
  vpc_id            = ibm_is_vpc.vpc.id
  flavor            = "cx2.2x4"
  worker_count      = 3
  resource_group_id = data.ibm_resource_group.resource_group.id
  zones {
    subnet_id = ibm_is_subnet.subnet.id
    name      = "us-south-1"
  }
  zones {
    subnet_id = ibm_is_subnet.subnet2.id
    name      = "us-south-2"
  }
}



provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key
}
terraform {
  required_providers {
    ibm = {
      source = "IBM-Cloud/ibm"
    }
  }
}
