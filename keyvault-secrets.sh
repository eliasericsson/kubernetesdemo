# Create a Key Vault
read KVNAME
KVID=$(az keyvault create --resource-group $RESOURCEGROUP --name $KVNAME --query id --output tsv)

# Add the password to the Key Vault
az keyvault secret set --vault-name $KVNAME --name mongo-password --value "orders-password"

# Give the service principal access to the Key Vault resource
az role assignment create --role Reader --assignee $APPID --scope $KVID

# Give the service principal access to the secrets
az keyvault set-policy -n $KVNAME --secret-permissions get --spn $APPID

# Create a Kubernetes secret that enables access to the service principal
kubectl create secret generic kvcreds --from-literal clientid=$APPID --from-literal clientsecret=$APPSECRET --type=azure/kv

# Create the flex volume
kubectl create -f https://raw.githubusercontent.com/Azure/kubernetes-keyvault-flexvol/master/deployment/kv-flexvol-installer.yaml

wget http://aksworkshop.io/yaml-solutions/advanced/captureorder-deployment-flexvol.yaml

SUBSCRIPTIONID=$(az account show --query id --output tsv)
TENANTID=$(az account show --query tenantId --output tsv)

# Replace tokens
sed "s/<unique\ keyvault\ name>/$KVNAME/g" captureorder-deployment-flexvol.yaml > tmp; mv tmp captureorder-deployment-flexvol.yaml
sed "s/<kv\ resource\ group>/$RESOURCEGROUP/g" captureorder-deployment-flexvol.yaml > tmp; mv tmp captureorder-deployment-flexvol.yaml
sed "s/<kv\ azure\ subscription\ id>/$SUBSCRIPTIONID/g" captureorder-deployment-flexvol.yaml > tmp; mv tmp captureorder-deployment-flexvol.yaml
sed "s/<kv\ azure\ tenant\ id>/$TENANTID/g" captureorder-deployment-flexvol.yaml > tmp; mv tmp captureorder-deployment-flexvol.yaml

# Apply the template
kubectl apply -f captureorder-deployment-flexvol.yaml