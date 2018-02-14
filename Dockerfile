FROM fluent/fluentd:v1.1.0
LABEL maintainer "terje.sannum@nav.no"

RUN apk add --update --virtual .build-deps sudo build-base ruby-dev \
 && sudo gem install --no-document fluent-plugin-kubernetes_metadata_filter -v 1.0.1 \
 && sudo gem install --no-document fluent-plugin-elasticsearch -v 2.6.0 \
 && sudo gem install --no-document nais-log-parser -v 0.20.0 \
 && sudo gem install --no-document fluent-plugin-nais -v 0.20.0 \
 && sudo gem sources --clear-all \
 && apk del .build-deps \
 && rm -rf /var/cache/apk/* \
           /usr/lib/ruby/gems/*/cache/*.gem

ENV FLUENT_UID 0
ENV FLUENTD_OPT -q
ENV LOGD_POS_FILE_DIR /var/log
ENV ELASTICSEARCH_HOSTS elasticsearch-logging:9200
ENV ELASTICSEARCH_INDEX_PREFIX logstash-apps-test
ENV CLUSTER_NAME kubernetes
ENV CLUSTER_ENVCLASS t

COPY fluent.conf /fluentd/etc/
