FROM php:7.4-fpm

WORKDIR /var/www/html

RUN apt-get update \
    && apt-get install --quiet --yes --no-install-recommends \
        libzip-dev \
        unzip \
    #install redis with pecl and enable redis extension 
    && docker-php-ext-install zip pdo pdo_mysql \
    && pecl install -o -f redis-5.1.1 \
    && docker-php-ext-enable redis 

#copy file from composer image to our container image
COPY --from=composer  /usr/bin/composer /usr/bin/composer

#create a user with corect permissions
RUN groupadd --gid 1000 appuser \
    && useradd --uid 1000 -g appuser \
    -G www-data,root --shell /bin/bash \
    --create-home appuser
USER appuser