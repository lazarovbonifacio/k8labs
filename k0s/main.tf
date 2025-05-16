resource "libvirt_network" "this" {
  name = "k0s"
  mode = "nat"
  addresses = ["10.7.7.0/24"]
  autostart = true
}

resource "libvirt_cloudinit_disk" "this" {
  name      = "k0s.iso"
  user_data = file("${path.module}/cloud_init.cfg")
}

resource "libvirt_volume" "debian_bookworm" {
  name   = "debian_bookworm_amd64"
  source = "https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-genericcloud-amd64.qcow2"
}

resource "libvirt_volume" "boot" {
  name           = "k0s-boot.qcow2"
  base_volume_id = libvirt_volume.debian_bookworm.id
  size = 25 * pow(10,9)  # 25GB
  lifecycle {
    ignore_changes = [ size ]
  }
}

# resource "local_file" "this" {
#   filename = "/usr/local/share/k0s/README"
#   source = "${path.module}/README.md"
# }

resource "libvirt_domain" "this" {
  name = "k0s"
  vcpu = 2
  memory = 4096

  cloudinit = libvirt_cloudinit_disk.this.id

  disk {
    volume_id = libvirt_volume.boot.id
    scsi      = "true"
  }

  # filesystem {
  #   source   = "${path.module}/shared"
  #   target   = "/usr/local/share/k0s"
  #   readonly = false
  # }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
    source_path = "/dev/pts/4"
  }

  network_interface {
    network_id = libvirt_network.this.id
  }

  # depends_on = [ local_file.this ]
}