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


RUN . "$APACHE_ENVVARS" && rm -f "$APACHE_LOG_DIR/error.log" "$APACHE_LOG_DIR/access.log" "$APACHE_LOG_DIR/other_vhosts_access.log"; \
    touch "$APACHE_LOG_DIR/error.log" "$APACHE_LOG_DIR/access.log" "$APACHE_LOG_DIR/other_vhosts_access.log"; \
    chown -R --no-dereference "$APACHE_RUN_USER:$APACHE_RUN_GROUP" "$APACHE_LOG_DIR"

COPY apache.conf /etc/apache2/sites-available/000-default.conf
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

CMD ["apache2-foreground"]
