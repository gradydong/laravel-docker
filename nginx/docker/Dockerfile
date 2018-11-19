FROM nginx:stable-alpine

MAINTAINER gradydong <gradydong@126.com>
LABEL Description="This image is used to start nginx server for Laravel." Vendor="gradydong" Version="1.0"

ARG NPM_REGISTRY="https://registry.npmjs.org/"

RUN set -xe \
    # add mirrors in China
    && echo http://mirrors.ustc.edu.cn/alpine/v$(head -1 /etc/apk/repositories | cut -dv -f2) > /tmp/repos \
    && cat /etc/apk/repositories >> /tmp/repos \
    && mv /tmp/repos /etc/apk/repositories \
    # install dependences
    && apk add --no-cache --virtual .build-deps \
        nodejs \
        npm \
    && npm config set registry ${NPM_REGISTRY} \
    # install gulp for building the old front-end framework
    && npm install -g gulp-cli

WORKDIR /usr/share/nginx/html

# nginx custom configuration
COPY ./docker/config/* /etc/nginx/conf.d/

# front-end source code
COPY ./ ./

RUN apk add --no-cache bash

COPY ./docker/docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh \
    &&ln -s /usr/local/bin/docker-entrypoint.sh / # backwards compat
ENTRYPOINT ["docker-entrypoint.sh"]


# It seems that a duplicate of CMD within nginx:stable-alpine is mandatary,
# since the ENTRYPOINT above will override the CMD within the base image.
CMD ["nginx", "-g", "daemon off;"]
