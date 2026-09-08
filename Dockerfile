FROM docker.io/library/php:7.4-apache

LABEL org.opencontainers.image.source=https://github.com/digininja/DVWA
LABEL org.opencontainers.image.description="DVWA pre-built image."
LABEL org.opencontainers.image.licenses="gpl-3.0"

WORKDIR /var/www/html

# PHP GD and other required extensions
RUN apt-get update \
 && export DEBIAN_FRONTEND=noninteractive \
 && apt-get install -y \
      zlib1g-dev \
      libpng-dev \
      libjpeg-dev \
      libfreetype6-dev \
      iputils-ping \
      git \
      zip \
      unzip \
      7zip \
 && apt-get clean -y \
 && rm -rf /var/lib/apt/lists/* \
 && docker-php-ext-configure gd --with-jpeg --with-freetype \
 && a2enmod rewrite \
 && docker-php-ext-install gd mysqli pdo pdo_mysql

# Composer version compatible with PHP 7.4
COPY --from=composer:2.2 /usr/bin/composer /usr/local/bin/composer

COPY --chown=www-data:www-data . .
COPY --chown=www-data:www-data config/config.inc.php.dist config/config.inc.php

# Configure the API dependencies
RUN cd /var/www/html/vulnerabilities/api \
 && composer install
