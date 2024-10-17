CONFDIR := $(HOME)/.americancoin
LOGFILE := $(CONFDIR)/debug.log
CONFIG := $(CONFDIR)/americancoin.conf
docker: americancoind $(CONFIG) $(LOGFILE)
	./$<
americancoind: americancoind.template docker.mk
	$(MAKE) -f docker.mk $@
$(HOME)/%:
	mkdir -p $@
$(LOGFILE): $(@D)
	touch $@
$(CONFIG): americancoind .FORCE
	if ! grep '^rpc' $@; then ./$< | grep '^rpc' >> $@; fi
.FORCE:
