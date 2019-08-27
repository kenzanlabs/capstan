#GKE_CLUSTER_VERSION="1.8.6-gke.0"
#GKE_MACHINE_TYPE="n1-standard-2"
#gcloud container --project $PROJECT_NAME clusters create $CLUSTER_NAME --zone $ZONE --username="admin" \
# --cluster-version $GKE_CLUSTER_VERSION --machine-type $GKE_MACHINE_TYPE --image-type "COS" --disk-size "100" \
# --scopes "https://www.googleapis.com/auth/compute", "https://www.googleapis.com/auth/devstorage.read_write", \
# "https://www.googleapis.com/auth/logging.write", "https://www.googleapis.com/auth/monitoring.write", \
# "https://www.googleapis.com/auth/cloud-platform", "https://www.googleapis.com/auth/servicecontrol", \
# "https://www.googleapis.com/auth/service.management.readonly", "https://www.googleapis.com/auth/trace.append", \
# "https://www.googleapis.com/auth/source.read_write", "https://www.googleapis.com/auth/projecthosting,storage-rw" \
# --num-nodes $NODE_PER_ZONE --network "default" --enable-cloud-logging --enable-cloud-monitoring $OTHER_ZONES \
# --enable-legacy-authorization

variable "gke_cluster_name" {
    description = ""
    default = "cdci-runtime"
}

variable "gke_cluster_node_count" {
    description = ""
    default = 3
}

variable "gke_node_machine_type" {
    description = ""
    default = "n1-standard-2"
}





resource "google_container_cluster" "primary" {
    name = "${var.gke_cluster_name}"
    #min_master_version = "${var.}"
    initial_node_count = "${var.gke_cluster_node_count}"
   # zone = "${var.gke_primary_zone}"
   # additional_zones = "${var.gke_additional_zones}"
    location = "${var.regionzone}"
    node_locations = "${var.gke_additional_zones}"

    depends_on = [
        #"google_project_service.iam_service",
        #"google_project_service.cloudresourcemanager_service",
        #"google_project_service.container_service"
    ]

    node_config {
        oauth_scopes = [
            "https://www.googleapis.com/auth/compute",
            "https://www.googleapis.com/auth/devstorage.read_write",
            "https://www.googleapis.com/auth/logging.write",
            "https://www.googleapis.com/auth/monitoring.write",
            "https://www.googleapis.com/auth/cloud-platform",
            "https://www.googleapis.com/auth/servicecontrol",
            "https://www.googleapis.com/auth/service.management.readonly",
            "https://www.googleapis.com/auth/trace.append",
            "https://www.googleapis.com/auth/source.read_write"
        ]

        machine_type = "${var.gke_node_machine_type}"

        image_type = "COS"

        disk_size_gb = 100
    }
}

# The following outputs allow authentication and connectivity to the GKE Cluster.
#output "gke_cluster_client_certificate" {
#  value = "${google_container_cluster.primary.master_auth.0.client_certificate}"
#}

#output "gke_cluster_client_key" {
#  value = "${google_container_cluster.primary.master_auth.0.client_key}"
#}

#output "gke_cluster_ca_certificate" {
#  value = "${google_container_cluster.primary.master_auth.0.cluster_ca_certificate}"
#}
