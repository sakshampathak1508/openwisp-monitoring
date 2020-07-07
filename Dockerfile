FROM python:3.7.5-slim-buster

RUN apt update && \
    apt install --yes zlib1g-dev libjpeg-dev gdal-bin libproj-dev \
    libgeos-dev libspatialite-dev libsqlite3-mod-spatialite \
    sqlite3 libsqlite3-dev openssl libssl-dev fping && \
    rm -rf /var/lib/apt/lists/* /root/.cache/pip/* /tmp/*

COPY install-dev.sh requirements-test.txt requirements.txt /opt/openwisp/
RUN pip install -r /opt/openwisp/requirements.txt && \
    pip install -r /opt/openwisp/requirements-test.txt && \
    sh /opt/openwisp/install-dev.sh && \
    rm -rf /var/lib/apt/lists/* /root/.cache/pip/* /tmp/*

ADD . /opt/openwisp
RUN pip install -U /opt/openwisp && \
    rm -rf /var/lib/apt/lists/* /root/.cache/pip/* /tmp/*
WORKDIR /opt/openwisp/tests/
ENV NAME=openwisp-monitoring \
    PYTHONBUFFERED=1 \
    INFLUXDB_HOST=influxdb \
    REDIS_HOST=redis \
    ELASTICSEARCH_HOST=es01
CMD ["sh", "docker-entrypoint.sh"]
EXPOSE 8000
