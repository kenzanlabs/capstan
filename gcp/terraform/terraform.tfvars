#####
# Varibles for TF - thanks pancoast
#
#####

#### Where are we?
# If you change this here
# You need to change it in the env.sh
#
region = "us-central1"

zone = "f"

bucket_location = "us"

### Project Info
#
#gcp_project_id = "CHANGE ME"
created_by = "kenzan-capstan"

#
#	Note: This needs to be the ssh key you have associated with your google compute
#		engine account. It can't just be some random one.
#
ssh_private_key_location = "~/.ssh/google_compute_engine"

creds_file = "gcp-account.json"

#
#	Stuff that you probably won't have to update that often
#		Can change bastion type if you want, but be very careful about
#		changing spinnaker type
#
halyard_machine_type = "n1-standard-1"

ubuntu_image = "ubuntu-1604-xenial-v20190122a"

halyard_machine_name = "halyard-tunnel"

service_account_name = "halyard-tunnel-tools"
