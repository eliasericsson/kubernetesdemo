# Install the CustomResourceDefinition resources separately
kubectl apply --validate=false -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.11/deploy/manifests/00-crds.yaml

# Create the namespace for cert-manager
kubectl create namespace cert-manager

# Add the Jetstack Helm repository
helm repo add jetstack https://charts.jetstack.io

# Update your local Helm chart repository cache
helm repo update

# Install the cert-manager Helm chart
helm install cert-manager --namespace cert-manager jetstack/cert-manager

# Get the let's encrypt cluster issuer template
wget http://aksworkshop.io/yaml-solutions/advanced/letsencrypt-clusterissuer.yaml

# Replace the token in the template
sed "s/_YOUR_EMAIL_/elias.ericsson.rydberg@xperta.se/g" letsencrypt-clusterissuer.yaml > tmp; mv tmp letsencrypt-clusterissuer.yaml

# Apply the template
kubectl apply -f letsencrypt-clusterissuer.yaml

# Get the new template the supports TLS
wget http://aksworkshop.io/yaml-solutions/advanced/frontend-ingress-tls.yaml

# Replace the placeholder in the template with the IP of the ingress
sed "s/_INGRESS_CONTROLLER_EXTERNAL_IP_/$INGRESSIP/g" frontend-ingress-tls.yaml > tmp; mv tmp frontend-ingress-tls.yaml

# Apply the template
kubectl apply -f frontend-ingress-tls.yaml

# Describe the certificate until you see a successful issuing at the bottom
kubectl describe certificate frontend
