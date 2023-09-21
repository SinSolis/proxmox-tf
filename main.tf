terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = "2.9.14"
    }
  }
}

provider "proxmox" {
  pm_api_url = "https://192.168.1.153:8006/api2/json"
  pm_tls_insecure = "true"
}

resource "proxmox_vm_qemu" "plex_server" {
  count = 1
  name = "plex01"
  target_node = "pve"
  onboot = true
  define_connection_info = true
  agent = 1
  clone = "ubuntu-2204-template"
  full_clone = true
  sockets = 1
  cores = 2
  memory = 2048
  scsihw = "virtio-scsi-pci"
  
  disk {
    slot = 0
    size = "50G"
    type = "scsi"
    storage = "primary-datastore"
  }

  disk {
    slot = 1
    size = "2000G"
    type = "scsi"
    storage = "primary-datastore"
  }
  
  network {
    model = "virtio"
    bridge = "vmbr0"
  }
  lifecycle {
    ignore_changes = [
      network,
    ]
  }
}
