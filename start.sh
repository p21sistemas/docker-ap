#!/bin/bash

# Importa todas as variáveis do arquivo .env na raiz do projeto
read_var() {
    VAR=$(grep $1 $2 | xargs)
    IFS="=" read -ra VAR <<< "$VAR"
    echo ${VAR[1]}
}

APPLICATION_ENV=$(read_var APP_ENV .env)

# Cria um arquivo de configuração para o apache, de forma global
touch /etc/apache2/conf-enabled/environment.conf
echo SetEnv APP_ENV "'$APPLICATION_ENV'">> /etc/apache2/conf-enabled/environment.conf

# Coisas do ambiente de desenvolvimento
if [ $APPLICATION_ENV == 'desenvolvimento' ]; then

    #Composer
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

    #Install XDebug
    pecl install xdebug-2.5.5

    #Configuration XDebug
    echo 'zend_extension=/usr/lib/php/20131226/xdebug.so' >> /etc/php/5.6/apache2/php.ini
    echo 'zend_extension=/usr/lib/php/20131226/xdebug.so' >> /etc/php/5.6/cli/php.ini

    mkdir "/conf.d" && version=$(php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;") \
        && curl -A "Docker" -o /tmp/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/linux/amd64/$version \
        && mkdir -p /tmp/blackfire \
        && tar zxpf /tmp/blackfire-probe.tar.gz -C /tmp/blackfire \
        && mv /tmp/blackfire/blackfire-*.so $(php -r "echo ini_get ('extension_dir');")/blackfire.so \
        && printf "extension=blackfire.so\nblackfire.agent_socket=tcp://blackfire:8707\n" > /etc/php/5.6/apache2/conf.d/blackfire.ini

    #limpando lixo
    rm -rf /tmp/pear \
    && apt-get purge -y --auto-remove \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
fi