#!/bin/bash

set -euo pipefail

readonly SCHEMA_LOCATION="https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/"

run_cmd() {
    local charts_dir="$(git diff --find-renames --name-only "$(git rev-parse --abbrev-ref HEAD)" remotes/origin/master -- charts | grep '[cC]hart.yaml' | sed -e 's#/[Cc]hart.yaml##g')"

    # validate charts
    for chart in ${charts_dir}; do
      helm kubeval "${chart}" --values "${chart}"/ci/ci-values.yaml --strict --schema-location "${SCHEMA_LOCATION}"
    done
}

run_cmd

