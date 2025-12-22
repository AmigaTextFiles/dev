## Process this file with automake to produce Makefile.in

AUTOMAKE_OPTIONS = no-dependencies dist-shar
SUBDIRS = @SU_VERSION@ scripts docs lycos

EXTRA_DIST = License.txt email2smssend

bin_SCRIPTS = email2smssend

bin_PROGRAMS = smssend
smssend_SOURCES = smssend.c
CFLAGS = @CFLAGS@ @O_SKYUTILS_FLAGS@

