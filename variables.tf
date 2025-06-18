# Variáveis de provisionamento de recursos e configuração
variable "vm_hostname" {
  description = "Nome do host para a VM"
  type        = string
  default     = "tf-pm-grafana"
}

variable "vm_ip" {
  description = "IP do host para a VM"
  type        = string
  default     = "192.168.0.161"
}

variable "vm_domain" {
  description = "Domínio para a VM"
  type        = string
  default     = "homelab.mcn"
}

variable "vm" {
  description = "Nome da VM"
  type        = string
  default     = "tf-pm-grafana"
}

variable "node" {
  description = "Nó do cluster"
  type        = string
  default     = "pve"
}

variable "template" {
  description = "Clone do template"
  type        = string
  default     = "bookworm-nocloud"
}

variable "vm_vmid" {
  description = "VMID da VM"
  type        = number
  default     = 203
}

variable "vm_memory" {
  description = "Memória disponível da VM (MB)"
  type        = number
  default     = 1024
}

variable "vm_cores" {
  description = "Quantidade de cores da VM"
  type        = number
  default     = 1
}

variable "storage_proxmox" {
  description = "Armazenamento do Proxmox"
  type        = string
  default     = "local"
}

variable "vm_macaddr" {
  description = "Endereço MAC da rede da VM"
  type        = string
  default     = "BC:24:11:CB:18:06"
}

variable "disk_size" {
  description = "Tamanho do disco da VM (GB)"
  type        = number
  default     = 15
}

# Variáveis de caminho usadas em execução local
variable "cloud_config_file" {
  description = "Caminho do arquivo cloud-init"
  type        = string
  default     = "./configs/cloud-config.yml"
}

variable "network_config_file" {
  description = "Caminho do arquivo de rede"
  type        = string
  default     = "./configs/network-config.yml"
}

variable "vm_template_script_path" {
  description = "Caminho do script do template da VM"
  type        = string
  default     = "./configs/vm-template.sh"
}

variable "config_motd_script_path" {
  description = "Caminho do script do MOTD"
  type        = string
  default     = "./configs/config-motd.sh"
}

variable "motd_grafana_path" {
  description = "Caminho do arquivo de MOTD do Grafana"
  type        = string
  default     = "./configs/motd-grafana"
}

variable "docker_compose_path" {
  description = "Caminho do arquivo docker-compose"
  type        = string
  default     = "./configs/docker-compose.yml"
}

variable "file_json_speedtest_path" {
  description = "Dashboard speedtest"
  type        = string
  #default     = "./configs/dash-elevalink-speedtest.json"
  default = ""
}

variable "file_json_zabbix_hw_path" {
  description = "Dashboard Zabbix HW"
  type        = string
  #default     = "./configs/dash-zabbix-docker-hardware.json"
  default = ""
}

# Variáveis sensíveis para secrets e arquivos (usadas em cloud e local)
variable "proxmox_url" {
  type        = string
  sensitive   = true
  description = "URL da API do Proxmox"
}

variable "proxmox_token_id" {
  type        = string
  sensitive   = true
  description = "Token ID"
}

variable "proxmox_token_secret" {
  type        = string
  sensitive   = true
  description = "Token Secret"
}

variable "vm_password" {
  type        = string
  sensitive   = true
  description = "Senha da VM"
}

variable "vm_user" {
  type        = string
  sensitive   = true
  description = "Usuário da VM"
}

variable "srv_proxmox" {
  type        = string
  sensitive   = true
  description = "IP do Proxmox"
}

variable "ssh_key" {
  type        = string
  sensitive   = true
  description = "Chave SSH pública"
}

variable "private_key" {
  type        = string
  sensitive   = true
  description = "Chave SSH privada"
}

variable "file_env_path" {
  type        = string
  sensitive   = true
  description = "Caminho do .env"
}

variable "file_datasources_path" {
  type        = string
  sensitive   = true
  description = "Caminho do datasources.yml"
}

# Variáveis usadas quando rodando no Terraform Cloud (valores passados via TFC variables)
variable "config_motd_script_content" {
  type        = string
  sensitive   = true
  description = "Conteúdo do script do MOTD (usado no Terraform Cloud)"
}

variable "motd_grafana_content" {
  type        = string
  sensitive   = true
  description = "Conteúdo do MOTD Grafana (usado no Terraform Cloud)"
}

variable "docker_compose_content" {
  type        = string
  sensitive   = true
  description = "Conteúdo do docker-compose.yml (usado no Terraform Cloud)"
}

variable "file_env_content" {
  type        = string
  sensitive   = true
  description = "Conteúdo do .env (usado no Terraform Cloud)"
}

variable "file_datasources_content" {
  type        = string
  sensitive   = true
  description = "Conteúdo do datasources.yml (usado no Terraform Cloud)"
}

/*variable "file_json_speedtest_content" {
  type        = string
  sensitive   = true
  description = "Conteúdo do dashboard speedtest (usado no Terraform Cloud)"
}

variable "file_json_zabbix_hw_content" {
  type        = string
  sensitive   = true
  description = "Conteúdo do dashboard Zabbix hardware (usado no Terraform Cloud)"
}*/
