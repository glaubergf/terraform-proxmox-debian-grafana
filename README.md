<!---
Projeto: terraform-proxmox-debian-grafana
Descrição: Este projeto automatiza a criação de uma máquina virtual Debian 12 (Bookworm) 
no Proxmox utilizando Terraform e Cloud-Init, realizando a instalação do Grafana e 
MariaDB via Docker.
Autor: Glauber GF (mcnd2)
Criado em: 05-06-2025
Atualizado: 17-06-2025
--->

# Servidor Debian Grafana (Docker)

![Image](https://github.com/glaubergf/terraform-proxmox-debian-grafana/blob/main/images/tf-pm-grafana.png)

![Image](https://github.com/glaubergf/terraform-proxmox-debian-grafana/blob/main/images/grafana.png)

![Image](https://github.com/glaubergf/terraform-proxmox-debian-grafana/blob/main/images/dashboard.png)

![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)

## 📜 Sobre o Projeto

Este projeto provisiona um servidor **Debian 12 (Bookworm)** no **Proxmox VE** utilizando **Terraform** e **cloud-init**, com implantação automatizada do **Grafana** e **MariaDB** em container **Docker**.

## 🪄 O Projeto Realiza

- Download automático da imagem Debian noCloud.
- Criação de VM no Proxmox via QEMU.
- Configuração do sistema operacional via Cloud-Init.
- Instalação e configuração do Docker.
- Deploy do container do Grafana e MariaDB.

## 🧩 Tecnologias Utilizadas

![Terraform](https://img.shields.io/badge/Terraform-623CE4?logo=terraform&logoColor=white&style=for-the-badge)
- [Terraform](https://developer.hashicorp.com/terraform) — Provisionamento de infraestrutura como código (IaC).
 ---
![Proxmox](https://img.shields.io/badge/Proxmox-E57000?logo=proxmox&logoColor=white&style=for-the-badge)
- [Proxmox VE](https://www.proxmox.com/en/proxmox-ve) — Hypervisor para virtualização.
---
![Cloud-Init](https://img.shields.io/badge/Cloud--Init-00ADEF?logo=cloud&logoColor=white&style=for-the-badge)
- [Cloud-Init](https://cloudinit.readthedocs.io/en/latest/) — Ferramenta de inicialização e configuração automatizada da VM.
---
![Debian](https://img.shields.io/badge/Debian-A81D33?logo=debian&logoColor=white&style=for-the-badge)
- [Debian](https://www.debian.org/) — Sistema operacional da VM.
---
![Docker](https://img.shields.io/badge/Docker-2496ED?logo=docker&logoColor=white&style=for-the-badge)
- [Docker](https://www.docker.com/) — Containerização da aplicação sysPass.
---
![Grafana](https://img.shields.io/badge/Grafana-F46800?style=for-the-badge&logo=grafana&logoColor=white)
- [Grafana](https://grafana.com/) — Plataforma de visualização e observabilidade de dados.
---
![MariaDB](https://img.shields.io/badge/MariaDB-003545?style=for-the-badge&logo=mariadb&logoColor=white)
- [MariaDB](https://mariadb.org) — Banco de dados relacional.

## 💡 Motivação

Automatizar a criação de um ambiente seguro e escalável para visualização e observabilidade de dados, ideal para dashboards e métricas:

- Implantação consistente;
- Restauração do datasources do ambiente (dashboards);
- Cópia dos arquivos dos dashboards do ambiente datasources.

## 🛠️ Pré-requisitos

- ✅ Proxmox VE com API habilitada.
- ✅ Usuário no Proxmox com permissão para criação de VMs.
- ✅ Bucket na AWS S3 configurado.
- ✅ Chave de acesso à AWS configurada.
- ✅ Chave SSH pública e privada para acesso à VM.
- ✅ Terraform instalado localmente.

## 📂 Estrutura do Projeto

```
terraform-proxmox-debian-grafana
├── configs
│   ├── cloud-config.yml
│   ├── config-motd.sh
│   ├── dash-elevalink-speedtest.json
│   ├── dash-zabbix-docker-hardware.json
│   ├── docker-compose.yml
│   ├── motd-grafana
│   ├── network-config.yml
│   └── vm-template.sh
├── images
│   ├── grafana.png
│   └── tf-pm-grafana.png
├── LICENSE
├── notes
│   ├── art-ascii-to-modt.txt
│   ├── dashboard-importado.txt
│   ├── datasources.yml.template
│   ├── docker-compose.yml.template
│   ├── dotenv.template
│   └── terraform.tfvars.template
├── output.tf
├── provider.tf
├── README.md
├── security
│   ├── .env
│   ├── auth-proxmox.txt
│   ├── datasources.yml
│   ├── tf-proxmox_id_rsa
│   └── tf-proxmox_id_rsa.pub
├── terraform.tfvars
├── variables.tf
└── vm-proxmox.tf
```

### 📄 Arquivos

- `provider.tf` → Provedor do Proxmox
- `vm_proxmox.tf` → Criação da VM, configuração da rede, execução dos scripts
- `variables.tf` → Definição de variáveis
- `terraform.tfvars` → Valores das variáveis (customização)
- `cloud_config.yml` → Configurações do Cloud-Init (usuário, pacotes, timezone, scripts)
- `network_config.yml` → Configuração de rede estática
- `docker-compose.yml` → Define e organiza os contêineres Docker
- `.env` → Variáveis de acesso ao banco de dados e do Grafana

## 🚀 Fluxo de Funcionamento

1. **Terraform Init:** Inicializa o Terraform e carrega os providers e módulos necessários.

2. **Download da imagem Debian noCloud:** Baixa a imagem Debian pré-configurada (noCloud) se ainda não estiver no Proxmox.

3. **Criação da VM no Proxmox:** Terraform cria uma VM no Proxmox com base nas variáveis definidas.

4. **Aplicação do Cloud-Init:** Injeta configuração automática na VM (rede, usuário, SSH, hostname, etc.).

5. **Configuração inicial da VM:** A VM é inicializada e aplica configurações básicas (acesso remoto, hostname, rede, etc.).

6. **Preparação da VM:** Envio de arquivos de confiurações para a VM, instalação do Docker e Docker Compose na VM, etc.

7. **Deploy dos containers:** O Docker Compose sobe o container do Grafana e do mariaDB.

8. **Pós provisonamento:** Importar (manualmente) o json dos dashboards que foram copiados para o ambiente de acordo com o datasources.

## 🛠️ Terraform

Ferramenta de IaC (Infrastructure as Code) que permite definir e gerenciar infraestrutura através de arquivos de configuração declarativos.

Saiba mais: [https://developer.hashicorp.com/terraform](https://developer.hashicorp.com/terraform)

## 🖥️ Proxmox VE

O Proxmox VE é um hipervisor bare-metal, robusto e completo, muito utilizado tanto em ambientes profissionais quanto em homelabs. É uma plataforma de virtualização open-source que permite gerenciar máquinas virtuais e containers de forma eficiente, com suporte a alta disponibilidade, backups, snapshots e uma interface web intuitiva.

Saiba mais: [https://www.proxmox.com/](https://www.proxmox.com/)

## 🐧 Debian

Distribuição Linux livre, estável e robusta. A imagem utilizada é baseada em **Debian noCloud**, que permite integração com Cloud-Init no Proxmox.

Saiba mais: [https://www.debian.org/](https://www.debian.org/)

### ☁️ Sobre a imagem Debian nocloud

Este projeto utiliza a imagem Debian nocloud por maior estabilidade no provisionamento via Terraform no Proxmox, evitando problemas recorrentes como **kernel panic** em outras versões (*generic*, *genericcloud*).

## ☁️ Cloud-Init

Ferramenta de provisionamento padrão de instâncias de nuvem. Permite configurar usuários, pacotes, rede, timezone, scripts e mais, tudo automaticamente na criação da VM.

Saiba mais: [https://cloudinit.readthedocs.io/](https://cloudinit.readthedocs.io/)

## 🐳 Docker

Plataforma que permite empacotar, distribuir e executar aplicações em containers de forma leve, portátil e isolada, facilitando a implantação e escalabilidade de serviços.

Saiba mais: [https://www.docker.com](https://www.docker.com)

## 📊 Grafana

Plataforma open source de observabilidade e análise de métricas. Permite criar dashboards interativos e em tempo real, conectando-se a diversas fontes de dados como Prometheus, InfluxDB, Zabbix, Elasticsearch, entre outras.

✨ Principais funcionalidades:

- Dashboards dinâmicos com gráficos, tabelas, mapas e alertas.
- Alertas configuráveis por e-mail, Slack, Webhook, etc.
- Autenticação e permissões por usuário.
- Suporte a plugins (painéis, fontes de dados e apps).
- Análise de séries temporais com filtros e variáveis dinâmicas.

Mais informações: [https://grafana.com](https://grafana.com)

## ▶️ Execução do Projeto

1. Clone o repositório:

```bash
git clone https://github.com/glaubergf/terraform-proxmox-debian-grafana.git
cd terraform-proxmox-debian-grafana
```

2. Edite o arquivo `terraform.tfvars` com suas variáveis.

3. Inicialize o Terraform:

```bash
terraform init
```

4. Execute o plano para mostra o que será criado:

```bash
terraform plan
```

5. Aplique o provisionamento (infraestrutura):

```bash
terraform apply
```

6. Para destruir toda a infraestrutura criada (caso necessário):

```bash
terraform destroy
```

7. Para executar sem confirmação interativa, use:

```bash
terraform apply --auto-approve
terraform destroy --auto-approve
```

## 🤝 Contribuições

Contribuições são bem-vindas!

## 📜 Licença

Este projeto está licenciado sob os termos da **[GNU General Public License v3](https://www.gnu.org/licenses/gpl-3.0.html)**.

### 🏛️ Aviso Legal

```
Copyright (c) 2025

Este programa é software livre: você pode redistribuí-lo e/ou modificá-lo
sob os termos da Licença Pública Geral GNU conforme publicada pela
Free Software Foundation, na versão 3 da Licença.

Este programa é distribuído na esperança de que seja útil,
mas SEM NENHUMA GARANTIA, nem mesmo a garantia implícita de
COMERCIALIZAÇÃO ou ADEQUAÇÃO A UM DETERMINADO FIM.

Veja a Licença Pública Geral GNU para mais detalhes.
```
