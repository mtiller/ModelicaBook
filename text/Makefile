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
IMAGEDIRS      = source/_static/Icons source/_static/img $(shell find $(SOURCEDIR)/ModelicaByExample/ -name "*.svg" -exec dirname {} ";" | sort -u)

# SVG to PDF conversion
SVG2PDF       = rsvg-convert
SVG2PDF_FLAGS =

# The following commands seemed to have problems but are kept for reference
S3CMD = s3cmd $(S3FLAGS)
SYNC = $(S3CMD) sync -P -F
S3GET = $(S3CMD) get
S3PUT = $(S3CMD) put -P
S3MODIFY = $(S3CMD) modify

S3BUCKET ?= book.xogeny.com
S3BUCKET_FILES ?= files.xogeny.com

# for the copying of the print versions we use awscli
S3CP = aws s3 cp
S3ACCESS= --grants read=uri=http://acs.amazonaws.com/groups/global/AllUsers

# Internal variables.
PAPEROPT_a4     = -D latex_paper_size=a4
PAPEROPT_letter = -D latex_paper_size=letter
ALLSPHINXOPTS   = -d $(BUILDDIR)/doctrees $(PAPEROPT_$(PAPER)) $(SPHINXOPTS) source
# the i18n builder cannot share the environment and doctrees with the others
I18NSPHINXOPTS  = $(PAPEROPT_$(PAPER)) $(SPHINXOPTS) source
LATEXMKOPTS     = "-xelatex"

PREV_SPEC_HASH = $(shell cat spec-hash || echo "")
SPEC_HASH = $(shell git hash-object specs.py)
PREV_RES_HASH = $(shell cat results-hash || echo "")
RES_HASH = $(shell git rev-parse HEAD:ModelicaByExample HEAD:text/specs.py | git hash-object --stdin)

# Language definition
SET_BOOK_LANG_CN = BOOK_LANG=zh_CN

.PHONY: help clean distclean html dirhtml singlehtml pickle json htmlhelp qthelp devhelp epub latex latexpdf pdf text man changes linkcheck doctest gettext results uploadCIdeps

# For CI we don't want to rebuild the whole dependencies each time.
# To enable the CI build do, e.g., `make CI_BUILD=1 pdf`
CI_BUILD=0
ifeq ($(CI_BUILD),1)
SPHINXDEPS =
else
SPHINXDEPS = specs results images
endif

# This builds the material necessary to create the book
book: specs results dirhtml server

specs: specs.py
ifneq ($(SPEC_HASH), $(PREV_SPEC_HASH))
	$(info Specification hashes do not match, regenerating specifications)
	-rm spec-hash
	-mkdir -p results/json
	-mkdir -p results/js
	-mkdir -p plots
	-rm -f plots/*
	python specs.py
	# Record the content hash of specs.py used to
	# generate all the files
	echo $(SPEC_HASH) > spec-hash
else
	$(info Specification hashes match, skipping)
endif

specs_cn: specs.py
	-mkdir -p results/json
	-mkdir -p results/js
	-mkdir -p plots
	-rm -f plots/*
	$(SET_BOOK_LANG_CN) python specs.py

# This target builds all the simulation results
results:
ifneq ($(RES_HASH), $(PREV_RES_HASH))
	@echo "Generate results"
	$(info Results hashes do not match, regenerating results)
	(cd results; make results_files exes.tar.gz tidy)
	echo $(RES_HASH) > results-hash
else
	$(info Results hashes match, skipping)
endif

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
	-mkdir -p results/js
	-mkdir -p results/json
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
deploy_print:
	($(S3CP) build/latex/ModelicaByExample.pdf s3://$(S3BUCKET_FILES)/ModelicaByExample/ $(S3ACCESS))
	($(S3CP) build/latex-a4/ModelicaByExample.pdf s3://$(S3BUCKET_FILES)/ModelicaByExample/ModelicaByExample-a4.pdf $(S3ACCESS))

	($(S3CP) build/epub/ModelicabyExample.epub s3://$(S3BUCKET_FILES)/ModelicaByExample/ModelicaByExample.epub $(S3ACCESS))
	($(S3CP) build/epub/ModelicaByExample.mobi s3://$(S3BUCKET_FILES)/ModelicaByExample/ $(S3ACCESS))



# This target builds all the SVG images of icons
icons:
	@echo "Generate Icons"
	-rm -rf docs-dir
	-mkdir -p docs-dir
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

build_links_ar:
	cp build/dirhtml_ar/_static/sitemap.xml build/dirhtml_ar
	cp build/dirhtml_ar/_static/robots.txt build/dirhtml_ar

	-(cd build/dirhtml_ar/_static; ln -s ../../../results/js)
	-(cd build/dirhtml_ar/_static; ln -s ../../../results/json)

build_links_cn:
	cp build/dirhtml_cn/_static/sitemap.xml build/dirhtml_cn
	cp build/dirhtml_cn/_static/robots.txt build/dirhtml_cn

	-(cd build/dirhtml_cn/_static; ln -s ../../../results/js)
	-(cd build/dirhtml_cn/_static; ln -s ../../../results/json)

build_links_kr:
	cp build/dirhtml_kr/_static/sitemap.xml build/dirhtml_kr
	cp build/dirhtml_kr/_static/robots.txt build/dirhtml_kr

	-(cd build/dirhtml_kr/_static; ln -s ../../../results/js)
	-(cd build/dirhtml_kr/_static; ln -s ../../../results/json)

build_links_es:
	cp build/dirhtml_es/_static/sitemap.xml build/dirhtml_es
	cp build/dirhtml_es/_static/robots.txt build/dirhtml_es

	-(cd build/dirhtml_es/_static; ln -s ../../../results/js)
	-(cd build/dirhtml_es/_static; ln -s ../../../results/json)

# This builds the HTML and then runs a simple web server
server: dirhtml build_links
	(cd build/dirhtml; python -m SimpleHTTPServer)

server_ar: dirhtml_ar build_links_ar
	(cd build/dirhtml_ar; python -m SimpleHTTPServer)

server_cn: dirhtml_cn build_links_cn
	(cd build/dirhtml_cn; python -m SimpleHTTPServer)

server_kr: dirhtml_kr build_links_kr
	(cd build/dirhtml_kr; python -m SimpleHTTPServer)

#server_de: dirhtml_de build_links
#	(cd build/dirhtml_de; python -m SimpleHTTPServer)

server_es: dirhtml_es build_links_es
	(cd build/dirhtml_es; python -m SimpleHTTPServer)

#server_fr: dirhtml_fr build_links
#	(cd build/dirhtml_fr; python -m SimpleHTTPServer)

#server_it: dirhtml_it build_links
#	(cd build/dirhtml_it; python -m SimpleHTTPServer)

web: dirhtml build_links
	(cd build/dirhtml; $(SYNC) * s3://$(S3BUCKET)/)
	$(S3MODIFY)  -m text/css  s3://$(S3BUCKET)/_static/*.css

web_ar: dirhtml_ar build_links_ar
	(cd build/dirhtml_ar; $(SYNC) * s3://$(S3BUCKET)/ar/)
	$(S3MODIFY)  -m text/css  s3://$(S3BUCKET)/ar/_static/*.css

web_cn: dirhtml_cn build_links_cn
	(cd build/dirhtml_cn; $(SYNC) * s3://$(S3BUCKET)/cn/)
	$(S3MODIFY)  -m text/css  s3://$(S3BUCKET)/cn/_static/*.css

web_kr: dirhtml_kr build_links_kr
	(cd build/dirhtml_kr; $(SYNC) * s3://$(S3BUCKET)/kr/)
	$(S3MODIFY)  -m text/css  s3://$(S3BUCKET)/kr/_static/*.css

#web_de: dirhtml_de build_links
#	(cd build/dirhtml_de; $(SYNC) * s3://$(S3BUCKET)/de/)
#	$(S3MODIFY)  -m text/css  s3://$(S3BUCKET)/de/_static/*.css

web_es: dirhtml_es build_links_es
	(cd build/dirhtml_es; $(SYNC) * s3://$(S3BUCKET)/es/)
	$(S3MODIFY)  -m text/css  s3://$(S3BUCKET)/es/_static/*.css

#web_fr: dirhtml_fr build_links
#	(cd build/dirhtml_fr; $(SYNC) * s3://$(S3BUCKET)/fr/)
#	$(S3MODIFY)  -m text/css  s3://$(S3BUCKET)/fr/_static/*.css

#web_it: dirhtml_it build_links
#	(cd build/dirhtml_it; $(SYNC) * s3://$(S3BUCKET)/it/)
#	$(S3MODIFY)  -m text/css  s3://$(S3BUCKET)/it/_static/*.css

node: dirhtml build_links
	-rm -rf build/node
	-mkdir -p build/node
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
	-rm spec-hash
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
	find $(BUILDDIR)/dirhtml -name '*.html' -exec ./inline-math.sh {} \;
	@echo
	@echo "Build finished. The HTML pages are in $(BUILDDIR)/dirhtml."

singlehtml:
	$(SPHINXBUILD) -b singlehtml  $(ALLSPHINXOPTS) $(BUILDDIR)/singlehtml
	find  $(BUILDDIR)/singlehtml -name '*.html' -exec ./inline-math.sh {} \;
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
	$(SPHINXBUILD) -b epub $(ALLSPHINXOPTS) $(BUILDDIR)/epub
	-rm $(BUILDDIR)/epub/*.epub
	find $(BUILDDIR)/epub -name '*.xhtml' -exec ./inline-math.sh {} \;
	(cd $(BUILDDIR)/epub; zip -r ModelicaByExample.epub .)
	@echo
	@echo "Build finished. The epub file is in $(BUILDDIR)/epub."

mobi:
	$(SPHINXBUILD) -b epub -t mobi $(ALLSPHINXOPTS) $(BUILDDIR)/mobi
	(cd $(BUILDDIR)/mobi; ebook-convert ModelicabyExample.epub ModelicaByExample.mobi)
	@echo
	@echo "Build finished. The mobi file is in $(BUILDDIR)/mobi."

ebooks: epub mobi

latex: latex-letter latex-a4

latex-letter: $(SPHINXDEPS)
	@echo
	@echo "Applying horrible LaTeX hack..."
	-mkdir -p build
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


latex-a4: $(SPHINXDEPS)
	@echo
	@echo "Applying horrible LaTeX hack..."
	-mkdir -p build
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

latex-a4-cn: specs_cn results images
	@echo
	@echo "Applying horrible LaTeX hack..."
	-mkdir -p build
	git checkout $(SOURCEDIR)/index.rst # make sure we have pristine index.rst
	cp $(SOURCEDIR)/index.rst $(BUILDDIR)/index.rst.orig
	(echo "#####\nDUMMY\n#####"; cat $(BUILDDIR)/index.rst.orig) > $(SOURCEDIR)/index.rst
	@echo
	$(SET_BOOK_LANG_CN) $(SPHINXBUILD) -b latex -t latex -t a4 -D language=zh_CN $(ALLSPHINXOPTS) $(BUILDDIR)/latex-a4-cn

	@echo "Reverting horrible LaTeX hack..."
	git checkout $(SOURCEDIR)/index.rst # revert back to pristine index.rst
	@echo
	@echo "Build finished; the LaTeX files are in $(BUILDDIR)/latex-a4-cn."
	@echo "Run \`make' in that directory to run these through (pdf)latex" \
	      "(use \`make latexpdf' here to do that automatically)."

pdf:	pdf-letter pdf-a4

pdf-letter: latex-letter
	@echo "Running LaTeX files through xelatex..."
	$(MAKE) -C $(BUILDDIR)/latex all-pdf
	@echo "xelatex letter finished; the PDF files are in $(BUILDDIR)/latex."

pdf-a4:	latex-a4
	@echo "Running LaTeX files through xelatex..."
	$(MAKE) -C $(BUILDDIR)/latex-a4 all-pdf
	@echo "xelatex finished; the PDF files are in $(BUILDDIR)/latex-a4."

pdf-cn: latex-a4-cn
	@echo "Running LaTeX files through xelatex..."
	(cp locale/cn/mycjk.sty $(BUILDDIR)/latex-a4-cn; )
#	(cd $(BUILDDIR)/xelatex; sed -i '/\usepackage\[utf8\]{inputenc}/d' ModelicaByExample.tex)
	(cd $(BUILDDIR)/latex-a4-cn; sed -i 's/\\author{.*}/\\author{\\authorandtranslators}/' ModelicaByExample.tex)
	(cd $(BUILDDIR)/latex-a4-cn; sed -i 's/\\title{.*}/\\title{Modelica实例教程}/' ModelicaByExample.tex)
	(cd $(BUILDDIR)/latex-a4-cn; sed -i '/\\date{.*}/d' ModelicaByExample.tex)
#	(cd $(BUILDDIR)/latex-a4-cn; sed -i '/.DeclareUnicodeCharacter.*/d' ModelicaByExample.tex)
	(cd $(BUILDDIR)/latex-a4-cn; sed -i 's/{babel}/{mycjk}/' ModelicaByExample.tex)
	$(MAKE) -C $(BUILDDIR)/latex-a4-cn all-pdf
	@echo "xelatex finished; the PDF files are in $(BUILDDIR)/latex-a4."
#	(cd $(BUILDDIR)/xelatex; xelatex -shell-escape -interaction=batchmode  ModelicaByExample.tex; echo 'first pass')
#	(cd $(BUILDDIR)/xelatex; xelatex  -shell-escape -interaction=batchmode ModelicaByExample.tex; echo 'second pass')

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
	pygettext -d specs -p locale/pot specs.py
	pygettext -d plot_utils -p locale/pot source/_sphinxext/xogeny/plot_utils.py
	@echo
	@echo "Build finished. The message catalogs are in $(BUILDDIR)/locale."

update_all: gettext
	sphinx-intl update -l ar -l cn -l de -l es -l fr -l it -l kr -l pt_BR -d locale/ -p locale/pot

# Arabic
update_ar: gettext
	sphinx-intl update -l ar -d locale/ -p locale/pot

# Chinese
update_cn: gettext
	sphinx-intl update -l cn -d locale/ -p locale/pot

# German
update_de: gettext
	sphinx-intl update -l de -d locale/ -p locale/pot

# Spanish
update_es: gettext
	sphinx-intl update -l es -d locale/ -p locale/pot

# French
update_fr: gettext
	sphinx-intl update -l fr -d locale/ -p locale/pot

# Italian
update_it: gettext
	sphinx-intl update -l it -d locale/ -p locale/pot

# Korean
update_kr: gettext
	sphinx-intl update -l kr -d locale/ -p locale/pot

# Portuguese (Brazilian)
update_pt_BR: gettext
	sphinx-intl update -l pt_BR -d locale/ -p locale/pot

buildmo:
	sphinx-intl build -d locale/ -p locale/pot

dirhtml_cn: specs_cn update_cn buildmo
	$(SET_BOOK_LANG_CN) $(SPHINXBUILD) -b dirhtml -d build/doctrees -D language=zh_CN source build/dirhtml_cn
	cat locale/cn/cn.css >> build/dirhtml_cn/_static/xogeny.css

dirhtml_kr: update_kr buildmo
	$(SPHINXBUILD) -b dirhtml -d build/doctrees -D language=kr source build/dirhtml_kr

dirhtml_de: update_de buildmo
	$(SPHINXBUILD) -b dirhtml -d build/doctrees -D language=de source build/dirhtml_de

dirhtml_es: update_es buildmo
	$(SPHINXBUILD) -b dirhtml -d build/doctrees -D language=es source build/dirhtml_es

dirhtml_fr: update_fr buildmo
	$(SPHINXBUILD) -b dirhtml -d build/doctrees -D language=fr source build/dirhtml_fr

dirhtml_it: update_it buildmo
	$(SPHINXBUILD) -b dirhtml -d build/doctrees -D language=it source build/dirhtml_it

dirhtml_ar: update_ar buildmo
	$(SPHINXBUILD) -b dirhtml -d build/doctrees -D language=ar source build/dirhtml_ar

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

# upload the most time consuming deps so they can be used by CI build
uploadCIdeps: $(SPHINXDEPS)
	tar cJf build/CIdeps.tar.xz results plots docs-dir
	($(S3PUT) build/CIdeps.tar.xz s3://$(S3BUCKET_FILES)/ModelicaByExample/)
