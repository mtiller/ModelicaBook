FROM ubuntu:14.04

# Update index
RUN apt-get update

# Install weget
RUN apt-get install -y wget

# Add OpenModelica stable build
RUN for deb in deb deb-src; do echo "$deb http://build.openmodelica.org/apt `lsb_release -cs` stable"; done | sudo tee /etc/apt/sources.list.d/openmodelica.list
RUN wget -q http://build.openmodelica.org/apt/openmodelica.asc -O- | sudo apt-key add - 

# Update index (again)
RUN apt-get update

# Install OpenModelica
RUN apt-get install -y openmodelica

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

# Now install Git and grab the book
RUN apt-get install -y git

# Workaround: use an older version of sphinx-intl to workaround a bug in upstream
RUN pip install --upgrade 'sphinx-intl==0.9.6'
RUN pip install --upgrade 'sphinx==1.3'

# Because I was running into this: https://github.com/sphinx-doc/sphinx/issues/3212
RUN pip install docutils==0.12


# Create a directory for all the book related stuff
RUN mkdir /opt/MBE

# The rest of this we do as a user
RUN useradd builder

COPY default_s3cfg /home/builder/.s3cfg
RUN chown builder:builder /home/builder/.s3cfg

RUN chown builder /opt/MBE

USER builder

WORKDIR /opt/MBE

#RUN git clone https://github.com/xogeny/ModelicaBook.git
# Instead of checking this out from Git (because then we can
# only build *master*, we'll mount the repo as a volume)

# The default commands when run as a container
WORKDIR /opt/MBE/ModelicaBook/text
CMD ["/bin/bash", "build_all.sh"]
