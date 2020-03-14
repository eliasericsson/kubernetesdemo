# Get the template for Horizontal autoscaling
wget http://aksworkshop.io/yaml-solutions/01.%20challenge-04/captureorder-hpa.yaml

# Apply the template
kubectl apply -f captureorder-hpa.yaml

# Run the load test again
az container create -g kubernetesdemo -n loadtest --image azch/loadtest --restart-policy Never -e SERVICE_ENDPOINT=https://orders.$INGRESSIP.nip.io

# Watch the pods in your deployment scale
kubectl get pods -l app=captureorder
