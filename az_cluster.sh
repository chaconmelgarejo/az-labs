#!/bin/bash
# create with good vibes by: @chaconmelgarejo
# description: azure cli k8s cluster

# 1.- auth with your suscription
# 2.- define the vars: rg_name / zone / cluster_name / num_nodes 
echo "input rg name:"
read rg_name

#list zones in US
az account list-locations -o table | grep US

echo "input your zone:"
read zone

echo "input the cluster name:"
read cluster_name

echo "input num of nodes:"
read num_nodes

#validate function
confirm() {
  echo "please confirm with [y/n] to continue:"
  read x
}

while true; do
  confirm

  if [[ $x == "y" ]] || [[ $x == "n" ]]
  then
    if [[ "$x" == "y" ]]; then 
        echo "creating the rg ..."
        # create az resource group
        az group create --name $rg_name --location $zone
    
        echo "creating the aks cluster ..."
        # create cluster
        az aks create \
            --resource-group $rg_name \
            --name $cluster_name \
            --node-count $num_nodes \
            --generate-ssh-keys

        # get k8s credentials
        az aks get-credentials --resource-group $rg_name --name $cluster_name
        break
    else
        echo "thanks for save bills"
        break
    fi
  fi
done

# to clean up all
#  az aks delete --name $cluster_name -g $rg_name
#  az group delete --name $rg_name