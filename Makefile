SERVICE = server
SCALE ?= 5

monitoring-up:
	@kubectl apply --filename=k8s-prometheus.yml
	@kubectl apply --filename=k8s-grafana.yml

monitoring-down:
	@kubectl delete --filename=k8s-prometheus.yml
	@kubectl delete --filename=k8s-grafana.yml

server-build:
	@npm --prefix ./server install
	@npm --prefix ./server run build
	@docker build --no-cache --file server/Dockerfile --tag $(SERVICE) server

server-up:
	@kubectl apply --filename=k8s-server.yml

server-down:
	@kubectl delete --filename=k8s-server.yml

server-logs:
	@kubectl logs --selector app=$(SERVICE) --follow

server-info:
	@kubectl get service $(SERVICE)
	@kubectl get pods --selector app=$(SERVICE)

server-scale:
	@kubectl scale --replicas=$(SCALE) deployment/$(SERVICE)

server-test:
	@./test.sh $(SERVICE)
