# Generated automatically from Makefile.in by configure.
##
##  Makefile -- SMake Makefile
##  Copyright (c) 1994-1999 Ralf S. Engelschall, All Rights Reserved. 
##


# ------------------------------------------------
#   DEFINITIONS
# ------------------------------------------------

#   installation paths
prefix          = /usr/local
exec_prefix     = ${prefix}
bindir          = ${exec_prefix}/bin
libdir          = ${exec_prefix}/lib
libdirsub       = /smake
mandir          = ${prefix}/man

#   tools
RM              = rm -f
LN              = ln
SHTOOL          = etc/shtool
PERL            = /bin/perl
POD2MAN         = /bin/pod2man

# ------------------------------------------------
#   THE DEFAULT TARGETS
# ------------------------------------------------

all: smake smkmf smake.1

# ------------------------------------------------
#   THE CONFIGURATION SUPPORT
# ------------------------------------------------

config: configure

configure: configure.in
	autoconf

# ------------------------------------------------
#   THE RELEASE STUFF
# ------------------------------------------------

_GETDISTINFO = \
    _version=`$(SHTOOL) version -l perl -d short smake_version.pl`; \
    _date=`date '+%y%m%d'`;

_BUILDDIST = \
    echo "Creating tarball..."; \
    gtar --no-recursion -cvf - `find * -depth -print | sort | grep -v CVS | grep -v .cvsignore ` |\
    tardy --user_number=0  --user_name=rse \
          --group_number=0 --group_name=en \
          --prefix=$${_distname} - |\
    gzip >$${_tarball}; \
    echo "Done"; \
    ls -l $${_tarball}

_NEWVERS = \
	$(SHTOOL) version -l perl -n SMake -p smake $$OPT smake_version.pl; \
	V=`$(SHTOOL) version -l perl -d long smake_version.pl`;\
	sed -e "s/Version .*(.*)/Version $$V/g" <README >README.n && mv README.n README

_UPDATEVERS = \
	V=`$(SHTOOL) version -l perl -d short smake_version.pl`;\
	$(SHTOOL) version -l perl -n SMake -p smake -s $$V smake_version.pl; \
	V=`$(SHTOOL) version -l perl -d long smake_version.pl`;\
	sed -e "s/Version .*(.*)/Version $$V/g" <README >README.n && mv README.n README

dist: distclean fixperm
	@$(_GETDISTINFO) \
    _distname="smake-$${_version}"; \
    _tarball="/tmp/$${_distname}.tar.gz"; \
    echo "Release Distribution: SMake Version $$_version"; \
    $(_BUILDDIST); \
    mv /tmp/$${_distname}.tar.gz $${_distname}.tar.gz 

snap: distclean fixperm
	@$(_GETDISTINFO) \
    _distname="smake-$${_version}-SNAP-$${_date}"; \
    _tarball="/tmp/$${_distname}.tar.gz"; \
    echo "Snap of whole source tree: SMake Version $$_version as of $$_date"; \
    $(_BUILDDIST); \
    mv /tmp/$${_distname}.tar.gz $${_distname}.tar.gz 

new-version:
	OPT="-i v"; $(_NEWVERS)
new-revision:
	OPT="-i r"; $(_NEWVERS)
new-patchlevel:
	OPT="-i P"; $(_NEWVERS)
new-betalevel:
	OPT="-i b"; $(_NEWVERS)
new-alphalevel:
	OPT="-i a"; $(_NEWVERS)
new-snaplevel:
	OPT="-i s"; $(_NEWVERS)
new-release:
	OPT="-s $(R)"; $(_NEWVERS)
update-version:
	$(_UPDATEVERS)

# ------------------------------------------------
#   THE PROGRAM
# ------------------------------------------------

GEN_BIN_SRC=\
	$(RM) $@; \
	$(PERL) etc/unrequire $$src | \
	sed -e "s|\@PATH_PERL\@|$(PERL)|g" \
		-e "s|\@includedir\@|$(libdir)$(libdirsub)|g" >$@; \
	chmod a+x $@

smake: smake_smake.pl smake_getopts.pl smake_misc.pl smake_file.pl smake_version.pl
	src=smake_smake.pl; $(GEN_BIN_SRC)

smkmf: smake_smkmf.pl smake_getopts.pl smake_misc.pl smake_file.pl smake_version.pl
	src=smake_smkmf.pl; $(GEN_BIN_SRC)

fixperm:
	$(SHTOOL) fixperm *

# ------------------------------------------------
#   THE DOCUMENTATION
# ------------------------------------------------

smake.1: smake.pod smake_version.pl
	V=`$(SHTOOL) version -l perl -d long smake_version.pl`; \
	sed -e "s|\@V\@|$$V|g" -e "s|\@prefix\@|$(prefix)|" <smake.pod >/tmp/smake.pod; \
	pod2man --section=1 --center="Ralf S. Engelschall" --release="EN" \
			/tmp/smake.pod >smake.1 && \
	$(RM) /tmp/smake.pod

# ------------------------------------------------
#   TEST SUITE
# ------------------------------------------------

test:
	@cd t; $(MAKE) $(MFLAGS) test

# ------------------------------------------------
#   INSTALLATION
# ------------------------------------------------

install: all
	$(SHTOOL) mkdir -f -p -m 755 $(bindir)
	$(SHTOOL) mkdir -f -p -m 755 $(mandir)/man1
	$(SHTOOL) mkdir -f -p -m 755 $(libdir)$(libdirsub)
	$(SHTOOL) install -c -m 755 smake $(bindir)/smake
	$(SHTOOL) install -c -m 755 smkmf $(bindir)/smkmf
	$(SHTOOL) install -c -m 644 smake.1 $(mandir)/man1/smake.1
	$(RM) $(mandir)/man1/smkmf.1
	$(LN) $(mandir)/man1/smake.1 $(mandir)/man1/smkmf.1
	@for file in `cd include; echo *`; do \
	    test ! -f include/$$file && continue; \
	    echo "$(SHTOOL) install -c -m 644 include/$$file $(libdir)$(libdirsub)/$$file"; \
	    $(SHTOOL) install -c -m 644 include/$$file $(libdir)$(libdirsub)/$$file; \
	done

# ------------------------------------------------
#   CLEANUP
# ------------------------------------------------

clean:
	-$(RM) smake smkmf smake.1

distclean: clean
	-$(RM) Makefile config.status config.cache config.log

