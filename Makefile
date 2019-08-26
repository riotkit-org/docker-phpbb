
IMAGE=quay.io/riotkit/php-app:7.2-x86_64
REPO=phpbb/phpbb
SHELL=/bin/bash
SUDO=sudo
IMG_DH=wolnosciowiec/phpbb
IMG_QUAY=quay.io/riotkit/phpbb
PUSH=true

help:
	@grep -E '^[a-zA-Z\-\_0-9\.@]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

all: ## Build all versions
	python ./build-all-releases.py PUSH=${PUSH}

build: ## Build a specifc version (TAG=release-3.2.7, VERSION=3.2.7)
	set -xe; \
	url=https://api.github.com/repos/${REPO}/tarball/${TAG}; \
	\
	./notify.sh "$SLACK_URL" "[IN-PROGRESS] Building ${REPO} version: ${VERSION}"; \
	\
	wget $$url -O ./application.tar.gz; \
	VERSION=${VERSION} FROM_IMAGE=${IMAGE} j2 ./Dockerfile.j2 > ./Dockerfile; \
	${SUDO} docker build . -f ./Dockerfile -t ${IMG_DH}:${VERSION}; \
	${SUDO} docker tag ${IMG_DH}:${VERSION} ${IMG_QUAY}:${VERSION}; \
	\
	if [[ "${PUSH}" == "true" ]]; then \
		${SUDO} docker push ${IMG_DH}:${VERSION}; \
		${SUDO} docker push ${IMG_QUAY}:${VERSION}; \
	fi; \
	\
	./notify.sh "$SLACK_URL" "[OK] built ${REPO} version: ${VERSION}"

test_run: ## Run a container
	${SUDO} docker run --name test_app --rm -p 8000:80 ${IMG_DH}:${VERSION}

clean: ## Clean up build files
	rm -f ./Dockerfile application.tar.gz
