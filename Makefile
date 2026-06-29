# This is a root level Makefile that is primarily used by the CI system to
# trigger builds using Docker images (for anything involving non-standard
# tools like OpenModelica).  The goal is that anybody should be able to use
# this Makefile to build the book on any machine that has Docker installed
# on it.
#
# N.B. - Any requires credentials are assumed to be provided by environment
# variables and should *not* be provided here.

.PHONY: specs results dirhtml ebooks api publish_server publish_web serve

# When CI_BUILD=1, the json/dirhtml/pdfs targets skip the specs+results
# (DVC repro) dependency chain and assume text/results, text/plots, and
# text/docs-dir are already populated (e.g. restored from cache in CI).
# text/Makefile already has matching CI_BUILD support that drops the same
# deps from its sphinx targets. Default (CI_BUILD=0) preserves the old
# behavior so local builds work unchanged.
CI_BUILD ?= 0
ifeq ($(CI_BUILD),1)
SPHINX_DEPS =
else
SPHINX_DEPS = results
endif

all: specs results json ebooks pdfs

env:
	dvc cache dir .dvc/cache
	-mkdir .dvc/cache
	uname -m > text/build-arch
	-rm -rf "$(HOME)/.openmodelica/libraries/ModelicaByExample 0.6.0"
	mkdir -p $(HOME)/.openmodelica/libraries
	ln -s $(PWD)/ModelicaByExample "$(HOME)/.openmodelica/libraries/ModelicaByExample 0.6.0"

specs:
	(cd text; make specs)

results: env specs
	(cd text; make results)

dirhtml: $(SPHINX_DEPS)
	(cd text; make dirhtml)

json: $(SPHINX_DEPS)
	(cd text; make json json_kr)

ebooks:
	(cd text; make ebooks)

pdfs:
	(cd text; make pdf pdf-a4)

site:
	(cd nextgen; make all)

deploy_site:
	(cd nextgen; yarn deploy)

clean:
	git clean -fdx text
	git clean -fdx api
	git clean -fdx ModelicaByExample