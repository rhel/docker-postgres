FROM postgres:10-alpine
LABEL MAINTAINER="Artyom Nosov <chip@unixstyle.ru>"

RUN apk add --no-cache postgis
