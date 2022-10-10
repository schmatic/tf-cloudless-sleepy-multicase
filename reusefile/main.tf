#TF12
variable "filename" {
  description = "Name of the file. Give inside tmp/.schematics"
  default     = "reusedfile.txt"
}

variable "shouldcontain" {
  description = "Apply will check if this string is there in filename"
}

variable "writecontent" {
  description = "Apply Writes this content to the filename"
}

locals{
  args = "${var.shouldcontain == "" && var.writecontent != "" ? "${var.writecontent} random write_only" : "${var.shouldcontain} ${var.writecontent}"}"
}

# Runs a shell script
resource "null_resource" "sleep" {
  triggers = {
    uuid = uuid()
  }

  provisioner "local-exec" {
    #Run this script - fail if exit is not 0
    command = "./reuse.sh /tmp/.schematics/${var.filename} ${local.args}"  
  }
}

