FROM postgres:10-alpine
LABEL MAINTAINER="Artyom Nosov <chip@unixstyle.ru>"

ENV POSTGIS_VERSION 2.5.3
ENV POSTGIS_SHA256 72e8269d40f981e22fb2b78d3ff292338e69a4f5166e481a77b015e1d34e559a

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
        json-c-dev \
        libtool \
        libxml2-dev \
        make \
        pcre-dev \
        perl \
    \
    && apk add --no-cache --virtual .build-deps-testing \
        --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
        gdal-dev \
        geos-dev \
        proj-dev \
        protobuf-c-dev \
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
        json-c \
        pcre \
    && apk add --no-cache --virtual .postgis-rundeps-testing \
        --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
        geos \
        gdal \
        proj \
        protobuf-c \
    && cd / \
    && rm -rf /usr/src/postgis \
    && apk del .fetch-deps .build-deps .build-deps-testing
