
FROM microsoft/mssql-tools as mssql
FROM rshop/swoole:7.4

COPY --from=mssql /opt/microsoft/ /opt/microsoft/
COPY --from=mssql /opt/mssql-tools/ /opt/mssql-tools/
COPY --from=mssql /usr/lib/libmsodbcsql-13.so /usr/lib/libmsodbcsql-13.so

RUN apk update \
    && apk add --no-cache --virtual .persistent-deps \
        freetds \
        git \
        gnupg \
        openssh \
        unixodbc \
        unzip \
    && apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
        unixodbc-dev \
        freetds-dev \
    && pecl install sqlsrv pdo_sqlsrv \
    && echo "extension=sqlsrv.so" > /etc/php7/conf.d/50_sqlsrv.ini \
    && echo "extension=pdo_sqlsrv.so" > /etc/php7/conf.d/50_pdo_sqlsrv.ini \
    && apk del .build-deps

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer \
    && composer global require hirak/prestissimo \
    && composer global config "extra.shared-package.vendor-dir" "/root/.composer/vendor-shared" \
    && composer global require letudiant/composer-shared-package-plugin

ENV COMPOSER_SPP_VENDOR_DIR "/root/.composer/vendor-shared"

RUN curl -sL https://cs.sensiolabs.org/download/php-cs-fixer-v2.phar > /usr/bin/php-cs-fixer \
    && chmod a+x /usr/bin/php-cs-fixer
