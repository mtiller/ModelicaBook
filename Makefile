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

.PHONY: all deploy specs results dirhtml apps api publish_server publish_web serve

all: specs results dirhtml apps

deploy: api publish_server publish_web

deps:
	docker pull $(BUILDER_IMAGE)

specs: deps
	docker run -v `pwd`:/opt/MBE/ModelicaBook -i -t $(BUILDER_IMAGE) make specs

results: deps
	docker run -v `pwd`:/opt/MBE/ModelicaBook -i -t $(BUILDER_IMAGE) make results

dirhtml: deps
	docker run -v `pwd`:/opt/MBE/ModelicaBook -i -t $(BUILDER_IMAGE) make dirhtml
	find text/build/dirhtml -name '*.html' -exec ./inline-math.sh {} \;

epub: deps
	docker run -v `pwd`:/opt/MBE/ModelicaBook -i -t $(BUILDER_IMAGE) make epub
	find text/build/epub -name '*.html' -exec ./inline-math.sh {} \;
	# This is the bit that does not work.  Need to repackage epub without regenerating source...
	docker run -v `pwd`:/opt/MBE/ModelicaBook -e "SPHINXDEPS=''" -i -t $(BUILDER_IMAGE) make epub

apps: deps
	(cd apps; yarn install && yarn build && yarn run deploy -- ../text/build/dirhtml/_static/interact-bundle.js)

serve:
	(cd text/build/dirhtml; serve -p 5001)

# Note, this step will fail if you haven't set the NPM_TOKEN environment variable
api:
	- rm -rf api/models
	- mkdir api/models
	tar zxf text/results/exes.tar.gz --directory api/models
	(cd api; npm install -g dockergen && npm run image)

# This target requires the DOCKER_* environment variables to be set
publish_server:
	docker login -e $(DOCKER_EMAIL) -u $(DOCKER_USER) -p $(DOCKER_PASS)
	docker push $(BUILDER_IMAGE)

# This target requires the AWS_*_KEY environment variables to be set
publish_web:
	docker run -v `pwd`:/opt/MBE/ModelicaBook -e "AWS_ACCESS_KEY_ID=$(AWS_ACCESS_KEY)" -e "AWS_SECRET_KEY=$(AWS_SECRET_KEY)" -e "S3BUCKET=$(S3BUCKET)" -i -t $(BUILDER_IMAGE) make web
