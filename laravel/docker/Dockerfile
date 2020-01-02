FROM php:fpm-alpine3.9

MAINTAINER gradydong <gradydong@126.com>
LABEL Description="This image is used to start php server for Laravel." Vendor="gradydong" Version="1.0"

ARG COMPOSER_REPOSITORY="https://mirrors.aliyun.com/composer/"

WORKDIR /var/www/html

# With leverage of caching mechanism, installing dependencies, which rarely change, before copying in the scource files.
COPY ./composer.json ./composer.lock ./

RUN set -xe \
    # add mirrors in China and make them head of others
    && echo http://mirrors.ustc.edu.cn/alpine/v$(head -1 /etc/apk/repositories | cut -dv -f2) > /tmp/repos \
    && cat /etc/apk/repositories >> /tmp/repos \
    && mv /tmp/repos /etc/apk/repositories \
    # install dependences
    && apk add --no-cache --virtual .build-deps \
        libjpeg-turbo-dev \
        zlib-dev \
        libpng-dev \
        freetype-dev \
        libzip-dev \
        git \
        autoconf \
        make \
        gcc \
        g++ \
    && apk add --no-cache --virtual .persistent-deps \
        libjpeg-turbo \
        zlib \
        libpng \
        freetype \
        supervisor\
    && mkdir /etc/supervisor.d \
    # install php extensions
    && docker-php-ext-configure gd \
        --with-freetype-dir=/usr/include/ \
        --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-configure zip \
        --without-libzip \
    && docker-php-ext-configure bcmath --enable-bcmath \
    && docker-php-ext-install mysqli pdo_mysql zip gd bcmath \
    && pecl install -o -f redis \
    && docker-php-ext-enable redis \
    # install composer and php packages
    && php -r "copy('https://install.phpcomposer.com/installer', 'composer-setup.php');" \
    && php composer-setup.php \
    && php -r "unlink('composer-setup.php');" \
    && mv composer.phar /usr/local/bin/composer \
    && composer config repositories.packagist composer ${COMPOSER_REPOSITORY} \
    && composer install --no-scripts \
    && rm /usr/local/bin/composer \
    && rm -rf ~/.composer \
    # clean up
    && apk del .build-deps \
    && rm -rf /var/cache/apt/* \
    && rm -rf /tmp/* \
    && rm -rf /var/tmp/*

# laravel source code
COPY ./ ./

# php custom configuration
COPY ./docker/config/ /usr/local/etc/php/conf.d/
COPY ./docker/supervisord/ /etc/supervisor.d/
COPY ./docker/php-fpm/ /usr/local/etc/php-fpm.d/

# entrypoint.sh
COPY ./docker/docker-entrypoint.sh /usr/local/bin/

RUN sed -i 's/\r//g' /usr/local/bin/docker-entrypoint.sh \
    && chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

# give write permission
RUN sed -i 's/\r//g' ./crontab/laravel.crontab \
    && crontab -u www-data ./crontab/laravel.crontab

CMD ["php-fpm"]
