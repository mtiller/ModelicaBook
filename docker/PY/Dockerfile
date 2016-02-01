# This is a Dockerfile that creates a docker image with all the necessary
# dependencies for building the book.

FROM mtiller/book-om

RUN apt-get update

# Now Install base Python
RUN apt-get install -y python python-dev python-pip python-virtualenv

# Now a bunch of dependencies required for building the book
RUN apt-get install -y calibre
RUN apt-get install -y librsvg2-bin
RUN apt-get install -y texlive-fonts-recommended
RUN apt-get install -y texlive-latex-recommended
RUN apt-get install -y texlive-latex-extra
RUN apt-get install -y python-matplotlib
RUN apt-get install -y python-pip
RUN apt-get install -y python-scipy
RUN apt-get install -y python-sphinx
RUN apt-get install -y python-jinja2

# Install Sphinx internationalization stuff
RUN pip install sphinx-intl
RUN apt-get install -y fonts-droid

# Install internationalization packages needed for the book
RUN apt-get install -y latex-cjk-common
RUN apt-get install -y texlive-xetex 
RUN apt-get install -y texlive-generic-extra
RUN apt-get install -y fonts-arphic-gkai00mp fonts-arphic-ukai fonts-arphic-uming \
                       fonts-arphic-bkai00mp fonts-arphic-bsmi00lp fonts-arphic-gbsn00lp 

# Temporary: use the newest s3cmd
RUN pip install --upgrade s3cmd

# Finally, upgrade Pygments to the latest Modelica syntax rules
RUN pip install --upgrade https://bitbucket.org/dietmarw/pygments-main/get/default.tar.gz

# Now install Git and grab the book
RUN apt-get install -y git
