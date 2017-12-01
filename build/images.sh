#!/usr/bin/env bash

_ORG=$1
_COMMAND=$2
_TAG=$3

echo "Command: $_COMMAND"

if [[ -z "$DIR" ]]; then
    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
fi

OWD=$PWD

for _BASE in base custom sd2e
do
    ACTUAL_BASE="jupyteruser-${_BASE}"
    if [ -d "$DIR/../images/${_BASE}" ];
    then
        
        echo "Building ${ACTUAL_BASE} ..."

        cd "$DIR/../images/${_BASE}"
        if [ -f "Dockerfile" ];
        then
            $DIR/docker.sh "${_ORG}/${ACTUAL_BASE}" "Dockerfile" "${_COMMAND}" "${_TAG}" || { echo "Error building ${_ORG}/${ACTUAL_BASE}:${_TAG}" >&2 ; exit 1; }
        else
            echo "No Dockerfile. Skipping ${ACTUAL_BASE}"
        fi

    fi
    cd $OWD

done
