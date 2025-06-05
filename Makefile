NAMESPACE=dbgpt
SERVICE_DIR=service
DATABASE_DIR=database

.PHONY: all create-ns apply delete status logs port-forward create-secret

all: create-ns apply

create-ns:
	kubectl get ns $(NAMESPACE) || kubectl create namespace $(NAMESPACE)

apply:
	kubectl apply -f $(DATABASE_DIR)/ -n $(NAMESPACE)
	kubectl apply -f $(SERVICE_DIR)/ -n $(NAMESPACE)

delete:
	kubectl delete -f $(SERVICE_DIR)/ -n $(NAMESPACE) --ignore-not-found
	kubectl delete -f $(DATABASE_DIR)/ -n $(NAMESPACE) --ignore-not-found

status:
	kubectl get all -n $(NAMESPACE)
	kubectl get pvc -n $(NAMESPACE)
	kubectl get configmap -n $(NAMESPACE)

logs:
	@echo "用法: make logs POD=pod-name"
	kubectl logs -n $(NAMESPACE) $${POD}

port-forward:
	@echo "用法: make port-forward SERVICE=webserver LOCAL_PORT=5670 REMOTE_PORT=5670"
	kubectl port-forward svc/$${SERVICE} $${LOCAL_PORT}:$${REMOTE_PORT} -n $(NAMESPACE)

create-secret:
	@echo "用法: make create-secret KEY=your_key"
	kubectl create secret generic siliconflow-api-key --from-literal=SILICONFLOW_API_KEY=$${KEY} -n $(NAMESPACE) --dry-run=client -o yaml | kubectl apply -f -
	
