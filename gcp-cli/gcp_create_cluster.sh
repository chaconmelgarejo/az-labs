#!/bin/bash
# maintainer with good vibes by: alejandro.chacon
# description: GCP Customize Cluster

# cluster vars
project_name="starmeup-data-platform-dev"
cluster_name="test-cluster"
cluster_zone="us-central1-c"
cluster_version="1.14.10-gke.27"
cluster_netwotk="projects/starmeup-data-platform-dev/global/networks/operations"
cluster_subnetwork="projects/starmeup-data-platform-dev/regions/us-central1/subnetworks/applications"
cluster_label="env=dev"
vm_type="n1-standard-1"
image_type="COS"
num_nodes="1"
cluster_tags="services"
master_pool="172.16.0.0/28"
cluster_ring="projects/starmeup-data-platform-dev/locations/us-central1/keyRings/local-vault/cryptoKeys/cluster-keys"

# create customize cluster

gcloud beta container --project $project_name clusters create $cluster_name \
    --zone $cluster_zone --no-enable-basic-auth --cluster-version $cluster_version  \
    --machine-type $vm_type --image-type $image_type --disk-type "pd-standard" --disk-size "100" \
    --scopes "https://www.googleapis.com/auth/cloud-platform" --node-labels $cluster_label \
    --num-nodes $num_nodes --enable-stackdriver-kubernetes --enable-ip-alias \
    --network $cluster_netwotk --subnetwork $cluster_subnetwork \
    --enable-master-authorized-networks --master-authorized-networks=$master_pool \
    --tags $cluster_tags --addons HorizontalPodAutoscaling,HttpLoadBalancing --enable-autorepair \
    --labels $cluster_label 

# add kms support
gcloud container clusters update $cluster_name \
  --zone $cluster_zone \
  --database-encryption-key $cluster_ring \
  --project $project_name

# to clean cluster
# use: gcloud container clusters delete $cluster_name --zone $cluster_zone
# example: gcloud container clusters delete test-cluster --zone us-central1-c