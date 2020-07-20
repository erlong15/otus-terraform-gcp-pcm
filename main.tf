terraform {
  required_version = ">= 0.12"
}

provider "google" {
  credentials = file(var.cred_file_path)
  project = var.project
  region  = var.region
}

resource "google_compute_disk" "pcm-stand-node-drbd-disk1-" {
  count = var.node_count
  name = "pcm-stand-node-drbd-disk1-${count.index}-data"
  type = "pd-standard"
  zone = var.zone
  size = "1" #GiB
}

resource "google_compute_network" "vpc_network" {
  name = "pcm-internal-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "vpc_subnetwork" {
  name = "pcm-internal-subnet"
  ip_cidr_range = "10.0.0.0/24"
  network = google_compute_network.vpc_network.name
  secondary_ip_range {
    range_name    = "external"
    ip_cidr_range = "10.0.1.0/24"
  }
}

resource "google_compute_address" "vpc_static" {
  count = var.node_count
  name = "pcm-ipv4-address-${count.index}"
}

resource "google_compute_address" "vpc_static_ext" {
  name = "pcm-ipv4-address-ext-1" # !!! per hour tarification !!!
}

resource "google_compute_firewall" "firewall" {
  name = "tf-pcm-firewall"
  network = google_compute_network.vpc_network.name
  allow {
    protocol = "tcp"
    ports = ["22", "80", "2224", "3121", "5403", "7788", "9929", "21064"]
    }
  allow {
    protocol = "udp"
    ports = ["5404", "5405-5412", "9929"]
    }
  allow {
    protocol = "icmp"
    }
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["pcm-stand"]
}

resource "google_compute_instance" "app" {
  count = var.node_count
  name = "pcm-stand-${count.index}"
  machine_type = "n1-standard-1"
  zone = var.zone
  tags = ["pcm-stand"]

  boot_disk {
    initialize_params {
      image = var.disk_image
      type = "pd-ssd"
      size = "30" #GiB
    }
  }

  attached_disk {
    source = element(google_compute_disk.pcm-stand-node-drbd-disk1-.*.self_link, count.index)
    device_name = element(google_compute_disk.pcm-stand-node-drbd-disk1-.*.name, count.index)
  }

  # what to do during maintenance
  scheduling {
    on_host_maintenance = "TERMINATE"
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    subnetwork = google_compute_subnetwork.vpc_subnetwork.name
    network_ip = "10.0.0.${count.index+2}" # because .0 - network and .1 - gateway
    access_config {
      nat_ip = element(google_compute_address.vpc_static.*.address, count.index)
    }
    alias_ip_range {
      ip_cidr_range = "10.0.1.${count.index+2}" # because .0 - network and .1 - gateway
      subnetwork_range_name = "external"
    }
  }

  metadata = {
    sshKeys = "appuser:${file(var.public_key_path)}"
  }
}
#  This is bad idea because pacemaker needs state and parallelism of execution
#  provisioner "local-exec" {
#    command = "ansible-playbook ansible/main.yml"
#  }

# Try to use google_compute_health_check instead
resource "google_compute_http_health_check" "http_health_check" {
  name = "http-health-check"
  timeout_sec = 5
  check_interval_sec = 10
  healthy_threshold = 2
  unhealthy_threshold = 3
  request_path = "/"
}

resource "google_compute_target_pool" "pcm_pool" {
  name = "pcm-pool"
  instances = google_compute_instance.app.*.self_link
  health_checks = [ google_compute_http_health_check.http_health_check.name ]
}

resource "google_compute_forwarding_rule" "pcm-forwarding" {
  name = "pcm-forwarding-rule"
  region = var.region
  load_balancing_scheme = "EXTERNAL"
  ip_address = google_compute_address.vpc_static_ext.address
  ip_protocol = "TCP"
  port_range = "80"
  target = google_compute_target_pool.pcm_pool.self_link
}
