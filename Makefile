# This is a root level Makefile that is primarily used by the CI system to
# trigger builds using Docker images (for anything involving non-standard
# tools like OpenModelica).  The goal is that anybody should be able to use
# this Makefile to build the book on any machine that has Docker installed
# on it.
#
# N.B. - Any requires credentials are assumed to be provided by environment
# variables and should *not* be provided here.

.PHONY: specs results dirhtml ebooks api publish_server publish_web serve

all: specs results json ebooks pdfs

env:
	dvc cache dir .dvc/cache
	touch .dvc/cache
	rm -f text/dvc.lock
	uname -m > text/build-arch
	-rm -rf "$(HOME)/.openmodelica/libraries/ModelicaByExample 0.6.0" 
	mkdir -p $(HOME)/.openmodelica/libraries
	ln -s $(PWD)/ModelicaByExample "$(HOME)/.openmodelica/libraries/ModelicaByExample 0.6.0" 

specs:
	# dvc repro text/dvc.yaml:build-specs
	# dvc push
	(cd text; make specs)

results: env specs
	# dvc exp run ./text/dvc.yaml
	dvc repro text/dvc.yaml
	# dvc push
	# dvc repro text/dvc.yaml:build-results
	# (cd text; make results)

dirhtml:
	(cd text; make dirhtml)

json:
	(cd text; make json)

ebooks:
	(cd text; make ebooks)

pdfs:
	(cd text; make pdf pdf-a4)
