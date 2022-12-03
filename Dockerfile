#
FROM node:12.18.3-alpine3.11

RUN mkdir /app

WORKDIR /app

ARG PORT
ARG GRPC_PORT
ARG NODE_ENV
ARG USER_SVC
ARG DATABASE_LOGGING
ARG SLACK_TOKEN
ARG EMAIL
ARG EMAIL_PASSWORD
ARG WEBSITE_URL
ARG SUNSTONE_TOKEN
ARG TZ

ENV PORT $PORT
ENV GRPC_PORT $GRPC_PORT
ENV NODE_ENV $NODE_ENV
ENV USER_SVC $USER_SVC
ENV DATABASE_LOGGING $DATABASE_LOGGING
ENV SLACK_TOKEN $SLACK_TOKEN
ENV EMAIL $EMAIL
ENV MAIL_PASSWORD $MAIL_PASSWORD
ENV WEBSITE_URL $WEBSITE_URL
ENV SUNSTONE_TOKEN $SUNSTONE_TOKEN
ENV TZ $TZ

COPY ["package.json", "package-lock.json*", "tsconfig.build.json", "tsconfig.json", "./"]

COPY . .

RUN apk add --no-cache git
RUN apk add --no-cache protoc
RUN apk add --no-cache bash

RUN npm install

RUN npm run proto:install

RUN npm install -g webpack webpack-cli 
# ✅ Create a symbolic link from the global package
# to node_modules/ of current folder
RUN npm link webpack

RUN npm run build

RUN npm run proto:all

EXPOSE 8059

CMD [ "node", "dist/main.js" ]