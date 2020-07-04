help:
	@echo  'Usage:'
	@echo  '  help            - Display available commands'
	@echo  ''
	@echo  '  gcloud-build    - Build and tag latest images for both apps (board and client)'
	@echo  '  gcloud-push     - Push latest images to gcr.io registry'
	@echo  ''

gcloud-build: check-project-id-env
	cd board && docker build -t gcr.io/${PROJECT_ID}/board .
	cd ..
	cd client && docker build -t gcr.io/${PROJECT_ID}/client ./
	cd ..
	@echo 'Updated app images:'
	docker images

gcloud-push: check-project-id-env
	docker push gcr.io/${PROJECT_ID}/board
	docker push gcr.io/${PROJECT_ID}/client


check-project-id-env:
ifndef PROJECT_ID
	$(error PROJECT_ID must be defined)
endif