FROM php:5.6-apache
ENV DEBIAN_FRONTEND="noninteractive"
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y libcurl4-gnutls-dev libpng-dev libssl-dev libc-client2007e-dev 		libkrb5-dev unzip cron re2c python tree && \
    docker-php-ext-configure imap --with-imap-ssl --with-kerberos && \
    docker-php-ext-install mysql curl gd zip mbstring imap && \
    apt-get install -y mysql-server && \
    rm -rf /var/lib/apt/lists/*
COPY SuiteCRM /var/www/html/
RUN chown -R www-data:www-data /var/www/html/* && \
	chown -R www-data:www-data /var/www/html

ADD php.ini /usr/local/etc/php/php.ini
ADD config_override.php.pyt /usr/local/src/config_override.php.pyt
ADD envtemplate.py /usr/local/bin/envtemplate.py
RUN chmod u+x /usr/local/bin/envtemplate.py
ADD crons.conf /root/crons.conf
RUN crontab /root/crons.conf
CMD service apache2 start && service mysql start && tail -F /var/log/mysql/error.log
