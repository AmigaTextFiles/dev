#ifndef _DOSPACKET_H_
#define _DOSPACKET_H_ 1
/* DOSPacket.h
 *
 * Structures and defines needed for Packet-I/O with dos-handlers.
 *
 * You only need this if you whish to do direct I/O with the dos-handlers
 * via sending packets to them, this might be usefull to make asynchrone
 * I/O.
 * Be aware that you have to handle all errors that might occure while doing
 * I/O with the handlers direct.
 */

#ifdef _AMIGA

#ifndef DOS_DOSEXTENS_H
#include <dos/dosextens.h>
#endif

#else

#ifndef _DEFINES_H_
#include <joinOS/exec/defines.h>
#endif

#ifndef _LISTS_H_
#include <joinOS/exec/Lists.h>
#endif

#ifndef _PORTS_H_
#include <joinOS/exec/Ports.h>
#endif

#ifndef _TASKS_H_
#include <joinOS/exec/Tasks.h>
#endif

/* This is the extension of Exec's Messages used by dos
 */

struct DosPacket
{
   struct Message *dp_Link;	/* EXEC message	      */
   struct MsgPort *dp_Port;	/* Reply port for the packet */
				 						/* Must be filled in each send. */
   LONG dp_Type;	 				/* See ACTION_... below and
										 * 'R' means Read, 'W' means Write to the
										 * file system */
   LONG dp_Res1;					/* For file system calls this is the result
										 * that would have been returned by the
										 * function, e.g. Write ('W') returns actual
										 * length written */
   LONG dp_Res2;					/* For file system calls this is what would
										 * have been returned by IoErr() */
   LONG dp_Arg1;
   LONG dp_Arg2;
   LONG dp_Arg3;
   LONG dp_Arg4;
   LONG dp_Arg5;
   LONG dp_Arg6;
   LONG dp_Arg7;
}; /* DosPacket */

/*  Device packets common equivalents */
#define dp_Action  dp_Type
#define dp_Status  dp_Res1
#define dp_Status2 dp_Res2
#define dp_BufAddr dp_Arg1

/* A Packet does not require the Message to be before it in memory, but
 * for convenience it is useful to associate the two.
 * Also see the function init_std_pkt for initializing this structure */

struct StandardPacket
{
   struct Message   sp_Msg;
   struct DosPacket sp_Pkt;
}; /* StandardPacket */

/* Packet types */
#define ACTION_NIL		0
#define ACTION_STARTUP		0
#define ACTION_GET_BLOCK	2	/* OBSOLETE */
#define ACTION_SET_MAP		4
#define ACTION_DIE		5
#define ACTION_EVENT		6
#define ACTION_CURRENT_VOLUME	7
#define ACTION_LOCATE_OBJECT	8
#define ACTION_RENAME_DISK	9
#define ACTION_WRITE		'W'
#define ACTION_READ		'R'
#define ACTION_FREE_LOCK	15
#define ACTION_DELETE_OBJECT	16
#define ACTION_RENAME_OBJECT	17
#define ACTION_MORE_CACHE	18
#define ACTION_COPY_DIR		19
#define ACTION_WAIT_CHAR	20
#define ACTION_SET_PROTECT	21
#define ACTION_CREATE_DIR	22
#define ACTION_EXAMINE_OBJECT	23
#define ACTION_EXAMINE_NEXT	24
#define ACTION_DISK_INFO	25
#define ACTION_INFO		26
#define ACTION_FLUSH		27
#define ACTION_SET_COMMENT	28
#define ACTION_PARENT		29
#define ACTION_TIMER		30
#define ACTION_INHIBIT		31
#define ACTION_DISK_TYPE	32
#define ACTION_DISK_CHANGE	33
#define ACTION_SET_DATE		34

#define ACTION_SCREEN_MODE	994

#define ACTION_READ_RETURN	1001
#define ACTION_WRITE_RETURN	1002
#define ACTION_SEEK		1008
#define ACTION_FINDUPDATE	1004
#define ACTION_FINDINPUT	1005
#define ACTION_FINDOUTPUT	1006
#define ACTION_END		1007
#define ACTION_SET_FILE_SIZE	1022	/* fast file system only in 1.3 */
#define ACTION_WRITE_PROTECT	1023	/* fast file system only in 1.3 */

/* new 2.0 packets */
#define ACTION_SAME_LOCK	40
#define ACTION_CHANGE_SIGNAL	995
#define ACTION_FORMAT		1020
#define ACTION_MAKE_LINK	1021
/**/
/**/
#define ACTION_READ_LINK	1024
#define ACTION_FH_FROM_LOCK	1026
#define ACTION_IS_FILESYSTEM	1027
#define ACTION_CHANGE_MODE	1028
/**/
#define ACTION_COPY_DIR_FH	1030
#define ACTION_PARENT_FH	1031
#define ACTION_EXAMINE_ALL	1033
#define ACTION_EXAMINE_FH	1034

#define ACTION_LOCK_RECORD	2008
#define ACTION_FREE_RECORD	2009

#define ACTION_ADD_NOTIFY	4097
#define ACTION_REMOVE_NOTIFY	4098

/* Added in V39: */
#define ACTION_EXAMINE_ALL_END	1035
#define ACTION_SET_OWNER	1036

/* Tell a file system to serialize the current volume. This is typically
 * done by changing the creation date of the disk. This packet does not take
 * any arguments.  NOTE: be prepared to handle failure of this packet for
 * V37 ROM filesystems.
 */
#define	ACTION_SERIALIZE_DISK	4200

#endif		/* _AMIGA */

/* Added for Windoof: */

/* This "actions" are for the ROM-filesytem handlers of dos.library.
 * They are used to get the path of a filesystem object without the often
 *	process switches needed for the old compatible mode by sending consequent
 * ACTION_EXAMINE and ACTION_PARENT until the root is reached.
 *
 * If this packet-type is send to an AmigaDos handler this will usually
 * reply DOSFALSE with a secondary result of ERROR_ACTION_NOT_KNOWN.
 */

#define ACTION_NAME_FROM_LOCK		2150	/* dos.library's NameFromLock() */
#define ACTION_NAME_FROM_FH		2151	/* dos.library's NameFromFH() */

/* The packet has to be defined as follows:
 *		dp_Type - ACTION_NAME_FROM_LOCK
 *		dp_Arg1 - BPTR to struct FileLock
 *		dp_Arg2 - UBYTE* to buffer for path (MEMF_PUBLIC)
 *		dp_Arg3 - LONG buffer size
 *		dp_Res1 - LONG number of bytes copied to buffer (without terminating NUL)
 *							or -1 in the event of an error
 *		dp_Res2 - LONG AmigaDos error code if dp_Res1 == -1
 *
 * or:
 *		dp_Type - ACTION_NAME_FROM_FH
 *		dp_Arg1 - fh->fh_Arg1
 *		dp_Arg2 - UBYTE* to buffer for path (MEMF_PUBLIC)
 *		dp_Arg3 - LONG buffer size
 *		dp_Res1 - LONG number of bytes copied to buffer (without terminating NUL)
 *							or -1 in the event of an error
 *		dp_Res2 - LONG AmigaDos error code if dp_Res1 == -1
 *
 * If dp_Res1 is equal -1, the contents of the buffer is undefined.
 */

#endif		/* _DOSPACKET_H_ */
