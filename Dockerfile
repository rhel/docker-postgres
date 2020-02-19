FROM postgres:10-alpine
LABEL MAINTAINER="Artyom Nosov <chip@unixstyle.ru>"

ENV POSTGIS_VERSION 2.4.8
ENV POSTGIS_SHA256 9416647015bf5a6de44f5e8c51aad2eb35933eeee12682d75dd0fd5e82fa5659

RUN set -ex \
    \
    && apk add --no-cache --virtual .fetch-deps \
        ca-certificates \
        openssl \
        tar \
    \
    && wget -O postgis.tar.gz "http://download.osgeo.org/postgis/source/postgis-$POSTGIS_VERSION.tar.gz" \
    && echo "$POSTGIS_SHA256 *postgis.tar.gz" | sha256sum -c - \
    && mkdir -p /usr/src/postgis \
    && tar \
        --extract \
        --file postgis.tar.gz \
        --directory /usr/src/postgis \
        --strip-components 1 \
    && rm postgis.tar.gz \
    \
    && apk add --no-cache --virtual .build-deps \
        autoconf \
        automake \
        g++ \
        gdal-dev \
        geos-dev \
        json-c-dev \
        libtool \
        libxml2-dev \
        make \
        pcre-dev \
        perl \
        proj-dev \
        protobuf-c-dev \
    \
    && cd /usr/src/postgis \
    && ./autogen.sh \
    && ./configure \
        --prefix=/usr \
        --disable-gtktest \
        --disable-nls \
        --disable-rpath \
    && make \
    && make install \
    && apk add --no-cache --virtual .postgis-rundeps \
        geos \
        gdal \
        json-c \
        pcre \
        proj \
        protobuf-c \
    && cd / \
    && rm -rf /usr/src/postgis \
    && apk del .fetch-deps .build-deps
