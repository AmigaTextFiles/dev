## Process this file with automake to produce Makefile.in

@SET_MAKE@

bin_PROGRAMS = fakebo

if MEMWATCH
memwatch_src = memwatch.c memwatch.h
else
memwatch_src =
endif

fakebo_SOURCES = fakebo.c realbo.c bo.h global.h nb.h config.c misc.c misc.h $(memwatch_src)

man_MANS = fakebo.1

sysconf_DATA = fakebo.conf.dist

AUTOMAKE_OPTIONS = dist-zip
# this will be included once automake 1.4a goes into automake 1.5 :-)
# AUTOMAKE_OPTIONS += dist-bzip2

EXTRA_DIST =  $(man_MANS) $(sysconf_DATA) custom.replies HACKING fakebo.init \
	fakebo.spec.in fakebo.spec

# if no configuration is found, use default conf from distribution
install-data-local:
	-test ! -f $(DESTDIR)$(sysconfdir)/fakebo.conf && \
		mv $(DESTDIR)$(sysconfdir)/fakebo.conf.dist $(DESTDIR)$(sysconfdir)/fakebo.conf

dist-rpm: dist
	rpm -ta fakebo-@VERSION@.tar.gz

# help poor human make ChangeLog
changelog:
	rcs2log | sed 's/\/cvsroot\/fakebo\///g' | cat - ChangeLog > ChangeLog.$$$$ && mv ChangeLog.$$$$ ChangeLog
	$(SHELL) -c "$${VISUAL:-vi} ChangeLog"

