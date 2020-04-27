#!/bin/bash
# maintainer with good vibes by: alejandro.chacon
# description: KMS test

#kms vars
ring_name="local-vault"
key_name="cluster-keys"
project_name="starmeup-data-platform-dev"
cluster_zone="us-central1"

# kms conf - we need first enable kms api for the project
gcloud kms keyrings create $ring_name \
    --location $cluster_zone \
    --project $project_name

# create key
gcloud kms keys create $key_name --location $cluster_zone \
  --keyring $ring_name \
  --purpose encryption

#list the keys
gcloud kms keys list \
  --location $cluster_zone \
  --keyring $ring_name

# encrypt my secrets
gcloud kms encrypt --location $cluster_zone \
  --keyring $ring_name --key $key_name \
  --plaintext-file mysecret.txt \
  --ciphertext-file mysecret.txt.encrypted

# decrypt my secrets

gcloud kms decrypt \
  --location $cluster_zone \
  --keyring $ring_name \
  --key $key_name \
  --ciphertext-file mysecret.txt.encrypted \
  --plaintext-file mysecret.txt.decrypted

# clean up
gcloud kms keys versions list --location $cluster_zone \
  --keyring $ring_name --key $key_name

gcloud kms keys versions destroy [key-version] \
  --location $cluster_zone \
  --keyring $ring_name \
  --key $key_name