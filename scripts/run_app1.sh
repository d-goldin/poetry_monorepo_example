#!/usr/bin/env sh

REPO_DIR="$(cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )/.."

cd ${REPO_DIR}/apps/app1/
poetry install
poetry run
