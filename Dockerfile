FROM php:7.4-apache

LABEL org.opencontainers.image.source=https://github.com/digininja/DVWA
LABEL org.opencontainers.image.description="DVWA pre-built image."
LABEL org.opencontainers.image.licenses="gpl-3.0"

WORKDIR /var/www/html

RUN apt-get update \
 && export DEBIAN_FRONTEND=noninteractive \
 && apt-get install -y --no-install-recommends \
      zlib1g-dev \
      libpng-dev \
      libjpeg-dev \
      libfreetype6-dev \
      iputils-ping \
      git \
      zip \
      unzip \
      p7zip-full \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && docker-php-ext-configure gd --with-jpeg --with-freetype \
 && a2enmod rewrite \
 && docker-php-ext-install gd mysqli pdo pdo_mysql

COPY --from=composer:2.2 /usr/bin/composer /usr/local/bin/composer

COPY --chown=www-data:www-data . .
COPY --chown=www-data:www-data config/config.inc.php.dist config/config.inc.php

RUN cd /var/www/html/vulnerabilities/api \
 && composer install
