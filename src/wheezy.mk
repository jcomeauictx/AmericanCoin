# some recipes require bashisms
SHELL=/bin/bash
MAKEFILE := $(lastword $(MAKEFILE_LIST))
DISTRO ?= $(MAKEFILE:.mk=)
MACHINE ?= i386
i386 := 32
amd64 := 64
LOCATION := /opt/$(DISTRO)$($(MACHINE))
wheezy := http://archive.debian.org/debian
jessie := http://deb.debian.org/debian
stretch := http://deb.debian.org/debian
ARCHIVE := $($(DISTRO))
export
build:
	type g++ || \
	 (echo 'Must "sudo make -f $(MAKEFILE) prepare"' first >&2; false)
	$(MAKE) -f makefile.unix
env:
	$@
prepare:
	[ -w /usr ] || (echo Must be root to install package >&2; false)
	# including git for completeness but you probably cloned this, so...
	# also, you already had to have `make` to run this...
	apt-get update
	apt-get install git make libboost-all-dev g++ libdb++-dev libz-dev \
	 libminiupnpc-dev libssl-dev
clean:
	$(MAKE) -f makefile.unix $@
$(HOME)/$(DISTRO)/.americancoin $(LOCATION):
	mkdir -p $@
%/americancoin.conf: americancoind | %
	./$< -datadir=$(@D) 2>&1 | grep ^rpc > $@ && true
run: $(HOME)/$(DISTRO)/.americancoin/americancoin.conf americancoind
	# just take the rpc login from config file
	# we don't want it in daemon mode
	./americancoind -printtoconsole -debugnet \
	 -datadir=$(<D) -conf=<(head -n 2 $<)
$(LOCATION)/bin/bash: | $(LOCATION)
	debootstrap --arch=$(MACHINE) $(DISTRO) $(LOCATION) $(ARCHIVE)
debootstrap: $(LOCATION)/bin/bash
