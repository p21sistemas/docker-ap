# Sobre este repositório

Este é o repositório Git da imagem Docker para apache com PHP 7.4. Consulte a página do Hub para obter ou ler sobre como usar uma imagem Docker e informações sobre contribuições e problemas.

A imagem traz só o que é comum aos projetos em PHP 7.4. Cron, ghostscript, node, xdebug e afins ficam no Dockerfile de cada projeto.

## Executando
Para executar o contêiner:

```
$ docker run -d p21sistemas/ap:u24php74
```

Raiz da web padrão:

```
/usr/share/apache2/www
```

# Contribuindo

seja bem-vindo para discutir bugs, recursos e idéias.

# License

p21sistemas/docker-ap é lançado sob a licença do MIT.
