FROM ruby:2.4.1
LABEL maintainer "terje.sannum@nav.no"

RUN gem install --no-document fluentd -v 0.14.17
RUN gem install --no-document fluent-plugin-filter-record-map -v 0.1.4
RUN gem install --no-document fluent-plugin-kubernetes_metadata_filter -v 0.27.0
RUN gem install --no-document fluent-plugin-elasticsearch -v 1.9.5

ENV ENV_TYPE test

RUN mkdir -p /etc/fluent
COPY fluent.conf /etc/fluent/

CMD ["fluentd"]
