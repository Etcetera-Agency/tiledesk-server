FROM --platform=linux/arm64/v8 node:17

RUN sed -i 's/stable\/main/stable-community\/testing/' /etc/apk/

RUN apk update && apk add --no-cache build-base

RUN apt-get update

# Create app directory
WORKDIR /usr/src/app

ARG NPM_TOKEN

RUN if [ "$NPM_TOKEN" ]; \
    then RUN COPY .npmrc_ .npmrc \
    else export SOMEVAR=world; \
    fi


# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY package*.json ./

RUN npm install --production --build-from-source

RUN rm -f .npmrc

# Bundle app source
COPY . .

EXPOSE 3000

CMD [ "npm", "start" ]

