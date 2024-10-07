SHELL := /bin/bash
DOCKER_ID := jcomeauictx
USERNAME := americancoiner
APP_ID := americancoind
TAG := $(DOCKER_ID)/$(APP_ID)
ifeq ($(SHOWENV),)
	export USERNAME
else
	export
endif
all: build
build: Dockerfile americancoind
	docker build --tag $(TAG) .
%: %.template
	# FIXME: use envsubst
	#envsubst < $< > $@
	cp -f $< $@
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
env:
ifeq ($(SHOWENV),)
	$(MAKE) SHOWENV=1 $@
else
	$@
endif
