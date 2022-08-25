
FROM rshop/swoole:8.1-mssql

RUN apk update \
    && apk add --no-cache \
        bash \
        git \
        gnupg \
        openssh \
        unzip \
    && apk del --purge *-dev \
    && rm -rf /var/cache/apk/* /tmp/* /usr/share/man

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer \
    && composer global require phpstan/phpstan  \
    && ln -s /root/.composer/vendor/bin/phpstan /usr/bin/phpstan \
    && composer global require friendsofphp/php-cs-fixer \
    && ln -s /root/.composer/vendor/bin/php-cs-fixer /usr/bin/php-cs-fixer \
    && rm -Rf /root/.composer/cache
