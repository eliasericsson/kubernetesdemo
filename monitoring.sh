# Create a Operational Insights workspace
az resource create \
  --resource-type Microsoft.OperationalInsights/workspaces \
  --name akslogsxpt \
  --resource-group $RESOURCEGROUP \
  --location westeurope \
  --properties '{}' \
  --output table

# Get the resource ID from said workspace
WORKSPACEID=$(az resource show --resource-type Microsoft.OperationalInsights/workspaces --name akslogsxpt --resource-group kubernetesdemo --query "id" -o tsv)

# Enable the monitoring add-on
az aks enable-addons --resource-group kubernetesdemo --name akscluster --addons monitoring --workspace-resource-id $WORKSPACEID

# Get the log reader RBAC template
wget http://aksworkshop.io/yaml-solutions/01.%20challenge-03/logreader-rbac.yaml

# Apply the template
kubectl apply -f logreader-rbac.yaml

# Get the prometheus metrics demo
wget http://aksworkshop.io/yaml-solutions/01.%20challenge-03/prommetrics-demo.yaml

# Apply the template
kubectl apply -f prommetrics-demo.yaml

# List the resulting pods
#kubectl get pods | grep prommetrics-demo

# In a new terminal attach the pod
#kubectl exec -it prommetrics-demo-7c645c76b-5s7pd bash

# In the pod, run command:
#while (true); do curl 'http://prommetrics-demo.default.svc.cluster.local:8080'; sleep 5; done

# In the main terminal, get the config man template
wget http://aksworkshop.io/yaml-solutions/01.%20challenge-03/configmap.yaml

# Apply the template
kubectl apply -f configmap.yaml

# Run the following log query in AKS in the Azure portal (may take some time)
: '
InsightsMetrics
| where Name == prommetrics_demo_requests_counter_total
| extend dimensions=parse_json(Tags)
| extend request_status = tostring(dimensions.request_status)
| where request_status == bad
| project request_status, Val, TimeGenerated
| render timechart
'

# Create an Azure Container Instance to perform load testing
az container create -g kubernetesdemo -n loadtest --image azch/loadtest --restart-policy Never -e SERVICE_ENDPOINT=https://orders.$INGRESSIP.nip.io

# Read the logs of the container instance
az container logs -g kubernetesdemo -n loadtest --follow

# Delete the container instance after completing the test
az container delete -g kubernetesdemo -n loadtest
