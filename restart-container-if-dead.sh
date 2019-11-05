#!/bin/bash

##############################################################
# Re-Run a dead Docker container with docker-compose.
#
# Script needs three arguments:
#   1 - Name of container to check
#   2 - URL of repository tar.gz where Docker files are located
#   3 - Name of docker-compose file within repository
#
# Dependency: /usr/local/bin/check-container-status.sh
#
##############################################################

if [ "$1" == "" ] || [ "$2" == "" ] || [ "$3" == "" ]; then
  printf "Please provide all arguments:\n 1 - Container Name\n 2 - URL to <repo>.tar.gz\n 3 - docker-compose file name\n"
  exit 1
fi


container=$1
repository_tar=$2
composefile=$3

workingdir='/tmp/'$(date +"%m%d%y_%H%M")


/usr/local/bin/check-container-status.sh $container
status=$?

if [ $status == 0 ]; then
  exit 0
elif [ $status == 3 ]; then
  logger "Docker container $container not present"
  exit 0
elif [ $status == 2 ]; then
  logger "Docker container $container is dead, try re-running it with docker-compose"
  docker rm $container
  logger "Downloading $repository_tar to obtain Docker files"
  curl $repository_tar -k --create-dirs -o $workingdir/repofiles && tar -C $workingdir -xzf $workingdir/repofiles
  repopath=$(ls -d $workingdir/*/)
  /usr/local/bin/docker-compose -f $repopath$composefile up -d
  result=$?
  rm -rf $workingdir
fi

if [ $result == 0 ]; then
  logger "Successfully started container $container"
  exit 0
else
  logger "Could not restart container $container; docker-compose exit code was $result"
  exit 1
fi
