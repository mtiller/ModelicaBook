TAG = v1.1.0
IMAGE = us-central1-docker.pkg.dev/simulate-book-models/modelica-university/mbe-app

deps:
	yarn install --ignore-optional
	-rm -rf models
	-mkdir models
	tar zxf ../text/results/exes.tar.gz --directory models

# Right now I need to build this on the Mac using colima
image:
	docker buildx build --platform linux/amd64 . -t $(IMAGE):$(TAG)

deploy:
	docker push $(IMAGE):$(TAG)

