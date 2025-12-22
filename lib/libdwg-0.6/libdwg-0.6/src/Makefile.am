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

lib_LTLIBRARIES = libdwg.la

## Libtool versioning system, see "info libtool"
libdwg_la_LDFLAGS = \
	-version-info 3:1:0

libdwg_la_SOURCES = \
	dwg.c \
	bits.c \
	decode.c \
        decode_r2000.c \
        decode_r2004.c \
        variables.c \
        object.c \
	logging.c

BUILT_SOURCES = \
		auto_variables.c \
		auto_variables_free.c \
		auto_object.c \
		auto_object_free.c \
		auto_entity_handle.c

AM_CFLAGS = -Wextra

include_HEADERS = dwg.h

EXTRA_DIST = \
        dwg_variables.spe.c \
        dwg_variables.in.c \
        dwg_variables_free.in.c \
	dwg_object.spe.c \
	dwg_object.in.c \
	dwg_object_free.in.c \
        dwg_entity_handle.spe.c \
	dwg_entity_handle.in.c \
	dwg_macro.h \
	$(include_HEADERS) \
	bits.h \
	decode.h \
        decode_r2000.h \
        decode_r2004.h \
        variables.h \
        object.h \
	logging.h

auto_variables.c: dwg_variables.in.c dwg_variables.spe.c dwg_macro.h 
	$(CPP) -P dwg_variables.in.c > auto_variables.c
	indent -l120 auto_variables.c
	rm auto_variables.c~

auto_object.c: dwg_object.in.c dwg_object.spe.c dwg_macro.h
	$(CPP) -P dwg_object.in.c > auto_object.c
	indent -l120 auto_object.c
	rm auto_object.c~

auto_entity_handle.c: dwg_entity_handle.in.c dwg_entity_handle.spe.c dwg_macro.h
	$(CPP) -P dwg_entity_handle.in.c > auto_entity_handle.c
	indent -l120 auto_entity_handle.c
	rm auto_entity_handle.c~

auto_variables_free.c: dwg_variables_free.in.c dwg_variables.spe.c dwg_macro.h
	$(CPP) -P dwg_variables_free.in.c > auto_variables_free.c
	indent -l120 auto_variables_free.c
	rm auto_variables_free.c~

auto_object_free.c: dwg_object_free.in.c dwg_object.spe.c dwg_macro.h
	$(CPP) -P dwg_object_free.in.c > auto_object_free.c
	indent -l120 auto_object_free.c
	rm auto_object_free.c~

