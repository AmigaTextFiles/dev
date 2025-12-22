## Makefile.am
##
## Copyright (C) 2013 Free Software Foundation, Inc.
##
## This file is part of LibDWG.
##
## LibDWG is free software: you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## LibDWG is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty
## of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
## See the GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <http://www.gnu.org/licenses/>.

bin_PROGRAMS = dwg-dump dwg-preview dwg-dxf

AM_CFLAGS = -Wextra -I$(top_srcdir)/src

AM_LDFLAGS = -static

dwg_dump_SOURCES = dwg-dump.c
dwg_dump_LDADD = $(top_srcdir)/src/libdwg.la

dwg_preview_SOURCES = dwg-preview.c
dwg_preview_LDADD = $(top_srcdir)/src/libdwg.la

dwg_dxf_SOURCES = dwg-dxf.c
dwg_dxf_LDADD = $(top_srcdir)/src/libdwg.la

BUILT_SOURCES = dump_variables.c dump_objects.c dump_entity_handle.c

EXTRA_DIST = dump_variables.in.c dump_objects.in.c dump_entity_handle.in.c dwg-dxf.h dxf_object.c

dump_variables.c: dump_variables.in.c $(top_srcdir)/src/dwg_variables.spe.c $(top_srcdir)/src/dwg_macro.h
	$(CPP) -P $(AM_CFLAGS) dump_variables.in.c > dump_variables.c
	indent -l120 dump_variables.c
	rm dump_variables.c~

dump_objects.c: dump_objects.in.c $(top_srcdir)/src/dwg_object.spe.c $(top_srcdir)/src/dwg_macro.h
	$(CPP) -P $(AM_CFLAGS) dump_objects.in.c > dump_objects.c
	indent -l120 dump_objects.c
	rm dump_objects.c~

dump_entity_handle.c: dump_entity_handle.in.c $(top_srcdir)/src/dwg_entity_handle.spe.c $(top_srcdir)/src/dwg_macro.h
	$(CPP) -P $(AM_CFLAGS) dump_entity_handle.in.c > dump_entity_handle.c
	indent -l120 dump_entity_handle.c
	rm dump_entity_handle.c~

