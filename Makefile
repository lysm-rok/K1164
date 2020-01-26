SHELL := /bin/bash

PROJECT_NAME=K1164

# set binary
docker-compose = docker-compose -f docker/docker-compose.yml -p $(PROJECT_NAME)
jekyll = $(docker-compose) run --rm jekyll jekyll
bundler = $(docker-compose) run --rm jekyll bundler

.DEFAULT_GOAL := help
.PHONY: help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sed -e 's/Makefile://' -e 's/:/##/g'  | awk 'BEGIN {FS = "##"}; {printf "\033[36m%-30s\033[0m %-30s %s\n", $$1, $$3,$$4}'


install: up assets ## ## Install project from scratch

uninstall: clean ## ## Uninstall project
	$(docker-compose) down --remove-orphans -v

reinstall: uninstall install ## ## Reinstall existing project from scratch

up: ## [container=] ## (Re-)Create and start containers
	$(docker-compose) up -d --remove-orphans

ps: ## [container=] ## List containers status
	$(docker-compose) ps $(container)

logs: ## [container=] ## Show containers logs
	$(docker-compose) logs -f $(container)

jekyll: ## [CMD=] ## Launch console command
	$(jekyll) ${CMD}

clean: ## ## Remove project dependencies
	rm -rf _site/

assets: ## ## Generate assets
