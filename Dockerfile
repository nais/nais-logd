FROM fluent/fluentd:v1.3.2
LABEL maintainer "terje.sannum@nav.no"

# Prometheus plugin with pr 47
# https://github.com/terjesannum/fluent-plugin-prometheus/tree/patch-v1.2.1
COPY fluent-plugin-prometheus-1.2.1.gem /tmp/
# Throttle plugin with composite group support (not released on rubygems)
# https://github.com/terjesannum/fluent-plugin-throttle/tree/nais-patches
COPY fluent-plugin-throttle-0.0.3.gem /tmp/
RUN apk add --update --virtual .build-deps sudo build-base ruby-dev \
 && sudo gem install --no-document fluent-plugin-kubernetes_metadata_filter -v 2.1.6 \
 && sudo gem install --no-document fluent-plugin-elasticsearch -v 2.12.5 \
 && sudo gem install --no-document /tmp/fluent-plugin-throttle-0.0.3.gem \
 && sudo gem install --no-document fluent-plugin-rewrite-tag-filter -v 2.1.1 \
 && sudo gem install --no-document /tmp/fluent-plugin-prometheus-1.2.1.gem \
 && sudo gem install --no-document logfmt -v 0.0.8 \
 && sudo gem install --no-document nais-log-parser -v 0.33.0 \
 && sudo gem install --no-document fluent-plugin-nais -v 0.34.0 \
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
ENV THROTTLE_BUCKET_PERIOD 60
ENV THROTTLE_BUCKET_LIMIT 8000
ENV THROTTLE_RESET_RATE 100
ENV THROTTLE_DROP_LOGS true

COPY fluent.conf /fluentd/etc/
