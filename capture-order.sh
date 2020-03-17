# Get the deployment template
wget http://aksworkshop.io/yaml-solutions/01.%20challenge-02/captureorder-deployment.yaml

# Apply the deployment template
kubectl apply -f captureorder-deployment.yaml

# Get the service template that exposes the captureorder deployment
wget http://aksworkshop.io/yaml-solutions/01.%20challenge-02/captureorder-service.yaml

# Apply the template
kubectl apply -f captureorder-service.yaml

# Get the IP on which the service is exposed
until [[ $(kubectl get svc captureorder -o jsonpath='{.status.loadBalancer.ingress[*].ip}') ]]
do
    echo "Waiting for IP..."
    sleep 10
done
CAPTUREORDERIP=$(kubectl get svc captureorder -o jsonpath="{.status.loadBalancer.ingress[*].ip}")

# When the service has finished exposing the deployment curl the address
curl -d '{"EmailAddress": "email@domain.com", "Product": "prod-1", "Total": 100}' -H "Content-Type: application/json" -X POST http://$CAPTUREORDERIP/v1/order
