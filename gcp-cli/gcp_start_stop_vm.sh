#!/bin/bash
# create with good vibes by: @chaconmelgarejo
# description: GCP scheduler start and stop vm using pub/sub & nodejs function
# define: labels in the vm conf - env=dev
# requirements: gcp sdk installed & had editor permissions in the gcp project

#create the pub/sub 
gcloud pubsub topics create start-instance-event
gcloud pubsub topics create stop-instance-event

#clone the repo with gcp nodejs example functions
git clone https://github.com/GoogleCloudPlatform/nodejs-docs-samples.git
cd nodejs-docs-samples/functions/scheduleinstance/

#deploy nodejs functions
gcloud functions deploy startInstancePubSub \
    --trigger-topic start-instance-event \
    --runtime nodejs8

gcloud functions deploy stopInstancePubSub \
    --trigger-topic stop-instance-event \
    --runtime nodejs8

# create the cron entries using cloud schedulers - using labels env=dev 
gcloud beta scheduler jobs create pubsub startup-dev-instances \
    --schedule '0 10 * * *' \
    --topic start-instance-event \
    --message-body '{"zone":"us-west1-b", "label":"env=dev"}' \
    --time-zone 'America/Montevideo'

gcloud beta scheduler jobs create pubsub shutdown-dev-instances \
    --schedule '0 22 * * *' \
    --topic stop-instance-event \
    --message-body '{"zone":"us-west1-b", "label":"env=dev"}' \
    --time-zone 'America/Montevideo'