#!/bin/bash
# create with good vibes by: @chaconmelgarejo
# description: create vm and show its info
# 1.- do "az login" and configure - we need to have a rg created
# 2.- define the vars: rg_name / app_name / zone

echo "input rg name (to create or delete): "
read rg_name

echo "input app_name name (to create or delete): "
read app_name

echo "input zone name *skip if you want delete resources*[centralus]: "
read zone



while true; do
  echo "do you want to delete existing resorces [y/n]:"
  read input_user

  if [[ $input_user == "y" ]] || [[ $input_user == "n" ]]
    then
        if [[ "$input_user" == "y" ]]; then
          az container delete --name $app_name -g $rg_name
          az group delete --name $rg_name
          break
        else
          echo "creating the rg ..."
          # create az resource group
          az group create --name $rg_name --location $zone

          # random dns label
          DNS_NAME_LABEL=$app_name-$RANDOM

          echo "creating a test container ..."
          az container create \
            --resource-group $rg_name \
            --name $app_name \
            --image microsoft/aci-helloworld \
            --ports 80 \
            --dns-name-label $DNS_NAME_LABEL \
            --location $zone

          az container show \
            --resource-group $rg_name \
            --name $app_name \
            --query "{FQDN:ipAddress.fqdn,ProvisioningState:provisioningState}" \
            --out table

          break
      fi
  fi
done
