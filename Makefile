# This is a root level Makefile that is primarily used by the CI system to
# trigger builds using Docker images (for anything involving non-standard
# tools like OpenModelica).  The goal is that anybody should be able to use
# this Makefile to build the book on any machine that has Docker installed
# on it.
#
# N.B. - Any requires credentials are assumed to be provided by environment
# variables and should *not* be provided here.

.PHONY: specs results dirhtml ebooks api publish_server publish_web serve

specs:
	(cd text; make specs)

results:
	(cd text; make results)

dirhtml:
	(cd text; make dirhtml)

json:
	(cd text; make json)

ebooks:
	(cd text; make ebooks)

pdfs:
	(cd text; make pdf pdf-a4)
