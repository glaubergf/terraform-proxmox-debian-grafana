output "vm_ip" {
  description = "IP da VM provisionada"
  value       = var.vm_ip
  #value       = proxmox_vm_qemu.debian_nocloud.default_ipv4_address
}

output "vm_url" {
  description = "URL para acessar a VM"
  value       = "http://${var.vm_ip}"
  #value       = "http://${proxmox_vm_qemu.debian_nocloud.default_ipv4_address}"
}
