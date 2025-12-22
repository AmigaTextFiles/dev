OPT NATIVE
MODULE 'std/pUnsigned'
MODULE 'target/x86_64-linux-gnu/sys/types'	->guessed
PUBLIC MODULE 'target/fcntl'	->guessed
MODULE 'target/stdint'		->guessed
MODULE 'target/features'
MODULE 'target/x86_64-linux-gnu/bits/posix_opt'
/* Get the environment definitions from Unix98.  */
 MODULE 'target/x86_64-linux-gnu/bits/environments'
MODULE 'target/x86_64-linux-gnu/bits/types'
MODULE 'target/stddef'
/* Get the `_PC_*' symbols for the NAME argument to `pathconf' and `fpathconf';
   the `_SC_*' symbols for the NAME argument to `sysconf';
   and the `_CS_*' symbols for the NAME argument to `confstr'.  */
MODULE 'target/x86_64-linux-gnu/bits/confname'
/* Get definitions and prototypes for functions to process the
   arguments in ARGV (ARGC of them, minus the program name) for
   options given in OPTS.  */
 MODULE 'target/x86_64-linux-gnu/bits/getopt_posix'
/* System-specific extensions.  */
MODULE 'target/x86_64-linux-gnu/bits/unistd_ext'
{#include <unistd.h>}
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
 *	POSIX Standard: 2.10 Symbolic Constants		<unistd.h>
 */

NATIVE {_UNISTD_H}	CONST ->_UNISTD_H	= 1

/* These may be used to determine what facilities are present at compile time.
   Their values can be obtained at run time from `sysconf'.  */

/* POSIX Standard approved as ISO/IEC 9945-1 as of September 2008.  */
 NATIVE {_POSIX_VERSION}	CONST ->_POSIX_VERSION	= 200809

/* These are not #ifdef __USE_POSIX2 because they are
   in the theoretically application-owned namespace.  */

 ->NATIVE {__POSIX2_THIS_VERSION}	CONST __POSIX2_THIS_VERSION	= 200809
/* The utilities on GNU systems also correspond to this version.  */

/* The utilities on GNU systems also correspond to this version.  */
NATIVE {_POSIX2_VERSION}	CONST ->_POSIX2_VERSION	= __POSIX2_THIS_VERSION

/* This symbol was required until the 2001 edition of POSIX.  */
NATIVE {_POSIX2_C_VERSION}	CONST ->_POSIX2_C_VERSION	= __POSIX2_THIS_VERSION

/* If defined, the implementation supports the
   C Language Bindings Option.  */
NATIVE {_POSIX2_C_BIND}	CONST ->_POSIX2_C_BIND	= __POSIX2_THIS_VERSION

/* If defined, the implementation supports the
   C Language Development Utilities Option.  */
NATIVE {_POSIX2_C_DEV}	CONST ->_POSIX2_C_DEV	= __POSIX2_THIS_VERSION

/* If defined, the implementation supports the
   Software Development Utilities Option.  */
NATIVE {_POSIX2_SW_DEV}	CONST ->_POSIX2_SW_DEV	= __POSIX2_THIS_VERSION

/* If defined, the implementation supports the
   creation of locales with the localedef utility.  */
NATIVE {_POSIX2_LOCALEDEF}       CONST ->_POSIX2_LOCALEDEF       = __POSIX2_THIS_VERSION

/* X/Open version number to which the library conforms.  It is selectable.  */
 NATIVE {_XOPEN_VERSION}	CONST ->_XOPEN_VERSION	= 700

/* Commands and utilities from XPG4 are available.  */
NATIVE {_XOPEN_XCU_VERSION}	CONST ->_XOPEN_XCU_VERSION	= 4

/* We are compatible with the old published standards as well.  */
NATIVE {_XOPEN_XPG2}	CONST ->_XOPEN_XPG2	= 1
NATIVE {_XOPEN_XPG3}	CONST ->_XOPEN_XPG3	= 1
NATIVE {_XOPEN_XPG4}	CONST ->_XOPEN_XPG4	= 1

/* The X/Open Unix extensions are available.  */
NATIVE {_XOPEN_UNIX}	CONST ->_XOPEN_UNIX	= 1

/* The enhanced internationalization capabilities according to XPG4.2
   are present.  */
NATIVE {_XOPEN_ENH_I18N}	CONST ->_XOPEN_ENH_I18N	= 1

/* The legacy interfaces are also available.  */
NATIVE {_XOPEN_LEGACY}	CONST ->_XOPEN_LEGACY	= 1


/* Get values of POSIX options:

   If these symbols are defined, the corresponding features are
   always available.  If not, they may be available sometimes.
   The current values can be obtained with `sysconf'.

   _POSIX_JOB_CONTROL		Job control is supported.
   _POSIX_SAVED_IDS		Processes have a saved set-user-ID
				and a saved set-group-ID.
   _POSIX_REALTIME_SIGNALS	Real-time, queued signals are supported.
   _POSIX_PRIORITY_SCHEDULING	Priority scheduling is supported.
   _POSIX_TIMERS		POSIX.4 clocks and timers are supported.
   _POSIX_ASYNCHRONOUS_IO	Asynchronous I/O is supported.
   _POSIX_PRIORITIZED_IO	Prioritized asynchronous I/O is supported.
   _POSIX_SYNCHRONIZED_IO	Synchronizing file data is supported.
   _POSIX_FSYNC			The fsync function is present.
   _POSIX_MAPPED_FILES		Mapping of files to memory is supported.
   _POSIX_MEMLOCK		Locking of all memory is supported.
   _POSIX_MEMLOCK_RANGE		Locking of ranges of memory is supported.
   _POSIX_MEMORY_PROTECTION	Setting of memory protections is supported.
   _POSIX_MESSAGE_PASSING	POSIX.4 message queues are supported.
   _POSIX_SEMAPHORES		POSIX.4 counting semaphores are supported.
   _POSIX_SHARED_MEMORY_OBJECTS	POSIX.4 shared memory objects are supported.
   _POSIX_THREADS		POSIX.1c pthreads are supported.
   _POSIX_THREAD_ATTR_STACKADDR	Thread stack address attribute option supported.
   _POSIX_THREAD_ATTR_STACKSIZE	Thread stack size attribute option supported.
   _POSIX_THREAD_SAFE_FUNCTIONS	Thread-safe functions are supported.
   _POSIX_THREAD_PRIORITY_SCHEDULING
				POSIX.1c thread execution scheduling supported.
   _POSIX_THREAD_PRIO_INHERIT	Thread priority inheritance option supported.
   _POSIX_THREAD_PRIO_PROTECT	Thread priority protection option supported.
   _POSIX_THREAD_PROCESS_SHARED	Process-shared synchronization supported.
   _POSIX_PII			Protocol-independent interfaces are supported.
   _POSIX_PII_XTI		XTI protocol-indep. interfaces are supported.
   _POSIX_PII_SOCKET		Socket protocol-indep. interfaces are supported.
   _POSIX_PII_INTERNET		Internet family of protocols supported.
   _POSIX_PII_INTERNET_STREAM	Connection-mode Internet protocol supported.
   _POSIX_PII_INTERNET_DGRAM	Connectionless Internet protocol supported.
   _POSIX_PII_OSI		ISO/OSI family of protocols supported.
   _POSIX_PII_OSI_COTS		Connection-mode ISO/OSI service supported.
   _POSIX_PII_OSI_CLTS		Connectionless ISO/OSI service supported.
   _POSIX_POLL			Implementation supports `poll' function.
   _POSIX_SELECT		Implementation supports `select' and `pselect'.

   _XOPEN_REALTIME		X/Open realtime support is available.
   _XOPEN_REALTIME_THREADS	X/Open realtime thread support is available.
   _XOPEN_SHM			Shared memory interface according to XPG4.2.

   _XBS5_ILP32_OFF32		Implementation provides environment with 32-bit
				int, long, pointer, and OFF_T types.
   _XBS5_ILP32_OFFBIG		Implementation provides environment with 32-bit
				int, long, and pointer and OFF_T with at least
				64 bits.
   _XBS5_LP64_OFF64		Implementation provides environment with 32-bit
				int, and 64-bit long, pointer, and OFF_T types.
   _XBS5_LPBIG_OFFBIG		Implementation provides environment with at
				least 32 bits int and long, pointer, and OFF_T
				with at least 64 bits.

   If any of these symbols is defined as -1, the corresponding option is not
   true for any file.  If any is defined as other than -1, the corresponding
   option is true for all files.  If a symbol is not defined at all, the value
   for a specific file can be obtained from `pathconf' and `fpathconf'.

   _POSIX_CHOWN_RESTRICTED	Only the super user can use `chown' to change
				the owner of a file.  `chown' can only be used
				to change the group ID of a file to a group of
				which the calling process is a member.
   _POSIX_NO_TRUNC		Pathname components longer than
				NAME_MAX generate an error.
   _POSIX_VDISABLE		If defined, if the value of an element of the
				`c_cc' member of `struct termios' is
				_POSIX_VDISABLE, no character will have the
				effect associated with that element.
   _POSIX_SYNC_IO		Synchronous I/O may be performed.
   _POSIX_ASYNC_IO		Asynchronous I/O may be performed.
   _POSIX_PRIO_IO		Prioritized Asynchronous I/O may be performed.

   Support for the Large File Support interface is not generally available.
   If it is available the following constants are defined to one.
   _LFS64_LARGEFILE		Low-level I/O supports large files.
   _LFS64_STDIO			Standard I/O supports large files.
   */


/* Standard file descriptors.  */
NATIVE {STDIN_FILENO}	CONST STDIN_FILENO	= 0	/* Standard input.  */
NATIVE {STDOUT_FILENO}	CONST STDOUT_FILENO	= 1	/* Standard output.  */
NATIVE {STDERR_FILENO}	CONST STDERR_FILENO	= 2	/* Standard error output.  */


/* All functions that are not declared anywhere else.  */

/*
#ifndef	__ssize_t_defined
NATIVE {ssize_t} OBJECT
->TYPE SSIZE_T IS NATIVE {ssize_t} SSIZE_T__
 ->NATIVE {__ssize_t_defined} DEF
#endif
*/

->NATIVE {__need_size_t} DEF
->NATIVE {__need_NULL} DEF

/* The Single Unix specification says that some more types are
   available here.  */
->NATIVE {gid_t} OBJECT
->TYPE gid_t IS NATIVE {gid_t} GID_T__
  ->NATIVE {__gid_t_defined} DEF

->NATIVE {uid_t} OBJECT
->TYPE uid_t IS NATIVE {uid_t} UID_T__
  ->NATIVE {__uid_t_defined} DEF

/*
 #ifndef __off_t_defined
NATIVE {off_t} OBJECT
->TYPE OFF_T IS NATIVE {off_t} OFF_T__
  ->NATIVE {__off_t_defined} DEF
 #endif
 #if defined __USE_LARGEFILE64 && !defined __off64_t_defined
NATIVE {off64_t} OBJECT
->TYPE OFF64_T IS NATIVE {off64_t} OFF64_T__
  ->NATIVE {__off64_t_defined} DEF
 #endif
*/

->NATIVE {useconds_t} OBJECT
->TYPE useconds_t IS NATIVE {useconds_t} USECONDS_T__
  ->NATIVE {__useconds_t_defined} DEF

->NATIVE {pid_t} OBJECT
->TYPE PID_T IS NATIVE {pid_t} PID_T__
  ->NATIVE {__pid_t_defined} DEF

->NATIVE {intptr_t} OBJECT
->TYPE INTPTR_T IS NATIVE {intptr_t} __intptr_t
  ->NATIVE {__intptr_t_defined} DEF

NATIVE {socklen_t} OBJECT
->TYPE socklen_t IS NATIVE {socklen_t} __socklen_t
  ->NATIVE {__socklen_t_defined} DEF

/* Values for the second argument to access.
   These may be OR'd together.  */
/*
NATIVE {R_OK}	CONST R_OK	= 4		/* Test for read permission.  */
NATIVE {W_OK}	CONST W_OK	= 2		/* Test for write permission.  */
NATIVE {X_OK}	CONST X_OK	= 1		/* Test for execute permission.  */
NATIVE {F_OK}	CONST F_OK	= 0		/* Test for existence.  */
*/

/* Test for access to NAME using the real UID and real GID.  */
NATIVE {access} PROC
PROC access(__name:ARRAY OF CHAR, __type:LONG) IS NATIVE {access(} __name {,} __type {)} ENDNATIVE !!LONG

/* Test for access to NAME using the effective UID and GID
   (as normal file operations use).  */
NATIVE {euidaccess} PROC
PROC euidaccess(__name:ARRAY OF CHAR, __type:LONG) IS NATIVE {euidaccess(} __name {,} __type {)} ENDNATIVE !!LONG

/* An alias for `euidaccess', used by some other systems.  */
NATIVE {eaccess} PROC
PROC eaccess(__name:ARRAY OF CHAR, __type:LONG) IS NATIVE {eaccess(} __name {,} __type {)} ENDNATIVE !!LONG

/* Test for access to FILE relative to the directory FD is open on.
   If AT_EACCESS is set in FLAG, then use effective IDs like `eaccess',
   otherwise use real IDs like `access'.  */
NATIVE {faccessat} PROC
PROC faccessat(__fd:VALUE, __file:ARRAY OF CHAR, __type:LONG, __flag:LONG) IS NATIVE {faccessat(} __fd {,} __file {,} __type {,} __flag {)} ENDNATIVE !!LONG


/* Values for the WHENCE argument to lseek.  */
/*
#ifndef	_STDIO_H		/* <stdio.h> has the same definitions.  */
 NATIVE {SEEK_SET}	CONST SEEK_SET	= 0	/* Seek from beginning of file.  */
 NATIVE {SEEK_CUR}	CONST SEEK_CUR	= 1	/* Seek from current position.  */
 NATIVE {SEEK_END}	CONST SEEK_END	= 2	/* Seek from end of file.  */
  NATIVE {SEEK_DATA}	CONST SEEK_DATA	= 3	/* Seek to next data.  */
  NATIVE {SEEK_HOLE}	CONST SEEK_HOLE	= 4	/* Seek to next hole.  */
#endif
*/

/* Old BSD names for the same constants; just for compatibility.  */
 NATIVE {L_SET}		CONST L_SET		= SEEK_SET
 NATIVE {L_INCR}		CONST L_INCR		= SEEK_CUR
 NATIVE {L_XTND}		CONST L_XTND		= SEEK_END


/* Move FD's file position to OFFSET bytes from the
   beginning of the file (if WHENCE is SEEK_SET),
   the current position (if WHENCE is SEEK_CUR),
   or the end of the file (if WHENCE is SEEK_END).
   Return the new file position.  */
NATIVE {lseek} PROC
PROC lseek(__fd:VALUE, __offset:OFF_T__, __whence:VALUE) IS NATIVE {lseek(} __fd {,} __offset {,} __whence {)} ENDNATIVE !!OFF_T__
NATIVE {lseek64} PROC
PROC lseek64(__fd:VALUE, __offset:OFF64_T__, __whence:VALUE) IS NATIVE {lseek64(} __fd {,} __offset {,} __whence {)} ENDNATIVE !!OFF64_T__

/* Close the file descriptor FD.

   This function is a cancellation point and therefore not marked with
   __THROW.  */
NATIVE {close} PROC
PROC close(__fd:VALUE) IS NATIVE {close(} __fd {)} ENDNATIVE !!LONG

/* Read NBYTES into BUF from FD.  Return the
   number read, -1 for errors or 0 for EOF.

   This function is a cancellation point and therefore not marked with
   __THROW.  */
->NATIVE {read} PROC
PROC read(__fd:VALUE, __buf:ARRAY, __nbytes:SIZE_T) IS NATIVE {read(} __fd {,} __buf {,} __nbytes {)} ENDNATIVE !!SSIZE_T

/* Write N bytes of BUF to FD.  Return the number written, or -1.

   This function is a cancellation point and therefore not marked with
   __THROW.  */
->NATIVE {write} PROC
PROC write(__fd:VALUE, __buf:ARRAY, __n:SIZE_T) IS NATIVE {write(} __fd {,} __buf {,} __n {)} ENDNATIVE !!SSIZE_T

/* Read NBYTES into BUF from FD at the given position OFFSET without
   changing the file pointer.  Return the number read, -1 for errors
   or 0 for EOF.

   This function is a cancellation point and therefore not marked with
   __THROW.  */
NATIVE {pread} PROC
PROC pread(__fd:VALUE, __buf:ARRAY, __nbytes:SIZE_T,
		      __offset:OFF_T__) IS NATIVE {pread(} __fd {,} __buf {,} __nbytes {,} __offset {)} ENDNATIVE !!SSIZE_T

/* Write N bytes of BUF to FD at the given position OFFSET without
   changing the file pointer.  Return the number written, or -1.

   This function is a cancellation point and therefore not marked with
   __THROW.  */
NATIVE {pwrite} PROC
PROC pwrite(__fd:VALUE, __buf:ARRAY, __n:SIZE_T,
		       __offset:OFF_T__) IS NATIVE {pwrite(} __fd {,} __buf {,} __n {,} __offset {)} ENDNATIVE !!SSIZE_T

/* Read NBYTES into BUF from FD at the given position OFFSET without
   changing the file pointer.  Return the number read, -1 for errors
   or 0 for EOF.  */
NATIVE {pread64} PROC
PROC pread64(__fd:VALUE, __buf:ARRAY, __nbytes:SIZE_T,
			__offset:OFF64_T__) IS NATIVE {pread64(} __fd {,} __buf {,} __nbytes {,} __offset {)} ENDNATIVE !!SSIZE_T
/* Write N bytes of BUF to FD at the given position OFFSET without
   changing the file pointer.  Return the number written, or -1.  */
NATIVE {pwrite64} PROC
PROC pwrite64(__fd:VALUE, __buf:ARRAY, __n:SIZE_T,
			 __offset:OFF64_T__) IS NATIVE {pwrite64(} __fd {,} __buf {,} __n {,} __offset {)} ENDNATIVE !!SSIZE_T

/* Create a one-way communication channel (pipe).
   If successful, two file descriptors are stored in PIPEDES;
   bytes written on PIPEDES[1] can be read from PIPEDES[0].
   Returns 0 if successful, -1 if not.  */
NATIVE {pipe} PROC
PROC pipe(__pipedes:ARRAY OF LONG) IS NATIVE {pipe(} __pipedes {)} ENDNATIVE !!LONG

/* Same as pipe but apply flags passed in FLAGS to the new file
   descriptors.  */
NATIVE {pipe2} PROC
PROC pipe2(__pipedes:ARRAY OF LONG, __flags:LONG) IS NATIVE {pipe2(} __pipedes {,} __flags {)} ENDNATIVE !!LONG

/* Schedule an alarm.  In SECONDS seconds, the process will get a SIGALRM.
   If SECONDS is zero, any currently scheduled alarm will be cancelled.
   The function returns the number of seconds remaining until the last
   alarm scheduled would have signaled, or zero if there wasn't one.
   There is no return value to indicate an error, but you can set `errno'
   to 0 and check its value after calling `alarm', and this might tell you.
   The signal may come late due to processor scheduling.  */
NATIVE {alarm} PROC
PROC alarm(__seconds:ULONG) IS NATIVE {alarm(} __seconds {)} ENDNATIVE !!ULONG

/* Make the process sleep for SECONDS seconds, or until a signal arrives
   and is not ignored.  The function returns the number of seconds less
   than SECONDS which it actually slept (thus zero if it slept the full time).
   If a signal handler does a `longjmp' or modifies the handling of the
   SIGALRM signal while inside `sleep' call, the handling of the SIGALRM
   signal afterwards is undefined.  There is no return value to indicate
   error, but if `sleep' returns SECONDS, it probably didn't work.

   This function is a cancellation point and therefore not marked with
   __THROW.  */
NATIVE {sleep} PROC
PROC sleep(__seconds:ULONG) IS NATIVE {sleep(} __seconds {)} ENDNATIVE !!ULONG

/* Set an alarm to go off (generating a SIGALRM signal) in LONG
   microseconds.  If INTERVAL is nonzero, when the alarm goes off, the
   timer is reset to go off every INTERVAL microseconds thereafter.
   Returns the number of microseconds remaining before the alarm.  */
NATIVE {ualarm} PROC
PROC ualarm(__value:USECONDS_T__, __interval:USECONDS_T__) IS NATIVE {ualarm(} __value {,} __interval {)} ENDNATIVE !!USECONDS_T__

/* Sleep USECONDS microseconds, or until a signal arrives that is not blocked
   or ignored.

   This function is a cancellation point and therefore not marked with
   __THROW.  */
NATIVE {usleep} PROC
PROC usleep(__useconds:USECONDS_T__) IS NATIVE {usleep(} __useconds {)} ENDNATIVE !!LONG


/* Suspend the process until a signal arrives.
   This always returns -1 and sets `errno' to EINTR.

   This function is a cancellation point and therefore not marked with
   __THROW.  */
NATIVE {pause} PROC
PROC pause() IS NATIVE {pause()} ENDNATIVE !!LONG


/* Change the owner and group of FILE.  */
NATIVE {chown} PROC
PROC chown(__file:ARRAY OF CHAR, __owner:UID_T__, __group:GID_T__) IS NATIVE {chown(} __file {,} __owner {,} __group {)} ENDNATIVE !!LONG

/* Change the owner and group of the file that FD is open on.  */
NATIVE {fchown} PROC
PROC fchown(__fd:VALUE, __owner:UID_T__, __group:GID_T__) IS NATIVE {fchown(} __fd {,} __owner {,} __group {)} ENDNATIVE !!LONG


/* Change owner and group of FILE, if it is a symbolic
   link the ownership of the symbolic link is changed.  */
NATIVE {lchown} PROC
PROC lchown(__file:ARRAY OF CHAR, __owner:UID_T__, __group:GID_T__) IS NATIVE {lchown(} __file {,} __owner {,} __group {)} ENDNATIVE !!LONG


/* Change the owner and group of FILE relative to the directory FD is open
   on.  */
NATIVE {fchownat} PROC
PROC fchownat(__fd:VALUE, __file:ARRAY OF CHAR, __owner:UID_T__,
		     __group:GID_T__, __flag:LONG) IS NATIVE {fchownat(} __fd {,} __file {,} __owner {,} __group {,} __flag {)} ENDNATIVE !!LONG

/* Change the process's working directory to PATH.  */
NATIVE {chdir} PROC
PROC chdir(__path:ARRAY OF CHAR) IS NATIVE {chdir(} __path {)} ENDNATIVE !!LONG

/* Change the process's working directory to the one FD is open on.  */
NATIVE {fchdir} PROC
PROC fchdir(__fd:VALUE) IS NATIVE {fchdir(} __fd {)} ENDNATIVE !!LONG

/* Get the pathname of the current working directory,
   and put it in SIZE bytes of BUF.  Returns NULL if the
   directory couldn't be determined or SIZE was too small.
   If successful, returns BUF.  In GNU, if BUF is NULL,
   an array is allocated with `malloc'; the array is SIZE
   bytes long, unless SIZE == 0, in which case it is as
   big as necessary.  */
NATIVE {getcwd} PROC
PROC getcwd(__buf:ARRAY OF CHAR, __size:SIZE_T) IS NATIVE {getcwd(} __buf {,} __size {)} ENDNATIVE !!ARRAY OF CHAR

/* Return a malloc'd string containing the current directory name.
   If the environment variable `PWD' is set, and its value is correct,
   that value is used.  */
NATIVE {get_current_dir_name} PROC
PROC get_current_dir_name() IS NATIVE {get_current_dir_name()} ENDNATIVE !!ARRAY OF CHAR

/* Put the absolute pathname of the current working directory in BUF.
   If successful, return BUF.  If not, put an error message in
   BUF and return NULL.  BUF should be at least PATH_MAX bytes long.  */
NATIVE {getwd} PROC
->PROC getwd(__buf:ARRAY OF CHAR) IS NATIVE {getwd(} __buf {)} ENDNATIVE !!ARRAY OF CHAR


/* Duplicate FD, returning a new file descriptor on the same file.  */
NATIVE {dup} PROC
PROC dup(__fd:VALUE) IS NATIVE {dup(} __fd {)} ENDNATIVE !!LONG

/* Duplicate FD to FD2, closing FD2 and making it open on the same file.  */
NATIVE {dup2} PROC
PROC dup2(__fd:VALUE, __fd2:LONG) IS NATIVE {dup2(} __fd {,} __fd2 {)} ENDNATIVE !!LONG

/* Duplicate FD to FD2, closing FD2 and making it open on the same
   file while setting flags according to FLAGS.  */
NATIVE {dup3} PROC
PROC dup3(__fd:VALUE, __fd2:LONG, __flags:LONG) IS NATIVE {dup3(} __fd {,} __fd2 {,} __flags {)} ENDNATIVE !!LONG

/* NULL-terminated array of "NAME=LONG" environment variables.  */
->NATIVE {__environ} DEF
NATIVE {environ} DEF


/* Replace the current process, executing PATH with arguments ARGV and
   environment ENVP.  ARGV and ENVP are terminated by NULL pointers.  */
NATIVE {execve} PROC
PROC execve(__path:ARRAY OF CHAR, __argv:ARRAY OF ARRAY OF CHAR,
		   __envp:ARRAY OF ARRAY OF CHAR) IS NATIVE {execve(} __path {,} __argv {,} __envp {)} ENDNATIVE !!LONG

/* Execute the file FD refers to, overlaying the running program image.
   ARGV and ENVP are passed to the new program, as for `execve'.  */
NATIVE {fexecve} PROC
PROC fexecve(__fd:VALUE, __argv:ARRAY OF ARRAY OF CHAR, __envp:ARRAY OF ARRAY OF CHAR) IS NATIVE {fexecve(} __fd {,} __argv {,} __envp {)} ENDNATIVE !!LONG


/* Execute PATH with arguments ARGV and environment from `environ'.  */
NATIVE {execv} PROC
PROC execv(__path:ARRAY OF CHAR, __argv:ARRAY OF ARRAY OF CHAR) IS NATIVE {execv(} __path {,} __argv {)} ENDNATIVE !!LONG

/* Execute PATH with all arguments after PATH until a NULL pointer,
   and the argument after that for environment.  */
NATIVE {execle} PROC
PROC execle(__path:ARRAY OF CHAR, __arg:ARRAY OF CHAR, __arg2=0:ULONG, ...) IS NATIVE {execle(} __path {,} __arg {,} __arg2 {,} ... {)} ENDNATIVE !!LONG

/* Execute PATH with all arguments after PATH until
   a NULL pointer and environment from `environ'.  */
NATIVE {execl} PROC
PROC execl(__path:ARRAY OF CHAR, __arg:ARRAY OF CHAR, __arg2=0:ULONG, ...) IS NATIVE {execl(} __path {,} __arg {,} __arg2 {,} ... {)} ENDNATIVE !!LONG

/* Execute FILE, searching in the `PATH' environment variable if it contains
   no slashes, with arguments ARGV and environment from `environ'.  */
NATIVE {execvp} PROC
PROC execvp(__file:ARRAY OF CHAR, __argv:ARRAY OF ARRAY OF CHAR) IS NATIVE {execvp(} __file {,} __argv {)} ENDNATIVE !!LONG

/* Execute FILE, searching in the `PATH' environment variable if
   it contains no slashes, with all arguments after FILE until a
   NULL pointer and environment from `environ'.  */
NATIVE {execlp} PROC
PROC execlp(__file:ARRAY OF CHAR, __arg:ARRAY OF CHAR, __arg2=0:ULONG, ...) IS NATIVE {execlp(} __file {,} __arg {,} __arg2 {,} ... {)} ENDNATIVE !!LONG

/* Execute FILE, searching in the `PATH' environment variable if it contains
   no slashes, with arguments ARGV and environment from `environ'.  */
NATIVE {execvpe} PROC
PROC execvpe(__file:ARRAY OF CHAR, __argv:ARRAY OF ARRAY OF CHAR,
		    __envp:ARRAY OF ARRAY OF CHAR) IS NATIVE {execvpe(} __file {,} __argv {,} __envp {)} ENDNATIVE !!LONG


/* Add INC to priority of the current process.  */
NATIVE {nice} PROC
PROC nice(__inc:LONG) IS NATIVE {nice(} __inc {)} ENDNATIVE !!LONG


/* Terminate program execution with the low-order 8 bits of STATUS.  */
NATIVE {_exit} PROC
PROC _exit(__status:LONG) IS NATIVE {_exit(} __status {)} ENDNATIVE



/* Get file-specific configuration information about PATH.  */
NATIVE {pathconf} PROC
PROC pathconf(__path:ARRAY OF CHAR, __name:LONG) IS NATIVE {pathconf(} __path {,} __name {)} ENDNATIVE !!CLONG

/* Get file-specific configuration about descriptor FD.  */
NATIVE {fpathconf} PROC
PROC fpathconf(__fd:VALUE, __name:LONG) IS NATIVE {fpathconf(} __fd {,} __name {)} ENDNATIVE !!CLONG

/* Get the value of the system variable NAME.  */
NATIVE {sysconf} PROC
PROC sysconf(__name:LONG) IS NATIVE {sysconf(} __name {)} ENDNATIVE !!CLONG

/* Get the value of the string-valued system variable NAME.  */
NATIVE {confstr} PROC
PROC confstr(__name:LONG, __buf:ARRAY OF CHAR, __len:SIZE_T) IS NATIVE {confstr(} __name {,} __buf {,} __len {)} ENDNATIVE !!SIZE_T


/* Get the process ID of the calling process.  */
NATIVE {getpid} PROC
PROC getpid() IS NATIVE {getpid()} ENDNATIVE !!PID_T__

/* Get the process ID of the calling process's parent.  */
NATIVE {getppid} PROC
PROC getppid() IS NATIVE {getppid()} ENDNATIVE !!PID_T__

/* Get the process group ID of the calling process.  */
NATIVE {getpgrp} PROC
PROC getpgrp() IS NATIVE {getpgrp()} ENDNATIVE !!PID_T__

/* Get the process group ID of process PID.  */
->NATIVE {__getpgid} PROC
PROC __getpgid(__pid:PID_T__) IS NATIVE {__getpgid(} __pid {)} ENDNATIVE !!PID_T__
NATIVE {getpgid} PROC
PROC getpgid(__pid:PID_T__) IS NATIVE {getpgid(} __pid {)} ENDNATIVE !!PID_T__


/* Set the process group ID of the process matching PID to PGID.
   If PID is zero, the current process's process group ID is set.
   If PGID is zero, the process ID of the process is used.  */
NATIVE {setpgid} PROC
PROC setpgid(__pid:PID_T__, __pgid:PID_T__) IS NATIVE {setpgid(} __pid {,} __pgid {)} ENDNATIVE !!LONG

/* Both System V and BSD have `setpgrp' functions, but with different
   calling conventions.  The BSD function is the same as POSIX.1 `setpgid'
   (above).  The System V function takes no arguments and puts the calling
   process in its on group like `setpgid (0, 0)'.

   New programs should always use `setpgid' instead.

   GNU provides the POSIX.1 function.  */

/* Set the process group ID of the calling process to its own PID.
   This is exactly the same as `setpgid (0, 0)'.  */
NATIVE {setpgrp} PROC
PROC setpgrp() IS NATIVE {setpgrp()} ENDNATIVE !!LONG


/* Create a new session with the calling process as its leader.
   The process group IDs of the session and the calling process
   are set to the process ID of the calling process, which is returned.  */
NATIVE {setsid} PROC
PROC setsid() IS NATIVE {setsid()} ENDNATIVE !!PID_T__

/* Return the session ID of the given process.  */
NATIVE {getsid} PROC
PROC getsid(__pid:PID_T__) IS NATIVE {getsid(} __pid {)} ENDNATIVE !!PID_T__

/* Get the real user ID of the calling process.  */
NATIVE {getuid} PROC
PROC getuid() IS NATIVE {getuid()} ENDNATIVE !!UID_T__

/* Get the effective user ID of the calling process.  */
NATIVE {geteuid} PROC
PROC geteuid() IS NATIVE {geteuid()} ENDNATIVE !!UID_T__

/* Get the real group ID of the calling process.  */
NATIVE {getgid} PROC
PROC getgid() IS NATIVE {getgid()} ENDNATIVE !!GID_T__

/* Get the effective group ID of the calling process.  */
NATIVE {getegid} PROC
PROC getegid() IS NATIVE {getegid()} ENDNATIVE !!GID_T__

/* If SIZE is zero, return the number of supplementary groups
   the calling process is in.  Otherwise, fill in the group IDs
   of its supplementary groups in LIST and return the number written.  */
NATIVE {getgroups} PROC
PROC getgroups(__size:LONG, __list:ARRAY OF GID_T__) IS NATIVE {getgroups(} __size {,} __list {)} ENDNATIVE !!LONG

/* Return nonzero iff the calling process is in group GID.  */
NATIVE {group_member} PROC
PROC group_member(__gid:GID_T__) IS NATIVE {group_member(} __gid {)} ENDNATIVE !!LONG

/* Set the user ID of the calling process to UID.
   If the calling process is the super-user, set the real
   and effective user IDs, and the saved set-user-ID to UID;
   if not, the effective user ID is set to UID.  */
NATIVE {setuid} PROC
PROC setuid(__uid:UID_T__) IS NATIVE {setuid(} __uid {)} ENDNATIVE !!LONG

/* Set the real user ID of the calling process to RUID,
   and the effective user ID of the calling process to EUID.  */
NATIVE {setreuid} PROC
PROC setreuid(__ruid:UID_T__, __euid:UID_T__) IS NATIVE {setreuid(} __ruid {,} __euid {)} ENDNATIVE !!LONG

/* Set the effective user ID of the calling process to UID.  */
NATIVE {seteuid} PROC
PROC seteuid(__uid:UID_T__) IS NATIVE {seteuid(} __uid {)} ENDNATIVE !!LONG

/* Set the group ID of the calling process to GID.
   If the calling process is the super-user, set the real
   and effective group IDs, and the saved set-group-ID to GID;
   if not, the effective group ID is set to GID.  */
NATIVE {setgid} PROC
PROC setgid(__gid:GID_T__) IS NATIVE {setgid(} __gid {)} ENDNATIVE !!LONG

/* Set the real group ID of the calling process to RGID,
   and the effective group ID of the calling process to EGID.  */
NATIVE {setregid} PROC
PROC setregid(__rgid:GID_T__, __egid:GID_T__) IS NATIVE {setregid(} __rgid {,} __egid {)} ENDNATIVE !!LONG

/* Set the effective group ID of the calling process to GID.  */
NATIVE {setegid} PROC
PROC setegid(__gid:GID_T__) IS NATIVE {setegid(} __gid {)} ENDNATIVE !!LONG

/* Fetch the real user ID, effective user ID, and saved-set user ID,
   of the calling process.  */
NATIVE {getresuid} PROC
PROC getresuid(__ruid:PTR TO UID_T__, __euid:PTR TO UID_T__, __suid:PTR TO UID_T__) IS NATIVE {getresuid(} __ruid {,} __euid {,} __suid {)} ENDNATIVE !!LONG

/* Fetch the real group ID, effective group ID, and saved-set group ID,
   of the calling process.  */
NATIVE {getresgid} PROC
PROC getresgid(__rgid:PTR TO GID_T__, __egid:PTR TO GID_T__, __sgid:PTR TO GID_T__) IS NATIVE {getresgid(} __rgid {,} __egid {,} __sgid {)} ENDNATIVE !!LONG

/* Set the real user ID, effective user ID, and saved-set user ID,
   of the calling process to RUID, EUID, and SUID, respectively.  */
NATIVE {setresuid} PROC
PROC setresuid(__ruid:UID_T__, __euid:UID_T__, __suid:UID_T__) IS NATIVE {setresuid(} __ruid {,} __euid {,} __suid {)} ENDNATIVE !!LONG

/* Set the real group ID, effective group ID, and saved-set group ID,
   of the calling process to RGID, EGID, and SGID, respectively.  */
NATIVE {setresgid} PROC
PROC setresgid(__rgid:GID_T__, __egid:GID_T__, __sgid:GID_T__) IS NATIVE {setresgid(} __rgid {,} __egid {,} __sgid {)} ENDNATIVE !!LONG


/* Clone the calling process, creating an exact copy.
   Return -1 for errors, 0 to the new process,
   and the process ID of the new process to the old process.  */
NATIVE {fork} PROC
PROC fork() IS NATIVE {fork()} ENDNATIVE !!PID_T__

/* Clone the calling process, but without copying the whole address space.
   The calling process is suspended until the new process exits or is
   replaced by a call to `execve'.  Return -1 for errors, 0 to the new process,
   and the process ID of the new process to the old process.  */
NATIVE {vfork} PROC
PROC vfork() IS NATIVE {vfork()} ENDNATIVE !!PID_T__


/* Return the pathname of the terminal FD is open on, or NULL on errors.
   The returned storage is good only until the next call to this function.  */
NATIVE {ttyname} PROC
PROC ttyname(__fd:VALUE) IS NATIVE {ttyname(} __fd {)} ENDNATIVE !!ARRAY OF CHAR

/* Store at most BUFLEN characters of the pathname of the terminal FD is
   open on in BUF.  Return 0 on success, otherwise an error number.  */
NATIVE {ttyname_r} PROC
PROC ttyname_r(__fd:VALUE, __buf:ARRAY OF CHAR, __buflen:SIZE_T) IS NATIVE {ttyname_r(} __fd {,} __buf {,} __buflen {)} ENDNATIVE !!LONG

/* Return 1 if FD is a valid descriptor associated
   with a terminal, zero if not.  */
NATIVE {isatty} PROC
PROC isatty(__fd:VALUE) IS NATIVE {isatty(} __fd {)} ENDNATIVE !!LONG

/* Return the index into the active-logins file (utmp) for
   the controlling terminal.  */
NATIVE {ttyslot} PROC
PROC ttyslot() IS NATIVE {ttyslot()} ENDNATIVE !!LONG


/* Make a link to FROM named TO.  */
NATIVE {link} PROC
PROC link(__from:ARRAY OF CHAR, __to:ARRAY OF CHAR) IS NATIVE {link(} __from {,} __to {)} ENDNATIVE !!LONG

/* Like link but relative paths in TO and FROM are interpreted relative
   to FROMFD and TOFD respectively.  */
NATIVE {linkat} PROC
PROC linkat(__fromfd:VALUE, __from:ARRAY OF CHAR, __tofd:VALUE,
		   __to:ARRAY OF CHAR, __flags:LONG) IS NATIVE {linkat(} __fromfd {,} __from {,} __tofd {,} __to {,} __flags {)} ENDNATIVE !!LONG

/* Make a symbolic link to FROM named TO.  */
NATIVE {symlink} PROC
PROC symlink(__from:ARRAY OF CHAR, __to:ARRAY OF CHAR) IS NATIVE {symlink(} __from {,} __to {)} ENDNATIVE !!LONG

/* Read the contents of the symbolic link PATH into no more than
   LEN bytes of BUF.  The contents are not null-terminated.
   Returns the number of characters read, or -1 for errors.  */
NATIVE {readlink} PROC
PROC readlink(__path:ARRAY OF CHAR,
			 __buf:ARRAY OF CHAR, __len:SIZE_T) IS NATIVE {readlink(} __path {,} __buf {,} __len {)} ENDNATIVE !!SSIZE_T

/* Like symlink but a relative path in TO is interpreted relative to TOFD.  */
NATIVE {symlinkat} PROC
PROC symlinkat(__from:ARRAY OF CHAR, __tofd:VALUE,
		      __to:ARRAY OF CHAR) IS NATIVE {symlinkat(} __from {,} __tofd {,} __to {)} ENDNATIVE !!LONG

/* Like readlink but a relative PATH is interpreted relative to FD.  */
NATIVE {readlinkat} PROC
PROC readlinkat(__fd:VALUE, __path:ARRAY OF CHAR,
			   __buf:ARRAY OF CHAR, __len:SIZE_T) IS NATIVE {readlinkat(} __fd {,} __path {,} __buf {,} __len {)} ENDNATIVE !!SSIZE_T

/* Remove the link NAME.  */
NATIVE {unlink} PROC
PROC unlink(__name:ARRAY OF CHAR) IS NATIVE {unlink(} __name {)} ENDNATIVE !!LONG

/* Remove the link NAME relative to FD.  */
NATIVE {unlinkat} PROC
PROC unlinkat(__fd:VALUE, __name:ARRAY OF CHAR, __flag:LONG) IS NATIVE {unlinkat(} __fd {,} __name {,} __flag {)} ENDNATIVE !!LONG

/* Remove the directory PATH.  */
NATIVE {rmdir} PROC
PROC rmdir(__path:ARRAY OF CHAR) IS NATIVE {rmdir(} __path {)} ENDNATIVE !!LONG


/* Return the foreground process group ID of FD.  */
NATIVE {tcgetpgrp} PROC
PROC tcgetpgrp(__fd:VALUE) IS NATIVE {tcgetpgrp(} __fd {)} ENDNATIVE !!PID_T__

/* Set the foreground process group ID of FD set PGRP_ID.  */
NATIVE {tcsetpgrp} PROC
PROC tcsetpgrp(__fd:VALUE, __pgrp_id:PID_T__) IS NATIVE {tcsetpgrp(} __fd {,} __pgrp_id {)} ENDNATIVE !!LONG


/* Return the login name of the user.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
NATIVE {getlogin} PROC
PROC getlogin() IS NATIVE {getlogin()} ENDNATIVE !!ARRAY OF CHAR
/* Return at most NAME_LEN characters of the login name of the user in NAME.
   If it cannot be determined or some other error occurred, return the error
   code.  Otherwise return 0.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
NATIVE {getlogin_r} PROC
PROC getlogin_r(__name:ARRAY OF CHAR, __name_len:SIZE_T) IS NATIVE {getlogin_r(} __name {,} __name_len {)} ENDNATIVE !!LONG

/* Set the login name returned by `getlogin'.  */
NATIVE {setlogin} PROC
->PROC setlogin(__name:ARRAY OF CHAR) IS NATIVE {setlogin(} __name {)} ENDNATIVE !!LONG




/* Put the name of the current host in no more than LEN bytes of NAME.
   The result is null-terminated if LEN is large enough for the full
   name and the terminator.  */
NATIVE {gethostname} PROC
PROC gethostname(__name:ARRAY OF CHAR, __len:SIZE_T) IS NATIVE {gethostname(} __name {,} __len {)} ENDNATIVE !!LONG


/* Set the name of the current host to NAME, which is LEN bytes long.
   This call is restricted to the super-user.  */
NATIVE {sethostname} PROC
PROC sethostname(__name:ARRAY OF CHAR, __len:SIZE_T) IS NATIVE {sethostname(} __name {,} __len {)} ENDNATIVE !!LONG

/* Set the current machine's Internet number to ID.
   This call is restricted to the super-user.  */
NATIVE {sethostid} PROC
PROC sethostid(__id:CLONG) IS NATIVE {sethostid(} __id {)} ENDNATIVE !!LONG


/* Get and set the NIS (aka YP) domain name, if any.
   Called just like `gethostname' and `sethostname'.
   The NIS domain name is usually the empty string when not using NIS.  */
NATIVE {getdomainname} PROC
PROC getdomainname(__name:ARRAY OF CHAR, __len:SIZE_T) IS NATIVE {getdomainname(} __name {,} __len {)} ENDNATIVE !!LONG
NATIVE {setdomainname} PROC
PROC setdomainname(__name:ARRAY OF CHAR, __len:SIZE_T) IS NATIVE {setdomainname(} __name {,} __len {)} ENDNATIVE !!LONG


/* Revoke access permissions to all processes currently communicating
   with the control terminal, and then send a SIGHUP signal to the process
   group of the control terminal.  */
NATIVE {vhangup} PROC
PROC vhangup() IS NATIVE {vhangup()} ENDNATIVE !!LONG

/* Revoke the access of all descriptors currently open on FILE.  */
NATIVE {revoke} PROC
->PROC revoke(__file:ARRAY OF CHAR) IS NATIVE {revoke(} __file {)} ENDNATIVE !!LONG


/* Enable statistical profiling, writing samples of the PC into at most
   SIZE bytes of SAMPLE_BUFFER; every processor clock tick while profiling
   is enabled, the system examines the user PC and increments
   SAMPLE_BUFFER[((PC - OFFSET) / 2) * SCALE / 65536].  If SCALE is zero,
   disable profiling.  Returns zero on success, -1 on error.  */
NATIVE {profil} PROC
PROC profil(__sample_buffer:PTR TO UINT, __size:SIZE_T,
		   __offset:SIZE_T, __scale:ULONG) IS NATIVE {profil(} __sample_buffer {,} __size {,} __offset {,} __scale {)} ENDNATIVE !!LONG


/* Turn accounting on if NAME is an existing file.  The system will then write
   a record for each process as it terminates, to this file.  If NAME is NULL,
   turn accounting off.  This call is restricted to the super-user.  */
NATIVE {acct} PROC
PROC acct(__name:ARRAY OF CHAR) IS NATIVE {acct(} __name {)} ENDNATIVE !!LONG


/* Successive calls return the shells listed in `/etc/shells'.  */
NATIVE {getusershell} PROC
PROC getusershell() IS NATIVE {getusershell()} ENDNATIVE !!ARRAY OF CHAR
NATIVE {endusershell} PROC
PROC endusershell() IS NATIVE {endusershell()} ENDNATIVE /* Discard cached info.  */
NATIVE {setusershell} PROC
PROC setusershell() IS NATIVE {setusershell()} ENDNATIVE /* Rewind and re-read the file.  */


/* Put the program in the background, and dissociate from the controlling
   terminal.  If NOCHDIR is zero, do `chdir ("/")'.  If NOCLOSE is zero,
   redirects stdin, stdout, and stderr to /dev/null.  */
NATIVE {daemon} PROC
PROC daemon(__nochdir:LONG, __noclose:LONG) IS NATIVE {daemon(} __nochdir {,} __noclose {)} ENDNATIVE !!LONG


/* Make PATH be the root directory (the starting point for absolute paths).
   This call is restricted to the super-user.  */
NATIVE {chroot} PROC
PROC chroot(__path:ARRAY OF CHAR) IS NATIVE {chroot(} __path {)} ENDNATIVE !!LONG

/* Prompt with PROMPT and read a string from the terminal without echoing.
   Uses /dev/tty if possible; otherwise stderr and stdin.  */
NATIVE {getpass} PROC
PROC getpass(__prompt:ARRAY OF CHAR) IS NATIVE {getpass(} __prompt {)} ENDNATIVE !!ARRAY OF CHAR


/* Make all changes done to FD actually appear on disk.

   This function is a cancellation point and therefore not marked with
   __THROW.  */
NATIVE {fsync} PROC
PROC fsync(__fd:VALUE) IS NATIVE {fsync(} __fd {)} ENDNATIVE !!LONG


/* Make all changes done to all files on the file system associated
   with FD actually appear on disk.  */
NATIVE {syncfs} PROC
PROC syncfs(__fd:VALUE) IS NATIVE {syncfs(} __fd {)} ENDNATIVE !!LONG



/* Return identifier for the current host.  */
NATIVE {gethostid} PROC
PROC gethostid() IS NATIVE {gethostid()} ENDNATIVE !!CLONG

/* Make all changes done to all files actually appear on disk.  */
NATIVE {sync} PROC
PROC sync() IS NATIVE {sync()} ENDNATIVE


/* Return the number of bytes in a page.  This is the system's page size,
   which is not necessarily the same as the hardware page size.  */
NATIVE {getpagesize} PROC
PROC getpagesize() IS NATIVE {getpagesize()} ENDNATIVE !!LONG


/* Return the maximum number of file descriptors
   the current process could possibly have.  */
NATIVE {getdtablesize} PROC
PROC getdtablesize() IS NATIVE {getdtablesize()} ENDNATIVE !!LONG




/* Truncate FILE to LENGTH bytes.  */
NATIVE {truncate} PROC
PROC truncate(__file:ARRAY OF CHAR, __length:OFF_T__) IS NATIVE {truncate(} __file {,} __length {)} ENDNATIVE !!LONG
NATIVE {truncate64} PROC
PROC truncate64(__file:ARRAY OF CHAR, __length:OFF64_T__) IS NATIVE {truncate64(} __file {,} __length {)} ENDNATIVE !!LONG



/* Truncate the file FD is open on to LENGTH bytes.  */
NATIVE {ftruncate} PROC
PROC ftruncate(__fd:VALUE, __length:OFF_T__) IS NATIVE {ftruncate(} __fd {,} __length {)} ENDNATIVE !!LONG
NATIVE {ftruncate64} PROC
PROC ftruncate64(__fd:VALUE, __length:OFF64_T__) IS NATIVE {ftruncate64(} __fd {,} __length {)} ENDNATIVE !!LONG




/* Set the end of accessible data space (aka "the break") to ADDR.
   Returns zero on success and -1 for errors (with errno set).  */
NATIVE {brk} PROC
PROC brk(__addr:PTR) IS NATIVE {brk(} __addr {)} ENDNATIVE !!LONG

/* Increase or decrease the end of accessible data space by DELTA bytes.
   If successful, returns the address the previous end of data space
   (i.e. the beginning of the new space, if DELTA > 0);
   returns (void *) -1 for errors (with errno set).  */
NATIVE {sbrk} PROC
PROC sbrk(__delta:INTPTR_T) IS NATIVE {sbrk(} __delta {)} ENDNATIVE !!PTR


/* Invoke `system call' number SYSNO, passing it the remaining arguments.
   This is completely system-dependent, and not often useful.

   In Unix, `syscall' sets `errno' for all errors and most calls return -1
   for errors; in many systems you cannot pass arguments or get return
   values for all system calls (`pipe', `fork', and `getppid' typically
   among them).

   In Mach, all system calls take normal arguments and always return an
   error code (zero for success).  */
NATIVE {syscall} PROC
PROC syscall(__sysno:CLONG, __sysno2=0:UCLONG, ...) IS NATIVE {syscall(} __sysno {,} __sysno2 {,} ... {)} ENDNATIVE !!CLONG



/* NOTE: These declarations also appear in <fcntl.h>; be sure to keep both
   files consistent.  Some systems have them there and some here, and some
   software depends on the macros being defined without including both.  */

/* `lockf' is a simpler interface to the locking facilities of `fcntl'.
   LEN is always relative to the current file position.
   The CMD argument is one of the following.

   This function is a cancellation point and therefore not marked with
   __THROW.  */

/*
 NATIVE {F_ULOCK} CONST F_ULOCK = 0	/* Unlock a previously locked region.  */
 NATIVE {F_LOCK}  CONST F_LOCK  = 1	/* Lock a region for exclusive use.  */
 NATIVE {F_TLOCK} CONST F_TLOCK = 2	/* Test and lock a region for exclusive use.  */
 NATIVE {F_TEST}  CONST F_TEST  = 3	/* Test a region for other processes locks.  */
*/

/*
NATIVE {lockf} PROC
PROC lockf(__fd:VALUE, __cmd:LONG, __len:OFF_T__) IS NATIVE {lockf(} __fd {,} __cmd {,} __len {)} ENDNATIVE !!LONG
NATIVE {lockf64} PROC
PROC lockf64(__fd:VALUE, __cmd:LONG, __len:OFF64_T__) IS NATIVE {lockf64(} __fd {,} __cmd {,} __len {)} ENDNATIVE !!LONG
*/



/* Evaluate EXPRESSION, and repeat as long as it returns -1 with `errno'
   set to EINTR.  */

 NATIVE {TEMP_FAILURE_RETRY} CONST	->define TEMP_FAILURE_RETRY(expression) ...

/* Copy LENGTH bytes from INFD to OUTFD.  */
NATIVE {copy_file_range} PROC
PROC copy_file_range(__infd:VALUE, __pinoff:PTR TO OFF64_T__, __outfd:VALUE, __poutoff:PTR TO OFF64_T__, __length:SIZE_T, __flags:UINT) IS NATIVE {copy_file_range(} __infd {,} __pinoff {,} __outfd {,} __poutoff {,} __length {, (unsigned int) } __flags {)} ENDNATIVE !!SSIZE_T

/* Synchronize at least the data part of a file with the underlying
   media.  */
NATIVE {fdatasync} PROC
PROC fdatasync(__fildes:LONG) IS NATIVE {fdatasync(} __fildes {)} ENDNATIVE !!LONG

/* One-way hash PHRASE, returning a string suitable for storage in the
   user database.  SALT selects the one-way function to use, and
   ensures that no two users' hashes are the same, even if they use
   the same passphrase.  The return value points to static storage
   which will be overwritten by the next call to crypt.  */
NATIVE {crypt} PROC
->PROC crypt(__key:ARRAY OF CHAR, __salt:ARRAY OF CHAR) IS NATIVE {crypt(} __key {,} __salt {)} ENDNATIVE !!ARRAY OF CHAR

/* Swab pairs bytes in the first N bytes of the area pointed to by
   FROM and copy the result to TO.  The value of TO must not be in the
   range [FROM - N + 1, FROM - 1].  If N is odd the first byte in FROM
   is without partner.  */
NATIVE {swab} PROC
PROC swab(__from:PTR, __to:PTR,
		  __n:SSIZE_T) IS NATIVE {swab(} __from {,} __to {,} __n {)} ENDNATIVE


/* Prior to Issue 6, the Single Unix Specification required these
   prototypes to appear in this header.  They are also found in
   <stdio.h>.  */
/*
#if defined __USE_XOPEN && !defined __USE_XOPEN2K
/* Return the name of the controlling terminal.  */
NATIVE {ctermid} PROC
PROC ctermid(__s:ARRAY OF CHAR) IS NATIVE {ctermid(} __s {)} ENDNATIVE !!ARRAY OF CHAR

/* Return the name of the current user.  */
NATIVE {cuserid} PROC
PROC cuserid(__s:ARRAY OF CHAR) IS NATIVE {cuserid(} __s {)} ENDNATIVE !!ARRAY OF CHAR
#endif
*/


/* Unix98 requires this function to be declared here.  In other
   standards it is in <pthread.h>.  */
/*
#if defined __USE_UNIX98 && !defined __USE_XOPEN2K
NATIVE {pthread_atfork} PROC
PROC pthread_atfork(__prepare:PTR /*void (*__prepare) (void)*/,
			   __parent:PTR /*void (*__parent) (void)*/,
			   __child:PTR /*void (*__child) (void)*/) IS NATIVE {pthread_atfork( (void (*)()) } __prepare {, (void (*)()) } __parent {, (void (*)()) } __child {)} ENDNATIVE !!LONG
#endif
*/

/* Write LENGTH bytes of randomness starting at BUFFER.  Return 0 on
   success or -1 on error.  */
NATIVE {getentropy} PROC
PROC getentropy(__buffer:PTR, __length:SIZE_T) IS NATIVE {getentropy(} __buffer {,} __length {)} ENDNATIVE !!LONG

/* Define some macros helping to catch buffer overflows.  */
/*
#if __USE_FORTIFY_LEVEL > 0 && defined __fortify_function
 MODULE 'target/bits/unistd'
#endif
*/
