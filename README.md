# Simple scaffold mono-repo layout

This is a basic example of a python+poetry oriented monorepo with a docker
based workflow. The idea

This repository layout currently only hosts python utilizing poetry and
provides some general Makefiles and a Dockerfile to build and run a particular
app.

Note: In many cases its a bit redundant to run virtualenvs within docker, but
it's easier to go with it in this case, as it allows for pretty similar workflows
within and outside of a container. For the production image or so once could consider
to optimize that (poetry has a config flag to not use virtualenvs).

## Prerequisites

* Working docker installation
* Poetry if local development outside of docker is desired
* GNU make

## Usage

make `docker-run` and `docker-notebook` for interactive development within docker.
Those invocations also mount in a local dir into the poetry virtualenv cache to
preserve it across container runs and improve iteration speed.

There are three alpine based docker images available, including a simple poetry
based mechanism for pushing common and slow to build dependencies (like numpy -
at least on alpine, due to using musl instead of glibc) into the base image,
see `build/dockerfiles/Dockerfile.base`. The docker builds are "cached" via marker
files to avoid running `docker build`, which is slow even if everything is cached.
Those can be removed using `make docker-clean`.

## Libraries

Right now poetry depends on the libraries via relative path, which allows it to
pick up whatever state of the code is available in the repo itself.

The dependencies themselves don't really need to be installed individually, but could be
built using poetry to distribute tarballs/wheels. A few Makefiles could be created for that
but are left out for brevity.

Unfortunately it's currently not possible to "rename" packages, so the
path-duplication issue remains, but I guess it's fine, since it pretty common
in the python world. I was hoping poetrys "package" could work for that, but
it contains no renaming support, so its probably better to live with the
"aesthetical" shortcoming of duplication than the complexity needed to avoid
it.

## Notebooks

There is also an example of how to run notebooks from within poetry using
the local state of libraries, just like in the application.

## Apps

Apps could be run using poetry run quite easily in their own virtualenv
containing all the transitive dependencies of the libraries required.
