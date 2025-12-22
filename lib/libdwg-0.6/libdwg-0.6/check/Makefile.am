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

TESTS = alive.test

check_PROGRAMS = load_free 

TESTS_ENVIRONMENT = \
 srcdir='$(srcdir)'

AM_LDFLAGS = -L$(top_srcdir)/src -ldwg

load_free_SOURCES = load_free.c

AM_CFLAGS = -Wextra -I$(top_srcdir)/src

EXTRA_DIST = \
	     ACAD_r2000_sample.dwg \
	     ACAD_r2000_libereco.dwg \
	     ACAD_r2000_sample_original.dxf \
	     ACAD_r2000_libereco_original.dxf \
	     ACAD_r2004_sample.dwg \
	     ACAD_r2004_libereco.dwg \
	     DS_libereco.pdf \
	     $(TESTS)

