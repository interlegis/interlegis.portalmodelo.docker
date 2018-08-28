# interlegis.portalmodelo.docker
Containers docker para o Portal Modelo

## Requirements

### Docker

Para usar esta imagem você precisa ter o Docker daemon instalado. Verifique a documentação em https://docs.docker.com/install/

### Docker-compose

O Docker-compose é desejável (rode como root): 

```
curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose

chmod +x /usr/local/bin/docker-compose
```

## Exemplo de Docker-compose

Salve o seguinte trecho como  docker-compose.yml no diretório de sua preferência. Preencha as variáveis no container plonecfg, para a configuração inicial do Portal Modelo: 

```
version: '2'
services:
  plone:
    image: interlegis/portalmodelo:3.0-13
    restart: always
    environment:
      ZEO_ADDRESS: zeoserver:8100
      ZEO_SHARED_BLOB_DIR: 'on'
    ports:
      - 8080:8080
      - 8881:8881
    depends_on:
     - zeoserver
    volumes:
     - data:/data

  zeoserver:
    image: interlegis/portalmodelo:3.0-13
    restart: always
    command: zeoserver
    environment:
      ZEO_SHARED_BLOB_DIR: 'on'
    volumes:
      - data:/data

  plonecfg:
    image: interlegis/portalmodelo:3.0-13
    environment:
      ZEO_ADDRESS: zeoserver:8100
      EMAIL: "contato@tecnico.leg.br"
      PASSWORD: "adminpw"
      TITLE: "Câmara Municipal"
      DESCR: "Teste - DF"
      HOSTNAME: "teste.df.leg.br"
    entrypoint: "/configure.sh"
    volumes:
      - data:/data

volumes:
  data:
    driver: local

```

## Executando

```
cd <diretorio do docker-compose.yml>
docker-compose up -d
```

## O que está acontecendo?

Para visualizar os logs na tela:

```
docker-compose logs -f
```

## Contribuindo

Aceitamos Pull Requests e Issues!
