OPT NATIVE
MODULE 'std/pUnsigned'
MODULE 'target/x86_64-linux-gnu/sys/types'	->guessed
PUBLIC MODULE 'target/x86_64-linux-gnu/sys/stat'	->guessed, so that don't need to double-declare S_IFMT ... S_IFSOCK
PUBLIC MODULE 'target/x86_64-linux-gnu/sys/stat'	->guessed, so don't need to double-declare S_ISVTX ... S_IRWXO
MODULE 'target/features'
/* Get MODE_T__, DEV_T__ and OFF_T__  .*/
MODULE 'target/x86_64-linux-gnu/bits/types'
/* Get the definitions of O_*, F_*, FD_*: all the
   numbers and flag bits for `open', `fcntl', et al.  */
PUBLIC MODULE 'target/x86_64-linux-gnu/bits/fcntl'
/* For XPG all symbols from <sys/stat.h> should also be available.  */
 MODULE 'target/x86_64-linux-gnu/bits/types/struct_timespec'
 PUBLIC MODULE 'target/x86_64-linux-gnu/bits/stat'
{#include <fcntl.h>}
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
 *	POSIX Standard: 6.5 File Control Operations	<fcntl.h>
 */

NATIVE {_FCNTL_H}	CONST ->_FCNTL_H	= 1


/* This must be early so <bits/fcntl.h> can define types winningly.  */



/* Detect if open needs mode as a third argument (or for openat as a fourth
   argument).  */
 ->NATIVE {__OPEN_NEEDS_MODE} PROC	->define __OPEN_NEEDS_MODE(oflag) (((oflag) & O_CREAT) != 0 || ((oflag) & __O_TMPFILE) == __O_TMPFILE)

/* POSIX.1-2001 specifies that these types are defined by <fcntl.h>.
   Earlier POSIX standards permitted any type ending in `_t' to be defined
   by any POSIX header, so we don't conditionalize the definitions here.  */
/*
NATIVE {mode_t} OBJECT
TYPE MODE_T IS NATIVE {mode_t} MODE_T__
 ->NATIVE {__mode_t_defined} DEF
*/

/*
#ifndef __off_t_defined
NATIVE {off_t} OBJECT
->TYPE OFF_T IS NATIVE {off_t} OFF_T__
 ->NATIVE {__off_t_defined} DEF
#endif
*/

/*
#if defined __USE_LARGEFILE64 && !defined __off64_t_defined
NATIVE {off64_t} OBJECT
->TYPE OFF64_T IS NATIVE {off64_t} OFF64_T__
 ->NATIVE {__off64_t_defined} DEF
#endif
*/

/*
NATIVE {pid_t} OBJECT
TYPE PID_T IS NATIVE {pid_t} PID_T__
 ->NATIVE {__pid_t_defined} DEF
*/

/*
NATIVE {S_IFMT}		CONST S_IFMT		= S_IFMT__
 NATIVE {S_IFDIR}	CONST S_IFDIR	= S_IFDIR__
 NATIVE {S_IFCHR}	CONST S_IFCHR	= S_IFCHR__
 NATIVE {S_IFBLK}	CONST S_IFBLK	= S_IFBLK__
 NATIVE {S_IFREG}	CONST S_IFREG	= S_IFREG__
  NATIVE {S_IFIFO}	CONST S_IFIFO	= S_IFIFO__
  NATIVE {S_IFLNK}	CONST S_IFLNK	= S_IFLNK__
  NATIVE {S_IFSOCK}	CONST S_IFSOCK	= S_IFSOCK__
*/

/* Protection bits.  */

/*
 NATIVE {S_ISUID}	CONST S_ISUID	= S_ISUID__       /* Set user ID on execution.  */
 NATIVE {S_ISGID}	CONST S_ISGID	= S_ISGID__       /* Set group ID on execution.  */

/* Save swapped text after use (sticky bit).  This is pretty well obsolete.  */
  NATIVE {S_ISVTX}	CONST S_ISVTX	= S_ISVTX__

 NATIVE {S_IRUSR}	CONST S_IRUSR	= S_IREAD__       /* Read by owner.  */
 NATIVE {S_IWUSR}	CONST S_IWUSR	= S_IWRITE__      /* Write by owner.  */
 NATIVE {S_IXUSR}	CONST S_IXUSR	= S_IEXEC__       /* Execute by owner.  */
/* Read, write, and execute by owner.  */
 NATIVE {S_IRWXU}	CONST S_IRWXU	= (S_IREAD__ OR S_IWRITE__ OR S_IEXEC__)

 NATIVE {S_IRGRP}	CONST S_IRGRP	= (S_IRUSR SHR 3)  /* Read by group.  */
 NATIVE {S_IWGRP}	CONST S_IWGRP	= (S_IWUSR SHR 3)  /* Write by group.  */
 NATIVE {S_IXGRP}	CONST S_IXGRP	= (S_IXUSR SHR 3)  /* Execute by group.  */
/* Read, write, and execute by group.  */
 NATIVE {S_IRWXG}	CONST S_IRWXG	= (S_IRWXU SHR 3)

 NATIVE {S_IROTH}	CONST S_IROTH	= (S_IRGRP SHR 3)  /* Read by others.  */
 NATIVE {S_IWOTH}	CONST S_IWOTH	= (S_IWGRP SHR 3)  /* Write by others.  */
 NATIVE {S_IXOTH}	CONST S_IXOTH	= (S_IXGRP SHR 3)  /* Execute by others.  */
/* Read, write, and execute by others.  */
 NATIVE {S_IRWXO}	CONST S_IRWXO	= (S_IRWXG SHR 3)
*/

/* Values for the second argument to access.
   These may be OR'd together.  */
  NATIVE {R_OK}	CONST R_OK	= 4		/* Test for read permission.  */
  NATIVE {W_OK}	CONST W_OK	= 2		/* Test for write permission.  */
  NATIVE {X_OK}	CONST X_OK	= 1		/* Test for execute permission.  */
  NATIVE {F_OK}	CONST F_OK	= 0		/* Test for existence.  */

/* XPG wants the following symbols.   <stdio.h> has the same definitions.  */
 /*NATIVE {SEEK_SET}*/	CONST SEEK_SET	= 0	/* Seek from beginning of file.  */
 /*NATIVE {SEEK_CUR}*/	CONST SEEK_CUR	= 1	/* Seek from current position.  */
 /*NATIVE {SEEK_END}*/	CONST SEEK_END	= 2	/* Seek from end of file.  */

/* Do the file control operation described by CMD on FD.
   The remaining arguments are interpreted depending on CMD.

   This function is a cancellation point and therefore not marked with
   __THROW.  */
NATIVE {fcntl} PROC
PROC fcntl(__fd:VALUE, __cmd:VALUE, __cmd2=0:ULONG, ...) IS NATIVE {fcntl( (int) } __fd {, (int) } __cmd {,} __cmd2 {,} ... {)} ENDNATIVE !!VALUE
NATIVE {fcntl64} PROC
PROC fcntl64(__fd:VALUE, __cmd:VALUE, __cmd2=0:ULONG, ...) IS NATIVE {fcntl64( (int) } __fd {, (int) } __cmd {,} __cmd2 {,} ... {)} ENDNATIVE !!VALUE

/* Open FILE and return a new file descriptor for it, or -1 on error.
   OFLAG determines the type of access used.  If O_CREAT or O_TMPFILE is set
   in OFLAG, the third argument is taken as a `MODE_T', the mode of the
   created file.

   This function is a cancellation point and therefore not marked with
   __THROW.  */
NATIVE {open} PROC
PROC open(__file:ARRAY OF CHAR, __oflag:VALUE, __mode=0:ULONG) IS NATIVE {open(} __file {, (int) } __oflag {,} __mode {)} ENDNATIVE !!VALUE
NATIVE {open64} PROC
PROC open64(__file:ARRAY OF CHAR, __oflag:VALUE, __mode=0:ULONG) IS NATIVE {open64(} __file {, (int) } __oflag {,} __mode {)} ENDNATIVE !!VALUE

/* Similar to `open' but a relative path name is interpreted relative to
   the directory for which FD is a descriptor.

   NOTE: some other `openat' implementation support additional functionality
   through this interface, especially using the O_XATTR flag.  This is not
   yet supported here.

   This function is a cancellation point and therefore not marked with
   __THROW.  */
NATIVE {openat} PROC
PROC openat(__fd:VALUE, __file:ARRAY OF CHAR, __oflag:VALUE, __oflag2=0:ULONG, ...) IS NATIVE {openat( (int) } __fd {,} __file {, (int) } __oflag {,} __oflag2 {,} ... {)} ENDNATIVE !!VALUE
NATIVE {openat64} PROC
PROC openat64(__fd:VALUE, __file:ARRAY OF CHAR, __oflag:VALUE, __oflag2=0:ULONG, ...) IS NATIVE {openat64( (int) } __fd {,} __file {, (int) } __oflag {,} __oflag2 {,} ... {)} ENDNATIVE !!VALUE

/* Create and open FILE, with mode MODE.  This takes an `int' MODE
   argument because that is what `MODE_T' will be widened to.

   This function is a cancellation point and therefore not marked with
   __THROW.  */
NATIVE {creat} PROC
PROC creat(__file:ARRAY OF CHAR, __mode:MODE_T) IS NATIVE {creat(} __file {,} __mode {)} ENDNATIVE !!VALUE
NATIVE {creat64} PROC
PROC creat64(__file:ARRAY OF CHAR, __mode:MODE_T) IS NATIVE {creat64(} __file {,} __mode {)} ENDNATIVE !!VALUE

/* NOTE: These declarations also appear in <unistd.h>; be sure to keep both
   files consistent.  Some systems have them there and some here, and some
   software depends on the macros being defined without including both.  */

/* `lockf' is a simpler interface to the locking facilities of `fcntl'.
   LEN is always relative to the current file position.
   The CMD argument is one of the following.  */

 NATIVE {F_ULOCK} CONST F_ULOCK = 0	/* Unlock a previously locked region.  */
 NATIVE {F_LOCK}  CONST F_LOCK  = 1	/* Lock a region for exclusive use.  */
 NATIVE {F_TLOCK} CONST F_TLOCK = 2	/* Test and lock a region for exclusive use.  */
 NATIVE {F_TEST}  CONST F_TEST  = 3	/* Test a region for other processes locks.  */

NATIVE {lockf} PROC
PROC lockf(__fd:VALUE, __cmd:VALUE, __len:OFF_T) IS NATIVE {lockf( (int) } __fd {, (int) } __cmd {,} __len {)} ENDNATIVE !!VALUE
NATIVE {lockf64} PROC
PROC lockf64(__fd:VALUE, __cmd:VALUE, __len:OFF64_T) IS NATIVE {lockf64( (int) } __fd {, (int) } __cmd {,} __len {)} ENDNATIVE !!VALUE

/* Advice the system about the expected behaviour of the application with
   respect to the file associated with FD.  */
NATIVE {posix_fadvise} PROC
PROC posix_fadvise(__fd:VALUE, __offset:OFF_T, __len:OFF_T,
			  __advise:VALUE) IS NATIVE {posix_fadvise( (int) } __fd {,} __offset {,} __len {, (int) } __advise {)} ENDNATIVE !!VALUE
NATIVE {posix_fadvise64} PROC
PROC posix_fadvise64(__fd:VALUE, __offset:OFF64_T, __len:OFF64_T,
			    __advise:VALUE) IS NATIVE {posix_fadvise64( (int) } __fd {,} __offset {,} __len {, (int) } __advise {)} ENDNATIVE !!VALUE


/* Reserve storage for the data of the file associated with FD.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
NATIVE {posix_fallocate} PROC
PROC posix_fallocate(__fd:VALUE, __offset:OFF_T, __len:OFF_T) IS NATIVE {posix_fallocate( (int) } __fd {,} __offset {,} __len {)} ENDNATIVE !!VALUE
NATIVE {posix_fallocate64} PROC
PROC posix_fallocate64(__fd:VALUE, __offset:OFF64_T, __len:OFF64_T) IS NATIVE {posix_fallocate64( (int) } __fd {,} __offset {,} __len {)} ENDNATIVE !!VALUE


/* Define some inlines helping to catch common problems.  */
/*
#if __USE_FORTIFY_LEVEL > 0 && defined __fortify_function && defined __va_arg_pack_len
 MODULE 'target/bits/fcntl2'
#endif
*/
