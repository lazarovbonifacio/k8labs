resource "libvirt_network" "this" {
  name = "microk8s"
  mode = "nat"
  addresses = ["10.7.8.0/24"]
  autostart = true
}

resource "libvirt_cloudinit_disk" "this" {
  name      = "microk8s.iso"
  user_data = file("${path.module}/cloud_init.cfg")
}

resource "libvirt_volume" "ubuntu_noble" {
  name   = "ubuntu_noble_amd64"
  source = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
}

resource "libvirt_volume" "boot" {
  name           = "microk8s-boot.qcow2"
  base_volume_id = libvirt_volume.ubuntu_noble.id
  size = 25 * pow(10,9)  # 25GB
  lifecycle {
    ignore_changes = [ size ]
  }
}

resource "libvirt_domain" "this" {
  name = "microk8s"
  vcpu = 2
  memory = 4096
  running = false

  cloudinit = libvirt_cloudinit_disk.this.id

  disk {
    volume_id = libvirt_volume.boot.id
    scsi      = "true"
  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
    source_path = "/dev/pts/4"
  }

  network_interface {
    network_id = libvirt_network.this.id
  }
}