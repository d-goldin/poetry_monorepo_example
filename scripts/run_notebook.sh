#!/usr/bin/env sh

REPO_DIR="$(cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )/.."

cd ${REPO_DIR}/notebooks
poetry install
poetry run jupyter notebook --ip 0.0.0.0 --port 8888 --allow-root
