#!/bin/bash
# create with good vibes by: @chaconmelgarejo
# description: create network - instance template & instance group with healthcheck


#vars
project_name="my-project"
network_name="my-net"
subnet_name="my-subnet"
subnet_range="10.100.10.0/24"
region_name="us-central1"
gcs_name="my-super-gcs-labs"
script_path="mysecret.txt"
script_name="mysecret.txt"
it_name="my-instance-template"
it_subnet="projects/cloudsultor-dev/regions/$region_name/subnetworks/$subnet_name"
it_net_tags="webserver,http-server"
it_labels="env=dev,app=web"
vm_type="f1-micro"
it_metadata="startup-script-url=gs://$gcs_name/$script_name"
hc_name="my-hc-ig"
num_nodes="2"
vm_zone="us-central1-c"


# create networks

echo "Creating network and subnet ..."

gcloud compute networks create $network_name --project $project_name --description="my best net" --subnet-mode=custom

gcloud compute networks subnets create $subnet_name --project $project_name --network $network_name --region $region_name --range $subnet_range

echo "Creating the gcs storage ..."
# create tf_bucket and upload the script

gsutil mb gs://$gcs_name

gsutil cp $script_path gs://$gcs_name/$script_name

# gsutil rm -r gs://www.example.com

# create instance template

gcloud beta compute instance-templates create $it_name  --project $project_name --machine-type $vm_type \
  --subnet $it_subnet --network-tier=PREMIUM --metadata $it_metadata --maintenance-policy=MIGRATE \
  --service-account=390917694701-compute@developer.gserviceaccount.com --scopes=https://www.googleapis.com/auth/cloud-platform \
  --region $region_name --tags $it_net_tags --image=ubuntu-1804-bionic-v20200414 --image-project=ubuntu-os-cloud \
  --boot-disk-size=10GB --boot-disk-type=pd-standard --boot-disk-device-name=my-web-tp --no-shielded-secure-boot \
  --shielded-vtpm --shielded-integrity-monitoring --labels $it_labels--reservation-affinity=any


# create the healthcheck

gcloud compute health-checks create tcp $hc_name --project $project_name --description "my cool hc" --timeout "5" --check-interval "10" \
  --unhealthy-threshold "3" --healthy-threshold "2" --port "80"

# create the instance group
gcloud beta compute instance-groups managed create $ig_name --project $project_name --base-instance-name $ig_name --template $it_name \
  --size $num_nodes --zone $vm_zone --health-check $hc_name --initial-delay=300
