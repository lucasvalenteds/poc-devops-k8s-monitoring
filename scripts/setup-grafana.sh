#!/bin/sh

grafana_user="admin"
grafana_password="admin"
grafana_data_source="data_source.json"

service=$1
cluster_ip=$(minikube ip)
cluster_port=$(kubectl get service/"$service" -o jsonpath='{.spec.ports[0].nodePort}')
service_url="http://$cluster_ip:$cluster_port"

import_data_source () {
    curl "$service_url/api/datasources" \
        --request POST \
        --header "Content-Type: application/json" \
        --user $grafana_user:$grafana_password \
        --data-binary @$grafana_data_source
}

export_data_source () {
    data_sources=$(curl -s "$service_url/api/datasources" -u $grafana_user:$grafana_password)
    data_source=$(echo "$data_sources" | jq -c -M '.[0]')
    echo "$data_source" > $grafana_data_source
}

action=$2

if [ "$action" = "import" ]
then
    import_data_source
elif [ "$action" = "export" ]
then
    export_data_source
fi
