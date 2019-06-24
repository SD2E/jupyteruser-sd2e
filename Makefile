.PHONY: build test docker help stage release clean
ifndef VERBOSE
.SILENT: build test docker help stage release clean
endif

all: help
	@:

.PHONY: help
help:

	echo "\nUsage: make [action] [target]\n" && \
	echo "Actions:" && \
	echo " - build   - build docker images locally" && \
	echo " - test    - test images locally" && \
	echo " - stage   - push images to staging environment" && \
	echo " - release - push images to production environment\n" && \
	echo "Targets:" && \
	echo " - base - Recipe in images/base" && \
	echo " - sd2e - Recipe in images/sd2e which is where all community software should belong" && \
	echo " - singularity - Image for running on TACC HPC" && \
	echo " - ml - Image for running ML on TACC HPC\n"

# Make sure image targets are not used as make targets
%:
	@:

docker:
	docker info 1> /dev/null 2> /dev/null && \
	if [ ! $$? -eq 0 ]; then \
		echo "\n[ERROR] Could not communicate with docker daemon. You may need to run with sudo.\n"; \
		exit 1; \
	fi

build: docker
	TARGET=$(filter-out $@,$(MAKECMDGOALS)) && \
	case $${TARGET} in \
	base) \
		build/build_jupyteruser.sh build images/base; \
		;; \
	sd2e) \
		build/build_jupyteruser.sh build images/sd2e; \
		;; \
	singularity) \
		build/build_jupyteruser.sh build images/singularity; \
		;; \
	ml) \
		build/build_jupyteruser.sh build images/ml; \
		;; \
	*) \
		$(MAKE) help; \
		;; \
	esac

test: docker
	TARGET=$(filter-out $@,$(MAKECMDGOALS)) && \
	case $$TARGET in \
	base) \
		build/build_jupyteruser.sh test images/base; \
		;; \
	sd2e) \
		build/build_jupyteruser.sh test images/sd2e; \
		;; \
	singularity) \
		build/build_jupyteruser.sh test images/singularity; \
		;; \
	ml) \
		build/build_jupyteruser.sh test images/ml; \
		;; \
	*) \
		$(MAKE) help; \
		;; \
	esac

stage: docker
	TARGET=$(filter-out $@,$(MAKECMDGOALS)) && \
	case $$TARGET in \
	base) \
		build/build_jupyteruser.sh stage images/base; \
		;; \
	sd2e) \
		build/build_jupyteruser.sh stage images/sd2e; \
		;; \
	singularity) \
		build/build_jupyteruser.sh stage images/singularity; \
		;; \
	ml) \
		build/build_jupyteruser.sh stage images/ml; \
		;; \
	*) \
		$(MAKE) help; \
		;; \
	esac

release: docker
	TARGET=$(filter-out $@,$(MAKECMDGOALS)) && \
	case $$TARGET in \
	base) \
		build/build_jupyteruser.sh release images/base; \
		;; \
	sd2e) \
		build/build_jupyteruser.sh release images/sd2e; \
		;; \
	singularity) \
		build/build_jupyteruser.sh release images/singularity; \
		;; \
	ml) \
		build/build_jupyteruser.sh release images/ml; \
		;; \
	*) \
		$(MAKE) help; \
		;; \
	esac

clean: docker
	TARGET=$(filter-out $@,$(MAKECMDGOALS)) && \
	build/build_jupyteruser.sh clean images/ml && \
	build/build_jupyteruser.sh clean images/singularity && \
	build/build_jupyteruser.sh clean images/sd2e && \
	build/build_jupyteruser.sh clean images/base
