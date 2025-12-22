OPT NATIVE
MODULE 'target/x86_64-linux-gnu/bits/siginfo-arch'
/* Architectures might also add architecture-specific constants.
   These are all considered GNU extensions.  */
 MODULE 'target/x86_64-linux-gnu/bits/siginfo-consts-arch'
->{#include <x86_64-linux-gnu/bits/siginfo-consts.h>}
/* siginfo constants.  Linux version.
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

NATIVE {_BITS_SIGINFO_CONSTS_H} CONST ->_BITS_SIGINFO_CONSTS_H = 1

/* Most of these constants are uniform across all architectures, but there
   is one exception.  */
 ->NATIVE {__SI_ASYNCIO_AFTER_SIGIO} CONST __SI_ASYNCIO_AFTER_SIGIO = 1

/* Values for `si_code'.  Positive values are reserved for kernel-generated
   signals.  */
NATIVE {SI_ASYNCNL} CONST SI_ASYNCNL = -60		/* Sent by asynch name lookup completion.  */
NATIVE {SI_DETHREAD} CONST SI_DETHREAD = -7		/* Sent by execve killing subsidiary
				   threads.  */
NATIVE {SI_TKILL}	CONST SI_TKILL = -6			/* Sent by tkill.  */
NATIVE {SI_SIGIO}	CONST SI_SIGIO = -5			/* Sent by queued SIGIO. */
NATIVE {SI_ASYNCIO}	CONST SI_ASYNCIO = -4			/* Sent by AIO completion.  */
NATIVE {SI_MESGQ}	CONST SI_MESGQ = -3			/* Sent by real time mesq state change.  */
NATIVE {SI_TIMER}	CONST SI_TIMER = -2			/* Sent by timer expiration.  */
NATIVE {SI_QUEUE}	CONST SI_QUEUE = -1			/* Sent by sigqueue.  */
NATIVE {SI_USER}	CONST SI_USER = 0			/* Sent by kill, sigsend.  */
NATIVE {SI_KERNEL} CONST SI_KERNEL = $80		/* Send by kernel.  */

/* `si_code' values for SIGILL signal.  */
NATIVE {ILL_ILLOPC} CONST ILL_ILLOPC = 1		/* Illegal opcode.  */
NATIVE {ILL_ILLOPN}	CONST ILL_ILLOPN = 2			/* Illegal operand.  */
NATIVE {ILL_ILLADR}	CONST ILL_ILLADR = 3			/* Illegal addressing mode.  */
NATIVE {ILL_ILLTRP}	CONST ILL_ILLTRP = 4			/* Illegal trap. */
NATIVE {ILL_PRVOPC}	CONST ILL_PRVOPC = 5			/* Privileged opcode.  */
NATIVE {ILL_PRVREG}	CONST ILL_PRVREG = 6			/* Privileged register.  */
NATIVE {ILL_COPROC}	CONST ILL_COPROC = 7			/* Coprocessor error.  */
NATIVE {ILL_BADSTK}	CONST ILL_BADSTK = 8			/* Internal stack error.  */
NATIVE {ILL_BADIADDR}	CONST ILL_BADIADDR = 9			/* Unimplemented instruction address.  */

/* `si_code' values for SIGFPE signal.  */
NATIVE {FPE_INTDIV} CONST FPE_INTDIV = 1		/* Integer divide by zero.  */
NATIVE {FPE_INTOVF}	CONST FPE_INTOVF = 2			/* Integer overflow.  */
NATIVE {FPE_FLTDIV}	CONST FPE_FLTDIV = 3			/* Floating point divide by zero.  */
NATIVE {FPE_FLTOVF}	CONST FPE_FLTOVF = 4			/* Floating point overflow.  */
NATIVE {FPE_FLTUND}	CONST FPE_FLTUND = 5			/* Floating point underflow.  */
NATIVE {FPE_FLTRES}	CONST FPE_FLTRES = 6			/* Floating point inexact result.  */
NATIVE {FPE_FLTINV}	CONST FPE_FLTINV = 7			/* Floating point invalid operation.  */
NATIVE {FPE_FLTSUB}	CONST FPE_FLTSUB = 8			/* Subscript out of range.  */
NATIVE {FPE_FLTUNK} CONST FPE_FLTUNK = 14		/* Undiagnosed floating-point exception.  */
NATIVE {FPE_CONDTRAP}	CONST FPE_CONDTRAP = 15			/* Trap on condition.  */

/* `si_code' values for SIGSEGV signal.  */
NATIVE {SEGV_MAPERR} CONST SEGV_MAPERR = 1		/* Address not mapped to object.  */
NATIVE {SEGV_ACCERR}	CONST SEGV_ACCERR = 2			/* Invalid permissions for mapped object.  */
NATIVE {SEGV_BNDERR}	CONST SEGV_BNDERR = 3			/* Bounds checking failure.  */
NATIVE {SEGV_PKUERR}	CONST SEGV_PKUERR = 4			/* Protection key checking failure.  */
NATIVE {SEGV_ACCADI}	CONST SEGV_ACCADI = 5			/* ADI not enabled for mapped object.  */
NATIVE {SEGV_ADIDERR}	CONST SEGV_ADIDERR = 6			/* Disrupting MCD error.  */
NATIVE {SEGV_ADIPERR}	CONST SEGV_ADIPERR = 7			/* Precise MCD exception.  */

/* `si_code' values for SIGBUS signal.  */
NATIVE {BUS_ADRALN} CONST BUS_ADRALN = 1		/* Invalid address alignment.  */
NATIVE {BUS_ADRERR}	CONST BUS_ADRERR = 2			/* Non-existant physical address.  */
NATIVE {BUS_OBJERR}	CONST BUS_OBJERR = 3			/* Object specific hardware error.  */
NATIVE {BUS_MCEERR_AR}	CONST BUS_MCEERR_AR = 4		/* Hardware memory error: action required.  */
NATIVE {BUS_MCEERR_AO}	CONST BUS_MCEERR_AO = 5			/* Hardware memory error: action optional.  */

/* `si_code' values for SIGTRAP signal.  */
NATIVE {TRAP_BRKPT} CONST TRAP_BRKPT = 1		/* Process breakpoint.  */
NATIVE {TRAP_TRACE}	CONST TRAP_TRACE = 2			/* Process trace trap.  */
NATIVE {TRAP_BRANCH}	CONST TRAP_BRANCH = 3			/* Process taken branch trap.  */
NATIVE {TRAP_HWBKPT}	CONST TRAP_HWBKPT = 4			/* Hardware breakpoint/watchpoint.  */
NATIVE {TRAP_UNK}	CONST TRAP_UNK = 5			/* Undiagnosed trap.  */

/* `si_code' values for SIGCHLD signal.  */
NATIVE {CLD_EXITED} CONST CLD_EXITED = 1		/* Child has exited.  */
NATIVE {CLD_KILLED}	CONST CLD_KILLED = 2			/* Child was killed.  */
NATIVE {CLD_DUMPED}	CONST CLD_DUMPED = 3			/* Child terminated abnormally.  */
NATIVE {CLD_TRAPPED}	CONST CLD_TRAPPED = 4			/* Traced child has trapped.  */
NATIVE {CLD_STOPPED}	CONST CLD_STOPPED = 5			/* Child has stopped.  */
NATIVE {CLD_CONTINUED}	CONST CLD_CONTINUED = 6			/* Stopped child has continued.  */

/* `si_code' values for SIGPOLL signal.  */
NATIVE {POLL_IN} CONST POLL_IN = 1			/* Data input available.  */
NATIVE {POLL_OUT}	CONST POLL_OUT = 2			/* Output buffers available.  */
NATIVE {POLL_MSG}	CONST POLL_MSG = 3			/* Input message available.   */
NATIVE {POLL_ERR}	CONST POLL_ERR = 4			/* I/O error.  */
NATIVE {POLL_PRI}	CONST POLL_PRI = 5			/* High priority input available.  */
NATIVE {POLL_HUP}	CONST POLL_HUP = 6			/* Device disconnected.  */
