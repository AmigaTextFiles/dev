mandir = @mandir@

man_MANS = @PACKAGE@.1

EXTRA_DIST = texinfo2man.c $(man_MANS) @PACKAGE@.1.in

# --------------- Maintainer's Section

MAINTAINERCLEANFILES = @PACKAGE@.1 Makefile.in texinfo2man 

texinfo2man: texinfo2man.c
	$(CC_FOR_BUILD) -o $@ ${srcdir}/texinfo2man.c

@PACKAGE@.1: ${srcdir}/@PACKAGE@.1.in  ${srcdir}/../doc/@PACKAGE@.texi texinfo2man  Makefile.am
	./texinfo2man ${srcdir}/@PACKAGE@.1.in ${srcdir}/../doc/@PACKAGE@.texi > $@

