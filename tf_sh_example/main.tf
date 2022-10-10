# Runs a shell script

resource "null_resource" "sleep" {
  triggers = {
    uuid = uuid()
  }

  provisioner "local-exec" {
    command = "./sleep.sh"
  }
 }
