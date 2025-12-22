OPT NATIVE
MODULE 'target/x86_64-linux-gnu/bits/types/struct_statx_timestamp'	->guessed, so that don't need to double-declare "statx_timestamp"
MODULE 'target/x86_64-linux-gnu/bits/types/struct_statx'	->guessed, so that don't need to double-declare "statx"
MODULE 'target/x86_64-linux-gnu/bits/statx-generic'			->guessed, so that don't need to double-declare STATX_TYPE ... STATX_ATTR_AUTOMOUNT
->MODULE 'target/x86_64-linux-gnu/sys/stat'					->guessed, so that don't need to double-declare S_IFMT ... S_ISVTX
MODULE 'target/linux/types'
{#include <linux/stat.h>}
/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
NATIVE {_LINUX_STAT_H} DEF

/*
NATIVE {S_IFMT}  CONST S_IFMT  = 00170000
NATIVE {S_IFSOCK} CONST S_IFSOCK = 0140000
NATIVE {S_IFLNK}  CONST S_IFLNK	 = 0120000
NATIVE {S_IFREG}  CONST S_IFREG  = 0100000
NATIVE {S_IFBLK}  CONST S_IFBLK  = 0060000
NATIVE {S_IFDIR}  CONST S_IFDIR  = 0040000
NATIVE {S_IFCHR}  CONST S_IFCHR  = 0020000
NATIVE {S_IFIFO}  CONST S_IFIFO  = 0010000
NATIVE {S_ISUID}  CONST S_ISUID  = 0004000
NATIVE {S_ISGID}  CONST S_ISGID  = 0002000
NATIVE {S_ISVTX}  CONST S_ISVTX  = 0001000
*/

/*
NATIVE {S_ISLNK} PROC	->define S_ISLNK(m)	(((m) & S_IFMT) == S_IFLNK)
->PROC s_ISLNK(m) IS (m AND S_IFMT) = S_IFLNK
PROC s_ISLNK(m) IS NATIVE {S_ISLNK(} m {)} ENDNATIVE !!LONG <> 0
NATIVE {S_ISREG} PROC	->define S_ISREG(m)	(((m) & S_IFMT) == S_IFREG)
->PROC s_ISREG(m) IS (m AND S_IFMT) = S_IFREG
PROC s_ISREG(m) IS NATIVE {S_ISREG(} m {)} ENDNATIVE !!LONG <> 0
NATIVE {S_ISDIR} PROC	->define S_ISDIR(m)	(((m) & S_IFMT) == S_IFDIR)
->PROC s_ISDIR(m) IS (m AND S_IFMT) = S_IFDIR
PROC s_ISDIR(m) IS NATIVE {S_ISDIR(} m {)} ENDNATIVE !!LONG <> 0
NATIVE {S_ISCHR} PROC	->define S_ISCHR(m)	(((m) & S_IFMT) == S_IFCHR)
->PROC s_ISCHR(m) IS (m AND S_IFMT) = S_IFCHR
PROC s_ISCHR(m) IS NATIVE {S_ISCHR(} m {)} ENDNATIVE !!LONG <> 0
NATIVE {S_ISBLK} PROC	->define S_ISBLK(m)	(((m) & S_IFMT) == S_IFBLK)
->PROC s_ISBLK(m) IS (m AND S_IFMT) = S_IFBLK
PROC s_ISBLK(m) IS NATIVE {S_ISBLK(} m {)} ENDNATIVE !!LONG <> 0
NATIVE {S_ISFIFO} PROC	->define S_ISFIFO(m)	(((m) & S_IFMT) == S_IFIFO)
->PROC s_ISFIFO(m) IS (m AND S_IFMT) = S_IFIFO
PROC s_ISFIFO(m) IS NATIVE {S_ISFIFO(} m {)} ENDNATIVE !!LONG <> 0
NATIVE {S_ISSOCK} PROC	->define S_ISSOCK(m)	(((m) & S_IFMT) == S_IFSOCK)
->PROC s_ISSOCK(m) IS (m AND S_IFMT) = S_IFSOCK
PROC s_ISSOCK(m) IS NATIVE {S_ISSOCK(} m {)} ENDNATIVE !!LONG <> 0
*/

/*
NATIVE {S_IRWXU} CONST S_IRWXU = 00700
NATIVE {S_IRUSR} CONST S_IRUSR = 00400
NATIVE {S_IWUSR} CONST S_IWUSR = 00200
NATIVE {S_IXUSR} CONST S_IXUSR = 00100

NATIVE {S_IRWXG} CONST S_IRWXG = 00070
NATIVE {S_IRGRP} CONST S_IRGRP = 00040
NATIVE {S_IWGRP} CONST S_IWGRP = 00020
NATIVE {S_IXGRP} CONST S_IXGRP = 00010

NATIVE {S_IRWXO} CONST S_IRWXO = 00007
NATIVE {S_IROTH} CONST S_IROTH = 00004
NATIVE {S_IWOTH} CONST S_IWOTH = 00002
NATIVE {S_IXOTH} CONST S_IXOTH = 00001
*/

/*
 * Timestamp structure for the timestamps in struct statx.
 *
 * tv_sec holds the number of seconds before (negative) or after (positive)
 * 00:00:00 1st January 1970 UTC.
 *
 * tv_nsec holds a number of nanoseconds (0..999,999,999) after the tv_sec time.
 *
 * __reserved is held in case we need a yet finer resolution.
 */
/*
NATIVE {statx_timestamp} OBJECT statx_timestamp
	{tv_sec}	sec	:S64__
	{tv_nsec}	nsec	:U32__
->	{__reserved}	__reserved	:S32__
ENDOBJECT
*/

/*
 * Structures for the extended file attribute retrieval system call
 * (statx()).
 *
 * The caller passes a mask of what they're specifically interested in as a
 * parameter to statx().  What statx() actually got will be indicated in
 * st_mask upon return.
 *
 * For each bit in the mask argument:
 *
 * - if the datum is not supported:
 *
 *   - the bit will be cleared, and
 *
 *   - the datum will be set to an appropriate fabricated value if one is
 *     available (eg. CIFS can take a default uid and gid), otherwise
 *
 *   - the field will be cleared;
 *
 * - otherwise, if explicitly requested:
 *
 *   - the datum will be synchronised to the server if AT_STATX_FORCE_SYNC is
 *     set or if the datum is considered out of date, and
 *
 *   - the field will be filled in and the bit will be set;
 *
 * - otherwise, if not requested, but available in approximate form without any
 *   effort, it will be filled in anyway, and the bit will be set upon return
 *   (it might not be up to date, however, and no attempt will be made to
 *   synchronise the internal state first);
 *
 * - otherwise the field and the bit will be cleared before returning.
 *
 * Items in STATX_BASIC_STATS may be marked unavailable on return, but they
 * will have values installed for compatibility purposes so that stat() and
 * co. can be emulated in userspace.
 */
/*
NATIVE {statx} OBJECT statx
	/* 0x00 */
	{stx_mask}	mask	:U32__	/* What results were written [uncond] */
	{stx_blksize}	blksize	:U32__	/* Preferred general I/O size [uncond] */
	{stx_attributes}	attributes	:U64__	/* Flags conveying information about the file [uncond] */
	/* 0x10 */
	{stx_nlink}	nlink	:U32__	/* Number of hard links */
	{stx_uid}	uid	:U32__	/* User ID of owner */
	{stx_gid}	gid	:U32__	/* Group ID of owner */
	{stx_mode}	mode	:U16__	/* File mode */
->	{__spare0}	__spare0	:ARRAY OF U16__
	/* 0x20 */
	{stx_ino}	ino	:U64__	/* Inode number */
	{stx_size}	size	:U64__	/* File size */
	{stx_blocks}	blocks	:U64__	/* Number of 512-byte blocks allocated */
	{stx_attributes_mask}	attributes_mask	:U64__ /* Mask to show what's supported in stx_attributes */
	/* 0x40 */
	{stx_atime}	atime	:statx_timestamp	/* Last access time */
	{stx_btime}	btime	:statx_timestamp	/* File creation time */
	{stx_ctime}	ctime	:statx_timestamp	/* Last attribute change time */
	{stx_mtime}	mtime	:statx_timestamp	/* Last data modification time */
	/* 0x80 */
	{stx_rdev_major}	rdev_major	:U32__	/* Device ID of special file [if bdev/cdev] */
	{stx_rdev_minor}	rdev_minor	:U32__
	{stx_dev_major}	dev_major	:U32__	/* ID of device containing file [uncond] */
	{stx_dev_minor}	dev_minor	:U32__
	/* 0x90 */
->	{__spare2}	__spare2[14]	:ARRAY OF U64__	/* Spare space for future expansion */
	/* 0x100 */
ENDOBJECT
*/

/*
 * Flags to be stx_mask
 *
 * Query request/result mask for statx() and struct statx::stx_mask.
 *
 * These bits should be set in the mask argument of statx() to request
 * particular items when calling statx().
 */
/*
NATIVE {STATX_TYPE}		CONST STATX_TYPE		= $00000001	/* Want/got stx_mode & S_IFMT */
NATIVE {STATX_MODE}		CONST STATX_MODE		= $00000002	/* Want/got stx_mode & ~S_IFMT */
NATIVE {STATX_NLINK}		CONST STATX_NLINK		= $00000004	/* Want/got stx_nlink */
NATIVE {STATX_UID}		CONST STATX_UID		= $00000008	/* Want/got stx_uid */
NATIVE {STATX_GID}		CONST STATX_GID		= $00000010	/* Want/got stx_gid */
NATIVE {STATX_ATIME}		CONST STATX_ATIME		= $00000020	/* Want/got stx_atime */
NATIVE {STATX_MTIME}		CONST STATX_MTIME		= $00000040	/* Want/got stx_mtime */
NATIVE {STATX_CTIME}		CONST STATX_CTIME		= $00000080	/* Want/got stx_ctime */
NATIVE {STATX_INO}		CONST STATX_INO		= $00000100	/* Want/got stx_ino */
NATIVE {STATX_SIZE}		CONST STATX_SIZE		= $00000200	/* Want/got stx_size */
NATIVE {STATX_BLOCKS}		CONST STATX_BLOCKS		= $00000400	/* Want/got stx_blocks */
NATIVE {STATX_BASIC_STATS}	CONST STATX_BASIC_STATS	= $000007ff	/* The stuff in the normal stat struct */
NATIVE {STATX_BTIME}		CONST STATX_BTIME		= $00000800	/* Want/got stx_btime */
NATIVE {STATX_ALL}		CONST STATX_ALL		= $00000fff	/* All currently supported flags */
NATIVE {STATX__RESERVED}		CONST STATX__RESERVED		= $80000000	/* Reserved for future struct statx expansion */
*/

/*
 * Attributes to be found in stx_attributes and masked in stx_attributes_mask.
 *
 * These give information about the features or the state of a file that might
 * be of use to ordinary userspace programs such as GUIs or ls rather than
 * specialised tools.
 *
 * Note that the flags marked [I] correspond to generic FS_IOC_FLAGS
 * semantically.  Where possible, the numerical value is picked to correspond
 * also.
 */
/*
NATIVE {STATX_ATTR_COMPRESSED}		CONST STATX_ATTR_COMPRESSED		= $00000004 /* [I] File is compressed by the fs */
NATIVE {STATX_ATTR_IMMUTABLE}		CONST STATX_ATTR_IMMUTABLE		= $00000010 /* [I] File is marked immutable */
NATIVE {STATX_ATTR_APPEND}		CONST STATX_ATTR_APPEND		= $00000020 /* [I] File is append-only */
NATIVE {STATX_ATTR_NODUMP}		CONST STATX_ATTR_NODUMP		= $00000040 /* [I] File is not to be dumped */
NATIVE {STATX_ATTR_ENCRYPTED}		CONST STATX_ATTR_ENCRYPTED		= $00000800 /* [I] File requires key to decrypt in fs */

NATIVE {STATX_ATTR_AUTOMOUNT}		CONST STATX_ATTR_AUTOMOUNT		= $00001000 /* Dir: Automount trigger */
*/
