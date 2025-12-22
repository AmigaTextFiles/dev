OPT NATIVE
PUBLIC MODULE 'target/linux/errno'
->{#include <x86_64-linux-gnu/bits/errno.h>}
/* Error constants.  Linux specific version.
   Copyright (C) 1996-2020 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

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

NATIVE {_BITS_ERRNO_H} CONST ->_BITS_ERRNO_H = 1

/* Older Linux headers do not define these constants.  */
  NATIVE {ENOTSUP}		CONST ENOTSUP		= EOPNOTSUPP

->  NATIVE {ECANCELED}		CONST ECANCELED		= 125

->  NATIVE {EOWNERDEAD}		CONST EOWNERDEAD		= 130

->  NATIVE {ENOTRECOVERABLE}	CONST ENOTRECOVERABLE	= 131

->  NATIVE {ERFKILL}		CONST ERFKILL		= 132

->  NATIVE {EHWPOISON}		CONST EHWPOISON		= 133
