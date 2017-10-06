# API tenant config
TENANT_NAME=DARPA-SD2E
TENANT_KEY=sd2e
# Make support
MAKE_OBJ=reactors
# Docker
TACC_DOCKER_ORG=taccsciapps
TACC_DOCKER_REPO=jupyteruser-sd2e
TENANT_DOCKER_ORG=sd2e
LOCAL_TAG=":devel"
STAGING_TAG=":staging"
RELEASE_TAG=":$(shell cat VERSION)"
