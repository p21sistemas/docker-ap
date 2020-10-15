#!/bin/bash
echo "##### Iniciando ambiente #####"

echo "##### Copiando arquivos de configuração #####"
cp .env bin/webserver/
echo "##### Baixando shell script #####"
wget
echo "##### Atualizando imagem #####"
docker pull p21sistemas/ap:php56

echo "##### Deseja ignorar o cache o fazer build? ? (N/y) #####"
read cache

if [ $cache == 'y' ]; then
    NOCACHE='--no-cache'
fi

echo "##### Realizando build #####"
docker-compose -f docker-compose.yml build $NOCACHE

echo "##### Iniciando container #####"

docker-compose -f docker-compose.yml up -d --force

echo "##### Removendo arquivo de configuração #####"
rm bin/webserver/.env

echo '##### Acessando o ambiente e executando primeiros comandos #####'

read_var() {
    VAR=$(grep $1 $2 | xargs)
    IFS="=" read -ra VAR <<< "$VAR"
    echo ${VAR[1]}
}

docker exec -it $(read_var PROJECT_NAME .env)webserver php /usr/share/apache2/www/composer.phar install -d /usr/share/apache2/www

# todo list
# - Utiliza migrations para criar tabelas do banco e também alimentar o banco com os principais dados, para limar o ambiente de testes.
# @see https://laravel.com/docs/8.x/migrations Exemplo: https://github.com/jerfeson/slim4-skeleton/blob/master/app/Console/MigrationsCommand.php