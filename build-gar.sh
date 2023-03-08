#!/bin/bash

IFS=$'\n'
for tag in ${DOCKER_METADATA_OUTPUT_TAGS}; do
  docker build -t "$tag" \
    --build-arg "GEM_VERSION_NAIS_LOG_PARSER=$1" \
    --build-arg "GEM_VERSION_FLUENT_PLUGIN_NAIS=$2" \
  .
done
