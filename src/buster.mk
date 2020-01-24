# some recipes require bashisms
SHELL=/bin/bash
MAKEFILE := $(lastword $(MAKEFILE_LIST))
DISTRO ?= $(MAKEFILE:.mk=)
# use a version of openssl known to work
OPENSSL_VERSION := openssl-1.0.2a
OPENSSL_LIB_PATH := $(HOME)/$(OPENSSL_VERSION)/lib
OPENSSL_INCLUDE_PATH := $(dir $(OPENSSL_LIB_PATH))include
USE_UPNP := -
BOOST_ASIO_ENABLE_OLD_SERVICES := 1
export
all: build run
build: $(OPENSSL_INCLUDE_PATH)/openssl
	type g++ || \
	 (echo 'Must "sudo make -f $(MAKEFILE) prepare"' first >&2; false)
	$(MAKE) -f makefile.unix
$(OPENSSL_INCLUDE_PATH)/openssl: ../../$(OPENSSL_VERSION)
	type gcc || \
	 (echo 'Must "sudo make -f $(MAKEFILE) prepare"' first >&2; false)
	cd $< && ./config --prefix=$(dir $(OPENSSL_LIB_PATH))
	cd $< && make install
../../$(OPENSSL_VERSION): ../../$(OPENSSL_VERSION).tar.gz
	cd $(@D) && tar xfz $(<F)
../../$(OPENSSL_VERSION).tar.gz:
	cd $(@D) && wget http://www.openssl.org/source/$(@F)
env:
	$@
prepare:
	[ -w /usr ] || (echo Must be root to install package >&2; false)
	# including git for completeness but you probably cloned this, so...
	# also, you already had to have `make` to run this...
	# skipping libssl-dev because we need older version
	# not using libminiupnpc-dev either, some functions changed and it
	# shouldn't be necessary anyway
	apt update
	apt install git make libboost-all-dev g++ libdb++-dev libz-dev
clean:
	$(MAKE) -f makefile.unix $@
$(HOME)/$(DISTRO)/.americancoin:
	mkdir -p $@
%/americancoin.conf: americancoind | %
	./$< -datadir=$(@D) 2>&1 | grep ^rpc > $@ && true
run: $(HOME)/$(DISTRO)/.americancoin/americancoin.conf americancoind
	# just take the rpc login from config file
	# we don't want it in daemon mode
	./americancoind -printtoconsole -debugnet \
	 -datadir=$(<D) -conf=<(head -n 2 $<)
