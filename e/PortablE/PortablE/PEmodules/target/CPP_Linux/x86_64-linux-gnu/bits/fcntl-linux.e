OPT NATIVE
MODULE 'std/pUnsigned'
MODULE 'target/x86_64-linux-gnu/bits/types'	->guessed
MODULE 'target/stddef'	->guessed
MODULE 'target/x86_64-linux-gnu/bits/types/struct_iovec'
/* Flags for fallocate.  */
MODULE 'target/linux/falloc'
->{#include <x86_64-linux-gnu/bits/fcntl-linux.h>}
/* O_*, F_*, FD_* bit values for Linux.
   Copyright (C) 2001-2020 Free Software Foundation, Inc.
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

/* This file contains shared definitions between Linux architectures
   and is included by <bits/fcntl.h> to declare them.  The various
   #ifndef cases allow the architecture specific file to define those
   values with different values.
   A minimal <bits/fcntl.h> contains just:

   struct flock {...}
   #ifdef __USE_LARGEFILE64
   struct flock64 {...}
   #endif
   #include <bits/fcntl-linux.h>
*/

/* open/fcntl.  */
NATIVE {O_ACCMODE}	   CONST O_ACCMODE	   = 0003
NATIVE {O_RDONLY}	     CONST O_RDONLY	     = 00
NATIVE {O_WRONLY}	     CONST O_WRONLY	     = 01
NATIVE {O_RDWR}		     CONST O_RDWR		     = 02
 NATIVE {O_CREAT}	   CONST O_CREAT	   = 0100	/* Not fcntl.  */
 NATIVE {O_EXCL}		   CONST O_EXCL		   = 0200	/* Not fcntl.  */
 NATIVE {O_NOCTTY}	   CONST O_NOCTTY	   = 0400	/* Not fcntl.  */
 NATIVE {O_TRUNC}	  CONST O_TRUNC	  = 01000	/* Not fcntl.  */
 NATIVE {O_APPEND}	  CONST O_APPEND	  = 02000
 NATIVE {O_NONBLOCK}	  CONST O_NONBLOCK	  = 04000
 NATIVE {O_NDELAY}	CONST O_NDELAY	= O_NONBLOCK
 NATIVE {O_SYNC}	       CONST O_SYNC	       = 04010000
NATIVE {O_FSYNC}		CONST O_FSYNC		= O_SYNC
 NATIVE {O_ASYNC}	 CONST O_ASYNC	 = 020000
 NATIVE {__O_LARGEFILE}	CONST O_LARGEFILE__	= 0100000

 NATIVE {__O_DIRECTORY}	CONST O_DIRECTORY__	= 0200000
 NATIVE {__O_NOFOLLOW}	CONST O_NOFOLLOW__	= 0400000
 NATIVE {__O_CLOEXEC}   CONST O_CLOEXEC__   = 02000000
 NATIVE {__O_DIRECT}	 CONST O_DIRECT__	 = 040000
 NATIVE {__O_NOATIME}   CONST O_NOATIME__   = 01000000
 NATIVE {__O_PATH}     CONST O_PATH__     = 010000000
 NATIVE {__O_DSYNC}	 CONST O_DSYNC__	 = 010000
 NATIVE {__O_TMPFILE}   CONST O_TMPFILE__   = (020000000 OR O_DIRECTORY__)

/*
#ifndef F_GETLK
  NATIVE {F_GETLK}	CONST F_GETLK	= 5	/* Get record locking info.  */
  NATIVE {F_SETLK}	CONST F_SETLK	= 6	/* Set record locking info (non-blocking).  */
  NATIVE {F_SETLKW}	CONST F_SETLKW	= 7	/* Set record locking info (blocking).  */
 NATIVE {F_GETLK64}	CONST F_GETLK64	= 12	/* Get record locking info.  */
 NATIVE {F_SETLK64}	CONST F_SETLK64	= 13	/* Set record locking info (non-blocking).  */
 NATIVE {F_SETLKW64}	CONST F_SETLKW64	= 14	/* Set record locking info (blocking).  */
#endif
*/

/* open file description locks.

   Usually record locks held by a process are released on *any* close and are
   not inherited across a fork.

   These cmd values will set locks that conflict with process-associated record
   locks, but are "owned" by the opened file description, not the process.
   This means that they are inherited across fork or clone with CLONE_FILES
   like BSD (flock) locks, and they are only released automatically when the
   last reference to the the file description against which they were acquired
   is put. */
 NATIVE {F_OFD_GETLK}	CONST F_OFD_GETLK	= 36
 NATIVE {F_OFD_SETLK}	CONST F_OFD_SETLK	= 37
 NATIVE {F_OFD_SETLKW}	CONST F_OFD_SETLKW	= 38

 NATIVE {O_LARGEFILE} CONST O_LARGEFILE = O_LARGEFILE__

 NATIVE {O_DIRECTORY}	CONST O_DIRECTORY	= O_DIRECTORY__	/* Must be a directory.  */
 NATIVE {O_NOFOLLOW}	CONST O_NOFOLLOW	= O_NOFOLLOW__	/* Do not follow links.  */
 NATIVE {O_CLOEXEC}	CONST O_CLOEXEC	= O_CLOEXEC__	/* Set close_on_exec.  */

 NATIVE {O_DIRECT}	CONST O_DIRECT	= O_DIRECT__	/* Direct disk access.  */
 NATIVE {O_NOATIME}	CONST O_NOATIME	= O_NOATIME__	/* Do not set atime.  */
 NATIVE {O_PATH}		CONST O_PATH		= O_PATH__	/* Resolve pathname but do not open file.  */
 NATIVE {O_TMPFILE}	CONST O_TMPFILE	= O_TMPFILE__	/* Atomically create nameless file.  */

/* For now, Linux has no separate synchronicity options for read
   operations.  We define O_RSYNC therefore as the same as O_SYNC
   since this is a superset.  */
 NATIVE {O_DSYNC}	CONST O_DSYNC	= O_DSYNC__	/* Synchronize data.  */
  NATIVE {O_RSYNC}	CONST O_RSYNC	= O_SYNC		/* Synchronize read operations.  */

/* Values for the second argument to `fcntl'.  */
NATIVE {F_DUPFD}		CONST F_DUPFD		= 0	/* Duplicate file descriptor.  */
NATIVE {F_GETFD}		CONST F_GETFD		= 1	/* Get file descriptor flags.  */
NATIVE {F_SETFD}		CONST F_SETFD		= 2	/* Set file descriptor flags.  */
NATIVE {F_GETFL}		CONST F_GETFL		= 3	/* Get file status flags.  */
NATIVE {F_SETFL}		CONST F_SETFL		= 4	/* Set file status flags.  */

NATIVE {__F_SETOWN}	CONST F_SETOWN__	= 8
NATIVE {__F_GETOWN}	CONST F_GETOWN__	= 9

 NATIVE {F_SETOWN}	CONST F_SETOWN	= F_SETOWN__ /* Get owner (process receiving SIGIO).  */
 NATIVE {F_GETOWN}	CONST F_GETOWN	= F_GETOWN__ /* Set owner (process receiving SIGIO).  */
 
NATIVE {__F_SETSIG}	CONST F_SETSIG__	= 10	/* Set number of signal to be sent.  */
NATIVE {__F_GETSIG}	CONST F_GETSIG__	= 11	/* Get number of signal to be sent.  */
NATIVE {__F_SETOWN_EX}	CONST F_SETOWN_EX__	= 15	/* Get owner (thread receiving SIGIO).  */
NATIVE {__F_GETOWN_EX}	CONST F_GETOWN_EX__	= 16	/* Set owner (thread receiving SIGIO).  */

 NATIVE {F_SETSIG}	CONST F_SETSIG	= F_SETSIG__	/* Set number of signal to be sent.  */
 NATIVE {F_GETSIG}	CONST F_GETSIG	= F_GETSIG__	/* Get number of signal to be sent.  */
 NATIVE {F_SETOWN_EX}	CONST F_SETOWN_EX	= F_SETOWN_EX__	/* Get owner (thread receiving SIGIO).  */
 NATIVE {F_GETOWN_EX}	CONST F_GETOWN_EX	= F_GETOWN_EX__	/* Set owner (thread receiving SIGIO).  */

 NATIVE {F_SETLEASE}	CONST F_SETLEASE	= 1024	/* Set a lease.  */
 NATIVE {F_GETLEASE}	CONST F_GETLEASE	= 1025	/* Enquire what lease is active.  */
 NATIVE {F_NOTIFY}	CONST F_NOTIFY	= 1026	/* Request notifications on a directory.  */
 NATIVE {F_SETPIPE_SZ}	CONST F_SETPIPE_SZ	= 1031	/* Set pipe page size array.  */
 NATIVE {F_GETPIPE_SZ}	CONST F_GETPIPE_SZ	= 1032	/* Set pipe page size array.  */
 NATIVE {F_ADD_SEALS}	CONST F_ADD_SEALS	= 1033	/* Add seals to file.  */
 NATIVE {F_GET_SEALS}	CONST F_GET_SEALS	= 1034	/* Get seals for file.  */
/* Set / get write life time hints.  */
 NATIVE {F_GET_RW_HINT}	CONST F_GET_RW_HINT	= 1035
 NATIVE {F_SET_RW_HINT}	CONST F_SET_RW_HINT	= 1036
 NATIVE {F_GET_FILE_RW_HINT}	CONST F_GET_FILE_RW_HINT	= 1037
 NATIVE {F_SET_FILE_RW_HINT}	CONST F_SET_FILE_RW_HINT	= 1038
 NATIVE {F_DUPFD_CLOEXEC} CONST F_DUPFD_CLOEXEC = 1030	/* Duplicate file descriptor with
				   close-on-exit set.  */

/* For F_[GET|SET]FD.  */
NATIVE {FD_CLOEXEC}	CONST FD_CLOEXEC	= 1	/* Actually anything with low bit set goes */

/*
#ifndef F_RDLCK
/* For posix fcntl() and `l_type' field of a `struct flock' for lockf().  */
 NATIVE {F_RDLCK}		CONST F_RDLCK		= 0	/* Read lock.  */
 NATIVE {F_WRLCK}		CONST F_WRLCK		= 1	/* Write lock.  */
 NATIVE {F_UNLCK}		CONST F_UNLCK		= 2	/* Remove lock.  */
#endif
*/


/* For old implementation of BSD flock.  */
/*
#ifndef F_EXLCK
 NATIVE {F_EXLCK}		CONST F_EXLCK		= 4	/* or 3 */
 NATIVE {F_SHLCK}		CONST F_SHLCK		= 8	/* or 4 */
#endif
*/

/* Operations for BSD flock, also used by the kernel implementation.  */
 NATIVE {LOCK_SH}	CONST LOCK_SH	= 1	/* Shared lock.  */
 NATIVE {LOCK_EX}	CONST LOCK_EX	= 2	/* Exclusive lock.  */
 NATIVE {LOCK_NB}	CONST LOCK_NB	= 4	/* Or'd with one of the above to prevent
				   blocking.  */
 NATIVE {LOCK_UN}	CONST LOCK_UN	= 8	/* Remove lock.  */

 NATIVE {LOCK_MAND}	CONST LOCK_MAND	= 32	/* This is a mandatory flock:  */
 NATIVE {LOCK_READ}	CONST LOCK_READ	= 64	/* ... which allows concurrent read operations.  */
 NATIVE {LOCK_WRITE}	CONST LOCK_WRITE	= 128	/* ... which allows concurrent write operations.  */
 NATIVE {LOCK_RW}	CONST LOCK_RW	= 192	/* ... Which allows concurrent read & write operations.  */

/* Types of directory notifications that may be requested with F_NOTIFY.  */
 NATIVE {DN_ACCESS}	CONST DN_ACCESS	= $00000001	/* File accessed.  */
 NATIVE {DN_MODIFY}	CONST DN_MODIFY	= $00000002	/* File modified.  */
 NATIVE {DN_CREATE}	CONST DN_CREATE	= $00000004	/* File created.  */
 NATIVE {DN_DELETE}	CONST DN_DELETE	= $00000008	/* File removed.  */
 NATIVE {DN_RENAME}	CONST DN_RENAME	= $00000010	/* File renamed.  */
 NATIVE {DN_ATTRIB}	CONST DN_ATTRIB	= $00000020	/* File changed attributes.  */
 NATIVE {DN_MULTISHOT}	CONST DN_MULTISHOT	= $80000000	/* Don't remove notifier.  */


/* Owner types.  */
->NATIVE {__pid_type} DEF
NATIVE {F_OWNER_TID} CONST F_OWNER_TID = 0		/* Kernel thread.  */
NATIVE {F_OWNER_PID}	CONST F_OWNER_PID = 1		/* Process.  */
NATIVE {F_OWNER_PGRP}	CONST F_OWNER_PGRP = 2		/* Process group.  */
NATIVE {F_OWNER_GID} CONST F_OWNER_GID = F_OWNER_PGRP	/* Alternative, obsolete name.  */
  

/* Structure to use with F_GETOWN_EX and F_SETOWN_EX.  */
NATIVE {f_owner_ex} OBJECT f_owner_ex
    {type}	type	:NATIVE {enum __pid_type} VALUE	/* Owner type of ID.  */
    {pid}	pid	:PID_T__		/* ID of owner.  */
  ENDOBJECT

/* Types of seals.  */
 NATIVE {F_SEAL_SEAL}	CONST F_SEAL_SEAL	= $0001	/* Prevent further seals from being set.  */
 NATIVE {F_SEAL_SHRINK}	CONST F_SEAL_SHRINK	= $0002	/* Prevent file from shrinking.  */
 NATIVE {F_SEAL_GROW}	CONST F_SEAL_GROW	= $0004	/* Prevent file from growing.  */
 NATIVE {F_SEAL_WRITE}	CONST F_SEAL_WRITE	= $0008	/* Prevent writes.  */
 NATIVE {F_SEAL_FUTURE_WRITE}	CONST F_SEAL_FUTURE_WRITE	= $0010	/* Prevent future writes while
					   mapped.  */

/* Hint values for F_{GET,SET}_RW_HINT.  */
 NATIVE {RWF_WRITE_LIFE_NOT_SET}	CONST RWF_WRITE_LIFE_NOT_SET	= 0
 NATIVE {RWH_WRITE_LIFE_NONE}	CONST RWH_WRITE_LIFE_NONE	= 1
 NATIVE {RWH_WRITE_LIFE_SHORT}	CONST RWH_WRITE_LIFE_SHORT	= 2
 NATIVE {RWH_WRITE_LIFE_MEDIUM}	CONST RWH_WRITE_LIFE_MEDIUM	= 3
 NATIVE {RWH_WRITE_LIFE_LONG}	CONST RWH_WRITE_LIFE_LONG	= 4
 NATIVE {RWH_WRITE_LIFE_EXTREME}	CONST RWH_WRITE_LIFE_EXTREME	= 5

/* Define some more compatibility macros to be backward compatible with
   BSD systems which did not managed to hide these kernel macros.  */
 NATIVE {FAPPEND}	CONST FAPPEND	= O_APPEND
 NATIVE {FFSYNC}		CONST FFSYNC		= O_FSYNC
 NATIVE {FASYNC}		CONST FASYNC		= O_ASYNC
 NATIVE {FNONBLOCK}	CONST FNONBLOCK	= O_NONBLOCK
 NATIVE {FNDELAY}	CONST FNDELAY	= O_NDELAY

NATIVE {__POSIX_FADV_DONTNEED}	CONST	POSIX_FADV_DONTNEED__ = 4
NATIVE {__POSIX_FADV_NOREUSE}	CONST	POSIX_FADV_NOREUSE__ = 5

/* Advise to `posix_fadvise'.  */
 NATIVE {POSIX_FADV_NORMAL}	CONST POSIX_FADV_NORMAL	= 0 /* No further special treatment.  */
 NATIVE {POSIX_FADV_RANDOM}	CONST POSIX_FADV_RANDOM	= 1 /* Expect random page references.  */
 NATIVE {POSIX_FADV_SEQUENTIAL}	CONST POSIX_FADV_SEQUENTIAL	= 2 /* Expect sequential page references.  */
 NATIVE {POSIX_FADV_WILLNEED}	CONST POSIX_FADV_WILLNEED	= 3 /* Will need these pages.  */
 NATIVE {POSIX_FADV_DONTNEED}	CONST POSIX_FADV_DONTNEED	= POSIX_FADV_DONTNEED__ /* Don't need these pages.  */
 NATIVE {POSIX_FADV_NOREUSE}	CONST POSIX_FADV_NOREUSE	= POSIX_FADV_NOREUSE__ /* Data will be accessed once.  */


/* Flags for SYNC_FILE_RANGE.  */
 NATIVE {SYNC_FILE_RANGE_WAIT_BEFORE}	CONST SYNC_FILE_RANGE_WAIT_BEFORE	= 1 /* Wait upon writeout of all pages
					     in the range before performing the
					     write.  */
 NATIVE {SYNC_FILE_RANGE_WRITE}		CONST SYNC_FILE_RANGE_WRITE		= 2 /* Initiate writeout of all those
					     dirty pages in the range which are
					     not presently under writeback.  */
 NATIVE {SYNC_FILE_RANGE_WAIT_AFTER}	CONST SYNC_FILE_RANGE_WAIT_AFTER	= 4 /* Wait upon writeout of all pages in
					     the range after performing the
					     write.  */
/* SYNC_FILE_RANGE_WRITE_AND_WAIT ensures all pages in the range are
   written to disk before returning.  */
 NATIVE {SYNC_FILE_RANGE_WRITE_AND_WAIT}	CONST SYNC_FILE_RANGE_WRITE_AND_WAIT	= (SYNC_FILE_RANGE_WRITE OR SYNC_FILE_RANGE_WAIT_BEFORE	OR SYNC_FILE_RANGE_WAIT_AFTER)

/* Flags for SPLICE and VMSPLICE.  */
 NATIVE {SPLICE_F_MOVE}		CONST SPLICE_F_MOVE		= 1	/* Move pages instead of copying.  */
 NATIVE {SPLICE_F_NONBLOCK}	CONST SPLICE_F_NONBLOCK	= 2	/* Don't block on the pipe splicing
					   (but we may still block on the fd
					   we splice from/to).  */
 NATIVE {SPLICE_F_MORE}		CONST SPLICE_F_MORE		= 4	/* Expect more data.  */
 NATIVE {SPLICE_F_GIFT}		CONST SPLICE_F_GIFT		= 8	/* Pages passed in are a gift.  */



/* File handle structure.  */
NATIVE {file_handle} OBJECT file_handle
  {handle_bytes}	handle_bytes	:ULONG
  {handle_type}	handle_type	:VALUE
  /* File identifier.  */
  {f_handle}	f_handle[0+1]	:ARRAY OF UBYTE
ENDOBJECT

/* Maximum handle size (for now).  */
 NATIVE {MAX_HANDLE_SZ}	CONST MAX_HANDLE_SZ	= 128

/* Values for `*at' functions.  */
 NATIVE {AT_FDCWD}		CONST AT_FDCWD		= -100	/* Special value used to indicate
					   the *at functions should use the
					   current working directory. */
 NATIVE {AT_SYMLINK_NOFOLLOW}	CONST AT_SYMLINK_NOFOLLOW	= $100	/* Do not follow symbolic links.  */
 NATIVE {AT_REMOVEDIR}		CONST AT_REMOVEDIR		= $200	/* Remove directory instead of
					   unlinking file.  */
 NATIVE {AT_SYMLINK_FOLLOW}	CONST AT_SYMLINK_FOLLOW	= $400	/* Follow symbolic links.  */
  NATIVE {AT_NO_AUTOMOUNT}	CONST AT_NO_AUTOMOUNT	= $800	/* Suppress terminal automount
					   traversal.  */
  NATIVE {AT_EMPTY_PATH}		CONST AT_EMPTY_PATH		= $1000	/* Allow empty relative pathname.  */
  NATIVE {AT_STATX_SYNC_TYPE}	CONST AT_STATX_SYNC_TYPE	= $6000
  NATIVE {AT_STATX_SYNC_AS_STAT}	CONST AT_STATX_SYNC_AS_STAT	= $0000
  NATIVE {AT_STATX_FORCE_SYNC}	CONST AT_STATX_FORCE_SYNC	= $2000
  NATIVE {AT_STATX_DONT_SYNC}	CONST AT_STATX_DONT_SYNC	= $4000
  NATIVE {AT_RECURSIVE}		CONST AT_RECURSIVE		= $8000	/* Apply to the entire subtree.  */
 NATIVE {AT_EACCESS}		CONST AT_EACCESS		= $200	/* Test access permitted for
					   effective IDs, not real IDs.  */


/* Provide kernel hint to read ahead.  */
NATIVE {readahead} PROC
PROC readahead(__fd:VALUE, __offset:OFF64_T__, __count:SIZE_T) IS NATIVE {readahead( (int) } __fd {,} __offset {,} __count {)} ENDNATIVE !!SSIZE_T__


/* Selective file content synch'ing.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
NATIVE {sync_file_range} PROC
PROC sync_file_range(__fd:VALUE, __offset:OFF64_T__, __count:OFF64_T__,
			    __flags:ULONG) IS NATIVE {sync_file_range( (int) } __fd {,} __offset {,} __count {, (int) } __flags {)} ENDNATIVE !!VALUE


/* Splice address range into a pipe.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
NATIVE {vmsplice} PROC
PROC vmsplice(__fdout:VALUE, __iov:PTR TO iovec,
			   __count:SIZE_T, __flags:ULONG) IS NATIVE {vmsplice( (int) } __fdout {,} __iov {,} __count {, (int) } __flags {)} ENDNATIVE !!SSIZE_T__

/* Splice two files together.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
NATIVE {splice} PROC
PROC splice(__fdin:VALUE, __offin:PTR TO OFF64_T__, __fdout:VALUE,
			 __offout:PTR TO OFF64_T__, __len:SIZE_T,
			 __flags:ULONG) IS NATIVE {splice( (int) } __fdin {,} __offin {, (int) } __fdout {,} __offout {,} __len {, (int) } __flags {)} ENDNATIVE !!SSIZE_T__

/* In-kernel implementation of tee for pipe buffers.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
NATIVE {tee} PROC
PROC tee(__fdin:VALUE, __fdout:VALUE, __len:SIZE_T,
		      __flags:ULONG) IS NATIVE {tee( (int) } __fdin {, (int) } __fdout {,} __len {, (int) } __flags {)} ENDNATIVE !!SSIZE_T__

/* Reserve storage for the data of the file associated with FD.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
NATIVE {fallocate} PROC
PROC fallocate(__fd:VALUE, __mode:VALUE, __offset:OFF_T__, __len:OFF_T__) IS NATIVE {fallocate( (int) } __fd {, (int) } __mode {,} __offset {,} __len {)} ENDNATIVE !!VALUE
NATIVE {fallocate64} PROC
PROC fallocate64(__fd:VALUE, __mode:VALUE, __offset:OFF64_T__,
			__len:OFF64_T__) IS NATIVE {fallocate64( (int) } __fd {, (int) } __mode {,} __offset {,} __len {)} ENDNATIVE !!VALUE


/* Map file name to file handle.  */
NATIVE {name_to_handle_at} PROC
PROC name_to_handle_at(__dfd:VALUE, __name:ARRAY OF CHAR,
			      __handle:PTR TO file_handle, __mnt_id:PTR TO LONG,
			      __flags:VALUE) IS NATIVE {name_to_handle_at( (int) } __dfd {,} __name {,} __handle {,} __mnt_id {, (int) } __flags {)} ENDNATIVE !!VALUE

/* Open file using the file handle.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
NATIVE {open_by_handle_at} PROC
PROC open_by_handle_at(__mountdirfd:VALUE, __handle:PTR TO file_handle,
			      __flags:VALUE) IS NATIVE {open_by_handle_at( (int) } __mountdirfd {,} __handle {, (int) } __flags {)} ENDNATIVE !!VALUE
