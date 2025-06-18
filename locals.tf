# Rodar com Terraform Cloud

locals {
  config_motd_script_content    = var.config_motd_script_content
  motd_grafana_content          = var.motd_grafana_content
  docker_compose_content        = var.docker_compose_content
  file_env_content              = var.file_env_content
  file_datasources_content      = var.file_datasources_content
  #file_json_speedtest_content   = var.file_json_speedtest_content
  #file_json_zabbix_hw_content   = var.file_json_zabbix_hw_content
}

# Rodar localmente

/*locals {
  config_motd_script_content    = file(var.config_motd_script_path)
  motd_grafana_content          = file(var.motd_grafana_path)
  docker_compose_content        = file(var.docker_compose_path)
  file_env_content              = file(var.file_env_path)
  file_datasources_content      = file(var.file_datasources_path)
  file_json_speedtest_content   = file(var.file_json_speedtest_path)
  file_json_zabbix_hw_content   = file(var.file_json_zabbix_hw_path)
}*/
