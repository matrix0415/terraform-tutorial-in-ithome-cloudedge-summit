output "id" {
  value = aws_instance.instance.id
}

output "ip" {
  value = aws_instance.instance.public_ip
}