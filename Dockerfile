FROM ubuntu:24.04

## Sem interação humana
ARG DEBIAN_FRONTEND=noninteractive

## Atualizando sistema operacional
RUN apt-get update && apt-get -y upgrade && apt-get -y dist-upgrade

## Instalando pacotes essenciais
RUN apt-get -y install apt-utils software-properties-common curl bash-completion vim git zip unzip

## Configurar fuso horário
RUN ln -f -s /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime

## Apache
RUN apt-get -y install apache2
RUN a2enmod rewrite

## Repetir downloads que falham (o PPA devolve 503 quando sobrecarregado)
RUN echo 'Acquire::Retries "10";' > /etc/apt/apt.conf.d/80-retries

## Adicionando repositório PHP
RUN add-apt-repository -y ppa:ondrej/php && apt-get update

## Instalando PHP e extensões
## Sem php7.4-dev: o xdebug de desenvolvimento vem do pacote php7.4-xdebug, instalado pelo projeto
RUN apt-get -y install php7.4 libapache2-mod-php7.4 php7.4-cli php7.4-common php7.4-mysql \
    php7.4-curl php7.4-mbstring php7.4-gd php7.4-json php7.4-redis php7.4-xml \
    php7.4-zip php7.4-intl php7.4-soap php7.4-imagick php7.4-opcache

## Limpar
RUN rm -rf /tmp/pear \
    && apt-get purge -y --auto-remove \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

EXPOSE  80
CMD ["apachectl", "-D" , "FOREGROUND"]
