FROM ubuntu:20.04

## Sem interação humana
ARG DEBIAN_FRONTEND=noninteractive

## Atualizando sistema operacional
RUN apt-get update && apt-get -y upgrade && apt-get -y dist-upgrade

## Instalando pacotes essenciais
RUN apt-get -y install apt-utils software-properties-common curl bash-completion vim git supervisor zip unzip

## configurar fuso horário
RUN ln -f -s /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime

## Apache
RUN apt-get -y install apache2
RUN a2enmod rewrite

## Adicionando repositório PHP
RUN add-apt-repository -y ppa:ondrej/php && apt-get update

## Instalando PHP e extensões
RUN apt-get -y install php8.2 libapache2-mod-php8.2 php8.2-cli php8.2-common php8.2-mysql \
php8.2-curl php8.2-dev php8.2-mbstring php8.2-gd php8.2-json php8.2-redis php8.2-xml  \
php8.2-zip php8.2-intl php8.2-soap php8.2-imagick

## Limpar
RUN rm -rf /tmp/pear \
    && apt-get purge -y --auto-remove \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

EXPOSE  80

CMD apachectl -D FOREGROUND