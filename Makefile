docker: americancoind
	./$<
americancoind: americancoind.template docker.mk
	$(MAKE) -f docker.mk $@
