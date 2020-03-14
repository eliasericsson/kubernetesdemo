# Check that you now have three nodes in your cluster
kubectl get nodes

# Prereq: install helm
# Add the stable helm chart repository to your cluster
helm repo add stable https://kubernetes-charts.storage.googleapis.com/

# Update the charts
helm repo update

# Set the username and password for MongoDB
mongouser="orders-user"
mongopassword="orders-password"
mongohost="orders-mongo-mongodb.default.svc.cluster.local"

# Install a MongoDB database using a helm chart
helm install orders-mongo stable/mongodb --set mongodbUsername=$mongouser,mongodbPassword=$mongopassword,mongodbDatabase=akschallenge

# Create a secret in the AKS cluster to use for authentication to the DB later
kubectl create secret generic mongodb --from-literal=mongoHost=$mongohost --from-literal=mongoUser=$mongouser --from-literal=mongoPassword=$mongopassword
