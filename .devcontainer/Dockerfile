# FROM --platform=linux/amd64 openmodelica/openmodelica:v1.20.0-minimal
FROM openmodelica/openmodelica:v1.20.0-minimal

# This is currently preventing apt-get updates from working
RUN rm /etc/apt/sources.list.d/openmodelica.list

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y sudo python3 git python3-pip texlive-latex-extra nodejs golang-go && \
 	rm -rf /var/lib/apt/lists/*

# These are tools used by the Go language extension for VS Code
RUN go install -v github.com/mdempsky/gocode@v0.0.0-20200405233807-4acdcbdea79d
RUN go install -v github.com/ramya-rao-a/go-outline@v0.0.0-20210608161538-9736a4bde949
RUN go install -v golang.org/x/tools/gopls@latest
RUN go install -v github.com/go-delve/delve/cmd/dlv@latest

# Add a normal user
RUN useradd -m  -s /bin/bash ubuntu
# RUn mkdir /etc/sudoers.d
RUN usermod -aG sudo ubuntu && echo "ubuntu ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/ubuntu
RUN chmod 0440 /etc/sudoers.d/ubuntu
USER ubuntu:ubuntu

RUN pip install jinja2 matplotlib scipy sphinx

# Install 
RUN mkdir -p /home/ubuntu/.openmodelica/libraries
RUN ln -s /workspaces/ModelicaBook/ModelicaByExample "/home/ubuntu/.openmodelica/libraries/ModelicaByExample 0.6.0" 
# RUN npm install -g wrangler

# [Optional] Uncomment this section to install additional OS packages.
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>

# [Optional] Uncomment if you want to install an additional version of node using nvm
# ARG EXTRA_NODE_VERSION=10
# RUN su node -c "source /usr/local/share/nvm/nvm.sh && nvm install ${EXTRA_NODE_VERSION}"

# [Optional] Uncomment if you want to install more global node modules
# RUN su node -c "npm install -g <your-package-list-here>"
