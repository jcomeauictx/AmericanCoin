# some recipes require bashisms
SHELL=/bin/bash
MAKEFILE := $(lastword $(MAKEFILE_LIST))
PREFIX ?= /usr/local
# FIXME: Dockerfile should be built from template with values from Makefile
USERNAME ?= americancoiner
# use a version of openssl known to work
OPENSSL_VERSION := openssl-1.0.2a
OPENSSL_PATH := $(PREFIX)/$(OPENSSL_VERSION)
OPENSSL_LIB_PATH := $(OPENSSL_PATH)/lib
OPENSSL_INCLUDE_PATH := $(OPENSSL_PATH)include
OPENSSL_SRC_PATH ?= ../..
USE_UPNP := -
BOOST_ASIO_ENABLE_OLD_SERVICES := 1
export
build: $(OPENSSL_INCLUDE_PATH)/openssl
	type g++ || \
	 (echo 'Must "sudo make -f $(MAKEFILE) prepare"' first >&2; false)
	$(MAKE) -f makefile.unix
$(OPENSSL_INCLUDE_PATH)/openssl: $(OPENSSL_SRC_PATH)/$(OPENSSL_VERSION)
	type gcc || \
	 (echo 'Must "sudo make -f $(MAKEFILE) prepare"' first >&2; false)
	cd $< && ./config --prefix=$(OPENSSL_PATH)
	cd $< && make install
%/$(OPENSSL_VERSION): %/$(OPENSSL_VERSION).tar.gz
	cd $(@D) && tar xfz $(<F)
%/$(OPENSSL_VERSION).tar.gz:
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
	apt install --yes git make libboost-all-dev g++ libdb++-dev libz-dev \
	 wget
	mkdir -p $(OPENSSL_PATH)
	chown -R $(USERNAME):$(USERNAME) $(OPENSSL_PATH)
clean:
	$(MAKE) -f makefile.unix $@
%/.americancoin:
	mkdir -p $@
americancoind: build
%/americancoin.conf: | americancoind %
	# run to create ~/.americancoind/americancoin.conf
	./americancoind -datadir=$(@D) 2>&1 | grep ^rpc | tee $@
conf: $(HOME)/.americancoin/americancoin.conf
install: americancoind
	install -o $(USERNAME) $< $(PREFIX)/bin
.PRECIOUS: %/.americancoin %/americancoin.conf
