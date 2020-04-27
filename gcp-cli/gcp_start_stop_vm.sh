#!/bin/bash
# create with good vibes by: @chaconmelgarejo
# description: GCP scheduler start and stop vm using pub/sub & nodejs function
# define: labels in the vm conf
# requirements: gcp sdk installed & had editor permissions in the gcp project

#vars
ps_start_name="start-instance-event"
ps_stop_name="stop-instance-event"
gcp_tools_repo="https://github.com/GoogleCloudPlatform/nodejs-docs-samples.git"
script_path="nodejs-docs-samples/functions/scheduleinstance/"
cf_start_name="startInstancePubSub"
cf_stop_name="stopInstancePubSub"
my_runtime="nodejs8"
cs_start_name="startup-dev-instances"
cs_stop_name="shutdown-dev-instances"
cron_start="0 10 * * *"
cron_stop="0 22 * * *"
timezone="America/Montevideo"
my_label="vmOff=on"
my_zone="us-central1-b"
message_body="'{\"zone\":\"$my_zone\",\"label\":\"$my_label\"}'"

#create the pub/sub
echo "Creating the topics ..."
error_ps=$(gcloud pubsub topics create $ps_start_name && gcloud pubsub topics create $ps_stop_name 2>&1 1>/dev/null)

if [ $? -eq 0 ]; then
   echo "good job, go ahead!"
else
   echo "opsss, we got an error:--> $error"

fi


#clone the repo with gcp nodejs example functions
echo "Downloading the scripts ..."
git clone $gcp_tools_repo
cd $script_path

#deploy nodejs functions
echo "Creating the Cloud Funtions ..."
error_cf=$(gcloud functions deploy $cf_start_name \
    --trigger-topic $ps_start_name \
    --runtime $my_runtime 2>&1 1>/dev/null)

    if [ $? -eq 0 ]; then
       echo "good job, go ahead!"
    else
       echo "opsss, we got an error:--> $error"

    fi

error_cf2=$(gcloud functions deploy $cf_stop_name \
    --trigger-topic $ps_stop_name \
    --runtime $my_runtime 2>&1 1>/dev/null)

    if [ $? -eq 0 ]; then
       echo "good job, go ahead!"
    else
       echo "opsss, we got an error:--> $error"

    fi

echo "''{"zone":'$my_zone', "label":'$my_label'}''"
# create the cron entries using cloud schedulers - using labels
echo "Creating the schedulers using cron format ..."
error_cs=$(gcloud beta scheduler jobs create pubsub $cs_start_name \
  --schedule '$cron_start' --topic $ps_start_name \
  --message-body $message_body \
  --time-zone '$timezone' 2>&1 1>/dev/null)

  if [ $? -eq 0 ]; then
     echo "good job, go ahead!"
  else
     echo "opsss, we got an error:--> $error"

  fi

error=$(gcloud beta scheduler jobs create pubsub $cs_stop_name \
  --schedule '$cron_stop' --topic $ps_stop_name \
  --message-body $message_body \
  --time-zone '$timezone' 2>&1 1>/dev/null)


  if [ $? -eq 0 ]; then
     echo "good job, go ahead!"
  else
     echo "opsss, we got an error:--> $error"

  fi

  echo "if you have got error with cs ..."
  echo "..."
  echo "gcloud beta scheduler jobs create pubsub $cs_start_name --schedule '$cron_start' --topic $ps_start_name --message-body $message_body --time-zone '$timezone'"
  echo "gcloud beta scheduler jobs create pubsub $cs_stop_name --schedule '$cron_stop' --topic $ps_stop_name --message-body $message_body --time-zone '$timezone'"
  echo "Execute these two commands in Cloud Shell"

# remove: gcloud scheduler jobs delete [my-job]
# test: gcloud beta scheduler jobs run $cs_start_name
