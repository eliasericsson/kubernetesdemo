# Get the template for the frontend deployment
wget http://aksworkshop.io/yaml-solutions/01.%20challenge-02/frontend-deployment.yaml

# Replace the token in the template with the IP of the capture service
sed "s/_PUBLIC_IP_CAPTUREORDERSERVICE_/$CAPTUREORDERIP/g" frontend-deployment.yaml > tmp; mv tmp frontend-deployment.yaml

# Apply the template
kubectl apply -f frontend-deployment.yaml

# Get the template for the service that exposes the frontend
wget http://aksworkshop.io/yaml-solutions/01.%20challenge-02/frontend-service.yaml

# Apply the frontend
kubectl apply -f frontend-service.yaml
