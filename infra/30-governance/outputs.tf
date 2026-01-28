output "platform_admin_group" {
  value = azuread_group.platform_admins.display_name
}

output "platform_reader_group" {
  value = azuread_group.platform_readers.display_name
}
