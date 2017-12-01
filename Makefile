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

.PHONY: help
.SILENT: help
help:
	echo "You can make: develop, tests, staging, release, clean, distclean" ; \
	echo "You can make: server-start, server-restart, server-stop to manage build-local Jupyter"

.SILENT: develop
develop: 
	build/find-get-stats.sh > images/sd2e/jupyteruser-sd2e_release
	build/images.sh "$(TENANT_DOCKER_ORG)" build $(LOCAL_TAG) && \
	touch .built && \
	echo "Built. Now run 'make tests'."

.SILENT: tests
tests: .built
	cd test ; \
	docker-compose up -d && \
	echo "Go to http://localhost:8888/ to test" && \
	touch ../.tested

.PHONY: staging
.SILENT: staging
staging:
	docker tag $(TENANT_DOCKER_ORG)/$(TACC_DOCKER_REPO)$(LOCAL_TAG) $(TACC_DOCKER_ORG)/$(TACC_DOCKER_REPO)$(STAGING_TAG)
	docker push $(TACC_DOCKER_ORG)/$(TACC_DOCKER_REPO)$(STAGING_TAG)
	echo "$(TACC_DOCKER_ORG)/$(TACC_DOCKER_REPO)$(STAGING_TAG) released"

.PHONY: release
.SILENT: release
release:
	docker tag $(TACC_DOCKER_ORG)/$(TACC_DOCKER_REPO)$(STAGING_TAG) $(TACC_DOCKER_ORG)/$(TACC_DOCKER_REPO)$(RELEASE_TAG)
	docker push $(TACC_DOCKER_ORG)/$(TACC_DOCKER_REPO)$(RELEASE_TAG)
	echo "$(TACC_DOCKER_ORG)/$(TACC_DOCKER_REPO)$(RELEASE_TAG) released"

.PHONY: server-start
.SILENT: server-start
server-start:
	touch .server ; \
	cd test ; \
	docker-compose up -d > /dev/null 2>&1 ; \
	echo "Server online: Go to http://localhost:8888/ to test"

.PHONY: server-stop
.SILENT: server-stop
server-stop:
	rm -f .server ; \
	cd test ; \
	docker-compose down > /dev/null 2>&1 ; \
	echo "Server offline"

.PHONY: server-restart
.SILENT: server-restart
server-restart: server-stop server-start
	echo "Restarted"

.PHONY: clean-files
.SILENT: clean-files
clean-files:
	rm -f .built .tested .staged .released ; \
	echo "Staging dotfiles deleted"

.PHONY: clean-images
.SILENT: clean-images
clean-images:
	docker rmi -f "$(TENANT_DOCKER_ORG)/$(TACC_DOCKER_REPO)$(LOCAL_TAG)" ; \
	docker rmi -f "$(TACC_DOCKER_ORG)/$(TACC_DOCKER_REPO)$(STAGING_TAG)" ; \
	docker rmi -f "$(TACC_DOCKER_ORG)/$(TACC_DOCKER_REPO)$(RELEASE_TAG)" ; \

.PHONY: clean
.SILENT: clean
clean: clean-files server-stop

.PHONY: distclean
.SILENT: distclean
distclean: clean clean-images

.PHONY: info
.SILENT: info
info: 
	echo "devel/staging: $(TENANT_DOCKER_ORG)/$(TACC_DOCKER_REPO)" ; \
	echo "production: $(TACC_DOCKER_ORG)/$(TACC_DOCKER_REPO)" ; \
	echo "tags:\n - local: $(LOCAL_TAG)\n - staging: $(STAGING_TAG)\n - release: $(RELEASE_TAG)"
