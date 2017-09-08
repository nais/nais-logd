FROM fluent/fluentd:v0.14.18
LABEL maintainer "terje.sannum@nav.no"

RUN apk add --update --virtual .build-deps sudo build-base ruby-dev \
 && sudo gem install --no-document fluent-plugin-filter-record-map -v 0.1.4 \
 && sudo gem install --no-document fluent-plugin-kubernetes_metadata_filter -v 0.27.0 \
 && sudo gem install --no-document fluent-plugin-elasticsearch -v 1.9.5 \
 && sudo gem sources --clear-all \
 && apk del .build-deps \
 && rm -rf /var/cache/apk/* \
           /home/fluent/.gem/ruby/2.3.0/cache/*.gem

ENV FLUENT_UID 0
ENV LOGD_POS_FILE_DIR /var/log
ENV ELASTICSEARCH_HOST elasticsearch-logging
ENV ELASTICSEARCH_PORT 9200
ENV ELASTICSEARCH_INDEX_PREFIX logstash-apps-test
ENV CLUSTER_NAME kubernetes
ENV CLUSTER_ENVCLASS t

COPY fluent.conf /fluentd/etc
