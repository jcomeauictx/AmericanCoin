CONFDIR := $(HOME)/.americancoin
LOGFILE := $(CONFDIR)/debug.log
CONFIG := $(CONFDIR)/americancoin.conf
docker: americancoind $(CONFIG) $(LOGFILE)
	./$<
americancoind: americancoind.template docker.mk
	$(MAKE) -f docker.mk $@
$(CONFDIR):
	mkdir -p $@
$(LOGFILE): $(CONFDIR)
	touch $@
$(CONFIG): americancoind $(CONFDIR) .FORCE
	[ -e "$@" ] || touch $@
	if ! grep '^rpc' $@; then ./$< | grep '^rpc' >> $@; fi
.FORCE:
