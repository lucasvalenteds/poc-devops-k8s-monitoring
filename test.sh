#/bin/sh

service=$1
cluster_ip=$(minikube ip)
cluster_port=$(kubectl get service/$service -o jsonpath='{.spec.ports[0].nodePort}')

service_url="http://$cluster_ip:$cluster_port"

npx autocannon --connections 30 --method GET --duration 60 $service_url
