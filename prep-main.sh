#!/bin/bash
set -e

VERSION="$1"
  
if [ -z "$VERSION" ]
then
  echo "No tag supplied"
  exit 1
fi

echo "updating temporary directory to tag $VERSION..."
main update .tmp "$VERSION"

echo "pulling up-to-date images..."
cd /docker/.tmp
docker-compose pull
docker-compose build

echo "preparation finished"
