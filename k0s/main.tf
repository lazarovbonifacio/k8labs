resource "libvirt_volume" "debian_bookworm" {
  name   = "debian_bookworm_amd64"
  source = "https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-nocloud-amd64.qcow2"
}

resource "libvirt_volume" "boot" {
  name           = "k0s-boot.qcow2"
  base_volume_id = libvirt_volume.debian_bookworm.id
}

resource "libvirt_volume" "storage" {
  name           = "k0s-storage.qcow2"
  size = 25 * pow(10,9)  # 25GB
}

resource "local_file" "this" {
  filename = "/usr/local/share/k0s/README"
  source = "./README.md"
}

resource "libvirt_domain" "this" {
  name = "k0s"
  vcpu = 2
  memory = 4096

  disk {
    volume_id = libvirt_volume.boot.id
    scsi      = "true"
  }

  disk {
    volume_id = libvirt_volume.storage.id
    scsi      = "true"
  }

  filesystem {
    source   = "/usr/local/share/k0s"
    target   = "/usr/local/share/k0s"
    readonly = false
  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
    source_path = "/dev/pts/4"
  }

  depends_on = [ local_file.this ]
}