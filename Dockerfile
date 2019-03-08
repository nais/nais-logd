FROM fluent/fluentd:v1.4.0-debian-1.0
LABEL maintainer "terje.sannum@nav.no"

USER root
# Prometheus plugin with pr 47
# https://github.com/terjesannum/fluent-plugin-prometheus/tree/patch-v1.2.1
COPY fluent-plugin-prometheus-1.2.1.gem /tmp/
# Throttle plugin with composite group support (not released on rubygems)
# https://github.com/terjesannum/fluent-plugin-throttle/tree/nais-patches
COPY fluent-plugin-throttle-0.0.3.gem /tmp/
RUN buildDeps='ruby-dev g++ make' \
 && apt-get -y update && apt-get -y install $buildDeps libsystemd0 --no-install-recommends \
 && gem install --no-document fluent-plugin-kubernetes_metadata_filter -v 2.1.6 \
 && gem install --no-document fluent-plugin-elasticsearch -v 3.3.1 \
 && gem install --no-document /tmp/fluent-plugin-throttle-0.0.3.gem \
 && gem install --no-document fluent-plugin-rewrite-tag-filter -v 2.1.1 \
 && gem install --no-document /tmp/fluent-plugin-prometheus-1.2.1.gem \
 && gem install --no-document fluent-plugin-systemd -v 1.0.2 \
 && gem install --no-document logfmt -v 0.0.8 \
 && gem install --no-document nais-log-parser -v 0.37.0 \
 && gem install --no-document fluent-plugin-nais -v 0.37.0 \
 && gem sources --clear-all \
 && rm -rf /usr/lib/ruby/gems/*/cache/*.gem \
 && apt-get purge -y --auto-remove $buildDeps

ENV FLUENTD_OPT -q
ENV FLUENTD_CONTAINERS_POS_FILE /var/log/es-containers.log.pos
ENV FLUENTD_JOURNAL_POS_FILE /var/log/journald.log.pos
ENV ELASTICSEARCH_HOSTS elasticsearch-logging:9200
ENV ELASTICSEARCH_INDEX_PREFIX logstash-apps-test
ENV ELASTICSEARCH_TYPE_NAME containerlog
ENV ELASTICSEARCH_MAX_RETRIES 0
ENV CLUSTER_NAME kubernetes
ENV CLUSTER_ENVCLASS t
ENV THROTTLE_BUCKET_PERIOD 60
ENV THROTTLE_BUCKET_LIMIT 8000
ENV THROTTLE_RESET_RATE 100
ENV THROTTLE_DROP_LOGS true

COPY fluent.conf /fluentd/etc/

RUN usermod -u 1065 fluent
RUN groupadd -g 1065 logs
RUN usermod -g logs fluent

USER fluent
