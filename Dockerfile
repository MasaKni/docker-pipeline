
FROM microsoft/mssql-tools as mssql
FROM rshop/swoole:7.3

COPY --from=mssql /opt/microsoft/ /opt/microsoft/
COPY --from=mssql /opt/mssql-tools/ /opt/mssql-tools/
COPY --from=mssql /usr/lib/libmsodbcsql-13.so /usr/lib/libmsodbcsql-13.so

RUN apk update \
    && apk add --no-cache --virtual .persistent-deps \
        bash \
        freetds \
        git \
        gnupg \
        openssh \
        unixodbc \
        unzip \
    && apk add --no-cache --virtual .build-deps \
        autoconf \
        automake \
        dpkg \
        dpkg-dev \
        file \
        freetds-dev \
        g++ \
        gcc \
        libc-dev \
        libtool \
        make \
        pcre-dev \
        pcre2-dev \
        php7-dev \
        php7-pear \
        pkgconf \
        re2c \
        unixodbc-dev \
        zlib-dev \
    && pecl install sqlsrv pdo_sqlsrv \
    && echo "extension=sqlsrv.so" > /etc/php7/conf.d/50_sqlsrv.ini \
    && echo "extension=pdo_sqlsrv.so" > /etc/php7/conf.d/50_pdo_sqlsrv.ini \
    && apk del .build-deps \
    && apk del --purge *-dev \
    && rm -rf /var/cache/apk/* /tmp/* /usr/share/man

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer \
    && composer global require phpstan/phpstan \
    && ln -s /root/.composer/vendor/phpstan/phpstan/phpstan /usr/bin/phpstan

RUN curl -sL https://cs.sensiolabs.org/download/php-cs-fixer-v2.phar > /usr/bin/php-cs-fixer \
    && chmod a+x /usr/bin/php-cs-fixer
