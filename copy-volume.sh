#!/bin/bash

# Based on https://github.com/gdiepen/docker-convenience-scripts by Guido Diepen

# Convenience script that helps to easily create a clone of a given
# data volume. The script is mainly useful if you are using named volumes


if [ "$1" == "" ]; then
  printf "Please provide a source volume name\n"
  exit 1
fi

if [ "$2" = "" ]; then
  printf "Please provide a destination volume name\n"
  exit 1
fi


docker volume inspect $1 > /dev/null 2>&1
if [ "$?" != "0" ]; then
  printf "The source volume \"$1\" does not exist\n"
  exit 1
fi

docker volume inspect $2 > /dev/null 2>&1
if [ "$?" == "0" ]; then
  printf "The destination volume \"$2\" already exists\n"
  exit 1
fi


printf "Creating destination volume \"$2\"...\n"
docker volume create --name $2

printf "Copying data from source volume \"$1\" to destination volume \"$2\"...\n"
docker run --rm -it \
           -v $1:/from \
           -v $2:/to \
           alpine ash -c "cd /from ; cp -av . /to"
