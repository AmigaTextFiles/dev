OPT NATIVE
->{#include <x86_64-linux-gnu/bits/sigevent-consts.h>}
/* sigevent constants.  Linux version.
   Copyright (C) 1997-2020 Free Software Foundation, Inc.
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

NATIVE {_BITS_SIGEVENT_CONSTS_H} CONST ->_BITS_SIGEVENT_CONSTS_H = 1

/* `sigev_notify' values.  */
NATIVE {SIGEV_SIGNAL} CONST SIGEV_SIGNAL = 0		/* Notify via signal.  */
NATIVE {SIGEV_NONE}	CONST SIGEV_NONE = 1			/* Other notification: meaningless.  */
NATIVE {SIGEV_THREAD}	CONST SIGEV_THREAD = 2			/* Deliver via thread creation.  */

NATIVE {SIGEV_THREAD_ID} CONST SIGEV_THREAD_ID = 4		/* Send signal to specific thread.
				   This is a Linux extension.  */
