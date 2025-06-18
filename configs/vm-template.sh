#!/bin/bash

# ================================================================
# Nome:       vm-template.sh
# Versão:     2.0
# Autor:      Glauber GF (mcnd2)
# Criado:     17/04/2025
# Atualizado: 14/06/2025
#
# Descrição:
#   Esse script cria uma imagem de template atualizada em QCOW2 
#   no servidor Proxmox.
# ================================================================

set -euo pipefail

# === Instalar dependência para manipular imagens QCOW2 ===
# O pacote 'libguestfs-tools' é necessário para o 'virt-customize'
if ! dpkg -l | grep -q libguestfs-tools; then
    apt update -y && apt install libguestfs-tools -y
else
    echo "[✓] libguestfs-tools já está instalado."
fi

# === Variáveis de configuração ===
URL="https://cdimage.debian.org/cdimage/cloud/bookworm/latest/debian-12-nocloud-amd64.qcow2"  
IMAGE_NAME="debian-12-nocloud-amd64"
IMAGE_FILE="${IMAGE_NAME}.qcow2"
IMAGE_DIR="/var/lib/vz/template/qemu"
ARCHIVE_DIR="$IMAGE_DIR/archive"
STORAGE="local"
VMID=2000
TEMPLATE_NAME="bookworm-nocloud"
HASH_FILE="${IMAGE_FILE}.md5"

# === Criar diretório para armazenar imagens antigas compactadas ===
mkdir -p "$ARCHIVE_DIR"

# === Função: Baixar a imagem mais recente e verificar se ela é diferente da atual ===
download_latest_image() {
  echo "[+] Verificando nova versão da imagem..."
  cd "$IMAGE_DIR"
  TMP_IMAGE="latest_temp.qcow2"
  # Arquivo onde o hash MD5 da imagem atual é salvo
  HASH_FILE="${IMAGE_FILE}.md5"

  # === Baixar a imagem temporária para comparação ===
  wget -q -O "$TMP_IMAGE" "$URL"

  # === Se já houver imagem existente, comparar os hashes ===
  if [ -f "$IMAGE_FILE" ]; then
    # Calcula o hash da imagem nova
    TMP_HASH=$(md5sum "$TMP_IMAGE" | awk '{print $1}')

    # Verifica se há hash antigo salvo
    if [ -f "$HASH_FILE" ]; then
      OLD_HASH=$(cat "$HASH_FILE")

      if [ "$TMP_HASH" == "$OLD_HASH" ]; then
        echo "[✓] A imagem atual já está atualizada (hash MD5 idêntico)."
        rm "$TMP_IMAGE"
        return 1  # Nenhuma ação necessária
      else
        echo "[!] Imagem nova detectada via hash. Arquivando a imagem atual..."
        TIMESTAMP=$(date +%Y%m%d-%H%M%S)
        gzip -c "$IMAGE_FILE" > "$ARCHIVE_DIR/${IMAGE_FILE}.${TIMESTAMP}.gz"
        rm "$IMAGE_FILE"
      fi
    else
      echo "[!] Hash anterior não encontrado. Tratando como nova imagem."
      gzip -c "$IMAGE_FILE" > "$ARCHIVE_DIR/${IMAGE_FILE}.nohash.gz"
      rm "$IMAGE_FILE"
    fi
  fi

  # === Salvar nova imagem e gerar novo hash ===
  mv "$TMP_IMAGE" "$IMAGE_FILE"
  TMP_HASH=$(md5sum "$IMAGE_FILE" | awk '{print $1}')
  echo "$TMP_HASH" > "$HASH_FILE"

  echo "[+] Nova imagem baixada e hash registrado para futuras comparações."
  return 0
}

# === Função: Remover template existente com seu disco ===
remove_old_template() {
  if qm list | grep -q "$TEMPLATE_NAME"; then
    echo "[!] Template existente encontrado. Removendo..."
    qm destroy $VMID --purge || true
  else
    echo "[✓] Nenhum template anterior encontrado."
  fi
}

# === Função: Criar o novo template atualizado ===
create_template() {
  echo "[+] Personalizando imagem..."

  # Instalar pacotes e configurar o qemu-guest-agent
  virt-customize -a "$IMAGE_FILE" \
    --install cloud-init,qemu-guest-agent \
    --run-command 'systemctl enable qemu-guest-agent' \
    --run-command 'systemctl start qemu-guest-agent' \
    --truncate /etc/machine-id

  echo "[+] Criando nova VM no Proxmox..."
  qm create $VMID -name $TEMPLATE_NAME -memory 1024 -cores 1 -sockets 1 -net0 virtio,bridge=vmbr0 --scsihw virtio-scsi-pci

  echo "[+] Importando disco para o storage do Proxmox..."
  qm importdisk $VMID "$IMAGE_DIR/$IMAGE_FILE" $STORAGE

  # === Anexar o disco à VM ===
  qm set $VMID -scsihw virtio-scsi-pci -scsi0 $STORAGE:$VMID/vm-$VMID-disk-0.raw

  # Configurações adicionais da VM
  qm set $VMID -boot c -bootdisk scsi0    # Definir disco de boot
  qm set $VMID -agent 1                   # Habilitar QEMU guest agent
  qm set $VMID -hotplug disk,network,usb  # Permitir hotplug
  qm set $VMID -vcpus 1                   # Adicionar vCPU
  qm set $VMID -vga qxl                   # Definir saída de vídeo
  qm set $VMID -ide2 $STORAGE:cloudinit   # Adicionar disco de cloud-init

  # Aumentar o tamanho do disco principal
  qm disk resize $VMID scsi0 +4G

  # Converter a VM em template
  echo "[+] Convertendo para template..."
  qm template $VMID

  echo "[✓] Template atualizado com sucesso!"
}

# === Execução principal ===
if download_latest_image; then
  remove_old_template
  create_template
else
  echo "[✓] Nenhuma ação necessária. Template está atualizado."
fi
