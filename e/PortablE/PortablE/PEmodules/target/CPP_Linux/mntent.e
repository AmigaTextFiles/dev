OPT NATIVE
MODULE 'target/features'
MODULE 'target/paths'
PUBLIC MODULE 'target/x86_64-linux-gnu/bits/types/FILE'
{#include <mntent.h>}
/* Utilities for reading/writing fstab, mtab, etc.
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

NATIVE {_MNTENT_H}	CONST ->_MNTENT_H	= 1


/* File listing canonical interesting mount points.  */
NATIVE {MNTTAB}		CONST ->mnttab		= _PATH_MNTTAB	/* Deprecated alias.  */

/* File listing currently active mount points.  */
NATIVE {MOUNTED}		CONST ->mounted		= _PATH_MOUNTED	/* Deprecated alias.  */


/* General filesystem types.  */
NATIVE {MNTTYPE_IGNORE}	CONST
STATIC mnttype_ignore	= 'ignore'	/* Ignore this entry.  */
NATIVE {MNTTYPE_NFS}	CONST
STATIC mnttype_nfs	= 'nfs'		/* Network file system.  */
NATIVE {MNTTYPE_SWAP}	CONST
STATIC mnttype_swap	= 'swap'		/* Swap device.  */


/* Generic mount options.  */
NATIVE {MNTOPT_DEFAULTS}	CONST
STATIC mntopt_defaults	= 'defaults'	/* Use all default options.  */
NATIVE {MNTOPT_RO}	CONST
STATIC mntopt_ro	= 'ro'		/* Read only.  */
NATIVE {MNTOPT_RW}	CONST
STATIC mntopt_rw	= 'rw'		/* Read/write.  */
NATIVE {MNTOPT_SUID}	CONST
STATIC mntopt_suid	= 'suid'		/* Set uid allowed.  */
NATIVE {MNTOPT_NOSUID}	CONST
STATIC mntopt_nosuid	= 'nosuid'	/* No set uid allowed.  */
NATIVE {MNTOPT_NOAUTO}	CONST
STATIC mntopt_noauto	= 'noauto'	/* Do not auto mount.  */


/* Structure describing a mount table entry.  */
NATIVE {mntent} OBJECT mntent
    {mnt_fsname}	fsname	:ARRAY OF CHAR		/* Device or server for filesystem.  */
    {mnt_dir}	dir	:ARRAY OF CHAR		/* Directory mounted on.  */
    {mnt_type}	type	:ARRAY OF CHAR		/* Type of filesystem: ufs, nfs, etc.  */
    {mnt_opts}	opts	:ARRAY OF CHAR		/* Comma-separated options for fs.  */
    {mnt_freq}	freq	:VALUE		/* Dump frequency (in days).  */
    {mnt_passno}	passno	:VALUE		/* Pass number for `fsck'.  */
  ENDOBJECT


/* Prepare to begin reading and/or writing mount table entries from the
   beginning of FILE.  MODE is as for `fopen'.  */
NATIVE {setmntent} PROC
PROC setmntent(__file:ARRAY OF CHAR, __mode:ARRAY OF CHAR) IS NATIVE {setmntent(} __file {,} __mode {)} ENDNATIVE !!PTR TO FILE

/* Read one mount table entry from STREAM.  Returns a pointer to storage
   reused on the next call, or null for EOF or error (use feof/ferror to
   check).  */
NATIVE {getmntent} PROC
PROC getmntent(__stream:PTR TO FILE) IS NATIVE {getmntent(} __stream {)} ENDNATIVE !!PTR TO mntent

/* Reentrant version of the above function.  */
NATIVE {getmntent_r} PROC
PROC getmntent_r(__stream:PTR TO FILE,
				   __result:PTR TO mntent,
				   __buffer:ARRAY OF CHAR,
				   __bufsize:VALUE) IS NATIVE {getmntent_r(} __stream {,} __result {,} __buffer {, (int) } __bufsize {)} ENDNATIVE !!PTR TO mntent

/* Write the mount table entry described by MNT to STREAM.
   Return zero on success, nonzero on failure.  */
NATIVE {addmntent} PROC
PROC addmntent(__stream:PTR TO FILE,
		      __mnt:PTR TO mntent) IS NATIVE {addmntent(} __stream {,} __mnt {)} ENDNATIVE !!VALUE

/* Close a stream opened with `setmntent'.  */
NATIVE {endmntent} PROC
PROC endmntent(__stream:PTR TO FILE) IS NATIVE {endmntent(} __stream {)} ENDNATIVE !!VALUE

/* Search MNT->mnt_opts for an option matching OPT.
   Returns the address of the substring, or null if none found.  */
NATIVE {hasmntopt} PROC
PROC hasmntopt(__mnt:PTR TO mntent,
			__opt:ARRAY OF CHAR) IS NATIVE {hasmntopt(} __mnt {,} __opt {)} ENDNATIVE !!ARRAY OF CHAR
