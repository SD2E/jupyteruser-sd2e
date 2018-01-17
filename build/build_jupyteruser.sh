#!/bin/bash

SDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/../"

function getTags {
	# Returns the list of tags associated with a dockerhub image
	image=$1
	wget -q https://registry.hub.docker.com/v2/repositories/${image}/tags -O - | python -c '''
import sys, json
JS = json.load(sys.stdin)["results"]
for record in JS: print record["name"]
''' 2>/dev/null
}
function containsTag {
	# 0 if image contaisn the tag 1 if not
	image=$1
	tag=$2
	getTags $image | grep -q "${tag}"
}
function getVal {
	# Gets a YAML value from README.md
	grep "$1" Dockerfile | cut -f 2 -d ' '
}
function ee {
	# Echos to STDERR
	echo -e "[ERROR] $@" 1>&2;
	exit 1
}
function ed {
	# Echos to STDERR
	echo -e "[DEBUG] $@" 1>&2;
}
function fileExists {
	# Checks to see if a file exists relaive to pwd
	if [ ! -e $1 ]; then
		ee "$1 not found in $dir"
	fi
}
function askTrue {
	# Asks a message and default to YES
	read -r -p "$1 [Y/n] " response
	[[ ! $response =~ ^([Nn]o|[Nn])$ ]]
}
function askFalse {
	# Asks a message and default to YES
	read -r -p "$1 [y/N] " response
	[[ ! $response =~ ^([Yy]es|[Yy])$ ]]
}
function prevInfo {
	IMG=$1
	prevTag=$(getTags $IMG | head -n 1)
	if [ -z $prevTag ]; then
		echo -e "\nThis will be the first tag for $IMG\n"
	else
		echo -e "\nThe previous tag was $prevTag\n"
	fi
}

function buildImage {
	# Builds an image
	cd ${SDIR}/$1
	fileExists Dockerfile
	IMG=$(getVal Image:)
	VERSION=$(getVal Version:)
	echo "Starting ${IMG}:${VERSION}"
	if containsTag $IMG $VERSION; then
		# already exists
		if ! askTrue "${VERSION} already exists for ${IMG} on dockerhub. Do you want to use that public image instead of rebuilding?"; then
			# rebuild
			echo "Building ${IMG}:${VERSION}"
			ed "docker build --build-arg image_version=${VERSION} -t $IMG:${VERSION} ."
			! docker build --build-arg image_version=${VERSION} -t $IMG:${VERSION} . && ee "Failed to build $IMG:$VERSION"
		fi
	else
		# create version for first time
		echo "Building ${IMG}:${VERSION}"
		prevInfo $IMG
		ed "docker build --build-arg image_version=${VERSION} -t $IMG:${VERSION} ."
		! docker build --build-arg image_version=${VERSION} -t $IMG:${VERSION} . && ee "Failed to build $IMG:$VERSION"
	fi
	echo "Finished ${IMG}:${VERSION}"
	# Go back to original directory
	cd $OLDPWD
}
function testImage {
	# Builds an image
	cd ${SDIR}/$1
	fileExists Dockerfile
	IMG=$(getVal Image:)
	VERSION=$(getVal Version:)
	echo ""
	if ! askFalse "Do you want to test ${IMG}:${VERSION}?"; then
		EIP=$(dig +short myip.opendns.com @resolver1.opendns.com)
		ed "Local Address: http://localhost:8888"
		ed "External Address: http://${EIP}:8888"
		#ed "docker run --rm -p 8888:8888 -v ${SDIR}/images/base/jupyter-notebook-localconf.py:/home/jupyter/.jupyter/jupyter_notebook_config.py ${IMG}:${VERSION} start-notebook.sh"
		#docker run --rm -p 8888:8888 -v ${SDIR}/images/base/jupyter-notebook-localconf.py:/home/jupyter/.jupyter/jupyter_notebook_config.py ${IMG}:${VERSION} start-notebook.sh
		ed "docker run --rm -p 8888:8888 ${IMG}:${VERSION} start-notebook.sh"
		docker run --rm -p 8888:8888 ${IMG}:${VERSION} start-notebook.sh
		if [ ! $? -eq 0 ]; then
			ee "Notebook could not launch"
		fi
	fi
	# Go back to original directory
	cd $OLDPWD
}
function pushImage {
	# Builds an image
	cd ${SDIR}/$1
	fileExists Dockerfile
	IMG=$(getVal Image:)
	VERSION=$(getVal Version:)
	echo ""
	if askTrue "Do you want to push ${IMG}:${VERSION} to dockerhub?"; then
		# Check if version already exists on dockerhub
		if containsTag $IMG $VERSION; then
			# If it does, should it be overwritten?
			echo -e "[WARNING] the tag '${VERSION}' already exists for ${IMG} on dockerhub."
			if ! askFalse "Do you want to overwrite it?"; then
				ed "Overwriting dockerhub://${IMG}:${VERSION} with local version"
				# Print info about previous tag
				prevInfo $IMG
				ed "docker push ${IMG}:${VERSION}"
				docker push ${IMG}:${VERSION}
				if [ ! $? -eq 0 ]; then
					ee "Could not push notebook to dockerhub"
				fi
			else
				echo "Please increment the 'Version' in ${SDIR}/${1}/Dockerfile and re-build"
				exit 0
			fi
		else
			prevInfo $IMG
			ed "docker push ${IMG}:${VERSION}"
			docker push ${IMG}:${VERSION}
			if [ ! $? -eq 0 ]; then
				ee "Could not push notebook to dockerhub"
			fi
		fi
	fi
	if ! askFalse "Do you want to tag ${IMG}:${VERSION} as staging?"; then
		ed "docker tag ${IMG}:${VERSION} ${IMG}:staging"
		docker tag ${IMG}:${VERSION} ${IMG}:staging
		ed "docker push ${IMG}:staging"
		docker push ${IMG}:staging
	fi
	if ! askFalse "Do you want to tag ${IMG}:${VERSION} as latest?"; then
		ed "docker tag ${IMG}:${VERSION} ${IMG}:latest"
		docker tag ${IMG}:${VERSION} ${IMG}:latest
		ed "docker push ${IMG}:latest"
		docker push ${IMG}:latest
	fi
	# Go back to original directory
	cd $OLDPWD
}
function depFunc {
	# build target
	case $2 in
	images/base)
		eval $1 images/base
		;;
	images/custom)
		echo -e "\n==================================="
		echo "Checking dependencies"
		echo "==================================="
		eval $1 images/base
		echo -e "\n==================================="
		echo "Building Target"
		echo "==================================="
		eval $1 images/custom
		;;
	*)
		ee "Please specify either\n\n - images/base\n - images/custom"
		;;
	esac
}
helpStr="Usage: $0 option target\n\nAutomating the build and deploy process for taccsciapps images\n\nPlease specify an option and target\n\nOptions:\n - build\n - test\n - push\n - all\n\nTargets:\n - images/base\n - images/custom"

# Check to see if docker commands work.
if ! docker info &> /dev/null; then
	ee "Could not communicate with docker daemon. You may need to run with sudo."
fi

# Make sure enough arguments were used
if [ ! $# -eq 2 ]; then
	ee $helpStr
fi

# Perform option on target
case $1 in
build)
	depFunc buildImage $2
	;;
test)
	depFunc testImage $2
	;;
push)
	depFunc pushImage $2
	;;
all)
	depFunc buildImage images/custom
	depFunc testImage images/custom
	depFunc pushImage images/custom
	;;
*)
	ee $helpStr
	;;
esac

echo -e "\nDONE!"
