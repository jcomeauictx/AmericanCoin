docker: americancoind $(HOME)/.americancoin/debug.log
	./$<
americancoind: americancoind.template docker.mk
	$(MAKE) -f docker.mk $@
$(HOME)/%:
	mkdir -p $@
%.log: $(@D)
	touch $@
