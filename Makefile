SHELL=bash

DOCKER = docker
DOCKER_COMPOSE = docker-compose
YARN = $(DOCKER_COMPOSE) run -T app yarn

# Helper variables
_TITLE := "\033[32m[%s]\033[0m %s\n" # Green text
_ERROR := "\033[31m[%s]\033[0m %s\n" # Red text

##
## Project
## ───────
##

.DEFAULT_GOAL := help
help: ## Show this help message
	@grep -E '(^[a-zA-Z_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf " \033[32m%-25s\033[0m%s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'
.PHONY: help

install: build node_modules start  ## Install and start the project
.PHONY: install

build: build-docker-image
	@$(DOCKER_COMPOSE) build --force-rm --compress
.PHONY: build

start: ## Start the project
	@$(DOCKER_COMPOSE) up --detach --remove-orphans --no-recreate
.PHONY: start

stop: ## Stop the project
	@$(DOCKER_COMPOSE) stop
.PHONY: stop

restart: stop start ## Restart the project
.PHONY: restart

kill:
	@$(DOCKER_COMPOSE) kill
.PHONY: kill

clean: ## Stop the project and remove generated files and configuration
	@printf $(_ERROR) "WARNING" "This will remove ALL containers, data, cache, to make a fresh project! Use at your own risk!"

	@if [[ -z "$(RESET)" ]]; then \
		printf $(_ERROR) "WARNING" "If you are 100% sure of what you are doing, re-run with \"$(MAKE) RESET=1 ...\"" ; \
		exit 0 ; \
	fi ; \
	\
	$(DOCKER_COMPOSE) down --volumes --remove-orphans \
	&& rm -rf \
		node_modules/ \
		webdriver/webdriverio/node_modules/ \
		dist/ \
		.gitlab-ci-local/ \
		src-tauri/target/ \
	\
	&& printf $(_TITLE) "OK" "Done!"
.PHONY: clean

node_modules:
	$(YARN) install
	$(YARN) --cwd webdriver/webdriverio install
.PHONY: node_modules

##
## Docker image
## ──
##

docker-build: get-image-name ## Build the project's Docker image
	@$(DOCKER) build --compress --tag $(DOCKER_IMAGE_NAME) .
.PHONY: build-docker-image

docker-push: get-image-name ## Push the project's Docker image to Gitlab's registry
	$(DOCKER) push $(DOCKER_IMAGE_NAME)
.PHONY: push

get-image-name:
	@if [ -z "$(DOCKER_IMAGE_NAME)" ]; then \
		printf $(_ERROR) "ERROR" "Please specify the name of the docker image you want to build."; \
		printf $(_ERROR) "ERROR" ""; \
		printf $(_ERROR) "ERROR" "Usage:"; \
		printf $(_ERROR) "ERROR" "    make -e DOCKER_IMAGE_NAME=your_image_name [...]"; \
		printf $(_ERROR) "ERROR" ""; \
    	exit 1; \
	else \
    	echo "OKOK"; \
	fi;
.PHONY: get-image-name

##
## QA
## ──
##

test: ## Execute tests
	$(YARN) test
.PHONY: test
