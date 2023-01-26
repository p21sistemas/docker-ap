#!/bin/bash

#O arquivo de variavel é copiado e apagado através do script ambiente.sh
# Importa todas as variáveis do arquivo .env na raiz do projeto
read_var() {
    VAR=$(grep $1 $2 | xargs)
    IFS="=" read -ra VAR <<< "$VAR"
    echo ${VAR[1]}
}

APPLICATION_ENV=$(read_var APP_ENV .env)
PHP_ENV=$(read_var PHP_VERSION .env)

redis-server --daemonize yes

# Cria um arquivo de configuração para o apache, de forma global
touch /etc/apache2/conf-enabled/environment.conf
echo SetEnv APP_ENV "'$APPLICATION_ENV'">> /etc/apache2/conf-enabled/environment.conf

# Se a variável de ambiente for desenvolvimento, essas coisas são instalados
# Coisas do ambiente de desenvolvimento
if [ $APPLICATION_ENV == 'desenvolvimento' ]; then


    if [ $PHP_ENV == '72' ]; then
       pecl install xdebug
       XDEBUG='zend_extension=/usr/lib/php/20170718/xdebug.so'
       PHP='7.2'
    elif [ $PHP_ENV == '56' ]; then
      #Install XDebug
       pecl install xdebug-2.5.5
       XDEBUG='zend_extension=/usr/lib/php/20131226/xdebug.so'
       PHP='5.6'
    fi

    #Configuration XDebug
    echo $XDEBUG >> /etc/php/$PHP/apache2/php.ini
    echo $XDEBUG >> /etc/php/$PHP/cli/php.ini

    mkdir "/conf.d" && version=$(php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;") \
        && curl -A "Docker" -o /tmp/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/linux/amd64/$version \
        && mkdir -p /tmp/blackfire \
        && tar zxpf /tmp/blackfire-probe.tar.gz -C /tmp/blackfire \
        && mv /tmp/blackfire/blackfire-*.so $(php -r "echo ini_get ('extension_dir');")/blackfire.so \
        && printf "extension=blackfire.so\nblackfire.agent_socket=tcp://blackfire:8707\n" > /etc/php/$PHP/apache2/conf.d/blackfire.ini

    #limpando lixo
    rm -rf /tmp/pear \
    && apt-get purge -y --auto-remove \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
fi
