# This is a root level Makefile that is primarily used by the CI system to
# trigger builds using Docker images (for anything involving non-standard
# tools like OpenModelica).  The goal is that anybody should be able to use
# this Makefile to build the book on any machine that has Docker installed
# on it.
#
# N.B. - Any requires credentials are assumed to be provided by environment
# variables and should *not* be provided here.

BUILDER_IMAGE = mtiller/book-builder
S3BUCKET = beta.book.xogeny.com

.PHONY: all deploy specs results dirhtml apps api publish_server publish_web

all: specs results dirhtml api apps

deploy: publish_server publish_web

specs:
	docker run -v `pwd`:/opt/MBE/ModelicaBook -i -t $(BUILDER_IMAGE) make specs

results:
	docker run -v `pwd`:/opt/MBE/ModelicaBook -i -t $(BUILDER_IMAGE) make results

dirhtml:
	docker run -v `pwd`:/opt/MBE/ModelicaBook -i -t $(BUILDER_IMAGE) make dirhtml

apps:
	(cd apps; git pull && yarn install && yarn build && yarn run deploy -- ../text/build/dirhtml/_static/interact-bundle.js)

api:
	mkdir api/models
	tar zxf text/results/exes.tar.gz --directory api/models
	(cd api; npm install -g dockergen && npm run image)

publish_server:
	docker login -e $(DOCKER_EMAIL) -u $(DOCKER_USER) -p $(DOCKER_PASS)
	docker push $(BUILDER_IMAGE)

publish_web:
	docker run -v `pwd`:/opt/MBE/ModelicaBook -e "AWS_ACCESS_KEY_ID=$(AWS_ACCESS_KEY)" -e "AWS_SECRET_KEY=$(AWS_SECRET_KEY)" -e "S3BUCKET=$(S3BUCKET)" -i -t $(BUILDER_IMAGE) make web
