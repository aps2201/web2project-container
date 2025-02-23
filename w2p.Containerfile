FROM docker.io/library/php:8.4-apache
COPY --from=docker.io/library/composer /usr/bin/composer /usr/bin/composer

RUN apt-get update
RUN apt-get install -y unzip libwebp-dev libgd-dev zlib1g-dev libonig-dev libpng-dev libfreetype-dev libjpeg-dev libldap-dev

RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install gd
RUN docker-php-ext-install mbstring
RUN docker-php-ext-install mysqli
RUN docker-php-ext-install ldap
RUN docker-php-ext-install session

RUN mkdir /usr/session
COPY save_session_php.ini /usr/local/etc/php/conf.d/
COPY . /var/www/html/
WORKDIR /var/www/html/
RUN chown -Rv www-data:www-data /var/www/html/files && chmod -Rv 755 /var/www/html/files
RUN touch /var/www/html/includes/config.php
RUN chown -v www-data:www-data /var/www/html/includes/config.php && chmod -v 755 /var/www/html/includes/config.php
RUN chown -Rv www-data:www-data /var/www/html/locales/en && chmod -v 755 /var/www/html/locales/en
RUN chown -Rv www-data:www-data  /usr/session && chmod -v 755  /usr/session
RUN composer install
