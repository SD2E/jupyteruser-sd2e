#!/bin/bash

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
function ew {
	# Echos to STDERR
	echo -e "[WARNING] $@" 1>&2;
}
function fileExists {
	# Checks to see if a file exists relaive to pwd
	if [ ! -e $1 ]; then
		ee "$1 not found"
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
	fileExists $1/Dockerfile
	cd $1
	IMG=$(getVal Image:)
	VERSION=$(getVal Version:)
	DEP=$(getVal FROM)
	if [ -z "$(docker images -q $DEP)" ] && ! containsTag ${DEP%%:*} ${DEP##*:}; then
		ee "Could not find $DEP locally or on dockerhub. Please build it to build ${1}"
	fi
	echo "Starting ${IMG}:${VERSION}"
	if containsTag $IMG $VERSION; then
		# already exists
		if ! askFalse "${VERSION} already exists for ${IMG} on dockerhub. Did you want to increment the version?"; then
			echo -e "\nPlease increment \"Version:\" in $1/Dockerfile\n"
			exit 0
		fi
	fi
	ed "Building ${IMG}:${VERSION}"
	prevInfo $IMG
	ed "docker build --build-arg image_version=${VERSION} -t $IMG:${VERSION} ."
	! docker build --build-arg image_version=${VERSION} -t $IMG:${VERSION} . && ee "Failed to build $IMG:$VERSION"
	ed "Finished ${IMG}:${VERSION}"
}

function testImage {
	# Builds an image
	fileExists $1/Dockerfile
	cd $1
	IMG=$(getVal Image:)
	VERSION=$(getVal Version:)
	echo ""
	if ! askFalse "Do you want to test ${IMG}:${VERSION}?"; then
		EIP=$(dig +short myip.opendns.com @resolver1.opendns.com)
		ed "Local Address: http://localhost:8888"
		ed "External Address: http://${EIP}:8888"
		ed "docker run --rm -p 8888:8888 ${IMG}:${VERSION} start-notebook.sh"
		docker run --rm -p 8888:8888 ${IMG}:${VERSION} start-notebook.sh
		if [ ! $? -eq 0 ]; then
			ee "Notebook could not launch"
		fi
	fi
}

function cleanImage {
	# Builds an image
	fileExists $1/Dockerfile
	cd $1
	IMG=$(getVal Image:)
	docker images -a | grep ${IMG} | awk '{print $3}' | xargs -n 1 docker rmi -f
	docker images -q --filter dangling=true | xargs -n 1 docker rmi -f
}

function pushImage {
	# Builds an image
	fileExists $1/Dockerfile
	cd $1
	IMG=$(getVal Image:)
	VERSION=$(getVal Version:)
	echo ""
	if askTrue "Do you want to push ${IMG}:${VERSION} to dockerhub?"; then
		# Check if version already exists on dockerhub
		if containsTag $IMG $VERSION; then
			# If it does, should it be overwritten?
			ew "the tag '${VERSION}' already exists for ${IMG} on dockerhub."
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
				echo "Please increment the 'Version:' in ${1}/Dockerfile and re-build"
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
	if askTrue "Do you want to tag ${IMG}:${VERSION} as ${3}?"; then
		ed "docker tag ${IMG}:${VERSION} ${IMG}:${3}"
		docker tag ${IMG}:${VERSION} ${IMG}:${3}
		ed "docker push ${IMG}:${3}"
		docker push ${IMG}:${3}
	fi
}

helpStr="Usage: $0 option target\n\nAutomating the build and deploy process for taccsciapps images\n\nPlease specify an option and target\n\nOptions:\n - build\n - test\n - push\n - all\n\nTargets:\n - images/base\n - images/custom"

# Make sure enough arguments were used
if [ ! $# -eq 2 ]; then
	ee $helpStr
fi

# Perform option on target
case $1 in
build)
	buildImage $2
	;;
test)
	testImage $2
	;;
stage)
	pushImage $2 staging
	;;
release)
	pushImage $2 latest
	;;
clean)
	cleanImage $2 2> /dev/null
	exit 0
	;;
*)
	ee $helpStr
	;;
esac

echo -e "\nDONE!"
