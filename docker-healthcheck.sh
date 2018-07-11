#!/usr/bin/env sh

set -x

healthcheck_server() {
  curl --fail http://0.0.0.0:8000/shell/ \
    || exit 1
}

healthcheck_server
