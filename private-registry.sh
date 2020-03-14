# Create a private container registry
az acr create --resource-group $RESOURCEGROUP --name kubernetesacrxpt --sku Standard --location westeurope

# Clone the repository containing the code
git clone https://github.com/Azure/azch-captureorder.git

# Change directory to the application folder
cd azch-captureorder

# Tell ACR to build the contents of the folder
az acr build -t "captureorder:{{.Run.ID}}" -r kubernetesacrxpt .
cd ..

# Attach the container registry to AKS
az aks update -n akscluster -g $RESOURCEGROUP --attach-acr kubernetesacrxpt

# Replace the image reference in the deployment to match your private registry
sed "s|image: azch/captureorder|image: kubernetesacrxpt.azurecr.io/captureorder:cb1|g" captureorder-deployment.yaml > tmp; mv tmp captureorder-deployment.yaml

# Apply your changes
kubectl apply -f captureorder-deployment.yaml

# Watch your pods get replaced
kubectl get pods

# Replace the image reference in the manifest with your ACR endpoint
sed "s|image: .*|image: kubernetesacrxpt.azurecr.io/captureorder:placeholder|g" azch-captureorder/manifests/deployment.yaml > tmp; mv tmp azch-captureorder/manifests/deployment.yaml

# Replace the image reference in the manifest with your ACR endpoint
sed "s|uniqueacrname|kubernetesacrxpt|g" azch-captureorder/azure-pipelines.yml > tmp; mv tmp azch-captureorder/azure-pipelines.yml
