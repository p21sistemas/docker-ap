FROM php:7.2.34-apache-buster

# Repositórios do Buster arquivados
COPY sources.list /etc/apt/sources.list
COPY 99no-check-valid-until /etc/apt/apt.conf.d/99no-check-valid-until

# Atualizações
RUN apt-get update && apt-get upgrade -y

# Dependências para extensões do PHP
RUN apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    libicu-dev \
    libsqlite3-dev \
    unzip \
    zip \
    git \
    curl \
    vim \
    supervisor \
    bash-completion \
    software-properties-common \
    libcurl4-openssl-dev \
    libmagickwand-dev \
    libcurl4-openssl-dev  \
    pkg-config \
    libssl-dev \
    libreadline-dev \
    libxslt-dev \
    p7zip-full \
    p7zip-rar

# Configurar fuso horário
RUN ln -f -s /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime

# Apache
RUN apt-get -y install apache2
RUN  a2enmod rewrite

# GD com suporte a JPEG e FreeType
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/

# Instalar extensões PHP internas
RUN docker-php-ext-install mbstring
RUN docker-php-ext-install xml
RUN docker-php-ext-install zip
RUN docker-php-ext-install intl
RUN docker-php-ext-install soap
RUN docker-php-ext-install mysqli
RUN docker-php-ext-install pdo
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install gd
RUN docker-php-ext-install pdo_sqlite
RUN docker-php-ext-install curl
RUN docker-php-ext-install calendar
RUN docker-php-ext-install exif
RUN docker-php-ext-install gettext
RUN docker-php-ext-install pcntl
RUN docker-php-ext-install sockets
RUN docker-php-ext-install shmop
RUN docker-php-ext-install sysvmsg
RUN docker-php-ext-install sysvsem
RUN docker-php-ext-install sysvshm
RUN docker-php-ext-install wddx
RUN docker-php-ext-install xsl
RUN docker-php-ext-enable opcache

# Instala extensões via PECL
RUN pecl install redis-6.0.2 && docker-php-ext-enable redis
RUN pecl install raphf-2.0.1 && docker-php-ext-enable raphf
RUN pecl install propro-2.0.1 && docker-php-ext-enable propro
RUN pecl install pecl_http-3.2.4 && docker-php-ext-enable http
RUN pecl install imagick-3.4.4 && docker-php-ext-enable imagick
RUN pecl install igbinary-3.1.6 && docker-php-ext-enable igbinary

# Limpeza
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

EXPOSE 80
WORKDIR /usr/share/apache2/www

CMD ["apache2-foreground"]
