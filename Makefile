.PHONY: apps docker-prod docker-run docker-notebook clean

REPO_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
CACHE_DIR=$(REPO_DIR)/.poetry_venvs
CONTAINER_CACHE_DIR=/root/.cache/pypoetry/virtualenvs

DOCKERFILES_DIR=build/dockerfiles
DOCKER_BASE=$(DOCKERFILES_DIR)/.Dockerfile.base.tag
DOCKER_DEV=$(DOCKERFILES_DIR)/.Dockerfile.dev.tag
DOCKER_PROD=$(DOCKERFILES_DIR)/.Dockerfile.prod.tag

NOTEBOOK_PORT=8888

VERSION="latest"

IMAGE_PREFIX="poetry_test"

app1:
	cd apps/app1 && poetry install

# This should be deduplicated with a bit more make-fu
$(DOCKER_BASE): $(DOCKERFILES_DIR)/Dockerfile.base
	docker build -t $(IMAGE_PREFIX)_base:$(VERSION) -f $(DOCKERFILES_DIR)/Dockerfile.base .
	touch $@

$(DOCKER_PROD): $(DOCKERFILES_DIR)/Dockerfile.prod

	docker build -t $(IMAGE_PREFIX)_prod:$(VERSION) -f $(DOCKERFILES_DIR)/Dockerfile.prod .
	touch $@

$(DOCKER_DEV): $(DOCKERFILES_DIR)/Dockerfile.dev
	docker build -t $(IMAGE_PREFIX)_dev:$(VERSION) -f $(DOCKERFILES_DIR)/Dockerfile.dev .
	touch $@

docker-prod: $(DOCKER_PROD)

docker-run: $(DOCKER_DEV)
	docker run -it -v $(CACHE_DIR):$(CONTAINER_CACHE_DIR) \
		-v $(REPO_DIR):/src -w /src \
		-it $(IMAGE_PREFIX)_dev /bin/bash

docker-notebook: $(DOCKER_DEV)
	docker run -it -v $(CACHE_DIR):$(CONTAINER_CACHE_DIR) \
		-v $(REPO_DIR):/src -w /src \
		-p $(NOTEBOOK_PORT):8888 \
		-it $(IMAGE_PREFIX)_dev /src/scripts/run_notebook.sh

docker-clean:
	rm $(DOCKERFILES_DIR)/.Dockerfile.*.tag

# Watch out, this will nuke a lot of things, like the poetry cache
# and files listed in .gitignore.
clean:
	git clean -xdf --dry-run
