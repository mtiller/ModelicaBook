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
IMAGEDIRS      = docs-dir/Icons source/_static/img $(shell find $(SOURCEDIR)/ModelicaByExample/ -name "*.svg" -exec dirname {} ";" | sort -u)

# SVG to PDF conversion
SVG2PDF       = rsvg-convert
SVG2PDF_FLAGS =

S3CMD = s3cmd $(S3FLAGS)

SYNC = $(S3CMD) sync -P -F
S3GET = $(S3CMD) get
S3PUT = $(S3CMD) put -P
S3BUCKET = book.xogeny.com

# Internal variables.
PAPEROPT_a4     = -D latex_paper_size=a4
PAPEROPT_letter = -D latex_paper_size=letter
ALLSPHINXOPTS   = -d $(BUILDDIR)/doctrees $(PAPEROPT_$(PAPER)) $(SPHINXOPTS) source
# the i18n builder cannot share the environment and doctrees with the others
I18NSPHINXOPTS  = $(PAPEROPT_$(PAPER)) $(SPHINXOPTS) source

.PHONY: help clean distclean html dirhtml singlehtml pickle json htmlhelp qthelp devhelp epub latex latexpdf pdf text man changes linkcheck doctest gettext results

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
	-rm -f results/js/*_node.js
	-rm -f results/js/*_node.js.gz

# This downloads already compiled JS and JSON files.  Use this if you
# do not have the ability to compile JS files locally
download_js:
	-mkdir results/js
	-mkdir results/json
	(cd results/js; $(SYNC) 's3://$(S3BUCKET)/_static/js/*.js.gz' .)
	(cd results/js; gzip -dk *.js.gz)
	(cd results/json; $(SYNC) 's3://$(S3BUCKET)/_static/json/*.json.gz' .)
	(cd results/json; gzip -dk *.json.gz)

# This target builds all the simulation results and then pushes them
# out to an S3 bucket for static hosting
deploy_js: local_js
	(cd results/js; $(SYNC) *.js.gz --add-header=Content-Encoding:gzip s3://$(S3BUCKET)/_static/js/)
	(cd results/js; $(SYNC) *.xml.gz --add-header=Content-Encoding:gzip s3://$(S3BUCKET)/_static/js/)
	(cd results/json; $(SYNC) *.json.gz --add-header=Content-Encoding:gzip s3://$(S3BUCKET)/_static/json/)
	(cd results/js; $(SYNC) *.js s3://$(S3BUCKET)/_static/js/)
	(cd results/js; $(SYNC) *.xml s3://$(S3BUCKET)/_static/js/)
	(cd results/json; $(SYNC) *.json s3://$(S3BUCKET)/_static/json/)

# This target builds the PDF and the epub version and pushes them
# out to an S3 bucket

deploy_print: pdf ebook
	($(S3PUT) build/latex/ModelicaByExample.pdf s3://files.xogeny.com/ModelicaByExample/)
	($(S3PUT) build/latex-a4/ModelicaByExample.pdf s3://files.xogeny.com/ModelicaByExample/ModelicaByExample-a4.pdf)

	($(S3PUT) build/epub/ModelicabyExample.epub s3://files.xogeny.com/ModelicaByExample/ModelicaByExample.epub)
	($(S3PUT) build/epub/ModelicaByExample.mobi s3://files.xogeny.com/ModelicaByExample/)



# This target builds all the SVG images of icons
icons:
	@echo "Generate Icons"
	-rm -rf docs-dir
	-mkdir docs-dir
#       If you have issues here, make sure you can import OMPython
#       and OMPythonIDL into the default python interpreter (doing
#       a `export PYTHONPATH=...` if necessary.
	(cd docs-dir; omc ../GenerateIcons.mos)

# This creates links for the JS and JSON and puts the sitemap and robots
# files where they need to be
build_links:
	cp build/dirhtml/_static/sitemap.xml build/dirhtml
	cp build/dirhtml/_static/robots.txt build/dirhtml

	-(cd build/dirhtml/_static; ln -s ../../../results/js)
	-(cd build/dirhtml/_static; ln -s ../../../results/json)

build_links_cn:
	cp build/dirhtml_cn/_static/sitemap.xml build/dirhtml_cn
	cp build/dirhtml_cn/_static/robots.txt build/dirhtml_cn

	-(cd build/dirhtml_cn/_static; ln -s ../../../results/js)
	-(cd build/dirhtml_cn/_static; ln -s ../../../results/json)

# This builds the HTML and then runs a simple web server
server: dirhtml build_links
	(cd build/dirhtml; python -m SimpleHTTPServer)

server_cn: dirhtml_cn build_links_cn
	(cd build/dirhtml_cn; python -m SimpleHTTPServer)

#server_de: dirhtml_de build_links
#	(cd build/dirhtml_de; python -m SimpleHTTPServer)

#server_es: dirhtml_es build_links
#	(cd build/dirhtml_es; python -m SimpleHTTPServer)

#server_fr: dirhtml_fr build_links
#	(cd build/dirhtml_fr; python -m SimpleHTTPServer)

#server_it: dirhtml_it build_links
#	(cd build/dirhtml_it; python -m SimpleHTTPServer)

web: dirhtml build_links
	(cd build/dirhtml; $(SYNC) * s3://$(S3BUCKET)/)

web_cn: dirhtml_cn build_links_cn
	(cd build/dirhtml_cn; $(SYNC) * s3://$(S3BUCKET)/cn/)

#web_de: dirhtml_de build_links
#	(cd build/dirhtml_de; $(SYNC) * s3://$(S3BUCKET)/de/)

#web_es: dirhtml_es build_links
#	(cd build/dirhtml_es; $(SYNC) * s3://$(S3BUCKET)/es/)

#web_fr: dirhtml_fr build_links
#	(cd build/dirhtml_fr; $(SYNC) * s3://$(S3BUCKET)/fr/)

#web_it: dirhtml_it build_links
#	(cd build/dirhtml_it; $(SYNC) * s3://$(S3BUCKET)/it/)

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
	$(foreach file, $(PDFs), $(shell rm -f "$(file)"))

clean:
	-rm -rf $(BUILDDIR)/*

html:
	$(SPHINXBUILD) -b html  $(ALLSPHINXOPTS) $(BUILDDIR)/html
	@echo
	@echo "Build finished. The HTML pages are in $(BUILDDIR)/html."

dirhtml:
	$(SPHINXBUILD) -b dirhtml  $(ALLSPHINXOPTS) $(BUILDDIR)/dirhtml
	@echo
	@echo "Build finished. The HTML pages are in $(BUILDDIR)/dirhtml."

singlehtml:
	$(SPHINXBUILD) -b singlehtml  $(ALLSPHINXOPTS) $(BUILDDIR)/singlehtml
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

mobi:   epub
	(cd $(BUILDDIR)/epub; ebook-convert ModelicabyExample.epub ModelicaByExample.mobi)
	@echo
	@echo "Conversion to mobi finished. The mobi file is in $(BUILDDIR)/epub."

ebook:  epub mobi

latex: latex-letter latex-a4

latex-letter: specs results images
	@echo
	@echo "Applying horrible LaTeX hack..."
	-mkdir build
	git checkout $(SOURCEDIR)/index.rst # make sure we have pristine index.rst
	cp $(SOURCEDIR)/index.rst $(BUILDDIR)/index.rst.orig
	(echo "#####\nDUMMY\n#####"; cat $(BUILDDIR)/index.rst.orig) > $(SOURCEDIR)/index.rst
	@echo
	$(SPHINXBUILD) -b latex -t latex $(ALLSPHINXOPTS) $(BUILDDIR)/latex
	@echo "Reverting horrible LaTeX hack..."
	git checkout $(SOURCEDIR)/index.rst # revert back to pristine index.rst
	@echo
	@echo "Build finished; the LaTeX files are in $(BUILDDIR)/latex."
	@echo "Run \`make' in that directory to run these through (pdf)latex" \
	      "(use \`make latexpdf' here to do that automatically)."


latex-a4: specs results images
	@echo
	@echo "Applying horrible LaTeX hack..."
	-mkdir build
	git checkout $(SOURCEDIR)/index.rst # make sure we have pristine index.rst
	cp $(SOURCEDIR)/index.rst $(BUILDDIR)/index.rst.orig
	(echo "#####\nDUMMY\n#####"; cat $(BUILDDIR)/index.rst.orig) > $(SOURCEDIR)/index.rst
	@echo
	$(SPHINXBUILD) -b latex -t latex -t a4 $(ALLSPHINXOPTS) $(BUILDDIR)/latex-a4
	@echo "Reverting horrible LaTeX hack..."
	git checkout $(SOURCEDIR)/index.rst # revert back to pristine index.rst
	@echo
	@echo "Build finished; the LaTeX files are in $(BUILDDIR)/latex-a4."
	@echo "Run \`make' in that directory to run these through (pdf)latex" \
	      "(use \`make latexpdf' here to do that automatically)."

pdf:	pdf-letter pdf-a4

pdf-letter: latex-letter
	@echo "Running LaTeX files through pdflatex..."
	$(MAKE) -C $(BUILDDIR)/latex all-pdf
	@echo "pdflatex letter finished; the PDF files are in $(BUILDDIR)/latex."

pdf-a4:	latex-a4
	@echo "Running LaTeX files through pdflatex..."
	$(MAKE) -C $(BUILDDIR)/latex-a4 all-pdf
	@echo "pdflatex finished; the PDF files are in $(BUILDDIR)/latex-a4."

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

update_all: gettext
	sphinx-intl update -l cn -l de -l es -l fr -l it -d locale/ -p locale/pot

update_cn: gettext
	sphinx-intl update -l cn -d locale/ -p locale/pot

update_de: gettext
	sphinx-intl update -l de -d locale/ -p locale/pot

update_es: gettext
	sphinx-intl update -l es -d locale/ -p locale/pot

update_fr: gettext
	sphinx-intl update -l fr -d locale/ -p locale/pot

update_it: gettext
	sphinx-intl update -l it -d locale/ -p locale/pot

buildmo:
	sphinx-intl build -d locale/ -p locale/pot

dirhtml_cn: update_cn buildmo
	$(SPHINXBUILD) -b dirhtml -d build/doctrees -D language=cn source build/dirhtml_cn

dirhtml_de: update_de buildmo
	$(SPHINXBUILD) -b dirhtml -d build/doctrees -D language=de source build/dirhtml_de

dirhtml_es: update_es buildmo
	$(SPHINXBUILD) -b dirhtml -d build/doctrees -D language=es source build/dirhtml_es

dirhtml_fr: update_fr buildmo
	$(SPHINXBUILD) -b dirhtml -d build/doctrees -D language=fr source build/dirhtml_fr

dirhtml_it: update_it buildmo
	$(SPHINXBUILD) -b dirhtml -d build/doctrees -D language=it source build/dirhtml_it

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
%.pdf:  %.svg
	test -L "$<" || $(SVG2PDF)  -f pdf -o "$@" "$<"
	test ! -L "$<" || ln -s `readlink "$<" | sed "s/[.]svg/.pdf/"` "$@"

# Build a list of SVG files to convert to PDFs
PDFs:=	$(foreach dir, $(IMAGEDIRS), $(patsubst %.svg,%.pdf,$(wildcard $(dir)/*.svg)))

# Make a rule to build the PDFs
images: $(PDFs)
