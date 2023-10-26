#!/bin/bash

#set -o xtrace
CONTAINER_NAME="bess_build_env"
# v1.5 v1.6 setting
IMAGE="766589103339.dkr.ecr.us-west-2.amazonaws.com/jenkinsci/upf-dpdk-devenv"
PROJECTS_MOUNT="/home/vm76/projects:/bess/projects"
VERSION="0.1.14"

# v1.2 setting
#IMAGE="atayalan/dpdkbuildenv"
#VERSION="latest"
#PROJECTS_MOUNT="/home/vm76/projects:/home/ataya/projects"

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

