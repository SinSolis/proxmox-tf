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

resource "proxmox_vm_qemu" "lab01" {
  count = 1
  name = "lab01"
  os_type = "cloud-init"
  target_node = "pve"
  onboot = true
  agent = 1
  clone = "ubuntu-2204-template"
  ciuser = "juan"
  ipconfig0 = "ip=dhcp"
  qemu_os = "l26"
  full_clone = true
  sockets = 1
  cores = 2
  memory = 4096
  scsihw = "virtio-scsi-pci"
  sshkeys = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDPo139Zepne8Cu/x4fChh11PM+LphQGxdvuz+zW9qMSy9dzdeXG3g0d4AsxAlEHzrE8mi5G9ne4IPFnSmFg+6F6eZCooz1w5b3D3RspZnlM0bdzGrdf8ddrR7wqhDfLWW6qqx3zZWllB+Zo0zRtczjFi+5M7pdt92ktfmeDAthdEa4GL5JyMH1m1NBWXKlkOLt/uDUAqaW5SH64ruLS87bjWUwfMLxRlNSb7eN4dldk9FZm/qKMNPOv6SbMuySRXwcikaPeOPORJdhIWhhjn2NdGqHeWsW2WaTlk/ypcIvq3db66YaktFf51+ijLpVNz/w/8LKh0k4RAoT3a2FBPhR majora"
  
  #/dev/sda
  disk {
    slot = 0
    size = "50G"
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
