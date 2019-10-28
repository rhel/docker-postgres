FROM postgres:10
LABEL MAINTAINER="Artyom Nosov <chip@unixstyle.ru>"

RUN apt-get update \
 && apt-get install -y postgis \
 && rm -rf /var/lib/apt/lists/*
