# Sobre este repositório

Este é o repositório Git da imagem Docker para apache com PHP. Consulte a página do Hub para obter ou ler sobre como usar uma imagem Docker e informações sobre contribuições e problemas.

This is the Git repository of the Docker image for apache with PHP. See a Hub page to get or read me about using a Docker image and information about contributions and issues.

## Controle de versão
| Docker Tag | GitHub Release | Versão do apache | Versão do PHP | Versão do ubuntu |
|-----|-------|-----|--------|--------|
| php56 | [php56 Branch](https://github.com/p21sistemas/docker-ap/tree/php56) | 2.4 | 5.6.x | 18.04 |
| php72 | php72 Branch | 2.4 | 7.2.x | 18.04 |
| php73 | php73 Branch | 2.4 | 7.3.x | 18.04 |

## environment.sh
Esse script é baixado através do arquivo init.sh, dentro de cada projeto;

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
