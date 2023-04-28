#!/bin/bash

#set -o xtrace

IMAGE="atayalan/buildenv"
VERSION="latest"
CONTAINER_NAME="fgc_build_env"
PROJECTS_MOUNT="/home/vm73/projects:/home/ataya/projects"



runDocker()
{
#docker run --privileged -v $PROJECTS_MOUNT -v /dev/shm/:/dev/shm -itd --net container:pause -v ~/data/:/home/ataya/data --name $CONTAINER_NAME $IMAGE:$VERSION pause
docker run --privileged -v $PROJECTS_MOUNT -v /dev/shm/:/dev/shm -itd -v ~/data/:/home/ataya/data --name $CONTAINER_NAME $IMAGE:$VERSION pause
}

execDocker()
{
    docker exec -it $CONTAINER_NAME bash
}

stopDocker()
{
    docker stop $CONTAINER_NAME
    docker rm $CONTAINER_NAME
    sudo rm -r /dev/shm/*
}

usage()
{
    echo "usage: $0 [-r|--run] [-e|--exec] [-s|--stop]"
}

if [ "$1" != "" ]
then
    case $1 in
        -r | --run)
            runDocker
            ;;
        -e | --exec)
            execDocker
            ;;
        -s | --stop)
            stopDocker
            ;;
        *) 
            usage
            exit 1
    esac
else
    usage
fi

