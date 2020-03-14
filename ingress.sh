# Create a namespace to later put our ingress controller
kubectl create namespace ingress

# Install the NGINX ingress controller in said namespace
helm install ingress stable/nginx-ingress --namespace ingress

# Get the IP from the service, might take a few minutes
until [[ $(kubectl get svc -n ingress ingress-nginx-ingress-controller -o jsonpath='{.status.loadBalancer.ingress[*].ip}') ]]
do
    echo "Waiting for IP..."
    sleep 10
done
INGRESSIP=$(kubectl get svc -n ingress ingress-nginx-ingress-controller -o jsonpath="{.status.loadBalancer.ingress[*].ip}")

# Get the frontend ingress template
wget http://aksworkshop.io/yaml-solutions/01.%20challenge-02/frontend-ingress.yaml

# Apply the template
kubectl apply -f frontend-ingress.yaml