
FROM rshop/swoole:7.3-mssql

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
    && composer global require phpstan/phpstan \
    && ln -s /root/.composer/vendor/phpstan/phpstan/phpstan /usr/bin/phpstan \
    && curl -sL https://cs.sensiolabs.org/download/php-cs-fixer-v2.phar > /usr/bin/php-cs-fixer \
    && chmod a+x /usr/bin/php-cs-fixer
