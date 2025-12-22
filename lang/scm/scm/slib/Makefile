# Makefile for Scheme Library
# Copyright (C) 1991, 1992, 1993, 1994, 1995, 1996, 1997, 1998 Aubrey Jaffer.

SHELL = /bin/sh
intro:
	@echo
	@echo "Welcome to SLIB.  Read \"README\" and \"slib.info\" (or"
	@echo "\"slib.texi\") to learn how to install and use SLIB."
	@echo
	@echo
	-make slib.info

srcdir=$(HOME)/slib/
dvidir=../dvi/
dvi:	$(dvidir)slib.dvi
$(dvidir)slib.dvi:	version.txi slib.texi $(dvidir)slib.fn
#	cd $(dvidir);export TEXINPUTS=$(srcdir):;texi2dvi $(srcdir)slib.texi
	-(cd $(dvidir);export TEXINPUTS=$(srcdir):;texindex slib.??)
	cd $(dvidir);export TEXINPUTS=$(srcdir):;tex $(srcdir)slib.texi
$(dvidir)slib.fn:
	cd $(dvidir);export TEXINPUTS=$(srcdir):;tex $(srcdir)slib.texi
xdvi:	$(dvidir)slib.dvi
	xdvi -s 6 $(dvidir)slib.dvi
htmldir=../public_html/
slib_toc.html:	version.txi slib.texi
	texi2html -split -verbose slib.texi

slib/slib_toc.html:
	cd slib;make slib_toc.html
	cd slib;texi2html -split -verbose slib.texi

html:	$(htmldir)slib_toc.html
$(htmldir)slib_toc.html:	slib slib/slib_toc.html slib_toc.html Makefile
	hitch slib/slib_\*.html slib_\*.html $(htmldir)

prefix = /usr/local
exec_prefix = $(prefix)
bindir = $(exec_prefix)/bin
libdir = $(exec_prefix)/lib
infodir = $(exec_prefix)/info
RUNNABLE = scheme48
LIB = $(libdir)/$(RUNNABLE)
VM = scheme48vm
IMAGE = slib.image
INSTALL_DATA = install -c

slib48.036:
	(echo ,load `pwd`/scheme48.init; \
	 echo "(define *args* '())"; \
	 echo "(define (program-arguments) (cons \"$(VM)\" *args*))"; \
	 echo ,dump $(LIB)/$(IMAGE); \
	 echo ,exit) | scheme48
	(echo '#!/bin/sh'; \
	 echo exec '$(LIB)/$(VM)' -i '$(LIB)/$(IMAGE)' \"\$$\@\") \
	  > $(bindir)/slib48
	chmod +x $(bindir)/slib48

$(LIB)/slibcat:
	touch $(LIB)/slibcat

slib48:	$(LIB)/slibcat Makefile
	(echo ",batch on"; \
	 echo ",config"; \
	 echo ",load =scheme48/misc/packages.scm"; \
	 echo "(define-structure slib-primitives"; \
	 echo "	 (export s48-error"; \
	 echo "	   s48-ascii->char"; \
	 echo "	   s48-force-output"; \
	 echo "	   s48-current-error-port"; \
	 echo "	   s48-system";\
	 echo "	   s48-with-handler";\
	 echo "	   s48-getenv)";\
	 echo "	 (open scheme signals ascii extended-ports i/o"; \
	 echo "	       primitives handle unix-getenv)"; \
	 echo "	 (begin"; \
	 echo "	   (define s48-error error)"; \
	 echo "	   (define s48-ascii->char ascii->char)"; \
	 echo "	   (define s48-force-output force-output)"; \
	 echo "	   (define s48-current-error-port current-error-port)"; \
	 echo "	   (define (s48-system c) (vm-extension 96 c))"; \
	 echo "	   (define s48-with-handler with-handler)"; \
	 echo "	   (define s48-getenv getenv)))"; \
	 echo ",user"; \
	 echo ",open slib-primitives"; \
	 echo "(define (implementation-vicinity) \"$(LIB)/\")"; \
	 echo "(define (library-vicinity) \"`pwd`/\")"; \
	 echo ",load scheme48.init"; \
	 echo "(define *args* '())"; \
	 echo "(define (program-arguments) (cons \"scheme48\" *args*))"; \
	 echo "(set! *catalog* #f)"; \
	 echo ",collect"; \
	 echo ",batch off"; \
	 echo ",dump $(IMAGE) \"(slib $(VERSION))\""; \
	 echo ",exit") | scheme48

install48: slib48
	$(INSTALL_DATA) $(IMAGE) $(LIB)
	(echo '#!/bin/sh'; \
	 echo exec $(RUNNABLE) -i '$(LIB)/$(IMAGE)' \"\$$\@\") \
	  > $(bindir)/slib48
	chmod +x $(bindir)/slib48	

#### Stuff for maintaining SLIB below ####

VERSION = 2c5
ver = $(VERSION)
version.txi:	Makefile
	echo @set SLIBVERSION $(VERSION) > version.txi
	echo @set SLIBDATE `date +"%B %Y"` >> version.txi

scheme = scm

htmlform.txi:	 *.scm
	$(scheme) -rschmooz -e'(schmooz "slib.texi")'
slib$(VERSION).info:	version.txi slib.texi htmlform.txi objdoc.txi
	makeinfo slib.texi --no-split -o slib.info
	mv slib.info slib$(VERSION).info
slib.info:	slib/slib.info slib$(VERSION).info
	infobar slib/slib.info slib$(VERSION).info slib.info
info:	installinfo
installinfo:	$(infodir)/slib.info
$(infodir)/slib.info:	slib.info
	cp -a slib.info $(infodir)/slib.info
	install-info $(infodir)/slib.info $(infodir)/dir
	-rm $(infodir)/slib.info.gz
infoz:	installinfoz
installinfoz:	$(infodir)/slib.info.gz
$(infodir)/slib.info.gz:	$(infodir)/slib.info
	gzip -f $(infodir)/slib.info

ffiles = printf.scm format.scm genwrite.scm obj2str.scm pp.scm \
	ppfile.scm strcase.scm debug.scm trace.scm lineio.scm \
	strport.scm scanf.scm chap.scm qp.scm break.scm stdio.scm \
	strsrch.scm prec.scm schmooz.scm
lfiles = sort.scm comlist.scm tree.scm logical.scm random.scm tsort.scm
revfiles = sc4opt.scm sc4sc3.scm sc2.scm mularg.scm mulapply.scm \
	trnscrpt.scm withfile.scm dynwind.scm promise.scm values.scm \
	eval.scm
afiles = ratize.scm randinex.scm modular.scm factor.scm \
	 charplot.scm root.scm cring.scm determ.scm selfset.scm \
	 psxtime.scm cltime.scm timezone.scm tzfile.scm
bfiles = collect.scm fluidlet.scm struct.scm object.scm recobj.scm yasyn.scm
scfiles = r4rsyn.scm scmacro.scm synclo.scm synrul.scm synchk.scm \
	repl.scm macwork.scm mwexpand.scm mwdenote.scm mwsynrul.scm
scafiles = scainit.scm scaglob.scm scamacr.scm scaoutp.scm scaexpp.scm \
	structure.scm
dfiles = defmacex.scm mbe.scm
efiles = record.scm dynamic.scm queue.scm process.scm \
	priorque.scm hash.scm hashtab.scm alist.scm \
	wttree.scm wttest.scm array.scm arraymap.scm \
	sierpinski.scm soundex.scm byte.scm nclients.scm
rfiles = rdms.scm alistab.scm dbutil.scm paramlst.scm report.scm \
	batch.scm makcrc.scm dbrowse.scm comparse.scm getopt.scm \
	htmlform.scm getparam.scm glob.scm
gfiles = tek40.scm tek41.scm
docfiles = ANNOUNCE README FAQ slib.info slib.texi objdoc.txi fmtdoc.txi \
	ChangeLog
mfiles = Makefile require.scm Template.scm syncase.sh mklibcat.scm \
	Bev2slib.scm
ifiles = chez.init elk.init macscheme.init				\
	mitscheme.init scheme2c.init scheme48.init gambit.init t3.init	\
	vscm.init mitcomp.pat scm.init scsh.init pscheme.init STk.init	\
	RScheme.init umbscheme.init
tfiles = plottest.scm formatst.scm macrotst.scm scmactst.scm \
	dwindtst.scm structst.scm
sfiles = $(ffiles) $(lfiles) $(revfiles) $(afiles) $(scfiles) $(efiles) \
	$(rfiles) $(gfiles) $(scafiles) $(dfiles)
allfiles = $(docfiles) $(mfiles) $(ifiles) $(sfiles) $(tfiles) $(bfiles)

makedev = make -f $(HOME)/makefile.dev
CHPAT=$(HOME)/bin/chpat
dest = $(HOME)/dist/
temp/slib:	$(allfiles)
	-rm -rf temp
	mkdir temp
	mkdir temp/slib
	ln  $(allfiles) temp/slib

infotemp/slib:	slib.info
	-rm -rf infotemp
	mkdir infotemp
	mkdir infotemp/slib
	ln slib.info slib.info-* infotemp/slib
#For change-barred HTML.
slib:
	tar xzvf $(dest)slib[0-9]*.tar.gz

distinfo:	$(dest)slib.info.tar.gz
$(dest)slib.info.tar.gz:	infotemp/slib
	$(makedev) TEMP=infotemp/ DEST=$(dest) PROD=slib ver=.info tar.gz
	rm -rf infotemp

release:	dist
	cp $(srcdir)ANNOUNCE $(htmldir)SLIB_ANNOUNCE
	rsync -v $(htmldir)SLIB.html $(htmldir)SLIB_ANNOUNCE martigny.ai.mit.edu:public_html/
	rsync -v $(dest)README $(dest)slib$(VERSION).tar.gz martigny.ai.mit.edu:dist/
#	upload $(dest)README $(dest)slib$(VERSION).tar.gz ftp.gnu.org:gnu/jacal/
	make indiana
indiana:
	upload $(dest)slib$(VERSION).tar.gz ftp@ftp.cs.indiana.edu:/pub/scheme-repository/incoming
	echo -e \
	'I have uploaded slib$(VERSION).tar.gz to ftp.cs.indiana.edu:/pub/scheme-repository/incoming\n' \
	'for placement into ftp.cs.indiana.edu:/pub/scheme-repository/code/lib/' \
	 | mail -s 'SLIB upload' -b jaffer scheme-repository-request@cs.indiana.edu

upzip:	$(HOME)/pub/slib.zip
	rsync -v $(HOME)/pub/slib.zip martigny.ai.mit.edu:pub/

dist:	$(dest)slib$(VERSION).tar.gz
$(dest)slib$(VERSION).tar.gz:	temp/slib
	$(makedev) DEST=$(dest) PROD=slib ver=$(VERSION) tar.gz
	cvs tag -F slib$(VERSION)
shar:	slib.shar
slib.shar:	temp/slib
	$(makedev) PROD=slib shar
dclshar:	slib.com
com:	slib.com
slib.com:	temp/slib
	$(makedev) PROD=slib com
zip:	slib.zip
slib.zip:	temp/slib
	$(makedev) PROD=slib zip
distzip:	slib$(VERSION).zip
slib$(VERSION).zip:	temp/slib
	$(makedev) DEST=$(dest) PROD=slib ver=$(VERSION) zip
	zip -d $(dest)slib$(VERSION).zip slib/slib.info
	mv $(dest)slib$(VERSION).zip /c/scm/dist/
pubzip:	temp/slib
	$(makedev) DEST=$(HOME)/pub/ PROD=slib zip

diffs:	pubdiffs
pubdiffs:	temp/slib
	$(makedev) DEST=$(HOME)/pub/ PROD=slib pubdiffs
distdiffs:	temp/slib
	$(makedev) DEST=$(dest) PROD=slib ver=$(ver) distdiffs
announcediffs:	temp/slib
	$(makedev) DEST=$(dest) PROD=slib ver=$(VERSION) announcediffs

psdfiles=COPYING.psd README.psd cmuscheme.el comint.el instrum.scm pexpr.scm \
	primitives.scm psd-slib.scm psd.el read.scm runtime.scm version.scm
psdocfiles=article.bbl article.tex manual.bbl manual.tex quick-intro.tex

psdtemp/slib:
	-rm -rf psdtemp
	mkdir psdtemp
	mkdir psdtemp/slib
	mkdir psdtemp/slib/psd
	cd psd; ln $(psdfiles) ../psdtemp/slib/psd
	mkdir psdtemp/slib/psd/doc
	cd psd/doc; ln $(psdocfiles) ../../psdtemp/slib/psd/doc

psdist:	$(dest)slib-psd.tar.gz
$(dest)slib-psd.tar.gz:	psdtemp/slib
	$(makedev) DEST=$(dest) PROD=slib ver=-psd tar.gz TEMP=psdtemp/

new:
	echo `date` \ Aubrey Jaffer \ \<`whoami`@`hostname`\>> change
	echo>> change
	echo \	\* require.scm \(*SLIB-VERSION*\): Bumped from $(VERSION) to $(ver).>>change
	echo>> change
	cat ChangeLog >> change
	mv -f change ChangeLog
	$(CHPAT) slib$(VERSION) slib$(ver) ANNOUNCE FAQ ../scm/ANNOUNCE \
		../jacal/ANNOUNCE ../wb/README ../wb/ANNOUNCE \
		$(htmldir)README.html ../dist/README \
		$(htmldir)SLIB.html $(htmldir)JACAL.html \
		$(htmldir)SCM.html $(htmldir)Hobbit.html \
		$(htmldir)SIMSYNCH.html ../scm/scm.texi \
		/c/scm/dist/install.bat /c/scm/dist/makefile \
		/c/scm/dist/mkdisk.bat
	$(CHPAT) $(VERSION) $(ver) README slib.texi require.scm Makefile \
		 $(htmldir)SLIB.html
	cvs commit -m '(*SLIB-VERSION*): Bumped from $(VERSION) to $(ver).'
	cvs tag -F slib$(ver)

tagfiles = version.txi slib.texi $(mfiles) $(sfiles) $(bfiles) $(tfiles)
# README and $(ifiles) cause semgentation faults in ETAGS for Emacs version 19.
tags:	$(tagfiles)
	etags $(tagfiles)
test:	$(sfiles)
	scheme Template.scm $(sfiles)
rights:
	scm -ladmin -e"(admin:check-all)" $(sfiles) $(tfiles) \
		$(bfiles) $(ifiles)
report:
	scmlit -e"(slib:report #t)"
	scm -e"(slib:report #t)"
clean:
	-rm -f *~ *.bak *.orig *.rej core a.out *.o \#*
	-rm -rf *temp
distclean:	realclean
realclean:
	-rm -f *~ *.bak *.orig *.rej TAGS core a.out *.o \#*
	-rm -f slib.info* slib.?? slib.???
	-rm -rf *temp
realempty:	temp/slib
	-rm -f $(allfiles)
