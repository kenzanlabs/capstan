# Configure the Google Cloud provider
provider "google" {
  credentials = "${file("${var.creds_file}")}"
  project     = "${var.gcp_project_id}"

}