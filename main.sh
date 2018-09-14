#!/bin/bash
# DIR_NAME is some directory name of your choice to be inside /docker
# $ main init DIR_NAME GIT_REPO
# $ main update DIR_NAME TAG

set -e

DOCKER_GIT_REPO=lucasbasquerotto/git
BASE_DIR=/docker
MAIN_DIR_NAME="$2"
GIT_CONF_DIR=$BASE_DIR/.conf
MAIN_DIR=$BASE_DIR/$MAIN_DIR_NAME
MAPPED_DIR=/git

function mainCmd() {
  docker run -it --rm -v $GIT_CONF_DIR:/root -v $BASE_DIR:/git $DOCKER_GIT_REPO "$@"
}

if [ $# -eq 0 ]
then
  echo "No arguments supplied"
  exit 1
fi

if [ "$1" = "init" ]
then
  GIT_REPO="$3"
 
  if [ -z "$MAIN_DIR_NAME" ]
  then
    echo "Inform the directory name"
    exit 1
  fi
  
  if [ -z "$GIT_REPO" ]
  then
    echo "No git repository supplied (need to export to MAIN_REPO environment variable)"
    exit 1
  fi

  echo "preparing"
  mainCmd config --global credential.helper store
  mainCmd clone "$GIT_REPO" "$MAIN_DIR_NAME"
  echo "prepared"
fi

if [ "$1" = "update" ]
then
  VERSION="$3"

  if [ -z "$MAIN_DIR_NAME" ]
  then
    echo "Inform the directory name"
    exit 1
  fi
  
  if [ -z "$VERSION" ]
  then
    echo "No tag supplied"
    exit 1
  fi

  echo "updating to version $VERSION"
  mainCmd -C "$MAIN_DIR_NAME" fetch
  mainCmd -C "$MAIN_DIR_NAME" reset --hard
  mainCmd -C "$MAIN_DIR_NAME" checkout -f tags/"$VERSION"
  echo "updated"
fi
