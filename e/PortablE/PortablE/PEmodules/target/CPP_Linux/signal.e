OPT NATIVE
MODULE 'target/signal_shared'	->manually added
MODULE 'target/x86_64-linux-gnu/bits/types/__sigval_t'	->guessed
MODULE 'target/x86_64-linux-gnu/bits/types/struct_sigstack'	->guessed
MODULE 'target/features'
MODULE 'target/x86_64-linux-gnu/bits/types'
PUBLIC MODULE 'target/x86_64-linux-gnu/bits/signum'
MODULE 'target/x86_64-linux-gnu/bits/types/sig_atomic_t'
MODULE 'target/x86_64-linux-gnu/bits/types/sigset_t'
/* We need `struct timespec' later on.  */
 MODULE 'target/x86_64-linux-gnu/bits/types/struct_timespec'
 MODULE 'target/x86_64-linux-gnu/bits/types/siginfo_t'
 MODULE 'target/x86_64-linux-gnu/bits/siginfo-consts'
 MODULE 'target/x86_64-linux-gnu/bits/types/sigval_t'
 MODULE 'target/x86_64-linux-gnu/bits/types/sigevent_t'
 MODULE 'target/x86_64-linux-gnu/bits/sigevent-consts'
/* Get the system-specific definitions of `struct sigaction'
   and the `SA_*' and `SIG_*'. constants.  */
 MODULE 'target/x86_64-linux-gnu/bits/sigaction'
/* Get machine-dependent `struct sigcontext' and signal subcodes.  */
 MODULE 'target/x86_64-linux-gnu/bits/sigcontext'
 MODULE 'target/stddef'
 MODULE 'target/x86_64-linux-gnu/bits/types/stack_t'
/* This will define `ucontext_t' and `mcontext_t'.  */
  MODULE 'target/x86_64-linux-gnu/sys/ucontext'
 MODULE 'target/x86_64-linux-gnu/bits/sigstack'
 MODULE 'target/x86_64-linux-gnu/bits/ss_flags'
 MODULE 'target/x86_64-linux-gnu/bits/sigstack'
 MODULE 'target/x86_64-linux-gnu/bits/ss_flags'
/* Some of the functions for handling signals in threaded programs must
   be defined here.  */
 MODULE 'target/x86_64-linux-gnu/bits/pthreadtypes'
 MODULE 'target/x86_64-linux-gnu/bits/sigthread'
/* System-specific extensions.  */
MODULE 'target/x86_64-linux-gnu/bits/signal_ext'
{#include <signal.h>}
/* Copyright (C) 1991-2020 Free Software Foundation, Inc.
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

/*
 *	ISO C99 Standard: 7.14 Signal handling <signal.h>
 */

NATIVE {_SIGNAL_H} DEF

->NATIVE {pid_t} OBJECT
->TYPE pid_t IS NATIVE {pid_t} PID_T__
  ->NATIVE {PID_T___defined} DEF
->NATIVE {uid_t} OBJECT
->TYPE uid_t IS NATIVE {uid_t} __uid_t
  ->NATIVE {__uid_t_defined} DEF


/* Type of a signal handler.  */

/*->moved to MODULE 'target/signal_shared'
TYPE SIGHANDLER_T__ IS NATIVE {__sighandler_t} PTR /*void (*__sighandler_t) (int)*/
*/

/* The X/Open definition of `signal' specifies the SVID semantic.  Use
   the additional function `sysv_signal' when X/Open compatibility is
   requested.  */
->NATIVE {__sysv_signal} PROC
PROC __sysv_signal(__sig:LONG, __handler:SIGHANDLER_T__) IS NATIVE {__sysv_signal( (int) } __sig {,} __handler {)} ENDNATIVE !!SIGHANDLER_T__
NATIVE {sysv_signal} PROC
PROC sysv_signal(__sig:LONG, __handler:SIGHANDLER_T__) IS NATIVE {sysv_signal( (int) } __sig {,} __handler {)} ENDNATIVE !!SIGHANDLER_T__

/* Set the handler for the signal SIG to HANDLER, returning the old
   handler, or SIG_ERR on error.
   By default `signal' has the BSD semantic.  */
NATIVE {signal} PROC
PROC signal(__sig:LONG, __handler:SIGHANDLER_T__) IS NATIVE {signal( (int) } __sig {,} __handler {)} ENDNATIVE !!SIGHANDLER_T__

/*
#if defined __USE_XOPEN_EXTENDED && !defined __USE_XOPEN2K8
/* The X/Open definition of `signal' conflicts with the BSD version.
   So they defined another function `bsd_signal'.  */
NATIVE {bsd_signal} PROC
PROC bsd_signal(__sig:LONG, __handler:SIGHANDLER_T__) IS NATIVE {bsd_signal( (int) } __sig {,} __handler {)} ENDNATIVE !!SIGHANDLER_T__
#endif
*/

/* Send signal SIG to process number PID.  If PID is zero,
   send SIG to all processes in the current process's process group.
   If PID is < -1, send SIG to all processes in process group - PID.  */
NATIVE {kill} PROC
PROC kill(__pid:PID_T__, __sig:LONG) IS NATIVE {kill(} __pid {, (int) } __sig {)} ENDNATIVE !!LONG

/* Send SIG to all processes in process group PGRP.
   If PGRP is zero, send SIG to all processes in
   the current process's process group.  */
NATIVE {killpg} PROC
PROC killpg(__pgrp:PID_T__, __sig:LONG) IS NATIVE {killpg(} __pgrp {, (int) } __sig {)} ENDNATIVE !!LONG

/* Raise signal SIG, i.e., send SIG to yourself.  */
NATIVE {raise} PROC
PROC raise(__sig:LONG) IS NATIVE {raise( (int) } __sig {)} ENDNATIVE !!LONG

/* SVID names for the same things.  */
NATIVE {ssignal} PROC
PROC ssignal(__sig:LONG, __handler:SIGHANDLER_T__) IS NATIVE {ssignal( (int) } __sig {,} __handler {)} ENDNATIVE !!SIGHANDLER_T__
NATIVE {gsignal} PROC
PROC gsignal(__sig:LONG) IS NATIVE {gsignal( (int) } __sig {)} ENDNATIVE !!LONG

/* Print a message describing the meaning of the given signal number.  */
NATIVE {psignal} PROC
PROC psignal(__sig:LONG, __s:ARRAY OF CHAR) IS NATIVE {psignal( (int) } __sig {,} __s {)} ENDNATIVE

/* Print a message describing the meaning of the given signal information.  */
NATIVE {psiginfo} PROC
PROC psiginfo(__pinfo:PTR TO siginfo_t, __s:ARRAY OF CHAR) IS NATIVE {psiginfo(} __pinfo {,} __s {)} ENDNATIVE



/* The `sigpause' function in X/Open defines the argument as the
   signal number.  This requires redirecting to another function
   because the default version in glibc uses an old BSD interface.

   This function is a cancellation point and therefore not marked with
   __THROW.  */

NATIVE {sigpause} PROC
PROC sigpause(__sig:LONG) IS NATIVE {sigpause( (int) } __sig {)} ENDNATIVE !!LONG


/* None of the following functions should be used anymore.  They are here
   only for compatibility.  A single word (`int') is not guaranteed to be
   enough to hold a complete signal mask and therefore these functions
   simply do not work in many situations.  Use `sigprocmask' instead.  */

/* Compute mask for signal SIG.  */
 NATIVE {sigmask} PROC	->define sigmask(sig) ((int)(1u << ((sig) - 1)))

/* Block signals in MASK, returning the old mask.  */
NATIVE {sigblock} PROC
PROC sigblock(__mask:LONG) IS NATIVE {sigblock( (int) } __mask {)} ENDNATIVE !!LONG

/* Set the mask of blocked signals to MASK, returning the old mask.  */
NATIVE {sigsetmask} PROC
PROC sigsetmask(__mask:LONG) IS NATIVE {sigsetmask( (int) } __mask {)} ENDNATIVE !!LONG

/* Return currently selected signal mask.  */
NATIVE {siggetmask} PROC
->PROC siggetmask() IS NATIVE {siggetmask()} ENDNATIVE !!LONG


-> NATIVE {NSIG}	CONST NSIG	= NSIG_

NATIVE {sighandler_t} OBJECT
->TYPE sighandler_t IS NATIVE {sighandler_t} SIGHANDLER_T__

/* 4.4 BSD uses the name `sig_t' for this.  */
NATIVE {sig_t} OBJECT
->TYPE sig_t IS NATIVE {sig_t} SIGHANDLER_T__


/* Clear all signals from SET.  */
NATIVE {sigemptyset} PROC
PROC sigemptyset(__set:PTR TO sigset_t) IS NATIVE {sigemptyset(} __set {)} ENDNATIVE !!LONG

/* Set all signals in SET.  */
NATIVE {sigfillset} PROC
PROC sigfillset(__set:PTR TO sigset_t) IS NATIVE {sigfillset(} __set {)} ENDNATIVE !!LONG

/* Add SIGNO to SET.  */
NATIVE {sigaddset} PROC
PROC sigaddset(__set:PTR TO sigset_t, __signo:LONG) IS NATIVE {sigaddset(} __set {, (int) } __signo {)} ENDNATIVE !!LONG

/* Remove SIGNO from SET.  */
NATIVE {sigdelset} PROC
PROC sigdelset(__set:PTR TO sigset_t, __signo:LONG) IS NATIVE {sigdelset(} __set {, (int) } __signo {)} ENDNATIVE !!LONG

/* Return 1 if SIGNO is in SET, 0 if not.  */
NATIVE {sigismember} PROC
PROC sigismember(__set:PTR TO sigset_t, __signo:LONG) IS NATIVE {sigismember(} __set {, (int) } __signo {)} ENDNATIVE !!LONG

/* Return non-empty value is SET is not empty.  */
NATIVE {sigisemptyset} PROC
PROC sigisemptyset(__set:PTR TO sigset_t) IS NATIVE {sigisemptyset(} __set {)} ENDNATIVE !!LONG

/* Build new signal set by combining the two inputs set using logical AND.  */
NATIVE {sigandset} PROC
PROC sigandset(__set:PTR TO sigset_t, __left:PTR TO sigset_t,
		      __right:PTR TO sigset_t) IS NATIVE {sigandset(} __set {,} __left {,} __right {)} ENDNATIVE !!LONG

/* Build new signal set by combining the two inputs set using logical OR.  */
NATIVE {sigorset} PROC
PROC sigorset(__set:PTR TO sigset_t, __left:PTR TO sigset_t,
		     __right:PTR TO sigset_t) IS NATIVE {sigorset(} __set {,} __left {,} __right {)} ENDNATIVE !!LONG

/* Get and/or change the set of blocked signals.  */
NATIVE {sigprocmask} PROC
PROC sigprocmask(__how:LONG, __set:PTR TO sigset_t,
			__oset:PTR TO sigset_t) IS NATIVE {sigprocmask( (int) } __how {,} __set {,} __oset {)} ENDNATIVE !!LONG

/* Change the set of blocked signals to SET,
   wait until a signal arrives, and restore the set of blocked signals.

   This function is a cancellation point and therefore not marked with
   __THROW.  */
NATIVE {sigsuspend} PROC
PROC sigsuspend(__set:PTR TO sigset_t) IS NATIVE {sigsuspend(} __set {)} ENDNATIVE !!LONG

/* Get and/or set the action for signal SIG.  */
->NATIVE {sigaction} PROC
PROC sigaction(__sig:LONG, __act:PTR TO sigaction,
		      __oact:PTR TO sigaction) IS NATIVE {sigaction( (int) } __sig {,} __act {,} __oact {)} ENDNATIVE !!LONG

/* Put in SET all signals that are blocked and waiting to be delivered.  */
NATIVE {sigpending} PROC
PROC sigpending(__set:PTR TO sigset_t) IS NATIVE {sigpending(} __set {)} ENDNATIVE !!LONG


/* Select any of pending signals from SET or wait for any to arrive.

   This function is a cancellation point and therefore not marked with
   __THROW.  */
NATIVE {sigwait} PROC
PROC sigwait(__set:PTR TO sigset_t, __sig:PTR TO LONG) IS NATIVE {sigwait(} __set {,} __sig {)} ENDNATIVE !!LONG

/* Select any of pending signals from SET and place information in INFO.

   This function is a cancellation point and therefore not marked with
   __THROW.  */
NATIVE {sigwaitinfo} PROC
PROC sigwaitinfo(__set:PTR TO sigset_t,
			__info:PTR TO siginfo_t) IS NATIVE {sigwaitinfo(} __set {,} __info {)} ENDNATIVE !!LONG

/* Select any of pending signals from SET and place information in INFO.
   Wait the time specified by TIMEOUT if no signal is pending.

   This function is a cancellation point and therefore not marked with
   __THROW.  */
NATIVE {sigtimedwait} PROC
PROC sigtimedwait(__set:PTR TO sigset_t,
			 __info:PTR TO siginfo_t,
			 __timeout:PTR TO timespec) IS NATIVE {sigtimedwait(} __set {,} __info {,} __timeout {)} ENDNATIVE !!LONG

/* Send signal SIG to the process PID.  Associate data in VAL with the
   signal.  */
NATIVE {sigqueue} PROC
PROC sigqueue(__pid:PID_T__, __sig:LONG, __val:PTR TO sigval) IS NATIVE {sigqueue(} __pid {, (int) } __sig {, *} __val {)} ENDNATIVE !!LONG



/* Names of the signals.  This variable exists only for compatibility.
   Use `strsignal' instead (see <string.h>).  */
NATIVE {_sys_siglist} DEF
NATIVE {sys_siglist} DEF


/* Restore the state saved in SCP.  */
NATIVE {sigreturn} PROC
->PROC sigreturn(__scp:PTR TO sigcontext) IS NATIVE {sigreturn(} __scp {)} ENDNATIVE !!LONG



 ->NATIVE {__need_size_t} DEF

/* If INTERRUPT is nonzero, make signal SIG interrupt system calls
   (causing them to fail with EINTR); if INTERRUPT is zero, make system
   calls be restarted after signal SIG.  */
NATIVE {siginterrupt} PROC
PROC siginterrupt(__sig:LONG, __interrupt:LONG) IS NATIVE {siginterrupt( (int) } __sig {, (int) } __interrupt {)} ENDNATIVE !!LONG

/* Alternate signal handler stack interface.
   This interface should always be preferred over `sigstack'.  */
->NATIVE {sigaltstack} PROC
PROC sigaltstack(__ss:PTR TO stack_t,
			__oss:PTR TO stack_t) IS NATIVE {sigaltstack(} __ss {,} __oss {)} ENDNATIVE !!LONG

/* Run signals handlers on the stack specified by SS (if not NULL).
   If OSS is not NULL, it is filled in with the old signal stack status.
   This interface is obsolete and on many platform not implemented.  */
->NATIVE {sigstack} PROC
->PROC sigstack(__ss:PTR TO sigstack, __oss:PTR TO sigstack) IS NATIVE {sigstack(} __ss {,} __oss {)} ENDNATIVE !!LONG

/* Simplified interface for signal management.  */

/* Add SIG to the calling process' signal mask.  */
NATIVE {sighold} PROC
PROC sighold(__sig:LONG) IS NATIVE {sighold( (int) } __sig {)} ENDNATIVE !!LONG

/* Remove SIG from the calling process' signal mask.  */
NATIVE {sigrelse} PROC
PROC sigrelse(__sig:LONG) IS NATIVE {sigrelse( (int) } __sig {)} ENDNATIVE !!LONG

/* Set the disposition of SIG to SIG_IGN.  */
NATIVE {sigignore} PROC
PROC sigignore(__sig:LONG) IS NATIVE {sigignore( (int) } __sig {)} ENDNATIVE !!LONG

/* Set the disposition of SIG.  */
NATIVE {sigset} PROC
PROC sigset(__sig:LONG, __disp:SIGHANDLER_T__) IS NATIVE {sigset( (int) } __sig {,} __disp {)} ENDNATIVE !!SIGHANDLER_T__


/* The following functions are used internally in the C library and in
   other code which need deep insights.  */

/* Return number of available real-time signal with highest priority.  */
->NATIVE {__libc_current_sigrtmin} PROC
PROC __libc_current_sigrtmin() IS NATIVE {__libc_current_sigrtmin()} ENDNATIVE !!LONG
/* Return number of available real-time signal with lowest priority.  */
->NATIVE {__libc_current_sigrtmax} PROC
PROC __libc_current_sigrtmax() IS NATIVE {__libc_current_sigrtmax()} ENDNATIVE !!LONG

NATIVE {SIGRTMIN}        CONST ->SIGRTMIN        = (__libc_current_sigrtmin ())
NATIVE {SIGRTMAX}        CONST ->SIGRTMAX        = (__libc_current_sigrtmax ())
