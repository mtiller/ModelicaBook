# Makefile for Sphinx documentation
#

# You can set these variables from the command line.
SPHINXOPTS    = -q
SPHINXBUILD   = sphinx-build
PAPER         =
BUILDDIR      = build

# Variables for the SVG2PDF generation
SOURCEDIR     = source
#IMAGEDIRS can be a list of directories that contain SVG files and are relative to the SOURCEDIR
IMAGEDIRS      = docs-dir/Icons $(shell find $(SOURCEDIR)/ModelicaByExample/ -name "*.svg" -exec dirname {} ";" | sort -u)

# SVG to PDF conversion
SVG2PDF       = inkscape
SVG2PDF_FLAGS =

SYNC = s3cmd sync -P -F
S3GET = s3cmd get

# Internal variables.
PAPEROPT_a4     = -D latex_paper_size=a4
PAPEROPT_letter = -D latex_paper_size=letter
ALLSPHINXOPTS   = -d $(BUILDDIR)/doctrees $(PAPEROPT_$(PAPER)) $(SPHINXOPTS) source
# the i18n builder cannot share the environment and doctrees with the others
I18NSPHINXOPTS  = $(PAPEROPT_$(PAPER)) $(SPHINXOPTS) source

.PHONY: help clean distclean html dirhtml singlehtml pickle json htmlhelp qthelp devhelp epub latex latexpdf text man changes linkcheck doctest gettext results

# This builds the material necessary to create the book
book: specs results dirhtml server

specs: specs.py
	-mkdir results
	-mkdir results/json
	-mkdir results/js
	-mkdir plots
	-rm -f plots/*
	python specs.py

# This target builds all the simulation results
results:
	@echo "Generate results"
	(cd results; make results_files tidy)

# This builds all the JS and JSON files.  Use this if your development
# environment is setup to compile the JS files
local_js: specs
	@echo "Generate JS files and deploy them"
	(cd results; make js_files json_files tidy)
	-rm results/js/*_node.js
	-rm results/js/*_node.js.gz

# This downloads already compiled JS and JSON files.  Use this if you
# do not have the ability to compile JS files locally
download_js:
	-mkdir results/js
	-mkdir results/json
	(cd results/js; $(SYNC) 's3://beta.book.xogeny.com/_static/js/*.js.gz' .)
	(cd results/js; gzip -dk *.js.gz)
	(cd results/json; $(SYNC) 's3://beta.book.xogeny.com/_static/json/*.json.gz' .)
	(cd results/json; gzip -dk *.json.gz)

# This target builds all the simulation results and then pushes them
# out to an S3 bucket for static hosting
deploy_js: local_js
	(cd results/js; $(SYNC) *.js.gz --add-header=Content-Encoding:gzip s3://beta.book.xogeny.com/_static/js/)
	(cd results/js; $(SYNC) *.xml.gz --add-header=Content-Encoding:gzip s3://beta.book.xogeny.com/_static/js/)
	(cd results/json; $(SYNC) *.json.gz --add-header=Content-Encoding:gzip s3://beta.book.xogeny.com/_static/json/)
	(cd results/js; $(SYNC) *.js s3://beta.book.xogeny.com/_static/js/)
	(cd results/js; $(SYNC) *.xml s3://beta.book.xogeny.com/_static/js/)
	(cd results/json; $(SYNC) *.json s3://beta.book.xogeny.com/_static/json/)

# This target builds all the SVG images
docs:
	@echo "Generate docs"
	-rm -rf docs-dir
	-mkdir docs-dir
#       If you have issues here, make sure you can import OMPython
#       and OMPythonIDL into the default python interpreter (doing
#       a `export PYTHONPATH=...` if necessary.
	(cd docs-dir; omc ../GenerateDoc.mos)

# This creates links for th JS and JSON
build_links:
	-(cd build/dirhtml/_static; ln -s ../../../results/js)
	-(cd build/dirhtml/_static; ln -s ../../../results/json)

# This builds the HTML and then runs a simple web server
server: dirhtml build_links
	(cd build/dirhtml; python -m SimpleHTTPServer)

server_fr: dirhtml_fr build_links
	(cd build/dirhtml_fr; python -m SimpleHTTPServer)

web: dirhtml build_links
	(cd build/dirhtml; $(SYNC) * s3://beta.book.xogeny.com/)
# TODO: Set Content-Encoding on all gz files to be gzip (use find?)

node: dirhtml build_links
	-rm -rf build/node
	-mkdir build/node
	cp -r build/dirhtml/* build/node
	cp nw-package.json build/node/package.json
	cp nw-app.js build/node/app.js
	(cd build/node; npm install)

book.nw: node
	(cd build/node; zip -r ../book.nw .)

help:
	@echo "Please use \`make <target>' where <target> is one of"
	@echo "  html       to make standalone HTML files"
	@echo "  dirhtml    to make HTML files named index.html in directories"
	@echo "  singlehtml to make a single large HTML file"
	@echo "  pickle     to make pickle files"
	@echo "  json       to make JSON files"
	@echo "  htmlhelp   to make HTML files and a HTML help project"
	@echo "  qthelp     to make HTML files and a qthelp project"
	@echo "  devhelp    to make HTML files and a Devhelp project"
	@echo "  epub       to make an epub"
	@echo "  latex      to make LaTeX files, you can set PAPER=a4 or PAPER=letter"
	@echo "  pdf        to make LaTeX files and run them through pdflatex"
	@echo "  latexpdf   alias for pdf"
	@echo "  text       to make text files"
	@echo "  man        to make manual pages"
	@echo "  texinfo    to make Texinfo files"
	@echo "  info       to make Texinfo files and run them through makeinfo"
	@echo "  gettext    to make PO message catalogs"
	@echo "  changes    to make an overview of all changed/added/deprecated items"
	@echo "  linkcheck  to check all external links for integrity"
	@echo "  doctest    to run all doctests embedded in the documentation (if enabled)"

distclean: clean
	-rm -rf results tmp plots
	-rm $(PDFs)

clean:
	-rm -rf $(BUILDDIR)/*

html:
	$(SPHINXBUILD) -b html $(ALLSPHINXOPTS) $(BUILDDIR)/html
	@echo
	@echo "Build finished. The HTML pages are in $(BUILDDIR)/html."

dirhtml:
	$(SPHINXBUILD) -b dirhtml $(ALLSPHINXOPTS) $(BUILDDIR)/dirhtml
	@echo
	@echo "Build finished. The HTML pages are in $(BUILDDIR)/dirhtml."

singlehtml:
	$(SPHINXBUILD) -b singlehtml $(ALLSPHINXOPTS) $(BUILDDIR)/singlehtml
	@echo
	@echo "Build finished. The HTML page is in $(BUILDDIR)/singlehtml."

pickle:
	$(SPHINXBUILD) -b pickle $(ALLSPHINXOPTS) $(BUILDDIR)/pickle
	@echo
	@echo "Build finished; now you can process the pickle files."

json:
	$(SPHINXBUILD) -b json $(ALLSPHINXOPTS) $(BUILDDIR)/json
	@echo
	@echo "Build finished; now you can process the JSON files."

htmlhelp:
	$(SPHINXBUILD) -b htmlhelp $(ALLSPHINXOPTS) $(BUILDDIR)/htmlhelp
	@echo
	@echo "Build finished; now you can run HTML Help Workshop with the" \
	      ".hhp project file in $(BUILDDIR)/htmlhelp."

qthelp:
	$(SPHINXBUILD) -b qthelp $(ALLSPHINXOPTS) $(BUILDDIR)/qthelp
	@echo
	@echo "Build finished; now you can run "qcollectiongenerator" with the" \
	      ".qhcp project file in $(BUILDDIR)/qthelp, like this:"
	@echo "# qcollectiongenerator $(BUILDDIR)/qthelp/ModelicaByExample.qhcp"
	@echo "To view the help file:"
	@echo "# assistant -collectionFile $(BUILDDIR)/qthelp/ModelicaByExample.qhc"

devhelp:
	$(SPHINXBUILD) -b devhelp $(ALLSPHINXOPTS) $(BUILDDIR)/devhelp
	@echo
	@echo "Build finished."
	@echo "To view the help file:"
	@echo "# mkdir -p $$HOME/.local/share/devhelp/ModelicaByExample"
	@echo "# ln -s $(BUILDDIR)/devhelp $$HOME/.local/share/devhelp/ModelicaByExample"
	@echo "# devhelp"

epub:
	$(SPHINXBUILD) -b epub -t epub $(ALLSPHINXOPTS) $(BUILDDIR)/epub
	@echo
	@echo "Build finished. The epub file is in $(BUILDDIR)/epub."

latex:	specs results images
	$(SPHINXBUILD) -b latex $(ALLSPHINXOPTS) $(BUILDDIR)/latex
	@echo
	@echo "Build finished; the LaTeX files are in $(BUILDDIR)/latex."
	@echo "Run \`make' in that directory to run these through (pdf)latex" \
	      "(use \`make latexpdf' here to do that automatically)."

pdf:	latex
	@echo "Running LaTeX files through pdflatex..."
	$(MAKE) -C $(BUILDDIR)/latex all-pdf
	@echo "pdflatex finished; the PDF files are in $(BUILDDIR)/latex."

latexpdf: pdf

text:
	$(SPHINXBUILD) -b text $(ALLSPHINXOPTS) $(BUILDDIR)/text
	@echo
	@echo "Build finished. The text files are in $(BUILDDIR)/text."

man:
	$(SPHINXBUILD) -b man $(ALLSPHINXOPTS) $(BUILDDIR)/man
	@echo
	@echo "Build finished. The manual pages are in $(BUILDDIR)/man."

texinfo:
	$(SPHINXBUILD) -b texinfo $(ALLSPHINXOPTS) $(BUILDDIR)/texinfo
	@echo
	@echo "Build finished. The Texinfo files are in $(BUILDDIR)/texinfo."
	@echo "Run \`make' in that directory to run these through makeinfo" \
	      "(use \`make info' here to do that automatically)."

info:
	$(SPHINXBUILD) -b texinfo $(ALLSPHINXOPTS) $(BUILDDIR)/texinfo
	@echo "Running Texinfo files through makeinfo..."
	make -C $(BUILDDIR)/texinfo info
	@echo "makeinfo finished; the Info files are in $(BUILDDIR)/texinfo."

gettext:
	$(SPHINXBUILD) -b gettext $(I18NSPHINXOPTS) locale/pot
	@echo
	@echo "Build finished. The message catalogs are in $(BUILDDIR)/locale."

update:
	sphinx-intl update -l es -l cn -l fr -l de -d locale/ -p locale/pot

buildmo:
	sphinx-intl build -d locale/ -p locale/pot

dirhtml_es:
	$(SPHINXBUILD) -b dirhtml -d build/doctrees -D language=es source build/dirhtml_es

dirhtml_fr:
	$(SPHINXBUILD) -b dirhtml -d build/doctrees -D language=fr source build/dirhtml_fr

changes:
	$(SPHINXBUILD) -b changes $(ALLSPHINXOPTS) $(BUILDDIR)/changes
	@echo
	@echo "The overview file is in $(BUILDDIR)/changes."

linkcheck:
	$(SPHINXBUILD) -b linkcheck $(ALLSPHINXOPTS) $(BUILDDIR)/linkcheck
	@echo
	@echo "Link check complete; look for any errors in the above output " \
	      "or in $(BUILDDIR)/linkcheck/output.txt."

doctest:
	$(SPHINXBUILD) -b doctest $(ALLSPHINXOPTS) $(BUILDDIR)/doctest
	@echo "Testing of doctests in the sources finished, look at the " \
	      "results in $(BUILDDIR)/doctest/output.txt."


# Pattern rule for converting SVG to PDF (and copying symlinks)
%.pdf:	%.svg
	test -L "$<" || $(SVG2PDF) -f "$<" -A "$@"
	test ! -L "$<" || ln -s `readlink "$<" | sed "s/[.]svg/.pdf/"` "$@"

# Build a list of SVG files to convert to PDFs
PDFs:=	$(foreach dir, $(IMAGEDIRS), $(patsubst %.svg,%.pdf,$(wildcard $(dir)/*.svg)))

# Make a rule to build the PDFs
images:  $(PDFs)
