OPT NATIVE
MODULE 'target/features'
MODULE 'target/x86_64-linux-gnu/bits/types'
 MODULE 'target/x86_64-linux-gnu/bits/types/struct_timespec'
 MODULE 'target/x86_64-linux-gnu/bits/types/time_t'
MODULE 'target/x86_64-linux-gnu/bits/stat'
 MODULE 'target/x86_64-linux-gnu/bits/statx'	->this then includes 'target/linux/stat'
{#include <x86_64-linux-gnu/sys/stat.h>}
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
 *	POSIX Standard: 5.6 File Characteristics	<sys/stat.h>
 */

NATIVE {_SYS_STAT_H}	CONST ->_SYS_STAT_H	= 1

/* The Single Unix specification says that some more types are
   available here.  */

->NATIVE {dev_t} OBJECT
->TYPE dev_t IS NATIVE {dev_t} DEV_T__
  ->NATIVE {__dev_t_defined} DEF

->NATIVE {gid_t} OBJECT
->TYPE gid_t IS NATIVE {gid_t} GID_T__
  ->NATIVE {__gid_t_defined} DEF

->NATIVE {ino_t} OBJECT
->TYPE ino_t IS NATIVE {ino_t} INO_T__
  ->NATIVE {__ino_t_defined} DEF

->NATIVE {mode_t} OBJECT
->TYPE mode_t IS NATIVE {mode_t} MODE_T__
  ->NATIVE {__mode_t_defined} DEF

->NATIVE {nlink_t} OBJECT
->TYPE nlink_t IS NATIVE {nlink_t} NLINK_T__
  ->NATIVE {__nlink_t_defined} DEF

/*
 #ifndef __off_t_defined
NATIVE {off_t} OBJECT
->TYPE OFF_T IS NATIVE {off_t} OFF_T__
  ->NATIVE {__off_t_defined} DEF
 #endif
*/

->NATIVE {uid_t} OBJECT
->TYPE uid_t IS NATIVE {uid_t} UID_T__
  ->NATIVE {__uid_t_defined} DEF

->NATIVE {blkcnt_t} OBJECT
->TYPE blkcnt_t IS NATIVE {blkcnt_t} BLKCNT_T__
  ->NATIVE {__blkcnt_t_defined} DEF

->NATIVE {blksize_t} OBJECT
->TYPE blksize_t IS NATIVE {blksize_t} BLKSIZE_T__
  ->NATIVE {__blksize_t_defined} DEF


 NATIVE {S_IFMT}		CONST S_IFMT		= S_IFMT__
 NATIVE {S_IFDIR}	CONST S_IFDIR	= S_IFDIR__
 NATIVE {S_IFCHR}	CONST S_IFCHR	= S_IFCHR__
 NATIVE {S_IFBLK}	CONST S_IFBLK	= S_IFBLK__
 NATIVE {S_IFREG}	CONST S_IFREG	= S_IFREG__
  NATIVE {S_IFIFO}	CONST S_IFIFO	= S_IFIFO__
  NATIVE {S_IFLNK}	CONST S_IFLNK	= S_IFLNK__
/*
 #if (defined __USE_MISC || defined __USE_XOPEN_EXTENDED) defined S_IFSOCK__
*/
  NATIVE {S_IFSOCK}	CONST S_IFSOCK	= S_IFSOCK__
/*
 #endif
*/

/* Test macros for file types.	*/

->NATIVE {__S_ISTYPE} PROC	->define __S_ISTYPE(mode, mask)	(((mode) & S_IFMT__) == (mask))

NATIVE {S_ISDIR} PROC	->define S_ISDIR(mode)	 __S_ISTYPE((mode), S_IFDIR__)
PROC s_ISDIR(mode) IS NATIVE {S_ISDIR(} mode {)} ENDNATIVE !!LONG <> 0
NATIVE {S_ISCHR} PROC	->define S_ISCHR(mode)	 __S_ISTYPE((mode), S_IFCHR__)
PROC s_ISCHR(mode) IS NATIVE {S_ISCHR(} mode {)} ENDNATIVE !!LONG <> 0
NATIVE {S_ISBLK} PROC	->define S_ISBLK(mode)	 __S_ISTYPE((mode), S_IFBLK__)
PROC s_ISBLK(mode) IS NATIVE {S_ISBLK(} mode {)} ENDNATIVE !!LONG <> 0
NATIVE {S_ISREG} PROC	->define S_ISREG(mode)	 __S_ISTYPE((mode), S_IFREG__)
PROC s_ISREG(mode) IS NATIVE {S_ISREG(} mode {)} ENDNATIVE !!LONG <> 0
 NATIVE {S_ISFIFO} PROC	->define S_ISFIFO(mode)	 __S_ISTYPE((mode), S_IFIFO__)
PROC s_ISFIFO(mode) IS NATIVE {S_ISFIFO(} mode {)} ENDNATIVE !!LONG <> 0
 NATIVE {S_ISLNK} PROC	->define S_ISLNK(mode)	 __S_ISTYPE((mode), S_IFLNK__)
PROC s_ISLNK(mode) IS NATIVE {S_ISLNK(} mode {)} ENDNATIVE !!LONG <> 0

/*
#if defined __USE_MISC && !defined __S_IFLNK
 NATIVE {S_ISLNK} PROC	->define S_ISLNK(mode)  0
#endif
*/

 NATIVE {S_ISSOCK} PROC	->define S_ISSOCK(mode) __S_ISTYPE((mode), S_IFSOCK__)
PROC s_ISSOCK(mode) IS NATIVE {S_ISSOCK(} mode {)} ENDNATIVE !!LONG <> 0

/* These are from POSIX.1b.  If the objects are not implemented using separate
   distinct file types, the macros always will evaluate to zero.  Unlike the
   other S_* macros the following three take a pointer to a `struct stat'
   object as the argument.  */
 NATIVE {S_TYPEISMQ} PROC	->define S_TYPEISMQ(buf) __S_TYPEISMQ(buf)
 NATIVE {S_TYPEISSEM} PROC	->define S_TYPEISSEM(buf) __S_TYPEISSEM(buf)
 NATIVE {S_TYPEISSHM} PROC	->define S_TYPEISSHM(buf) __S_TYPEISSHM(buf)


/* Protection bits.  */

NATIVE {S_ISUID} CONST S_ISUID = S_ISUID__	/* Set user ID on execution.  */
NATIVE {S_ISGID}	CONST S_ISGID	= S_ISGID__	/* Set group ID on execution.  */

/* Save swapped text after use (sticky bit).  This is pretty well obsolete.  */
 NATIVE {S_ISVTX}	CONST S_ISVTX	= S_ISVTX__

NATIVE {S_IRUSR}	CONST S_IRUSR	= S_IREAD__	/* Read by owner.  */
NATIVE {S_IWUSR}	CONST S_IWUSR	= S_IWRITE__	/* Write by owner.  */
NATIVE {S_IXUSR}	CONST S_IXUSR	= S_IEXEC__	/* Execute by owner.  */
/* Read, write, and execute by owner.  */
NATIVE {S_IRWXU}	CONST S_IRWXU	= (S_IREAD__ OR S_IWRITE__ OR S_IEXEC__)

 NATIVE {S_IREAD}	CONST S_IREAD	= S_IRUSR
 NATIVE {S_IWRITE}	CONST S_IWRITE	= S_IWUSR
 NATIVE {S_IEXEC}	CONST S_IEXEC	= S_IXUSR

NATIVE {S_IRGRP}	CONST S_IRGRP	= (S_IRUSR SHR 3)	/* Read by group.  */
NATIVE {S_IWGRP}	CONST S_IWGRP	= (S_IWUSR SHR 3)	/* Write by group.  */
NATIVE {S_IXGRP}	CONST S_IXGRP	= (S_IXUSR SHR 3)	/* Execute by group.  */
/* Read, write, and execute by group.  */
NATIVE {S_IRWXG}	CONST S_IRWXG	= (S_IRWXU SHR 3)

NATIVE {S_IROTH}	CONST S_IROTH	= (S_IRGRP SHR 3)	/* Read by others.  */
NATIVE {S_IWOTH}	CONST S_IWOTH	= (S_IWGRP SHR 3)	/* Write by others.  */
NATIVE {S_IXOTH}	CONST S_IXOTH	= (S_IXGRP SHR 3)	/* Execute by others.  */
/* Read, write, and execute by others.  */
NATIVE {S_IRWXO}	CONST S_IRWXO	= (S_IRWXG SHR 3)


/* Macros for common mode bit masks.  */
 NATIVE {ACCESSPERMS} CONST ACCESSPERMS = (S_IRWXU OR S_IRWXG OR S_IRWXO) /* 0777 */
 NATIVE {ALLPERMS} CONST ALLPERMS = (S_ISUID OR S_ISGID OR S_ISVTX OR S_IRWXU OR S_IRWXG OR S_IRWXO)/* 07777 */
 NATIVE {DEFFILEMODE} CONST DEFFILEMODE = (S_IRUSR OR S_IWUSR OR S_IRGRP OR S_IWGRP OR S_IROTH OR S_IWOTH)/* 0666*/

 NATIVE {S_BLKSIZE}	CONST S_BLKSIZE	= 512	/* Block size for `st_blocks'.  */


/* Get file attributes for FILE and put them in BUF.  */
->NATIVE {stat} PROC
PROC stat(__file:ARRAY OF CHAR,
		 __buf:PTR TO stat) IS NATIVE {stat(} __file {,} __buf {)} ENDNATIVE !!VALUE

/* Get file attributes for the file, device, pipe, or socket
   that file descriptor FD is open on and put them in BUF.  */
NATIVE {fstat} PROC
PROC fstat(__fd:VALUE, __buf:PTR TO stat) IS NATIVE {fstat( (int) } __fd {,} __buf {)} ENDNATIVE !!VALUE
->NATIVE {stat64} PROC
PROC stat64(__file:ARRAY OF CHAR,
		   __buf:PTR TO stat64) IS NATIVE {stat64(} __file {,} __buf {)} ENDNATIVE !!VALUE
NATIVE {fstat64} PROC
PROC fstat64(__fd:VALUE, __buf:PTR TO stat64) IS NATIVE {fstat64( (int) } __fd {,} __buf {)} ENDNATIVE !!VALUE

/* Similar to stat, get the attributes for FILE and put them in BUF.
   Relative path names are interpreted relative to FD unless FD is
   AT_FDCWD.  */
NATIVE {fstatat} PROC
PROC fstatat(__fd:VALUE, __file:ARRAY OF CHAR,
		    __buf:PTR TO stat, __flag:VALUE) IS NATIVE {fstatat( (int) } __fd {,} __file {,} __buf {, (int) } __flag {)} ENDNATIVE !!VALUE

/* Get file attributes about FILE and put them in BUF.
   If FILE is a symbolic link, do not follow it.  */
NATIVE {lstat} PROC
PROC lstat(__file:ARRAY OF CHAR,
		  __buf:PTR TO stat) IS NATIVE {lstat(} __file {,} __buf {)} ENDNATIVE !!VALUE
NATIVE {lstat64} PROC
PROC lstat64(__file:ARRAY OF CHAR,
		    __buf:PTR TO stat64) IS NATIVE {lstat64(} __file {,} __buf {)} ENDNATIVE !!VALUE

/* Set file access permissions for FILE to MODE.
   If FILE is a symbolic link, this affects its target instead.  */
NATIVE {chmod} PROC
PROC chmod(__file:ARRAY OF CHAR, __mode:MODE_T__) IS NATIVE {chmod(} __file {,} __mode {)} ENDNATIVE !!VALUE

/* Set file access permissions for FILE to MODE.
   If FILE is a symbolic link, this affects the link itself
   rather than its target.  */
NATIVE {lchmod} PROC
->PROC lchmod(__file:ARRAY OF CHAR, __mode:MODE_T__) IS NATIVE {lchmod(} __file {,} __mode {)} ENDNATIVE !!VALUE

/* Set file access permissions of the file FD is open on to MODE.  */
NATIVE {fchmod} PROC
PROC fchmod(__fd:VALUE, __mode:MODE_T__) IS NATIVE {fchmod( (int) } __fd {,} __mode {)} ENDNATIVE !!VALUE

/* Set file access permissions of FILE relative to
   the directory FD is open on.  */
NATIVE {fchmodat} PROC
PROC fchmodat(__fd:VALUE, __file:ARRAY OF CHAR, __mode:MODE_T__,
		     __flag:VALUE) IS NATIVE {fchmodat( (int) } __fd {,} __file {,} __mode {, (int) } __flag {)} ENDNATIVE !!VALUE



/* Set the file creation mask of the current process to MASK,
   and return the old creation mask.  */
NATIVE {umask} PROC
PROC umask(__mask:MODE_T__) IS NATIVE {umask(} __mask {)} ENDNATIVE !!MODE_T__

/* Get the current `umask' value without changing it.
   This function is only available under the GNU Hurd.  */
NATIVE {getumask} PROC
->PROC getumask() IS NATIVE {getumask()} ENDNATIVE !!MODE_T__

/* Create a new directory named PATH, with permission bits MODE.  */
NATIVE {mkdir} PROC
PROC mkdir(__path:ARRAY OF CHAR, __mode:MODE_T__) IS NATIVE {mkdir(} __path {,} __mode {)} ENDNATIVE !!VALUE

/* Like mkdir, create a new directory with permission bits MODE.  But
   interpret relative PATH names relative to the directory associated
   with FD.  */
NATIVE {mkdirat} PROC
PROC mkdirat(__fd:VALUE, __path:ARRAY OF CHAR, __mode:MODE_T__) IS NATIVE {mkdirat( (int) } __fd {,} __path {,} __mode {)} ENDNATIVE !!VALUE

/* Create a device file named PATH, with permission and special bits MODE
   and device number DEV (which can be constructed from major and minor
   device numbers with the `makedev' macro above).  */
NATIVE {mknod} PROC
PROC mknod(__path:ARRAY OF CHAR, __mode:MODE_T__, __dev:DEV_T__) IS NATIVE {mknod(} __path {,} __mode {,} __dev {)} ENDNATIVE !!VALUE

/* Like mknod, create a new device file with permission bits MODE and
   device number DEV.  But interpret relative PATH names relative to
   the directory associated with FD.  */
NATIVE {mknodat} PROC
PROC mknodat(__fd:VALUE, __path:ARRAY OF CHAR, __mode:MODE_T__,
		    __dev:DEV_T__) IS NATIVE {mknodat( (int) } __fd {,} __path {,} __mode {,} __dev {)} ENDNATIVE !!VALUE


/* Create a new FIFO named PATH, with permission bits MODE.  */
NATIVE {mkfifo} PROC
PROC mkfifo(__path:ARRAY OF CHAR, __mode:MODE_T__) IS NATIVE {mkfifo(} __path {,} __mode {)} ENDNATIVE !!VALUE

/* Like mkfifo, create a new FIFO with permission bits MODE.  But
   interpret relative PATH names relative to the directory associated
   with FD.  */
NATIVE {mkfifoat} PROC
PROC mkfifoat(__fd:VALUE, __path:ARRAY OF CHAR, __mode:MODE_T__) IS NATIVE {mkfifoat( (int) } __fd {,} __path {,} __mode {)} ENDNATIVE !!VALUE

/* Set file access and modification times relative to directory file
   descriptor.  */
NATIVE {utimensat} PROC
PROC utimensat(__fd:VALUE, __path:ARRAY OF CHAR,
		      __times:ARRAY OF timespec,
		      __flags:VALUE) IS NATIVE {utimensat( (int) } __fd {,} __path {,} __times {, (int) } __flags {)} ENDNATIVE !!VALUE

/* Set file access and modification times of the file associated with FD.  */
NATIVE {futimens} PROC
PROC futimens(__fd:VALUE, __times:ARRAY OF timespec) IS NATIVE {futimens( (int) } __fd {,} __times {)} ENDNATIVE !!VALUE

/* To allow the `struct stat' structure and the file type `mode_t'
   bits to vary without changing shared library major version number,
   the `stat' family of functions and `mknod' are in fact inline
   wrappers around calls to `xstat', `fxstat', `lxstat', and `xmknod',
   which all take a leading version-number argument designating the
   data structure and bits used.  <bits/stat.h> defines _STAT_VER with
   the version number corresponding to `struct stat' as defined in
   that file; and _MKNOD_VER with the version number corresponding to
   the S_IF* macros defined therein.  It is arranged that when not
   inlined these function are always statically linked; that way a
   dynamically-linked executable always encodes the version number
   corresponding to the data structures it uses, so the `x' functions
   in the shared library can adapt without needing to recompile all
   callers.  */

/*
#ifndef _STAT_VER
 NATIVE {_STAT_VER}	CONST ->_STAT_VER	= 0
#endif
*/
 NATIVE {_MKNOD_VER}	CONST ->_MKNOD_VER	= 0

/* Wrappers for stat and mknod system calls.  */
->NATIVE {__fxstat} PROC
PROC __fxstat(__ver:VALUE, __fildes:VALUE, __stat_buf:PTR TO stat) IS NATIVE {__fxstat( (int) } __ver {, (int) } __fildes {,} __stat_buf {)} ENDNATIVE !!VALUE
->NATIVE {__xstat} PROC
PROC __xstat(__ver:VALUE, __filename:ARRAY OF CHAR,
		    __stat_buf:PTR TO stat) IS NATIVE {__xstat( (int) } __ver {,} __filename {,} __stat_buf {)} ENDNATIVE !!VALUE
->NATIVE {__lxstat} PROC
PROC __lxstat(__ver:VALUE, __filename:ARRAY OF CHAR,
		     __stat_buf:PTR TO stat) IS NATIVE {__lxstat( (int) } __ver {,} __filename {,} __stat_buf {)} ENDNATIVE !!VALUE
->NATIVE {__fxstatat} PROC
PROC __fxstatat(__ver:VALUE, __fildes:VALUE, __filename:ARRAY OF CHAR,
		       __stat_buf:PTR TO stat, __flag:VALUE) IS NATIVE {__fxstatat( (int) } __ver {, (int) } __fildes {,} __filename {,} __stat_buf {, (int) } __flag {)} ENDNATIVE !!VALUE

->NATIVE {__fxstat64} PROC
PROC __fxstat64(__ver:VALUE, __fildes:VALUE, __stat_buf:PTR TO stat64) IS NATIVE {__fxstat64( (int) } __ver {, (int) } __fildes {,} __stat_buf {)} ENDNATIVE !!VALUE
->NATIVE {__xstat64} PROC
PROC __xstat64(__ver:VALUE, __filename:ARRAY OF CHAR,
		      __stat_buf:PTR TO stat64) IS NATIVE {__xstat64( (int) } __ver {,} __filename {,} __stat_buf {)} ENDNATIVE !!VALUE
->NATIVE {__lxstat64} PROC
PROC __lxstat64(__ver:VALUE, __filename:ARRAY OF CHAR,
		       __stat_buf:PTR TO stat64) IS NATIVE {__lxstat64( (int) } __ver {,} __filename {,} __stat_buf {)} ENDNATIVE !!VALUE
->NATIVE {__fxstatat64} PROC
PROC __fxstatat64(__ver:VALUE, __fildes:VALUE, __filename:ARRAY OF CHAR,
			 __stat_buf:PTR TO stat64, __flag:VALUE) IS NATIVE {__fxstatat64( (int) } __ver {, (int) } __fildes {,} __filename {,} __stat_buf {, (int) } __flag {)} ENDNATIVE !!VALUE
->NATIVE {__xmknod} PROC
PROC __xmknod(__ver:VALUE, __path:ARRAY OF CHAR, __mode:MODE_T__,
		     __dev:PTR TO DEV_T__) IS NATIVE {__xmknod( (int) } __ver {,} __path {,} __mode {,} __dev {)} ENDNATIVE !!VALUE

->NATIVE {__xmknodat} PROC
PROC __xmknodat(__ver:VALUE, __fd:VALUE, __path:ARRAY OF CHAR,
		       __mode:MODE_T__, __dev:PTR TO DEV_T__) IS NATIVE {__xmknodat( (int) } __ver {, (int) } __fd {,} __path {,} __mode {,} __dev {)} ENDNATIVE !!VALUE
