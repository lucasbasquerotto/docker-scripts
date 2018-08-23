#!/bin/sh

set -e

echo "git running inside docker at ~/bin/git"
docker run -ti --rm --user $(id -u):$(id -g) -v ${HOME}:/root -v $(pwd):/git lucasbasquerotto/git "$@"
