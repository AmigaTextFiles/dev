OPT NATIVE
->{#include <x86_64-linux-gnu/bits/getopt_core.h>}
/* Declarations for getopt (basic, portable features only).
   Copyright (C) 1989-2020 Free Software Foundation, Inc.
   This file is part of the GNU C Library and is also part of gnulib.
   Patches to this file should be submitted to both projects.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, see
   <https://www.gnu.org/licenses/>.  */

NATIVE {_GETOPT_CORE_H} CONST ->_GETOPT_CORE_H = 1

/* For communication from 'getopt' to the caller.
   When 'getopt' finds an option that takes an argument,
   the argument value is returned here.
   Also, when 'ordering' is RETURN_IN_ORDER,
   each non-option ARGV-element is returned here.  */

NATIVE {optarg} DEF

/* Index in ARGV of the next element to be scanned.
   This is used for communication to and from the caller
   and for communication between successive calls to 'getopt'.

   On entry to 'getopt', zero means this is the first call; initialize.

   When 'getopt' returns -1, this is the index of the first of the
   non-option elements that the caller should itself scan.

   Otherwise, 'optind' communicates from one call to the next
   how much of ARGV has been scanned so far.  */

NATIVE {optind} DEF

/* Callers store zero here to inhibit the error message 'getopt' prints
   for unrecognized options.  */

NATIVE {opterr} DEF

/* Set to an option character which was unrecognized.  */

NATIVE {optopt} DEF

/* Get definitions and prototypes for functions to process the
   arguments in ARGV (ARGC of them, minus the program name) for
   options given in OPTS.

   Return the option character from OPTS just read.  Return -1 when
   there are no more options.  For unrecognized options, or options
   missing arguments, 'optopt' is set to the option letter, and '?' is
   returned.

   The OPTS string is a list of characters which are recognized option
   letters, optionally followed by colons, specifying that that letter
   takes an argument, to be placed in 'optarg'.

   If a letter in OPTS is followed by two colons, its argument is
   optional.  This behavior is specific to the GNU 'getopt'.

   The argument '--' causes premature termination of argument
   scanning, explicitly telling 'getopt' that there are no more
   options.

   If OPTS begins with '-', then non-option arguments are treated as
   arguments to the option '\1'.  This behavior is specific to the GNU
   'getopt'.  If OPTS begins with '+', or POSIXLY_CORRECT is set in
   the environment, then do not permute arguments.

   For standards compliance, the 'argv' argument has the type
   char *const *, but this is inaccurate; if argument permutation is
   enabled, the argv array (not the strings it points to) must be
   writable.  */

NATIVE {getopt} PROC
PROC getopt(___argc:VALUE, ___argv:ARRAY OF ARRAY OF CHAR, __shortopts:ARRAY OF CHAR) IS NATIVE {getopt( (int) } ___argc {,} ___argv {,} __shortopts {)} ENDNATIVE !!VALUE
