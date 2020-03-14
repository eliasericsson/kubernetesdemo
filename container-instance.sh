# Get the template to enable ACI
wget http://aksworkshop.io/yaml-solutions/advanced/captureorder-deployment-aci.yaml

# Apply the template
kubectl apply -f captureorder-deployment-aci.yaml

# Get running pods
kubectl get pod -l app=captureorder

# Replace ordinary containers with ACI's
kubectl scale deployment captureorder --replicas=0
kubectl scale deployment captureorder-aci --replicas=5

# Test the API again
curl -d '{"EmailAddress": "email@domain.com", "Product": "prod-1", "Total": 100}' -H "Content-Type: application/json" -X POST http://$CAPTUREORDERIP/v1/order
