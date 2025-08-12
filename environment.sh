#!/bin/bash

DIRECTORY_NGINX='/etc/nginx'

#########################
# FUNCTIONS             #
#########################

read_var() {
    VAR=$(grep $1 $2 | xargs)
    IFS="=" read -ra VAR <<< "$VAR"
    echo ${VAR[1]}
}

#########################
# CODE             #
#########################

echo "##### Iniciando ambiente #####"
if [ ! -d $DIRECTORY_NGINX ]; then
  read -p "##### Deseja instalar o nginx (servidor de proxy) ?  (y/N)?" INSTALL_NGINX
  INSTALL_NGINX=${INSTALL_NGINX:-'N'}
  if [ $INSTALL_NGINX == 'y' ] || [ $INSTALL_NGINX == 'Y' ]; then
     apt-get update && apt-get -y upgrade && apt-get  install -y nginx
  fi
fi


echo "##### Criando variáveis globais #####"
PHP_STRING='php'

UNDERLINE='_'

read -p "##### Deseja baixar os arquivos de configuração novamente ? (y/N) #####" CONFIG
CONFIG=${CONFIG:-'N'}

if [ $CONFIG == 'y' ]; then
    rm -f docker-compose.yml .env exec.sh start.sh proxy bin/webserver/Dockerfile
fi

if [ ! -f .env ]; then

  if [ ! -d "www/" ]; then
    echo "##### Configuração inicial do projeto #####"
    mkdir --parents www/; mv * www/
    mv -f www/*.sh . && mkdir docs &&  mv -f www/docs docs
  fi

  echo "##### Baixando arquivo de configuração do projeto #####"

  wget --no-check-certificate --no-cache --no-cookies --quiet https://raw.githubusercontent.com/p21sistemas/docker-ap/master/sample.env
  wget --no-check-certificate --no-cache --no-cookies --quiet https://raw.githubusercontent.com/p21sistemas/docker-ap/master/proxy

  echo "##### Por favor informa o nome do projeto  Ex. sdt21_df #####"
  read ENV_PROJECT

  echo "##### Por favor informa a porta em que o projeto vai estar externamente Ex. 8080 #####"
  read ENV_PORT

  echo "#####Qual o ambiente do projeto (desenvolvimento, teste ou producao) ? #####"
  read ENV_APP

  if [ $ENV_APP == 'producao' ]; then
     echo "##### Qual o dominio do projeto ? #####"
     read ENV_DOMAIN
  fi

  if [ $ENV_APP != 'desenvolvimento' ] && [ $ENV_APP != 'teste' ] && [ $ENV_APP != 'producao' ]; then
    echo "##### O ambiente selecionado é inválido #####"
    exit;
  fi

  if [ -d $DIRECTORY_NGINX ]; then
     rm -f "$DIRECTORY_NGINX/sites-available/$ENV_PROJECT" "$DIRECTORY_NGINX/sites-enabled/$ENV_PROJECT"
     cp proxy $ENV_PROJECT
     sed -i "s/PORT_ENV/$ENV_PORT/g" $ENV_PROJECT
     sed -i "s/DOMAIN_ENV/$ENV_DOMAIN/g" $ENV_PROJECT
     cp "$ENV_PROJECT" "$DIRECTORY_NGINX/sites-available/"
     ln -s "$DIRECTORY_NGINX/sites-available/$ENV_PROJECT" "$DIRECTORY_NGINX/sites-enabled/"
     rm -f "$ENV_PROJECT"
  fi

  sed -i "s/ENV_PROJECT/$ENV_PROJECT$UNDERLINE/g" sample.env
  sed -i "s/ENV_PORT/$ENV_PORT/g" sample.env
  sed -i "s/ENV_APP/$ENV_APP/g" sample.env

  echo "##### Criando pastas do projeto #####"
  mkdir -p bin/webserver
  mkdir -p config/apache2/sites-enabled
  mkdir -p config/php
  mkdir -p logs/apache2

  echo "##### criando primeiros arquivos do projeto #####"
  touch bin/webserver/Dockerfile
  touch logs/apache2/.gitkeep

  echo "##### Por favor informa a versão do ubuntu (18)"
  read ENV_UBUNTU

  echo "##### Por favor informa a versão do php (56, 72, 73)"
  read ENV_PHP

  sed -i "s/ENV_UBUNTU/$ENV_UBUNTU/g" sample.env
  sed -i "s/ENV_PHP/$ENV_PHP/g" sample.env

  echo "FROM p21sistemas/ap:u$ENV_UBUNTU$PHP_STRING$ENV_PHP" >> bin/webserver/Dockerfile
  echo "ADD ./start.sh /start.sh" >> bin/webserver/Dockerfile
  echo "ADD ./.env /.env" >> bin/webserver/Dockerfile
  echo "RUN chmod +x /start.sh && bash /start.sh" >> bin/webserver/Dockerfile
  echo "CMD apachectl -D FOREGROUND" >> bin/webserver/Dockerfile

  echo "##### Baixando primeiros arquivos do projeto #####"
  wget --no-check-certificate --no-cache --no-cookies --quiet -O config/apache2/sites-enabled/default.conf https://raw.githubusercontent.com/p21sistemas/docker-ap/master/config/apache2/sites-enabled/default.conf
  wget --no-check-certificate --no-cache --no-cookies --quiet -O config/php/php.ini https://raw.githubusercontent.com/p21sistemas/docker-ap/master/config/php/php.ini
  wget --no-check-certificate --no-cache --no-cookies --quiet -O config/php/desenvolvimento.ini https://raw.githubusercontent.com/p21sistemas/docker-ap/master/config/php/desenvolvimento.ini
  wget --no-check-certificate --no-cache --no-cookies --quiet -O config/php/producao.ini https://raw.githubusercontent.com/p21sistemas/docker-ap/master/config/php/producao.ini

  sed -i "s/ENV_APP/$ENV_APP/g" config/apache2/sites-enabled/default.conf

  echo "##### Gerando arquivo .env #####"
  cp sample.env .env

fi

echo "##### Removendo arquivo de configuração residuais #####"
rm -f bin/webserver/.env bin/webserver/start.sh start.sh sample.env proxy
rm -f bin/webserver/.env.* bin/webserver/start.sh.* start.sh.* sample.env.* proxy.* *.cron

echo "##### Baixando arquivos essenciais #####"
wget --no-check-certificate --no-cache --no-cookies --quiet -nc https://raw.githubusercontent.com/p21sistemas/docker-ap/master/docker-compose.yml
wget --no-check-certificate --no-cache --no-cookies --quiet -nc https://raw.githubusercontent.com/p21sistemas/docker-ap/master/exec.sh && chmod +x exec.sh
wget --no-check-certificate --no-cache --no-cookies --quiet -nc https://raw.githubusercontent.com/p21sistemas/docker-ap/master/start.sh && chmod +x start.sh

PHP_ENV=$(read_var PHP_VERSION .env)

if [ $PHP_ENV == '72' ]; then
  sed -i "s/ENV_PHP_VERSION/7.2/g" docker-compose.yml
elif [ $PHP_ENV == '56' ]; then
  sed -i "s/ENV_PHP_VERSION/5.6/g" docker-compose.yml
fi

sed -i "s/ENV_APP/$ENV_APP/g" config/apache2/sites-enabled/default.conf

echo "##### Copiando arquivos de configuração #####"
cp .env bin/webserver/
cp start.sh bin/webserver/

  if [ -d "config/cron.d" ]; then
    cp config/cron.d/* bin/webserver/
  fi

echo "##### Atualizando imagem #####"

docker pull p21sistemas/ap:u$(read_var UBUNTU_VERSION .env)$PHP_STRING$(read_var PHP_VERSION .env)


read -p  "##### Deseja ignorar o cache o fazer build? ? (y/N) #####" CACHE
CACHE=${CACHE:-'N'}

if [ $CACHE == 'y' ]; then
    NOCACHE='--no-cache'
fi

echo "##### Realizando build #####"
docker compose -f docker-compose.yml build $NOCACHE

echo "##### Iniciando container #####"

docker compose -f docker-compose.yml up -d --force-recreate

echo "##### Removendo arquivo de configuração #####"

rm -f bin/webserver/.env bin/webserver/start.sh start.sh sample.env
rm -f bin/webserver/.env.* bin/webserver/start.sh.* start.sh.* sample.env.*

echo "##### Alterando permissão de pastas #####"

if [ -d "./www/data" ]; then
  sudo chown -R www-data:www-data www/data
  sudo chmod -R ug+w www/data
fi

if [ -d "./www/storage" ]; then
  sudo chown -R www-data:www-data www/storage
  sudo chmod -R ug+w www/storage
fi

echo '##### Acessando o ambiente e executando primeiros comandos #####'

read -p "##### Deseja executar o composer ?  (y/N)?" RUN_COMPOSER
RUN_COMPOSER=${RUN_COMPOSER:-'N'}
MOD_COMPOSER=''
if [ $(read_var APP_ENV .env) == 'producao' ]; then
MOD_COMPOSER='--no-dev'
fi

if [ RUN_COMPOSER == 'y' ] || [ RUN_COMPOSER == 'Y' ]; then
    docker exec -it $(read_var PROJECT_NAME .env)webserver php /usr/share/apache2/www/composer.phar install $MOD_COMPOSER -d /usr/share/apache2/www
fi


# todo list
# - Utiliza migrations para criar tabelas do banco e também alimentar o banco com os principais dados, para limar o ambiente de testes.
# @see https://laravel.com/docs/8.x/migrations Exemplo: https://github.com/jerfeson/slim4-skeleton/blob/master/app/Console/MigrationsCommand.php
