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
