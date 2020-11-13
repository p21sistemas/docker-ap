# Sobre este repositório

Este é o repositório Git da imagem Docker para apache com PHP. 

Consulte a página do Hub para obter ou ler sobre como usar uma imagem Docker e informações sobre contribuições e problemas.

Esse projeto fornece apenas o servidor web e o PHP, entende-se que por padrão vários apps dependendo do ambiente podem usar o mesmo container
de redis, phpmyadmin, mysql e blackfire.io, dependendo so ambiente em que é configurado, para este fim existe um repositório especifico para lidar com containers default's

Você é livre para mesclar os projetos desdro do seu projeto.

[Docker Default](https://github.com/p21sistemas/docker-default)

## Controle de versão
| Docker Tag | GitHub Release | Versão do apache | Versão do PHP | Versão do ubuntu |
|-----|-------|-----|--------|--------|
| php56 | [php56 Branch](https://github.com/p21sistemas/docker-ap/tree/u18php56) | 2.4 | 5.6.x | 18.04 |
| php72 | php72 Branch | 2.4 | 7.2.x | 18.04 |
| php73 | php73 Branch | 2.4 | 7.3.x | 18.04 |

## environment.sh
Esse script é baixado através do arquivo `init.sh`, dentro de cada projeto;

Para iniciar um novo projeto com docker, baixa o arquivo `init.sh`, insira no projeto e o execute

#### Responsabilidade

Esse arquivo é responsável por toda a configuração inical de um projeto, incluindo instalação opcional de servidor para proxy, determinação de porta, variáveis de ambiente de sistema além de configurações genericas de container

Se você entende um pouco de shell script, vai entender rapidamente como ele funciona.

## start.sh
Esse script é baixado através do arquivo environment.sh de cada projeto, ele será executado dentro do container para realizar algumas configurações

Ele está nesse repositório por uma questão de limitação técnica/docker de lidar com variaveis

## exec.sh 
Esse script é baixado através do arquivo init.sh, dentro de cada projeto;

### Ordem de execução

` init.sh > environment.sh/exec > start.sh`

## Contribuindo

seja bem-vindo para discutir bugs, recursos e idéias.

## License

 p21sistemas/docker-ap é lançado sob a licença do MIT.
