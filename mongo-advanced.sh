# Upgrade MongoDB to run on stateful set
helm upgrade orders-mongo stable/mongodb --set replicaSet.enabled=true,mongodbUsername=orders-user,mongodbPassword=orders-password,mongodbDatabase=akschallenge
kubectl get pods -l app=mongodb

# Scale up the number of replicas
kubectl scale statefulset orders-mongo-mongodb-secondary --replicas=3
kubectl get pods -l app=mongodb