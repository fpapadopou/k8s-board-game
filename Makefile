help:
	@echo  'Usage:'
	@echo  '  help            - Display available commands'
	@echo  ''
	@echo  '  local-build     - Build local latest images for both apps (board and client)'
	@echo  '  gcloud-build    - Build and tag latest images for both apps (board and client)'
	@echo  '  gcloud-push     - Push latest images to gcr.io registry'
	@echo  ''

local-build:
	cd board && docker build -t board .
	cd ..
	cd client && docker build -t client .
	cd ..
	@echo 'Updated local app images:'
	docker images

gcloud-build: check-project-id-env
	cd board && docker build -t gcr.io/${PROJECT_ID}/board .
	cd ..
	cd client && docker build -t gcr.io/${PROJECT_ID}/client .
	cd ..
	@echo 'Updated gcr.io app images:'
	docker images

gcloud-push: check-project-id-env
	@echo 'Pushing latest app images to gcr.io registry'
	docker push gcr.io/${PROJECT_ID}/board
	docker push gcr.io/${PROJECT_ID}/client

gcloud-deploy: check-project-id-env
	@echo 'Applying resources updates to cluster'
	cat ./kube/deployments/client-deployment.yaml | sed -E 's/image: client:latest/image: gcr.io\/${PROJECT_ID}\/client:latest/' | sed -E 's/imagePullPolicy: Never/imagePullPolicy: Always/' > ./kube/gcloud-resource-configs/client-deployment.yaml
	cat ./kube/deployments/even-board-deployment.yaml | sed -E 's/image: board:latest/image: gcr.io\/${PROJECT_ID}\/board:latest/' | sed -E 's/imagePullPolicy: Never/imagePullPolicy: Always/' > ./kube/gcloud-resource-configs/even-board-deployment.yaml
	cat ./kube/deployments/odd-board-deployment.yaml | sed -E 's/image: board:latest/image: gcr.io\/${PROJECT_ID}\/board:latest/' | sed -E 's/imagePullPolicy: Never/imagePullPolicy: Always/' > ./kube/gcloud-resource-configs/odd-board-deployment.yaml
	cp ./kube/services/* ./kube/gcloud-resource-configs
	cd kube && kubectly apply -k kustomization.yaml
	cd ..
	@echo 'Done applying resources updates'

check-project-id-env:
ifndef PROJECT_ID
	$(error PROJECT_ID must be defined)
endif