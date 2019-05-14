FROM php:7.2-apache

LABEL maintainer="docker-dario@neomediatech.it" \ 
      org.label-schema.version=$PHP_VERSION

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Rome

RUN echo $TZ > /etc/timezone && \ 
    apt-get update && \
    apt-get install -y libbz2-dev libpng-dev pdfgrep libfcgi-bin netcat tzdata && \
    rm -rf /var/lib/apt/lists* && \
    for mod in mysqli bz2 gd zip; do docker-php-ext-install $mod ; done 

COPY apache.conf /etc/apache2/sites-available/000-default.conf

CMD ["apache2-foreground"]
