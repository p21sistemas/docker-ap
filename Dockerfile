FROM ubuntu:20.04

## Sem interação humana
ARG DEBIAN_FRONTEND=noninteractive

## Atualizando sistema operacional
RUN apt-get update && apt-get -y upgrade && apt-get -y dist-upgrade

## Instalando pacotes essenciais
RUN apt-get -y install apt-utils software-properties-common curl bash-completion vim git supervisor zip unzip

## configurar fuso horário
RUN ln -f -s /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime

##Installing NGINX
RUN apt-get -y install nginx

## Adicionando repositório PHP
RUN add-apt-repository -y ppa:ondrej/php && apt-get update

## Instalando PHP e extensões
RUN apt-get -y install php7.3 libapache2-mod-php7.3 php7.3-cli php7.3-common php7.3-mysql \
php7.3-curl php7.3-mbstring php7.3-gd php7.3-json php7.3-redis php7.3-xml php7.3-zip php7.3-intl php7.3-soap

RUN apt-get install php7.3-dev php-pear -y

# Install xdebug and redis
RUN pecl install redis

RUN apt update && apt-get install php7.3-fpm -y

# Clean up
RUN rm -rf /tmp/pear \
    && apt-get purge -y --auto-remove \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

EXPOSE  80

CMD service php7.3-fpm start && nginx -g "daemon off;"

# wget http://downloadarchive.documentfoundation.org/libreoffice/old/6.4.4.2/deb/x86_64/LibreOffice_6.4.4.2_Linux_x86-64_deb.tar.gz
# dpkg -i LibreOffice_6.4.4.2_Linux_x86-64_deb.tar.gz
# dpkg -i *.deb
# apt install libxinerama1
# apt-get install libpangocairo-1.0-0
# apt-get install libsm6
# ln -s /opt/libreoffice6.4/program/soffice /usr/local/bin

# apt-get install ttf-mscorefonts-installer -y