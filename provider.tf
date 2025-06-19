terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.2-rc01" # versão de 05-06-2025
    }
  }
}

provider "proxmox" {
  #pm_user             = "root@pam"
  #pm_password         = "xxxxxxxxx"
  pm_api_url          = var.proxmox_url
  pm_api_token_id     = var.proxmox_token_id
  pm_api_token_secret = var.proxmox_token_secret
  pm_tls_insecure     = true # 'true' se não estiver usando HTTPS válido
}