OPT NATIVE
PUBLIC MODULE 'target/x86_64-linux-gnu/bits/signum-generic'
->{#include <x86_64-linux-gnu/bits/signum.h>}
/* Signal number definitions.  Linux version.
   Copyright (C) 1995-2020 Free Software Foundation, Inc.
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

NATIVE {_BITS_SIGNUM_H} CONST ->_BITS_SIGNUM_H = 1

/* Adjustments and additions to the signal number constants for
   most Linux systems.  */

/*
NATIVE {SIGSTKFLT}	CONST SIGSTKFLT	= 16	/* Stack fault (obsolete).  */
NATIVE {SIGPWR}		CONST SIGPWR		= 30	/* Power failure imminent.  */

NATIVE {SIGBUS}		 CONST SIGBUS		 = 7
NATIVE {SIGUSR1}		CONST SIGUSR1		= 10
NATIVE {SIGUSR2}		CONST SIGUSR2		= 12
NATIVE {SIGCHLD}		CONST SIGCHLD		= 17
NATIVE {SIGCONT}		CONST SIGCONT		= 18
NATIVE {SIGSTOP}		CONST SIGSTOP		= 19
NATIVE {SIGTSTP}		CONST SIGTSTP		= 20
NATIVE {SIGURG}		CONST SIGURG		= 23
NATIVE {SIGPOLL}		CONST SIGPOLL		= 29
NATIVE {SIGSYS}		CONST SIGSYS		= 31
*/

->NATIVE {__SIGRTMAX}	CONST __SIGRTMAX	= 64
