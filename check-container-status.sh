#!/bin/bash

##############################################################
# Script for checking the status of a Docker container.
# Takes the Docker container name or ID as argument.
##############################################################

if [ "$1" == "" ]; then
  printf "Please provide a container name\n"
  exit 1
fi

container=$1


if [ -z $container ]; then
  echo "Container ID or name required"
  exit 3
elif [ -z $(which docker) ]; then
  echo "Docker not installed"
  exit 3
elif ! docker info > /dev/null 2>&1; then
  echo "Couldn't execute Docker command. If Docker is running, please check permissions"
  exit 3
fi

status=$(docker inspect --format="{{.State.Status}}" $container 2> /dev/null)

if [ $? == 1 ]; then
  echo "$container does not exist"
  exit 3
elif [ "$status" != "running" ]; then
  echo "$container is not running"
  exit 2
fi

exit 0

