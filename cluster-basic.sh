# Choose a name for your Azure Kubernetes Service
echo "Set a name for the Azure Kubernetes Service: "
read AKSNAME

# Create a resource group in Azure
az group create -n $RESOURCEGROUP --location westeurope

# Create a service principal in Azure
read APPID APPSECRET < <(echo $(az ad sp create-for-rbac --name $AKSNAME | jq -r '.appId, .password'))

# Create an AKS cluster and get the credentials
az aks create --resource-group $RESOURCEGROUP --name $AKSNAME --service-principal $APPID --client-secret $APPSECRET
az aks get-credentials --resource-group $RESOURCEGROUP --name $AKSNAME