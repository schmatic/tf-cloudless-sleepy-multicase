resource "null_resource" "ifconfig" {
  provisioner "local-exec" {
    command = "curl ifconfig.me >> myip.log"
  }
}
resource "null_resource" "cat" {
  provisioner "local-exec" {
    command = "cat myip.log"
  }
  depends_on = [null_resource.ifconfig]
}
