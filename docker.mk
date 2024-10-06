SHELL := /bin/bash
DOCKER_ID := jcomeauictx
APP_ID := americancoin
TAG := $(DOCKER_ID)/$(APP_ID)
all: build
build:
	docker build --tag $(TAG) .
publish:
	docker login
	docker push $(TAG)
clean:
ifeq ($(UNDERSTOOD),1)
	-docker rm $$(docker ps -a --filter status=exited --format '{{.ID}}')
	-docker rmi $$(docker images -a | awk '$$1 ~ /^<none>$$/ {print $$3}')
else
	@echo '`make clean` will erase all intermediate images.' >&2
	@echo 'If you really want to do this, `make UNDERSTOOD=1 clean`' >&2
	false
endif
