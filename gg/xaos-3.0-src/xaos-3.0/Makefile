# Generated automatically from Makefile.in by configure.
# Makefile for XaoS
#
# Always use src as the top-level
prefix= /usr/local
exec_prefix= ${prefix}
datadir= ${prefix}/share
bindir= ${exec_prefix}/bin
mandir= ${prefix}/man
infodir= ${prefix}/info



default clean realclean echo help depend xaos:
	@cd src ; $(MAKE) $@

all:
	@cd src ; $(MAKE) all

distclean:
	#@$(MAKE) -C src $@
	@$(MAKE) -C src distclean
	rm -f config.cache config.status config.log src/include/config.h src/include/aconfig.h
	rm -f src/Makefile.common src/arch/linux/Makefile.main
	rm -f `find . -name Makefile`
	rm -f `find . -name '*~'`
	rm -f `find . -name '*.d'`
	rm -f `find . -name '*[\.]orig'`
	rm -vf `find . -size 0`

install: 
	/bin/install -c -d $(datadir)/XaoS
	/bin/install -c -d $(datadir)/XaoS/tutorial
	/bin/install -c -d $(datadir)/XaoS/examples
	/bin/install -c -d $(datadir)/XaoS/catalogs
	/bin/install -c -d $(datadir)/XaoS/doc
	/bin/install -c -d $(bindir)
	/bin/install -c -d $(mandir)/man6
	/bin/install -c -s bin/xaos $(bindir)
	/bin/install -c -m 444 tutorial/*.x[ah]f $(datadir)/XaoS/tutorial
	/bin/install -c -m 444 examples/* $(datadir)/XaoS/examples
	/bin/install -c -m 444 catalogs/* $(datadir)/XaoS/catalogs
	/bin/install -c -m 444 doc/README doc/README.bugs doc/compilers.txt doc/ANNOUNCE doc/PROBLEMS doc/tutorial.txt $(datadir)/XaoS/doc
	/bin/install -c -m 444 doc/xaos.6 $(mandir)/man6
	
	/bin/install -c -m 444 doc/xaos.info $(infodir)
	#install-info doc/xaos.info 

