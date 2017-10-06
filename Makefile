include build/config.mk

PREFIX := $(HOME)

TACC_DOCKER_ORG := $(TACC_DOCKER_ORG)
TENANT_DOCKER_ORG := $(TENANT_DOCKER_ORG)
TENANT_DOCKER_REPO := $(TENANT_DOCKER_REPO)
RELEASE_TAG := $(RELEASE_TAG)
STAGING_TAG := $(STAGING_TAG)
LOCAL_TAG := $(LOCAL_TAG)

OBJ := $(MAKE_OBJ)
SOURCES =

.SILENT: all
all:
	echo "Not implemented. Try 'make help' for usage information."

.SILENT: help
help:
	echo "You can make: develop, tests, staging, release, clean, distclean"

.SILENT: develop
develop:
	build/images.sh "$(TACC_DOCKER_ORG)" build $(LOCAL_TAG) ; \
	touch .built ; \
	echo "Built. Now run 'make tests'."

.SILENT: tests
tests: .built
	cd test ; \
	docker-compose up -d ; \
	echo "Go to http://localhost:8888/ to test" ; \
	touch .tested

.SILENT: staging
staging: tests
	build/images.sh "$(TACC_DOCKER_ORG)" build $(STAGING_TAG) ; \
	build/docker.sh "$(TACC_DOCKER_ORG)/$(TACC_DOCKER_REPO)" "Dockerfile" release $(STAGING_TAG) ; \
	touch .staged ; \
	echo "$(TACC_DOCKER_ORG)/$(TACC_DOCKER_REPO)$(STAGING_TAG) released"

.SILENT: release
release:
	build/images.sh "$(TACC_DOCKER_ORG)" build $(RELEASE_TAG) ; \
	build/docker.sh "$(TACC_DOCKER_ORG)/$(TACC_DOCKER_REPO)" "Dockerfile" release $(RELEASE_TAG) ; \
	touch .released ; \
	echo "$(TACC_DOCKER_ORG)/$(TACC_DOCKER_REPO)$(RELEASE_TAG) released"

.SILENT: server-start
server-start:
	touch .server ; \
	cd test ; \
	docker-compose up -d > /dev/null 2>&1 ; \
	echo "Server online: Go to http://localhost:8888/ to test"

.SILENT: server-stop
server-stop:
	rm -f .server ; \
	cd test ; \
	docker-compose down > /dev/null 2>&1 ; \
	echo "Server offline"

.SILENT: server-restart
server-restart: server-stop server-start
	echo "Restarted"

.SILENT: clean-files
clean-files:
	rm -f .built .tested .staged .released ; \
	echo "Staging dotfiles deleted"

.SILENT: clean-images
clean-images:
	docker rmi -f "$(TACC_DOCKER_REPO)$(LOCAL_TAG)" ; \
	docker rmi -f "$(TACC_DOCKER_ORG)/$(TACC_DOCKER_REPO)$(STAGING_TAG)" ; \
	docker rmi -f "$(TACC_DOCKER_ORG)/$(TACC_DOCKER_REPO)$(RELEASE_TAG)" ; \

.SILENT: clean
clean: clean-files server-stop

.SILENT: distclean
distclean: clean clean-images

.SILENT: info
info: 
	echo "image: $(TACC_DOCKER_ORG)/$(TACC_DOCKER_REPO)" ; \
	echo "tags:\n - local: $(LOCAL_TAG)\n - staging: $(STAGING_TAG)\n - release: $(RELEASE_TAG)"
