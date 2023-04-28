#!/bin/bash

#set -o xtrace

IMAGE="atayalan/dpdkbuildenv"
VERSION="latest"
CONTAINER_NAME="bess_build_env"
PROJECTS_MOUNT="/home/vm73/projects:/home/ataya/projects"


runDocker()
{
    docker run --privileged -v $PROJECTS_MOUNT -itd --network bridge --name $CONTAINER_NAME $IMAGE:$VERSION pause
}

execDocker()
{
    docker exec -it $CONTAINER_NAME bash
}

stopDocker()
{
    docker stop $CONTAINER_NAME
    docker rm $CONTAINER_NAME
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

