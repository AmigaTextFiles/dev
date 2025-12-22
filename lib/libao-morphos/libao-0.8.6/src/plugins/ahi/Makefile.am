## Process this file with automake to produce Makefile.in

AUTOMAKE_OPTIONS = foreign

if HAVE_AHI

ahiltlibs = libahi.la
ahisources = ao_ahi.c

else

ahiltlibs =
ahisources =

endif

INCLUDES = -I$(top_builddir)/include/ao -I$(top_srcdir)/include

libdir = $(plugindir)
lib_LTLIBRARIES = $(ahiltlibs)

libahi_la_LDFLAGS = @PLUGIN_LDFLAGS@
libahi_la_LIBADD = @AHI_LIBS@
libahi_la_SOURCES = $(ahisources)

EXTRA_DIST = ao_ahi.c
