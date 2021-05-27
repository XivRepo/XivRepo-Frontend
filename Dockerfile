# Dockerfile
FROM node:14.16.0-alpine

# update and install dependency
RUN apk update && apk upgrade
RUN apk add git

# create destination directory
RUN mkdir -p /usr/src/xivrepo-front
WORKDIR /usr/src/xivrepo-front

# copy the app, note .dockerignore
COPY . /usr/src/xivrepo-front/
RUN npm ci

ARG VERSION_ID=unknown

RUN npm run build

EXPOSE 3000


ENV NUXT_HOST=0.0.0.0
ENV NUXT_PORT=3000

ENTRYPOINT [ "npm", "start" ]
