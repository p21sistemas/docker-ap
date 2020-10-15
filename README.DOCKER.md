# Sobre este repositório

Este é o repositório Git do projeto

# Estrutura
O projeto usa uma estrutura simples, com base num container com APACHE&PHP

# Requisitos

O projeto utiliza uma rede customizada para se comunicar com suas dependências comuns com outros projetos, por exemplo `redis`, certifique-se de executar os containers do projeto default antes de executar esse projeto localmente, em ambiente de produção certifique-se que os containers default necessários estão sendo executados.

[default](link para o projeto default)

# Diretórios
```
 └───docker
│   └───bin
│   │   └─── webserver     # Container do (PHP e APACHE)
│   └───config
│   │   └─── apache        # Configuração do apache
│   │   └─── php           # Configuração do php
│   └───logs
│   │   └─── apache        # logs do apache
│   └───www 
│   │  .env                 # arquivo de variaveis do projeto. 
│   │  docker-compose.yml   # arquivo de configuração do projeto
```
---

## Desenvolvimento, teste e produção

Depois de subir os containers deafault, execute o seguinte comando na pasta raiz do projeto, dependendo do ambiente em que está.
Execute o comando abaixo no terminal e siga os passos
```
$ ./ambiente
```