#!/bin/bash

REPO=$1
DOCKERFILE=$2
COMMAND=$3
TAG=$4

echo "#########################"
echo "cmd: $COMMAND"
echo "image: $REPO"
echo "tag: $TAG"
echo "dockerfile: $DOCKERFILE"
echo "========================="

function die {

    die "$1"
    exit 1

}

DOCKER_INFO=`docker info > /dev/null`
if [ $? -ne 0 ] ; then die "Docker not found or unreachable. Exiting." ; fi

if [[ "$COMMAND" == "build" ]];
then

    docker build --force-rm --rm=true -t ${REPO}${TAG} -f ${DOCKERFILE} .
    if [ $? -ne 0 ] ; then die "Error on build. Exiting." ; fi

    IMAGEID=`docker images -q  ${REPO}${TAG}`
    if [ $? -ne 0 ] ; then die "Can't find image ${REPO}${TAG}. Exiting." ; fi

fi

if [[ "$COMMAND" == "release" ]];
then
    docker push ${REPO}${TAG}
    if [ $? -ne 0 ] ; then die "Error pushing to Docker Hub. Exiting." ; fi
fi

if [[ "$COMMAND" == "clean" ]];
then

    docker rmi -f ${REPO}${TAG} && docker rmi -f ${REPO}:latest
    if [ $? -ne 0 ] ; then die "Error deleting local images. Exiting." ; fi
fi
