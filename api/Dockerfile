# Base image
FROM node:6

# Install yarn
# N.B. - We don't use the preferred method because it has to be implemented 
# differently on different platforms (depending on whether sudo is preset)
RUN npm install --global yarn

# Create app directory
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Install app dependencies
# ARG NPM_TOKEN
# RUN yarn config set always-auth true
# RUN yarn config set scope @xogeny
# RUN yarn config set '//registry.npmjs.org/:_authToken' $NPM_TOKEN
# RUN yarn config set registry https://registry.npmjs.org
# RUN echo '//registry.npmjs.org/:_authToken=${NPM_TOKEN}' > .npmrc
# RUN cat ~/.npmrc

COPY . /usr/src/app

# Install dependencies using Yarn
RUN yarn install --ignore-optional

# Now get rid of the embedded "secret" used to access private repositories
RUN rm -f .npmrc

# Ports to EXPOSE
EXPOSE 3000

# NPM Scripts to run *during build*
RUN npm run compile

CMD [ "npm", "run", "server" ]
