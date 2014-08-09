# This is a Dockerfile that creates a docker image with all the necessary
# dependencies for building the book.

FROM ubuntu

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

# Finally, upgrade Pygments to the latest Modelica syntax rules
RUN pip install --upgrade https://bitbucket.org/dietmarw/pygments-main/get/default.tar.gz

# Now install Git and grab the book
RUN apt-get install -y git

RUN mkdir /opt/MBE
# The rest of this we do as a user
RUN useradd builder

RUN chown builder /opt/MBE

USER builder

WORKDIR /opt/MBE

RUN git clone https://github.com/xogeny/ModelicaBook.git
