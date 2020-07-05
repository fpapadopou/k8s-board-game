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
	cd client && docker build -t client ./
	cd ..
	@echo 'Updated local app images:'
	docker images

gcloud-build: check-project-id-env
	cd board && docker build -t gcr.io/${PROJECT_ID}/board .
	cd ..
	cd client && docker build -t gcr.io/${PROJECT_ID}/client ./
	cd ..
	@echo 'Updated gcr.io app images:'
	docker images

gcloud-push: check-project-id-env
	@echo 'Pushing latest app images to gcr.io registry'
	docker push gcr.io/${PROJECT_ID}/board
	docker push gcr.io/${PROJECT_ID}/client


check-project-id-env:
ifndef PROJECT_ID
	$(error PROJECT_ID must be defined)
endif