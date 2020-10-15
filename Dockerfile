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
RUN apt-get -y install php5.6 libapache2-mod-php5.6 php5.6-cli php5.6-common php5.6-mysql \
php5.6-curl php5.6-dev php5.6-mbstring php5.6-gd php5.6-json php5.6-redis php5.6-xml php5.6-zip php5.6-intl php5.6-soap

## Limpar
RUN rm -rf /tmp/pear \
    && apt-get purge -y --auto-remove \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

EXPOSE  80

ADD ./start.sh /start.sh
ADD ./.env /.env
RUN chmod +x /start.sh && bash /start.sh
CMD apachectl -D FOREGROUND