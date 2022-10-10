#TF12
variable "filename" {
  type = string
  description = "Name of the file. Give inside tmp/.schematics"
  default     = "repeatfile"
}

variable "numb" {
  default = 1000
  type = number
  description = "Prints this to log this many times. Takes this many seconds"
}

variable "writecontent" {
  default = "Writing into this file for %dth time. This is just to fill up the log"
  type = string
  description = "Apply Writes this content to the filename"
}

# Runs a shell script
resource "null_resource" "repeated" {
  count = floor(var.numb / 3)
  triggers = {
    uuid = uuid()
  }

  provisioner "local-exec" {
    command = "./largefile.sh /tmp/.schematics/${var.filename}_repeat \"${var.writecontent}\" ${count.index}"  
  }
}


# Runs a shell script
resource "null_resource" "loopy" {
  triggers = {
    uuid = uuid()
  }

  provisioner "local-exec" {
    command = "./largefile.sh /tmp/.schematics/${var.filename} \"${var.writecontent}\" ${var.numb} yes"  
  }
}

