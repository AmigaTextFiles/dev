OPT NATIVE
MODULE 'target/x86_64-linux-gnu/bits/types'	->guessed
MODULE 'target/x86_64-linux-gnu/bits/types/struct_timespec'	->guessed
->{#include <x86_64-linux-gnu/bits/stat.h>}
/* Copyright (C) 1999-2020 Free Software Foundation, Inc.
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

NATIVE {_BITS_STAT_H}	CONST ->_BITS_STAT_H	= 1

/* Versions of the `struct stat' data structure.  */
 NATIVE {_STAT_VER_KERNEL}	CONST ->_STAT_VER_KERNEL	= 0
 NATIVE {_STAT_VER_LINUX}	CONST ->_STAT_VER_LINUX	= 1

/* x86-64 versions of the `xmknod' interface.  */
 NATIVE {_MKNOD_VER_LINUX}	CONST ->_MKNOD_VER_LINUX	= 0

NATIVE {_STAT_VER}		CONST ->_STAT_VER		= _STAT_VER_LINUX

NATIVE {stat} OBJECT stat
    {st_dev}	dev	:DEV_T__		/* Device.  */
    {st_ino}	ino	:INO_T__		/* File serial number.	*/
    {st_nlink}	nlink	:NLINK_T__		/* Link count.  */
    {st_mode}	mode	:MODE_T__		/* File mode.  */
    {st_uid}	uid	:UID_T__		/* User ID of the file's owner.	*/
    {st_gid}	gid	:GID_T__		/* Group ID of the file's group.*/
->    {__pad0}	__pad0	:VALUE
    {st_rdev}	rdev	:DEV_T__		/* Device number, if device.  */
    {st_size}	size	:OFF_T__			/* Size of file, in bytes.  */
    {st_blksize}	blksize	:BLKSIZE_T__	/* Optimal block size for I/O.  */
    {st_blocks}	blocks	:BLKCNT_T__		/* Number 512-byte blocks allocated. */
    /* Nanosecond resolution timestamps are stored in a format
       equivalent to 'struct timespec'.  This is the type used
       whenever possible but the Unix namespace rules do not allow the
       identifier 'timespec' to appear in the <sys/stat.h> header.
       Therefore we have to handle the use of this header in strictly
       standard-compliant sources special.  */
    {st_atim}	atim	:timespec		/* Time of last access.  */
    {st_mtim}	mtim	:timespec		/* Time of last modification.  */
    {st_ctim}	ctim	:timespec		/* Time of last status change.  */
{st_atim.tv_sec} atime:TIME_T__	/* Backward compatibility.  */
{st_mtim.tv_sec} mtime:TIME_T__
{st_ctim.tv_sec} ctime:TIME_T__
->    {__glibc_reserved}	__glibc_reserved[3]	:ARRAY OF SYSCALL_SLONG_T__
  ENDOBJECT
NATIVE {st_atime} DEF ->st_atim.tv_sec	/* Backward compatibility.  */
NATIVE {st_mtime} DEF ->st_mtim.tv_sec
NATIVE {st_ctime} DEF ->st_ctim.tv_sec

/* Note stat64 has the same shape as stat for x86-64.  */
NATIVE {stat64} OBJECT stat64
    {st_dev}	dev	:DEV_T__		/* Device.  */
    {st_ino}	ino	:INO64_T__		/* File serial number.  */
    {st_nlink}	nlink	:NLINK_T__		/* Link count.  */
    {st_mode}	mode	:MODE_T__		/* File mode.  */
    {st_uid}	uid	:UID_T__		/* User ID of the file's owner.	*/
    {st_gid}	gid	:GID_T__		/* Group ID of the file's group.*/
->    {__pad0}	__pad0	:VALUE
    {st_rdev}	rdev	:DEV_T__		/* Device number, if device.  */
    {st_size}	size	:OFF_T__		/* Size of file, in bytes.  */
    {st_blksize}	blksize	:BLKSIZE_T__	/* Optimal block size for I/O.  */
    {st_blocks}	blocks	:BLKCNT64_T__	/* Nr. 512-byte blocks allocated.  */
    /* Nanosecond resolution timestamps are stored in a format
       equivalent to 'struct timespec'.  This is the type used
       whenever possible but the Unix namespace rules do not allow the
       identifier 'timespec' to appear in the <sys/stat.h> header.
       Therefore we have to handle the use of this header in strictly
       standard-compliant sources special.  */
    {st_atim}	atim	:timespec		/* Time of last access.  */
    {st_mtim}	mtim	:timespec		/* Time of last modification.  */
    {st_ctim}	ctim	:timespec		/* Time of last status change.  */
->    {__glibc_reserved}	__glibc_reserved[3]	:ARRAY OF SYSCALL_SLONG_T__
  ENDOBJECT

/* Tell code we have these members.  */
NATIVE {_STATBUF_ST_BLKSIZE} DEF
NATIVE {_STATBUF_ST_RDEV} DEF
/* Nanosecond resolution time values are supported.  */
NATIVE {_STATBUF_ST_NSEC} DEF

/* Encoding of the file mode.  */

NATIVE {__S_IFMT}	CONST S_IFMT__	= 0170000	/* These bits determine file type.  */

/* File types.  */
NATIVE {__S_IFDIR}	CONST S_IFDIR__	= 0040000	/* Directory.  */
NATIVE {__S_IFCHR}	CONST S_IFCHR__	= 0020000	/* Character device.  */
NATIVE {__S_IFBLK}	CONST S_IFBLK__	= 0060000	/* Block device.  */
NATIVE {__S_IFREG}	CONST S_IFREG__	= 0100000	/* Regular file.  */
NATIVE {__S_IFIFO}	CONST S_IFIFO__	= 0010000	/* FIFO.  */
NATIVE {__S_IFLNK}	CONST S_IFLNK__	= 0120000	/* Symbolic link.  */
NATIVE {__S_IFSOCK}	CONST S_IFSOCK__	= 0140000	/* Socket.  */

/* POSIX.1b objects.  Note that these macros always evaluate to zero.  But
   they do it by enforcing the correct use of the macros.  */
->NATIVE {__S_TYPEISMQ} PROC	->define __S_TYPEISMQ(buf)  ((buf)->st_mode - (buf)->st_mode)
->NATIVE {__S_TYPEISSEM} PROC	->define __S_TYPEISSEM(buf) ((buf)->st_mode - (buf)->st_mode)
->NATIVE {__S_TYPEISSHM} PROC	->define __S_TYPEISSHM(buf) ((buf)->st_mode - (buf)->st_mode)

/* Protection bits.  */

NATIVE {__S_ISUID}	CONST S_ISUID__	= 04000	/* Set user ID on execution.  */
NATIVE {__S_ISGID}	CONST S_ISGID__	= 02000	/* Set group ID on execution.  */
NATIVE {__S_ISVTX}	CONST S_ISVTX__	= 01000	/* Save swapped text after use (sticky).  */
NATIVE {__S_IREAD}	CONST S_IREAD__	= 0400	/* Read by owner.  */
NATIVE {__S_IWRITE}	CONST S_IWRITE__	= 0200	/* Write by owner.  */
NATIVE {__S_IEXEC}	CONST S_IEXEC__	= 0100	/* Execute by owner.  */

 NATIVE {UTIME_NOW}	CONST UTIME_NOW	= ((1 SHL 30) - 1)
 NATIVE {UTIME_OMIT}	CONST UTIME_OMIT	= ((1 SHL 30) - 2)
