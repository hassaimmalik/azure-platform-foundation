output "vm_username" {
  value = var.admin_username
}

# IMPORTANT: this will print private key; fine for sandbox, NOT for prod.
output "ssh_private_key_pem" {
  value     = tls_private_key.ssh.private_key_pem
  sensitive = true
}
