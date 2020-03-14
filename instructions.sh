# Choose a name for your resource group
echo "Set a name for the resource group: "
read RESOURCEGROUP

### BASIC CLUSTER ###
source cluster-basic.sh

### MONGODB ###
source mongo-basic.sh

### CAPTURE ORDER ###
source capture-order.sh

### FRONTEND ###
source frontend.sh

### INGRESS ###
source ingress.sh

### CERT MANAGER ###
source cert-manager.sh

### MONITORING ###
source monitoring.sh

### HORIZONTAL AUTOSCALING ###
source horizontalautoscaling.sh

### PRIVATE REGISTRY ###
source private-registry.sh

### ADVANCED CLUSTER ###
source cluster-advanced.sh

### MONGODB ###
source mongo-basic.sh

### CAPTURE ORDER ###
source capture-order.sh

### FRONTEND ###
source frontend.sh

### INGRESS ###
source ingress.sh

### CERT MANAGER ###
source cert-manager.sh

### MONITORING ###
source monitoring.sh

### HORIZONTAL AUTOSCALING ###
source horizontalautoscaling.sh

### PRIVATE REGISTRY ###
source private-registry.sh

### CONTAINER INSTANCE SCALING ###
source container-instance.sh

### MONGODB ON STATEFUL SETS ###
source mongo-advanced.sh

### KEY VAULT SECRETS ###
source keyvault-secrets.sh