/* $Id: filesystem.h 28392 2008-04-20 00:20:39Z neil $ */
OPT NATIVE
MODULE 'target/exec/io', 'target/exec/tasks', 'target/dos/dos', 'target/dos/filehandler', 'target/dos/exall'
MODULE 'target/dos/notify', 'target/dos/dosextens', 'target/exec/types', 'target/exec/devices'
{#include <dos/filesystem.h>}
NATIVE {DOS_FILESYSTEM_H} CONST

NATIVE {FSA_OPEN} CONST FSA_OPEN = 1
NATIVE {IFS_OPEN} OBJECT ifs_open
    {io_Filename}	filename	:CONST_STRPTR /* File to open. */
    {io_FileMode}	filemode	:ULONG /* see below */
ENDOBJECT

/* Closes an opened filehandle. Takes no extra arguments. */
NATIVE {FSA_CLOSE} CONST FSA_CLOSE = 2

/* Reads from a filehandle into a buffer. */
NATIVE {FSA_READ} CONST FSA_READ = 3
NATIVE {IFS_READ_WRITE} OBJECT ifs_read_write
    {io_Buffer}	buffer	:ARRAY OF CHAR
    {io_Length}	length	:VALUE
ENDOBJECT

/* Writes the contents of a buffer into a filehandle. Uses IFS_READ_WRITE. */
NATIVE {FSA_WRITE} CONST FSA_WRITE = 4

/* The action does exactly the same as the function Seek(). */
NATIVE {FSA_SEEK} CONST FSA_SEEK = 5
NATIVE {IFS_SEEK} OBJECT ifs_seek
    {io_Offset}	offset	:BIGVALUE 
    {io_SeekMode}	seekmode	:VALUE
ENDOBJECT

/* Sets the size of filehandle. Uses IFS_SEEK (see above) as argument array. */
NATIVE {FSA_SET_FILE_SIZE} CONST FSA_SET_FILE_SIZE = 6

NATIVE {FSA_WAIT_CHAR} CONST FSA_WAIT_CHAR = 7
NATIVE {IFS_WAIT_CHAR} OBJECT ifs_wait_char
    {io_Timeout}	timeout	:VALUE
    {io_Success}	success	:INT
ENDOBJECT

NATIVE {FSA_FILE_MODE} CONST FSA_FILE_MODE = 8
NATIVE {IFS_FILE_MODE} OBJECT ifs_file_mode
    {io_FileMode}	filemode	:ULONG
    {io_Mask}	mask	:ULONG
ENDOBJECT

NATIVE {FSA_IS_INTERACTIVE} CONST FSA_IS_INTERACTIVE = 9
NATIVE {IFS_IS_INTERACTIVE} OBJECT ifs_is_interactive
    {io_IsInteractive}	isinteractive	:INT
ENDOBJECT

/* Compares two locks for equality. */
NATIVE {FSA_SAME_LOCK} CONST FSA_SAME_LOCK = 10
NATIVE {IFS_SAME_LOCK} OBJECT ifs_same_lock
    {io_Lock}	lock[2]	:ARRAY OF APTR /* The two locks to compare. */
    {io_Same}	same	:VALUE    /* This is set to one of LOCK_DIFFERENT or LOCK_SAME (see
                        <dos/dos.h>). */
ENDOBJECT

/* Examines a filehandle, giving various information about it. */
NATIVE {FSA_EXAMINE} CONST FSA_EXAMINE = 11
NATIVE {IFS_EXAMINE} OBJECT ifs_examine
    {io_ead}	ead	:PTR TO exalldata
    {io_Size}	size	:VALUE /* Size of the buffer. */
    {io_Mode}	mode	:VALUE
ENDOBJECT

NATIVE {FSA_EXAMINE_NEXT} CONST FSA_EXAMINE_NEXT = 12
NATIVE {IFS_EXAMINE_NEXT} OBJECT ifs_examine_next
    {io_fib}	fib	:PTR TO fileinfoblock
ENDOBJECT

NATIVE {FSA_EXAMINE_ALL} CONST FSA_EXAMINE_ALL = 13
NATIVE {IFS_EXAMINE_ALL} OBJECT ifs_examine_all
    {io_ead}	ead	:PTR TO exalldata
	 {io_eac}	eac	:PTR TO exallcontrol
    {io_Size}	size	:VALUE /* Size of the buffer. */
    {io_Mode}	mode	:VALUE
ENDOBJECT

NATIVE {FSA_EXAMINE_ALL_END} CONST FSA_EXAMINE_ALL_END = 14

NATIVE {FSA_OPEN_FILE} CONST FSA_OPEN_FILE = 15
NATIVE {IFS_OPEN_FILE} OBJECT ifs_open_file
    {io_Filename}	filename	:CONST_STRPTR   /* File to open. */
    {io_FileMode}	filemode	:ULONG   /* see below */
    {io_Protection}	protection	:ULONG /* The protection bits. */
ENDOBJECT

/* Creates a new directory. The filehandle of that new directory is returned.
*/
NATIVE {FSA_CREATE_DIR} CONST FSA_CREATE_DIR = 16
NATIVE {IFS_CREATE_DIR} OBJECT ifs_create_dir
    {io_Filename}	filename	:CONST_STRPTR   /* Name of directory to create. */
    {io_Protection}	protection	:ULONG /* The protection bits. */
ENDOBJECT

/* Creates a hard link (ie gives one file a second name). */
NATIVE {FSA_CREATE_HARDLINK} CONST FSA_CREATE_HARDLINK = 17
NATIVE {IFS_CREATE_HARDLINK} OBJECT ifs_create_hardlink
    {io_Filename}	filename	:CONST_STRPTR /* The filename of the link to create. */
    {io_OldFile}	oldfile	:APTR  /* Filehandle of the file to link to. */
ENDOBJECT

/* Creates a soft link (ie a file is created, which references another by its
   name). */
NATIVE {FSA_CREATE_SOFTLINK} CONST FSA_CREATE_SOFTLINK = 18
NATIVE {IFS_CREATE_SOFTLINK} OBJECT ifs_create_softlink
    {io_Filename}	filename	:CONST_STRPTR  /* The filename of the link to create. */
    {io_Reference}	reference	:CONST_STRPTR /* The name of the file to link to. */
ENDOBJECT

/* Renames a file. To the old and the new name, the current directory is
   applied to. */
NATIVE {FSA_RENAME} CONST FSA_RENAME = 19
NATIVE {IFS_RENAME} OBJECT ifs_rename
    {io_Filename}	filename	:CONST_STRPTR /* The old filename. */
    {io_NewName}	newname	:CONST_STRPTR  /* The new filename. */
ENDOBJECT

/* Resolves the full path name of the file a softlink filehandle points to. */
NATIVE {FSA_READ_SOFTLINK} CONST FSA_READ_SOFTLINK = 20
NATIVE {IFS_READ_SOFTLINK} OBJECT ifs_read_softlink
    {io_Filename}	filename	:CONST_STRPTR /* file name which returned ERROR_IS_SOFT_LINK */
    {io_Buffer}	buffer	:/*STRPTR*/ ARRAY OF CHAR
    {io_Size}	size	:ULONG
ENDOBJECT

/* Deletes an object on the volume. */
NATIVE {FSA_DELETE_OBJECT} CONST FSA_DELETE_OBJECT = 21
NATIVE {IFS_DELETE_OBJECT} OBJECT ifs_delete_object
    {io_Filename}	filename	:CONST_STRPTR /* The name of the file to delete. */
ENDOBJECT

/* Sets a filecomment for a file. */
NATIVE {FSA_SET_COMMENT} CONST FSA_SET_COMMENT = 22
NATIVE {IFS_SET_COMMENT} OBJECT ifs_set_comment
    {io_Filename}	filename	:CONST_STRPTR /* The name of the file to be commented. */
    {io_Comment}	comment	:CONST_STRPTR  /* The new filecomment. May be NULL, in which case the
                           current filecomment is deleted. */
ENDOBJECT

/* Sets the protection bits of a file. */
NATIVE {FSA_SET_PROTECT} CONST FSA_SET_PROTECT = 23
NATIVE {IFS_SET_PROTECT} OBJECT ifs_set_protect
    {io_Filename}	filename	:CONST_STRPTR   /* The file to change. */
    {io_Protection}	protection	:ULONG /* The new protection bits. */
ENDOBJECT

/* Sets the ownership of a file. */
NATIVE {FSA_SET_OWNER} CONST FSA_SET_OWNER = 24
NATIVE {IFS_SET_OWNER} OBJECT ifs_set_owner
    {io_Filename}	filename	:CONST_STRPTR /* The file to change. */
    {io_UID}	uid	:UINT      /* The new owner. */
    {io_GID}	gid	:UINT      /* The new group owner. */
ENDOBJECT

NATIVE {FSA_SET_DATE} CONST FSA_SET_DATE = 25
NATIVE {IFS_SET_DATE} OBJECT ifs_set_date
    {io_Filename}	filename	:CONST_STRPTR /* The file to change. */
    {io_Date}	date	:datestamp     /* The new date. (see <dos/dosextens.h>) */
ENDOBJECT

/* Check if a filesystem is in fact a FILEsystem, ie can contain different
   files. */
NATIVE {FSA_IS_FILESYSTEM} CONST FSA_IS_FILESYSTEM = 26
NATIVE {IFS_IS_FILESYSTEM} OBJECT ifs_is_filesystem
    {io_IsFilesystem}	isfilesystem	:INT
ENDOBJECT

NATIVE {FSA_MORE_CACHE} CONST FSA_MORE_CACHE = 27
NATIVE {IFS_MORE_CACHE} OBJECT ifs_more_cache
    {io_NumBuffers}	numbuffers	:VALUE
ENDOBJECT

/* Formats a volume, ie erases all data on it. */
NATIVE {FSA_FORMAT} CONST FSA_FORMAT = 28
NATIVE {IFS_FORMAT} OBJECT ifs_format
    {io_VolumeName}	volumename	:CONST_STRPTR /* New name for the volume. */
    {io_DosType}	dostype	:ULONG    /* New type for the volume. Filesystem specific. */
ENDOBJECT

NATIVE {FSA_MOUNT_MODE} CONST FSA_MOUNT_MODE = 29
NATIVE {IFS_MOUNT_MODE} OBJECT ifs_mount_mode
    {io_MountMode}	mountmode	:ULONG
    {io_Mask}	mask	:ULONG
    {io_Password}	password	:CONST_STRPTR
ENDOBJECT

/* The following actions are currently not supported. */
->#if 0
->NATIVE {FSA_SERIALIZE_DISK}  CONST FSA_SERIALIZE_DISK  = 30
->NATIVE {FSA_FLUSH}	    CONST FSA_FLUSH	    = 31
->#endif

NATIVE {FSA_INHIBIT}	    CONST FSA_INHIBIT	    = 32
NATIVE {IFS_INHIBIT} OBJECT ifs_inhibit
    {io_Inhibit}	inhibit	:INT
ENDOBJECT


->#if 0
->NATIVE {FSA_WRITE_PROTECT}   CONST FSA_WRITE_PROTECT   = 33
->NATIVE {FSA_DISK_CHANGE}     CONST FSA_DISK_CHANGE     = 34
->#endif

NATIVE {FSA_ADD_NOTIFY}	    CONST FSA_ADD_NOTIFY	    = 35
NATIVE {IFS_NOTIFY} OBJECT ifs_notify
    {io_FileName}	filename	:CONST_STRPTR		/* Needed for synchronous operation */
    {io_NotificationRequest}	notificationrequest	:PTR TO notifyrequest
ENDOBJECT

/* Uses IFS_NOTIFY */
NATIVE {FSA_REMOVE_NOTIFY}   CONST FSA_REMOVE_NOTIFY   = 36

NATIVE {FSA_DISK_INFO}	    CONST FSA_DISK_INFO	    = 37
NATIVE {IFS_INFO} OBJECT ifs_info
    {io_Info}	info	:PTR TO infodata
ENDOBJECT

NATIVE {FSA_CHANGE_SIGNAL}   CONST FSA_CHANGE_SIGNAL   = 38
NATIVE {IFS_CHANGE_SIGNAL} OBJECT ifs_change_signal
    {io_Task}	task	:PTR TO tc
ENDOBJECT

NATIVE {FSA_LOCK_RECORD}     CONST FSA_LOCK_RECORD     = 39
NATIVE {IFS_RECORD} OBJECT ifs_record
    {io_Offset}	offset	:BIGVALUE
    {io_Size}	size	:VALUE
    {io_RecordMode}	recordmode	:ULONG
    {io_Timeout}	timeout	:ULONG
ENDOBJECT

NATIVE {FSA_UNLOCK_RECORD}   CONST FSA_UNLOCK_RECORD   = 40


NATIVE {FSA_PARENT_DIR}      CONST FSA_PARENT_DIR      = 41
NATIVE {FSA_PARENT_DIR_POST} CONST FSA_PARENT_DIR_POST = 42
NATIVE {IFS_PARENT_DIR} OBJECT ifs_parent_dir
    {io_DirName}	dirname	:ARRAY OF CHAR
ENDOBJECT

/*
    Allows us to change a console between raw and cooked mode.
*/
NATIVE {FSA_CONSOLE_MODE}    CONST FSA_CONSOLE_MODE    = 43
NATIVE {IFS_CONSOLE_MODE} OBJECT ifs_console_mode
    {io_ConsoleMode}	consolemode	:VALUE
ENDOBJECT
NATIVE {FCM_COOKED}	CONST FCM_COOKED	= 0
NATIVE {FCM_RAW}		CONST FCM_RAW		= $1
NATIVE {FCM_NOECHO}  CONST FCM_NOECHO  = $2


NATIVE {FSA_RELABEL}    CONST FSA_RELABEL    = 44
NATIVE {IFS_RELABEL} OBJECT ifs_relabel
    {io_NewName}	newname	:CONST_STRPTR
    {io_Result}	result	:INT
ENDOBJECT

/* FSA_PIPE: create a pair of handles connected to each other */
NATIVE {FSA_PIPE} CONST FSA_PIPE = 45
NATIVE {IFS_PIPE} OBJECT ifs_pipe
    {io_FileName}	filename	:CONST_STRPTR
    {io_Writer}	writer	:PTR TO unit
ENDOBJECT


NATIVE {FMF_LOCK}     CONST FMF_LOCK     = $1 /* Lock exclusively. */
NATIVE {FMF_EXECUTE}  CONST FMF_EXECUTE  = $2 /* Open for executing. */
NATIVE {FMF_WRITE}    CONST FMF_WRITE    = $4  /* Open for writing. */
NATIVE {FMF_READ}     CONST FMF_READ     = $8  /* Open for reading. */
NATIVE {FMF_CREATE}   CONST FMF_CREATE   = $10  /* Create file if it doesn't exist. */
NATIVE {FMF_CLEAR}    CONST FMF_CLEAR    = $20  /* Truncate file on open. */
NATIVE {FMF_RAW}      CONST FMF_RAW      = $40  /* Switch cooked to raw and vice versa. */
NATIVE {FMF_NONBLOCK} CONST FMF_NONBLOCK = $80  /* Don't block Open() in case it would
                                 and return an error in case Write()/Read()
				 would block */
NATIVE {FMF_APPEND}   CONST FMF_APPEND   = $100  /* Every write will happen always at the end of the file */

NATIVE {FMF_AMIGADOS} CONST FMF_AMIGADOS = $80000200 /* Identifies the old AmigaDOS modes:
				      */
NATIVE {FMF_MODE_OLDFILE}   CONST FMF_MODE_OLDFILE   = (FMF_AMIGADOS OR FMF_WRITE OR FMF_READ)
NATIVE {FMF_MODE_READWRITE} CONST FMF_MODE_READWRITE = (FMF_MODE_OLDFILE OR FMF_CREATE)
NATIVE {FMF_MODE_NEWFILE}   CONST FMF_MODE_NEWFILE   = (FMF_MODE_READWRITE OR FMF_LOCK OR FMF_CLEAR)

/* io_MountMode for FSA_MOUNT_MODE. These are flags and may be or'ed. */
NATIVE {MMF_READ}	CONST MMF_READ	= $1 /* Mounted for reading. */
NATIVE {MMF_WRITE}	CONST MMF_WRITE	= $2 /* Mounted for writing. */
NATIVE {MMF_READ_CACHE}	CONST MMF_READ_CACHE	= $4 /* Read cache enabled. */
NATIVE {MMF_WRITE_CACHE} CONST MMF_WRITE_CACHE = $8 /* Write cache enabled. */
NATIVE {MMF_OFFLINE}	CONST MMF_OFFLINE	= $10 /* Filesystem currently does not use the
                                   device. */
NATIVE {MMF_LOCKED}	CONST MMF_LOCKED	= $20 /* Mount mode is password protected. */


NATIVE {IOFileSys} OBJECT iofilesys
    {IOFS}	iofs	:io	  /* Standard I/O request. */
    {io_DosError}	doserror	:VALUE /* Dos error code. */
    {io_PacketEmulation}	packetemulation	:PTR TO dospacket /* Private */
    {io_DirPos}	dirpos	:VALUE   /* The result from telldir() is stored
				      here */

    /* This union contains all the data needed for the various actions. */
    {io_Union.io_OpenDevice.io_DeviceName}	devicename	:/*STRPTR*/ ARRAY OF CHAR /* Name of the device to open. */
    {io_Union.io_OpenDevice.io_Unit}	unit	:ULONG       /* Number of unit to open. */
    {io_Union.io_OpenDevice.io_Environ}	environ	:PTR TO IPTR
    {io_Union.io_OpenDevice.io_DosName}	dosname	:/*STRPTR*/ ARRAY OF CHAR
    {io_Union.io_OpenDevice.io_DeviceNode}	devicenode	:PTR TO devicenode

    {io_Union.io_NamedFile.io_Filename}	filename	:/*STRPTR*/ ARRAY OF CHAR

    {io_Union.io_OPEN}	open	:ifs_open           /* FSA_OPEN */
    {io_Union.io_READ_WRITE}	read_write	:ifs_read_write     /* FSA_READ, FSA_WRITE */
    {io_Union.io_SEEK}	seek	:ifs_seek           /* FSA_SEEK */
    {io_Union.io_WAIT_CHAR}	wait_char	:ifs_wait_char      /* FSA_WAIT_CHAR */
    {io_Union.io_FILE_MODE}	file_mode	:ifs_file_mode      /* FSA_FILE_MODE */
    {io_Union.io_IS_INTERACTIVE}	is_interactive	:ifs_is_interactive /* FSA_IS_INTERACTIVE */
    {io_Union.io_SAME_LOCK}	same_lock	:ifs_same_lock      /* FSA_SAME_LOCK */
    {io_Union.io_EXAMINE}	examine	:ifs_examine        /* FSA_EXAMINE */
    {io_Union.io_EXAMINE_ALL}	examine_all	:ifs_examine_all    /* FSA_EXAMINE_ALL */
    {io_Union.io_EXAMINE_NEXT}	examine_next	:ifs_examine_next   /* FSA_EXAMINE_NEXT */
    {io_Union.io_OPEN_FILE}	open_file	:ifs_open_file      /* FSA_OPEN_FILE */
    {io_Union.io_CREATE_DIR}	create_dir	:ifs_create_dir     /* FSA_CREATE_DIR */
    {io_Union.io_CREATE_HARDLINK}	create_hardlink	:ifs_create_hardlink/* FSA_CREATE_HARDLINK */
    {io_Union.io_CREATE_SOFTLINK}	create_softlink	:ifs_create_softlink/* FSA_CREATE_SOFTLINK */
    {io_Union.io_RENAME}	rename	:ifs_rename         /* FSA_RENAME */
    {io_Union.io_READ_SOFTLINK}	read_softlink	:ifs_read_softlink  /* FSA_READ_SOFTLINK */
    {io_Union.io_DELETE_OBJECT}	delete_object	:ifs_delete_object  /* FSA_DELETE_OBJECT */
    {io_Union.io_SET_COMMENT}	set_comment	:ifs_set_comment    /* FSA_SET_COMMENT */
    {io_Union.io_SET_PROTECT}	set_protect	:ifs_set_protect    /* FSA_SET_PROTECT */
    {io_Union.io_SET_OWNER}	set_owner	:ifs_set_owner      /* FSA_SET_OWNER */
    {io_Union.io_SET_DATE}	set_date	:ifs_set_date       /* FSA_SET_DATE */
    {io_Union.io_IS_FILESYSTEM}	is_filesystem	:ifs_is_filesystem  /* FSA_IS_FILESYSTEM */
    {io_Union.io_MORE_CACHE}	more_cache	:ifs_more_cache     /* FSA_MORE_CACHE */
    {io_Union.io_FORMAT}	format	:ifs_format         /* FSA_FORMAT */
    {io_Union.io_MOUNT_MODE}	mount_mode	:ifs_mount_mode     /* FSA_MOUNT_MODE */
    {io_Union.io_INHIBIT}	inhibit	:ifs_inhibit        /* FSA_INHIBIT */
    {io_Union.io_PARENT_DIR}	parent_dir	:ifs_parent_dir     /* FSA_PARENT_DIR */
    {io_Union.io_CONSOLE_MODE}	console_mode	:ifs_console_mode   /* FSA_CONSOLE_MODE */
    {io_Union.io_RELABEL}	relabel	:ifs_relabel        /* FSA_RELABEL */
    {io_Union.io_NOTIFY}	notify	:ifs_notify         /* FSA_ADD_NOTIFY */
    {io_Union.io_INFO}	info	:ifs_info           /* FSA_INFO */
    {io_Union.io_RECORD}	record	:ifs_record         /* FSA_LOCK_RECORD */
    {io_Union.io_CHANGE_SIGNAL}	change_signal	:ifs_change_signal  /* FSA_CHANGE_SIGNAL */
	{io_Union.io_PIPE}	pipe	:ifs_pipe           /* FSA_PIPE */
ENDOBJECT

NATIVE {io_READ} DEF  ->io_READ_WRITE
NATIVE {io_WRITE} DEF ->io_READ_WRITE
NATIVE {io_SET_FILE_SIZE} DEF ->io_SEEK

/* Define some AROS' specific errors */

NATIVE {ERROR_BROKEN_PIPE}   CONST ERROR_BROKEN_PIPE   = 400  /* An attempt to write on a pipe without any reader has been made */
NATIVE {ERROR_WOULD_BLOCK}   CONST ERROR_WOULD_BLOCK   = 401  /* A Read() or a Write() on a file opened with the FMF_NONBLOCK flag would block */
NATIVE {ERROR_INTERRUPTED}   CONST ERROR_INTERRUPTED   = 402  /* The I/O file operation has been interrupted for some reasons */
