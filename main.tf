provider "google" {
   credentials = file(var.cred_file_path)
   project = var.project
   region  = var.region
}

resource "google_compute_network" "vpc_network" {
  name = "pcm-internal-network"
}

resource "google_compute_firewall" "default" {  
  name    = "tf-pcm-firewall" 
  network = google_compute_network.vpc_network.name
  allow {   
    protocol = "tcp"
    ports    = ["22"]
    }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["pcm-stand"]
}

resource "google_compute_instance" "app" {
    count        = 3
    name         = "pcm-stand-${count.index}"
    machine_type = "n1-standard-1"
    zone         = var.zone
    tags         = ["pcm-stand"]

    boot_disk {
      initialize_params {
        image = var.disk_image
        type = "pd-ssd"
        size = "30"
      }
    }





    # what to do during maintenance
    scheduling{
      on_host_maintenance = "TERMINATE" // Need to terminate GPU on maintenance
    }

    network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
        # Ephemeral
      }    
    }
    
    metadata = { 
      sshKeys = "appuser:${file(var.public_key_path)}"
      }

}
