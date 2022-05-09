group=PFAzure-TrafficManager
az group create -g $group -l australiaeast
username=adminuser
password='SecretPassword123!@#'
az vm create \
  -n vm-OzEast \
  -g $group \
  -l australiaeast \
  --image Win2019Datacenter \
  --admin-username $username \
  --public-ip-sku Standard \
  --admin-password $password \
  --nsg-rule rdp
  
az vm create \
  -n vm-eastus \
  -g $group \
  -l eastus \
  --image Win2019Datacenter \
  --admin-username $username \
  --admin-password $password \
  --public-ip-sku Standard \
  --nsg-rule rdp

az appservice plan create \
  -n web-eastus-plan \
  -g $group \
  -l eastus \
  --sku S1
  
appname=demo-web-eastus-$RANDOM$RANDOM
az webapp create \
  -n $appname \
  -g $group \
  -p web-eastus-plan
  
az appservice plan create \
  -n web-australiaeast-plan \
  -g $group \
  -l australiaeast \
  --sku S1
  
appname=demo-web-australiaeast-$RANDOM$RANDOM
az webapp create \
  -n $appname \
  -g $group \
  -p web-australiaeast-plan
  
az webapp list -g $group --query "[].enabledHostNames" -o jsonc

az vm list \
  -g $group -d \
  --query "[].{name:name,ip:publicIps,user:osProfile.adminUsername,password:'$password'}" \
  -o jsonc

