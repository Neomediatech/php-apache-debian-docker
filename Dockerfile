FROM php:7.2-apache

LABEL maintainer="docker-dario@neomediatech.it" \ 
      org.label-schema.version=$PHP_VERSION

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Rome

ENV CUSTOM_PHP_INI_FILE=/usr/local/etc/php-fpm.d/zz-docker.conf

RUN echo $TZ > /etc/timezone && \ 
    apt-get update && \
    apt-get install -y libbz2-dev libpng-dev pdfgrep libfcgi-bin netcat tzdata && \
    rm -rf /var/lib/apt/lists* && \
    for mod in mysqli bz2 gd zip; do docker-php-ext-install $mod ; done && \
    echo "ping.path = /ping" >> $CUSTOM_PHP_INI_FILE && \
    echo "php_admin_value[memory_limit] = 1024M" >> $CUSTOM_PHP_INI_FILE && \
    echo "php_admin_value[post_max_size] = 200M" >> $CUSTOM_PHP_INI_FILE && \
    echo "php_admin_value[upload_max_filesize] = 200M" >> $CUSTOM_PHP_INI_FILE 

HEALTHCHECK --interval=10s --timeout=3s --start-period=60s --retries=10 CMD SCRIPT_NAME=/ping SCRIPT_FILENAME=/ping REQUEST_METHOD=GET cgi-fcgi -bind -connect 127.0.0.1:9000 || exit 1

CMD ["apache2-foreground"]
