FROM ubuntu:18.04

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
RUN  a2enmod rewrite

## Adicionando repositório PHP
RUN add-apt-repository -y ppa:ondrej/php && apt-get update

## Instalando PHP e extensões
RUN apt-get -y install php7.2 libapache2-mod-php7.2 php7.2-cli php7.2-common php7.2-mysql \
php7.2-curl php7.2-dev php7.2-mbstring php7.2-gd php7.2-json php7.2-redis php7.2-xml php7.2-zip php7.2-intl php7.2-soap php7.2-sqlite

## Limpar
RUN rm -rf /tmp/pear \
    && apt-get purge -y --auto-remove \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

EXPOSE  80

CMD apachectl -D FOREGROUND