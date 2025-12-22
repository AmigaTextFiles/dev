OPT NATIVE
MODULE 'target/stddef'
{#include <x86_64-linux-gnu/bits/types/struct_iovec.h>}
/* Define struct iovec.
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

->NATIVE {__iovec_defined} CONST __IOVEC_DEFINED = 1

->NATIVE {__need_size_t} DEF

/* Structure for scatter/gather I/O.  */
NATIVE {iovec} OBJECT iovec
    {iov_base}	base	:PTR	/* Pointer to data.  */
    {iov_len}	len	:SIZE_T	/* Length of data.  */
  ENDOBJECT
