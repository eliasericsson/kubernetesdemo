# Set a name for the virtual network
echo "Set a name for the virtual network: "
read VNETNAME

# Create a virtual network
read VNETID SUBNET < <(echo $(az network vnet create \
  --resource-group $RESOURCEGROUP \
  --name $VNETNAME \
  --address-prefixes 10.0.0.0/8 \
  --subnet-name sub-AKS \
  --subnet-prefix 10.240.0.0/16 \
  --query "[newVNet.id, newVNet.subnets[0].id]" \
  --output tsv))

# Set a name for the subnet
echo "Set a name for the virtual node subnet: "
read VIRTUALNODESSUBNET

# Create a subnet for the AKS cluster
VNODESSUBNET=$(az network vnet subnet create \
  --resource-group $RESOURCEGROUP \
  --vnet-name $VNETNAME \
  --name $VIRTUALNODESSUBNET \
  --address-prefixes 10.241.0.0/16 \
  --query id \
  --output tsv)

# Give the service principal contributor rights on the network
az role assignment create --assignee $APPID --scope $VNETID --role Contributor

# Get the latest version of the orchestrator
VERSION=$(az aks get-versions -l westeurope --query "orchestrators[-1].orchestratorVersion" -o tsv)

# Conditionally register the service provider for container instances
state=$(az provider list --query "[?contains(namespace, 'Microsoft.ContainerInstance')].registrationState" -o tsv)
if [[ $state == Registered ]]
then
  echo "Container Instance provider already registered"
else
  az provider register --namespace Microsoft.ContainerInstance
fi

# Set a new name for the AKS cluster with advanced networking
echo "Set a name for the Azure Kubernetes Service (advanced): "
read AKSNAMEADV

# Create a cluster with advanced networking
az aks create \
  --resource-group $RESOURCEGROUP \
  --name $AKSNAMEADV \
  --node-count 2 \
  --kubernetes-version $VERSION \
  --network-plugin azure \
  --service-cidr 10.0.0.0/16 \
  --dns-service-ip 10.0.0.10 \
  --docker-bridge-address 172.17.0.1/16 \
  --vnet-subnet-id $SUBNET \
  --service-principal $APPID \
  --client-secret $APPSECRET

az aks get-credentials --name $AKSNAMEADV --resource-group $RESOURCEGROUP

kubectl get nodes

az aks enable-addons \
  --resource-group $RESOURCEGROUP \
  --name $AKSNAMEADV \
  --addons virtual-node \
  --subnet-name $VIRTUALNODESSUBNET
