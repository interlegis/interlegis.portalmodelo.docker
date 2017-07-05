# interlegis.portalmodelo.docker
Containers docker para o Portal Modelo

## Requirements

### Docker

Para usar esta imagem você precisa ter o Docker daemon instalado. Rode o seguinte comando como root:

```
curl -ssl https://get.docker.com | sh
```

### Docker-compose

O Docker-compose é desejável (rode também como root): 

```
curl -L https://github.com/docker/compose/releases/download/1.13.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose

chmod +x /usr/local/bin/docker-compose
```

## Exemplo de Docker-compose

Salve o seguinte trecho como  docker-compose.yml no diretório de sua preferência. 

```
version: '2'
services:
  plone:
    image: interlegis/portalmodelo:3.0-1
    environment:
      ZEO_ADDRESS: zeoserver:8100
      ZEO_SHARED_BLOB_DIR: 'on'
    command: fg
    depends_on:
      - zeoserver
    volumes:
      - data:/data
    ports:
      - 8080:8080
  zeoserver:
    image: interlegis/portalmodelo:3.0-1
    command: zeoserver
    environment:
      ZEO_SHARED_BLOB_DIR: 'on'
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
