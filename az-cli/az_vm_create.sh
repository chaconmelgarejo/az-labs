#!/bin/bash
# create with good vibes by: @chaconmelgarejo
# description: create vm and show its info
# 1.- do "az login" and configure - we need to have a rg created
# 2.- define the vars: rg_name / vm_name  / vm_image / zone

echo "input rg name (to create or delete): "
read rg_name

echo "input vm name (to create or delete): "
read vm_name

echo "input zone name *skip if you want delete resources*[centralus]: "
read zone

echo "input image *skip if you want delete resources*[UbuntuLTS]: "
read image

while true; do
  echo "do you want to delete existing resorces [y/n]:"
  read input_user
  
  if [[ $input_user == "y" ]] || [[ $input_user == "n" ]]
    then
        if [[ "$input_user" == "y" ]]; then
            az vm delete --name $vm_name -g $rg_name
            az group delete --name $rg_name
            break
        else
            echo "creating the rg ..."
            # create az resource group
            az group create --name $rg_name --location $zone

            echo "creating the vm..."
            az vm create --resource-group $rg_name \
                --name $vm_name \
                --image $image \
                --generate-ssh-keys \
                --output json \
                --verbose

                # show the vm info
            my_ip=$(az vm show --name $vm_name --resource-group $rg_name --query publicIpAddress -o tsv)
            echo $my_ip
            break
         fi
    fi
done