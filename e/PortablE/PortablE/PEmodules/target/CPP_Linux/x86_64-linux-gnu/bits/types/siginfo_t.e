OPT NATIVE
MODULE 'target/x86_64-linux-gnu/bits/wordsize'
MODULE 'target/x86_64-linux-gnu/bits/types'
MODULE 'target/x86_64-linux-gnu/bits/types/__sigval_t'
MODULE 'target/x86_64-linux-gnu/bits/siginfo-arch'
{#include <x86_64-linux-gnu/bits/types/siginfo_t.h>}
->NATIVE {__siginfo_t_defined} CONST __SIGINFO_T_DEFINED = 1

->NATIVE {__SI_MAX_SIZE}	CONST __SI_MAX_SIZE	= 128
 ->NATIVE {__SI_PAD_SIZE}	CONST __SI_PAD_SIZE	= ((__SI_MAX_SIZE / SIZEOF INT) - 4)

/* Some fields of siginfo_t have architecture-specific variations.  */
 ->NATIVE {__SI_ALIGNMENT} DEF
 TYPE SI_BAND_TYPE__ IS NATIVE {__SI_BAND_TYPE} CLONG
 TYPE SI_CLOCK_T__ IS NATIVE {__SI_CLOCK_T} CLOCK_T__
 ->NATIVE {__SI_ERRNO_THEN_CODE}	CONST __SI_ERRNO_THEN_CODE	= 1
 ->NATIVE {__SI_HAVE_SIGSYS}	CONST __SI_HAVE_SIGSYS	= 1
 ->NATIVE {__SI_SIGFAULT_ADDL} DEF

NATIVE {siginfo_t Typedef} OBJECT siginfo_t
    {si_signo}	si_signo	:VALUE		/* Signal number.  */
    {si_code}	si_code	:VALUE
    {si_errno}	si_errno	:VALUE
    {__pad0}	__pad0	:VALUE			/* Explicit padding.  */

->	{_sifields._pad}	_pad[__SI_PAD_SIZE]	:ARRAY OF VALUE

	 /* kill().  */
	    {_sifields._kill.si_pid}	_kill_si_pid	:PID_T__	/* Sending process ID.  */
	    {_sifields._kill.si_uid}	_kill_si_uid	:UID_T__	/* Real user ID of sending process.  */

	/* POSIX.1b timers.  */
	    {_sifields._timer.si_tid}	_timer_si_tid	:VALUE		/* Timer ID.  */
	    {_sifields._timer.si_overrun}	_timer_si_overrun	:VALUE	/* Overrun count.  */
	    {_sifields._timer.si_sigval}	_timer_si_sigval	:__sigval_t	/* Signal value.  */

	/* POSIX.1b signals.  */
	    {_sifields._rt.si_pid}	_rt_si_pid	:PID_T__	/* Sending process ID.  */
	    {_sifields._rt.si_uid}	_rt_si_uid	:UID_T__	/* Real user ID of sending process.  */
	    {_sifields._rt.si_sigval}	_rt_si_sigval	:__sigval_t	/* Signal value.  */

	/* SIGCHLD.  */
	    {_sifields._sigchld.si_pid}	_sigchld_si_pid	:PID_T__	/* Which child.	 */
	    {_sifields._sigchld.si_uid}	_sigchld_si_uid	:UID_T__	/* Real user ID of sending process.  */
	    {_sifields._sigchld.si_status}	_sigchld_si_status	:VALUE	/* Exit value or signal.  */
	    {_sifields._sigchld.si_utime}	_sigchld_si_utime	:SI_CLOCK_T__
	    {_sifields._sigchld.si_stime}	_sigchld_si_stime	:SI_CLOCK_T__

	/* SIGILL, SIGFPE, SIGSEGV, SIGBUS.  */
	    {_sifields._sigfault.si_addr}	_sigfault_si_addr	:PTR	    /* Faulting insn/memory ref.  */
	    {_sifields._sigfault.si_addr_lsb}	_sigfault_si_addr_lsb	:INT  /* Valid LSB of the reported address.  */
		/* used when si_code=SEGV_BNDERR */
		    {_sifields._sigfault._bounds._addr_bnd._lower}	_sigfault__lower	:PTR
		    {_sifields._sigfault._bounds._addr_bnd._upper}	_sigfault__upper	:PTR
		/* used when si_code=SEGV_PKUERR */
		{_sifields._sigfault._bounds._pkey}	_sigfault__pkey	:UINT32_T__

	/* SIGPOLL.  */
	    {_sifields._sigpoll.si_band}	_sigpoll_si_band	:SI_BAND_TYPE__	/* Band event for SIGPOLL.  */
	    {_sifields._sigpoll.si_fd}	_sigpoll_si_fd	:VALUE

	/* SIGSYS.  */
/*
#if __SI_HAVE_SIGSYS
	    {_sifields._sigsys._call_addr}	_call_addr	:PTR	/* Calling user insn.  */
	    {_sifields._sigsys._syscall}	_syscall	:VALUE	/* Triggering system call number.  */
	    {_sifields._sigsys._arch}	_arch	:ULONG /* AUDIT_ARCH_* of syscall.  */
#endif
*/
ENDOBJECT 


/* X/Open requires some more fields with fixed names.  */
/*
NATIVE {si_pid}		CONST ->SI_PID		= _sifields._kill.si_pid
NATIVE {si_uid}		CONST ->SI_UID		= _sifields._kill.si_uid
NATIVE {si_timerid}	CONST ->SI_TIMERID	= _sifields._timer.si_tid
NATIVE {si_overrun}	CONST ->SI_OVERRUN	= _sifields._timer.si_overrun
NATIVE {si_status}	CONST ->SI_STATUS	= _sifields._sigchld.si_status
NATIVE {si_utime}	CONST ->SI_UTIME	= _sifields._sigchld.si_utime
NATIVE {si_stime}	CONST ->SI_STIME	= _sifields._sigchld.si_stime
NATIVE {si_value}	CONST ->SI_VALUE	= _sifields._rt.si_sigval
NATIVE {si_int}		CONST ->SI_INT		= _sifields._rt.si_sigval.sival_int
NATIVE {si_ptr}		CONST ->SI_PTR		= _sifields._rt.si_sigval.sival_ptr
NATIVE {si_addr}		CONST ->SI_ADDR		= _sifields._sigfault.si_addr
NATIVE {si_addr_lsb}	CONST ->SI_ADDR_LSB	= _sifields._sigfault.si_addr_lsb
NATIVE {si_lower}	CONST ->SI_LOWER	= _sifields._sigfault._bounds._addr_bnd._lower
NATIVE {si_upper}	CONST ->SI_UPPER	= _sifields._sigfault._bounds._addr_bnd._upper
NATIVE {si_pkey}		CONST ->SI_PKEY		= _sifields._sigfault._bounds._pkey
NATIVE {si_band}		CONST ->SI_BAND		= _sifields._sigpoll.si_band
NATIVE {si_fd}		CONST ->SI_FD		= _sifields._sigpoll.si_fd
*/
/*
#if __SI_HAVE_SIGSYS
 NATIVE {si_call_addr}	CONST ->SI_CALL_ADDR	= _sifields._sigsys._call_addr
 NATIVE {si_syscall}	CONST ->SI_SYSCALL	= _sifields._sigsys._syscall
 NATIVE {si_arch}	CONST ->SI_ARCH	= _sifields._sigsys._arch
#endif
*/
