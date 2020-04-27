#!/bin/bash
# create with good vibes by: @chaconmelgarejo
# promote images inter gcp projects

#usage: ./gcr_image.sh [commit] [project_name] [service_name]

#vars
commit=$1
project_name=$2
service_name=$3
gcr_dest="gcr.io/$dest_project/$service_name"
gcr_ori="gcr.io/$ori_project/$service_name"

docker pull $gcr_ori:$commit
docker tag $gcr_ori:$commit $gcr_dest:$commit
docker push $gcr_dest:$commit
