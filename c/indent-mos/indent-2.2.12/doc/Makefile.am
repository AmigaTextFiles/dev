## Process this file with automake to produce Makefile.in.

info_TEXINFOS = indent.texi

docdir = $(prefix)/doc/@PACKAGE@
dvidir = $(docdir)
psdir = $(docdir)
pdfdir = $(docdir)
htmldir = $(docdir)
HTMLSTYLE = monolithic

AUTOMAKE_OPTIONS = 1.2 gnits

#EXTRA_DIST = @PACKAGE@.html

SED = sed
RM = rm -f

MAKEINFO = env LANG= LANGUAGE= @MAKEINFO@

all-local: html
install-data-local: install-html
installdirs-local: installdirs-html
uninstall-local: uninstall-html

html: html-$(HTMLSTYLE)
install-html: install-html-$(HTMLSTYLE)
uninstall-html: uninstall-html-$(HTMLSTYLE)

# BUILT_SOURCES = @PACKAGE@.1 @PACKAGE@.html @PACKAGE@_toc.html
html-monolithic: @PACKAGE@.html
html-split: @PACKAGE@_toc.html

@PACKAGE@.html: version.texi $(@PACKAGE@_TEXINFOS)
	$(MAKEINFO) --html --ifinfo --number-sections --no-split `if test -f @PACKAGE@.texi; then echo @PACKAGE@.texi; else echo $(srcdir)/@PACKAGE@.texi; fi`

@PACKAGE@_toc.html: version.texi $(@PACKAGE@_TEXINFOS)
	$(RM) @PACKAGE@_*.html
	$(MAKEINFO) --html --ifinfo --number-sections --no-headers --split=section `if test -f @PACKAGE@.texi; then echo @PACKAGE@.texi; else echo $(srcdir)/@PACKAGE@.texi; fi`

install-html-monolithic: @PACKAGE@.html
	$(mkinstalldirs) $(DESTDIR)$(htmldir)
	$(INSTALL_DATA) `if test -f @PACKAGE@.html; then echo .; else echo $(srcdir); fi`/@PACKAGE@.html $(DESTDIR)$(htmldir)/@PACKAGE@.html

install-html-split: @PACKAGE@_toc.html
	$(mkinstalldirs) $(DESTDIR)$(htmldir)
	for file in `if test -f @PACKAGE@_toc.html; then echo .; else echo $(srcdir); fi`/@PACKAGE@*.html; do \
	  $(INSTALL_DATA) $$file $(DESTDIR)$(htmldir)/`basename $$file`; \
	done

installdirs-html:
	$(mkinstalldirs) $(DESTDIR)$(htmldir)

uninstall-html-monolithic:
	$(RM) $(DESTDIR)$(htmldir)/@PACKAGE@.html

uninstall-html-split:
	$(RM) $(DESTDIR)$(htmldir)/@PACKAGE@_*.html

# Documentation in Portable Document Format.

SUFFIXES = .pdf

.texinfo.pdf:
	TEXINPUTS=.:$$TEXINPUTS \
	$(MAKEINFO) -I $(srcdir) --pdf $<

pdf: @PACKAGE@.pdf

CLEANFILES = @PACKAGE@.pdf

# --------------- Maintainer's Section

MAINTAINERCLEANFILES = Makefile.in version.texi stamp.vti @PACKAGE@*.html
