// Configure the Google Cloud provider
provider "google" {
 credentials = file("devops-332916-7d07d4ce5889.json")
 project     = "devops-332916"
 region      = "europe-central2-a"
}

// Terraform plugin for creating random ids
resource "random_id" "instance_id" {
 byte_length = 8
}

// A single Compute Engine instance
resource "google_compute_instance" "default" {
 name         = "flask-vm-${random_id.instance_id.hex}"
 machine_type = "f1-micro"
 zone         = "europe-central2-a"

 boot_disk {
   initialize_params {
     image = "centos-cloud/centos-8"
   }
 }

// Make sure flask is installed on all new instances for later steps
 metadata_startup_script = "sudo apt-get update; sudo apt-get install -yq build-essential python-pip rsync; pip install flask"

 network_interface {
   network = "default"

   access_config {
     // Include this section to give the VM an external ip address
   }
 }
}