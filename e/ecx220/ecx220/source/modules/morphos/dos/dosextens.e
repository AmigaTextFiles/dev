OPT MODULE
OPT EXPORT

MODULE 'devices/timer',
       'dos/dos',
       'exec/libraries',
       'exec/lists',
       'exec/nodes',
       'exec/ports',
       'exec/semaphores',
       'exec/tasks'

OBJECT process
  task:tc
  msgport:mp
  pad:INT
  seglist:LONG
  stacksize:LONG
  globvec:LONG
  tasknum:LONG
  stackbase:LONG
  result2:LONG
  currentdir:LONG
  cis:LONG
  cos:LONG
  consoletask:LONG
  filesystemtask:LONG
  cli:LONG
  returnaddr:LONG
  pktwait:LONG
  windowptr:LONG
  homedir:LONG
  flags:LONG
  exitcode:LONG
  exitdata:LONG
  arguments:PTR TO CHAR
  localvars:mlh
  shellprivate:LONG
  ces:LONG
ENDOBJECT     /* SIZEOF=228 */

CONST PRB_FREESEGLIST=0,
      PRF_FREESEGLIST=1,
      PRB_FREECURRDIR=1,
      PRF_FREECURRDIR=2,
      PRB_FREECLI=2,
      PRF_FREECLI=4,
      PRB_CLOSEINPUT=3,
      PRF_CLOSEINPUT=8,
      PRB_CLOSEOUTPUT=4,
      PRF_CLOSEOUTPUT=16,
      PRB_FREEARGS=5,
      PRF_FREEARGS=$20

OBJECT filehandle
  link:PTR TO mn
  interactive:PTR TO mp
  type:PTR TO mp
  buf:LONG
  pos:LONG
  end:LONG
  funcs:LONG
  func2:LONG
  func3:LONG
  args:LONG
  arg2:LONG
ENDOBJECT     /* SIZEOF=44 */

OBJECT dospacket
  link:PTR TO mn
  port:PTR TO mp
  type:LONG
  res1:LONG
  res2:LONG
  arg1:LONG
  arg2:LONG
  arg3:LONG
  arg4:LONG
  arg5:LONG
  arg6:LONG
  arg7:LONG

/* ECX "unions" */
  action:LONG @ type
  status:LONG @ res1
  status2:LONG @ res2
  bufaddr:LONG @ arg1
ENDOBJECT     /* SIZEOF=48 */

OBJECT standardpacket
  msg:mn
  pkt:dospacket
ENDOBJECT     /* SIZEOF=68 */

CONST ACTION_NIL=0,
      ACTION_STARTUP=0,
      ACTION_GET_BLOCK=2,
      ACTION_SET_MAP=4,
      ACTION_DIE=5,
      ACTION_EVENT=6,
      ACTION_CURRENT_VOLUME=7,
      ACTION_LOCATE_OBJECT=8,
      ACTION_RENAME_DISK=9,
      ACTION_WRITE=$57,
      ACTION_READ=$52,
      ACTION_FREE_LOCK=15,
      ACTION_DELETE_OBJECT=16,
      ACTION_RENAME_OBJECT=17,
      ACTION_MORE_CACHE=18,
      ACTION_COPY_DIR=19,
      ACTION_WAIT_CHAR=20,
      ACTION_SET_PROTECT=21,
      ACTION_CREATE_DIR=22,
      ACTION_EXAMINE_OBJECT=23,
      ACTION_EXAMINE_NEXT=24,
      ACTION_DISK_INFO=25,
      ACTION_INFO=26,
      ACTION_FLUSH=27,
      ACTION_SET_COMMENT=28,
      ACTION_PARENT=29,
      ACTION_TIMER=30,
      ACTION_INHIBIT=31,
      ACTION_DISK_TYPE=$20,
      ACTION_DISK_CHANGE=$21,
      ACTION_SET_DATE=$22,
      ACTION_SCREEN_MODE=$3E2,
      ACTION_READ_RETURN=$3E9,
      ACTION_WRITE_RETURN=$3EA,
      ACTION_SEEK=$3F0,
      ACTION_FINDUPDATE=$3EC,
      ACTION_FINDINPUT=$3ED,
      ACTION_FINDOUTPUT=$3EE,
      ACTION_END=$3EF,
      ACTION_SET_FILE_SIZE=$3FE,
      ACTION_WRITE_PROTECT=$3FF,
      ACTION_SAME_LOCK=$28,
      ACTION_CHANGE_SIGNAL=$3E3,
      ACTION_FORMAT=$3FC,
      ACTION_MAKE_LINK=$3FD,
      ACTION_READ_LINK=$400,
      ACTION_FH_FROM_LOCK=$402,
      ACTION_IS_FILESYSTEM=$403,
      ACTION_CHANGE_MODE=$404,
      ACTION_COPY_DIR_FH=$406,
      ACTION_PARENT_FH=$407,
      ACTION_EXAMINE_ALL=$409,
      ACTION_EXAMINE_FH=$40A,
      ACTION_LOCK_RECORD=$7D8,
      ACTION_FREE_RECORD=$7D9,
      ACTION_ADD_NOTIFY=$1001,
      ACTION_REMOVE_NOTIFY=$1002,
      ACTION_EXAMINE_ALL_END=$40B,
      ACTION_SET_OWNER=$40C,
      ACTION_SERIALIZE_DISK=$1068


CONST ACTION_GET_DISK_FSSM  =  4201,
      ACTION_FREE_DISK_FSSM =  4202


/* 64bit DOS extensions - V51 */

/* ACTION_SEEK64
 * dp_Arg1 - LONG fh_Arg1
 * dp_Arg2 - QUAD *position
 * dp_Arg3 - LONG mode
 * dp_Arg4 - QUAD *oldposition
 *
 * dp_Res1 - DOSFALSE for error (*oldposition is undefined!), dp_Res2 set
 *           DOSTRUE for success (*oldposition is the old seek position)
 *
 * Implementation notes
 * - Notice the different return value to ACTION_SEEK.
 * - ACTION_SEEK64 must work for all files.
 * - ACTION_SEEK should work for > 2^31-1 files aswell, as long as possible.
 *   Largefile ACTION_SEEK must fail with ERROR_SEEK_ERROR if:
 *   a) the current seek position before the call is > 2^31-1 or
 *   b) OFFSET_BEGINNING is used with position < 0 or
 *   c) OFFSET_END is used with position > 0
 *   d) the seek would result in having seek position in > 2^31-1 area.
 */
CONST ACTION_SEEK64    =       26400

/* ACTION_SET_FILE_SIZE64
 * dp_Arg1 - LONG fh_Arg1
 * dp_Arg2 - QUAD *position
 * dp_Arg3 - LONG mode
 * dp_Arg4 - QUAD *newsize
 *
 * dp_Res1 - DOSFALSE for error (*newsize is undefined!), dp_Res2 set
 *           DOSTRUE for success (*newsize is the new file size)
 *
 * Implementation notes
 * - ACTION_SET_FILE_SIZE64 must work for all files.
 * - ACTION_SET_FILE_SIZE should fail for > 2^31-1 files, for security
 *   reasons (dataloss is possible with old apps).
 */
CONST ACTION_SET_FILE_SIZE64 = 26401

/* ACTION_LOCK_RECORD64
 * dp_Arg1 - LONG fh_Arg1
 * dp_Arg2 - UQUAD *offset
 * dp_Arg3 - UQUAD *length
 * dp_Arg4 - ULONG mode
 * dp_Arg5 - ULONG timeout
 *
 * dp_Res1 - DOSFALSE for error, dp_Res2 set
 *           DOSTRUE for success
 *
 * Implementation notes
 * - ACTION_LOCK_RECORD64 must work for all files, but naturally
 *   fail if locking out of bounds is attempted.
 * - ACTION_LOCK_RECORD must work for > 2^31-1 files aswell,
 *   if offset and length are within 31bit range.
 * - Record locks are rarely used, so it's not fatal to return DOSFALSE
 *   with ERROR_ACTION_NOT_KNOWN.
 *
 */
CONST ACTION_LOCK_RECORD64  =  26402

/* ACTION_FREE_RECORD64
 * dp_Arg1 - LONG fh_Arg1
 * dp_Arg2 - UQUAD *offset
 * dp_Arg3 - UQUAD *length
 *
 * dp_Res1 - DOSFALSE for error, dp_Res2 set
 *           DOSTRUE for success
 *
 * Implementation notes
 * - ACTION_FREE_RECORD64 must work for all files.
 * - ACTION_FREE_RECORD must work for > 2^31-1 files aswell,
 *   if offset and length are within 31bit range.
 * - Record locks are rarely used, so it's not fatal to return DOSFALSE
 *   with ERROR_ACTION_NOT_KNOWN.
 */
CONST ACTION_FREE_RECORD64  =  26403

/* Reserved packet number - do not use
 */
CONST ACTION_RESERVED_1     =  26404

/* Reserved packet number - do not use
 */
CONST ACTION_RESERVED_2    =   26405

/* ACTION_NEW_READ_LINK
 * dp_Arg1 - BPTR lock, lock on directory that dp_Arg2 is relative to
 * dp_Arg2 - UBYTE *name, path and name of link (relative to dp_Arg1)
 * dp_Arg3 - UBYTE *buffer
 * dp_Arg4 - LONG buffersize
 *
 * dp_Res1 - Actual length of returned string, -2 if there isn't
 *           enough space in buffer, or -1 for other errors.
 *           0 return is error aswell (dp_Res2 is ERROR_ACTION_NOT_KNOWN likely)
 * dp_Res2 - 0 for successful return (dp_Res1 > 0), else ioerr code.
 *
 * Implementation notes
 * - ACTION_NEW_READ_LINK cause a linked object to be examined, and
 *   the path to the object linked to to be returned. It works both
 *   for soft and hard linked objects, as opposed to the original
 *   ACTION_READ_LINK packet which only works for soft linked
 *   objects.
 * - returns required buffer size in dp_Res1 if called with NULL
 *   buffer, including storage for string terminating '\0'.
 * - ACTION_NEW_READ_LINK should be well behaving, and handling all
 *   weird cases properly (see Olaf Barthel's docs and FFS2
 *   ACTION_READ_LINK for details).
 */
CONST ACTION_NEW_READ_LINK =   26406

/* ACTION_QUERY_ATTR
 * dp_Arg1 - LONG attr, which attribute you want to know about
 * dp_Arg2 - void *storage, memory to hold the return value
 * dp_Arg3 - LONG storagesize, size of storage reserved for
 *
 * dp_Res1 - DOSFALSE for error, dp_Res2 set
 *           DOSTRUE for success
 *
 * Implementation notes
 * - Unknown attributes must return DOSFALSE and dp_Res2 of
 *   ERROR_BAD_NUMBER. This instructs dos.library GetFileSysAttr()
 *   to fall back to emulation code.
 * - If result doesn't fit the storage, must return DOSFALSE
 *   and dp_Res2 of ERROR_LINE_TOO_LONG.
 * - Largefile filesystems MUST support this packet and
 *   FQA_MaximumFileSize attribute.
 * - Filesystems that can grow larger than 2TB (or actually fs where
 *   ACTION_DISK_INFO/ACTION_INFO NumBlocks and NumBlocksUsed can grow
 *   past 2^32-1) must implemented this packet and at least
 *   FQA_NumBlocks and FQA_NumBlocksUsed attributes.
 */
CONST ACTION_QUERY_ATTR    =   26407

/* ACTION_EXAMINE_OBJECT64
 * dp_Arg1 - BPTR to lock to examine
 * dp_Arg2 - BPTR to struct FileInfoBlock (see <dos/dos.h>)
 * dp_Arg3 - struct TagItem *taglist, no tags are defined for now (not BPTR!)
 *
 * dp_Res1 - DOSFALSE for error, dp_Res2 set
 *           DOSTRUE for success
 *
 * Implementation notes
 * - ACTION_EXAMINE_OBJECT and ACTION_EXAMINE_OBJECT64 must set
 *   fib_Size to 0 for files > 2^31-1.
 * - ACTION_EXAMINE_OBJECT64 must fill new fields: fib_Size64 and
 *   fib_NumBlocks64.
 * - Largefile filesystems MUST support this packet, aswell as
 *   ACTION_EXAMINE_NEXT64 and ACTION_EXAMINE_FH64.
 * - It is recommended that your implementation supports mixing
 *   ACTION_EXAMINE_OBJECT64 and ACTION_EXAMINE_NEXT.
 * - largefile filesystems must implement ACTION_EXAMINE_ALL with
 *   ED_SIZE64 (ed_Size64 field), and set ed_Size to 0 for files >
 *   2^31-1. Obviously ed_Size64 must be set for files < 2^31-1
 *   aswell.
 */
CONST ACTION_EXAMINE_OBJECT64 = 26408

/* ACTION_EXAMINE_NEXT64
 * dp_Arg1 - BPTR to directory lock to examine
 * dp_Arg2 - BPTR to struct FileInfoBlock (see <dos/dos.h>)
 * dp_Arg3 - struct TagItem *taglist, no tags are defined for now (not BPTR!)
 *
 * dp_Res1 - DOSFALSE for error, dp_Res2 set
 *           DOSTRUE for success,
 *
 * Implementation notes
 * - ACTION_EXAMINE_NEXT and ACTION_EXAMINE_NEXT64 must set
 *   fib_Size to 0 for files > 2^31-1.
 * - ACTION_EXAMINE_NEXT64 must fill a new fields: fib_Size64 and
 *   fib_NumBlocks64.
 * - Largefile filesystems MUST support this packet, aswell as
 *   ACTION_EXAMINE_OBJECT64 and ACTION_EXAMINE_FH64.
 * - It is recommended that your implementation supports mixing
 *   ACTION_EXAMINE_OBJECT and ACTION_EXAMINE_NEXT64.
 * - largefile filesystems must implement ACTION_EXAMINE_ALL with
 *   ED_SIZE64 (ed_Size64 field), and set ed_Size to 0 for files >
 *   2^31-1. Obviously ed_Size64 must be set for files < 2^31-1
 *   aswell.
 */
CONST ACTION_EXAMINE_NEXT64 =  26409

/* ACTION_EXAMINE_FH64
 * dp_Arg1 - LONG fh_Arg1
 * dp_Arg2 - BPTR to struct FileInfoBlock (see <dos/dos.h>)
 * dp_Arg3 - struct TagItem *taglist, no tags are defined for now (not BPTR!)
 *
 * dp_Res1 - DOSFALSE for error, dp_Res2 set
 *           DOSTRUE for success
 *
 * Implementation notes
 * - ACTION_EXAMINE_FH and ACTION_EXAMINE_FH64 must set
 *   fib_Size to 0 for files > 2^31-1.
 * - ACTION_EXAMINE_FH64 must fill a new field: fib_Size64 and
 *   fib_NumBlocks64.
 * - Largefile filesystems MUST support this packet, aswell as
 *   ACTION_EXAMINE_OBJECT64 and ACTION_EXAMINE_NEXT64.
 * - largefile filesystems must implement ACTION_EXAMINE_ALL with
 *   ED_SIZE64 (ed_Size64 field), and set ed_Size to 0 for files >
 *   2^31-1. Obviously ed_Size64 must be set for files < 2^31-1
 *   aswell.
 */
CONST ACTION_EXAMINE_FH64  =   26410

/* GetFileSysAttr attribute types
 */

/* Return the maximum length of a file name (in characters),
 * excluding terminating '\0' char.
 *
 * type: LONG
 */
CONST FQA_MaxFileNameLength =  0

/* Return the maximum length of the volume name (in characters),
 * excluding terminating '\0' char.
 *
 * type: LONG
 */
CONST FQA_MaxVolumeNameLength  = 1

/* Returns maximum size of the file the filesystem supports.
 * This attribute is meat to help system components/applications
 * to know if they can create large files or if they need to
 * resort to other means (split files). This attribute need not
 * account for currently available disk storage.
 *
 * type: QUAD
 */
CONST FQA_MaxFileSize      =   2

/* If the filesystem names are case sensitive, this attribute must
 * return TRUE.
 *
 * If this attribute return FALSE or is not implemented, filesystem is
 * assumed to be case insensitive.
 *
 * type: LONG
 */
CONST FQA_IsCaseSensitive  =   3

/* Return the type of the medium the filesystem is using, if known.
 * Value is one of DG_#? in devices/trackdisk.h.
 *
 * If this attribute return DG_UNKNOWN or is not implemented, no
 * assumptation of the device type can be made. DG_COMMUNICATION
 * is networked drive.
 *
 * type: LONG
 */
CONST FQA_DeviceType       =   4

/* This FQA attribute is reserved - do not use
 * In filesystem implementation return DOSFALSE with error ERROR_BAD_NUMBER
 * (as the filesystem doesn't know about this attribute).
 */
CONST FQA_ReservedAttr1    =   5

/* Return the total number of blocks on the filesystem. The size of a
 * block is the filesystem natural block size, also returned in struct
 * InfoData id_BytesPerBlock. This allows reporting filesystem capacity
 * of over 2TB.
 *
 * type: QUAD
 */
CONST FQA_NumBlocks        =   6

/* Return the total number of used blocks on the filesystem. The size of
 * a block is the filesystem natural block size, also returned in struct
 * InfoData id_BytesPerBlock. This allows reporting filesystem capacity
 * of over 2TB.
 *
 * type: QUAD
 */
CONST FQA_NumBlocksUsed    =   7


/*
 * Packets to get and set filesystem options runtime
 */
CONST ACTION_GET_PREFS_TEMPLATE = 26500 /* arg1 - STRPTR dest_buff, arg2 - LONG buffer_size */
CONST ACTION_GET_CURRENT_PREFS  = 26501 /* arg1 - STRPTR dest_buff, arg2 - LONG buffer_size */
CONST ACTION_SET_PREFS          = 26502 /* arg1 - STRPTR prefs_string */


OBJECT errorstring
  nums:PTR TO LONG
  strings:PTR TO CHAR
ENDOBJECT     /* SIZEOF=8 */

OBJECT doslibrary
  lib:lib
  root:PTR TO rootnode
  gv:LONG
  a2:LONG
  a5:LONG
  a6:LONG
  errors:PTR TO errorstring
  timereq:PTR TO timerequest
  utilitybase:PTR TO lib
  intuitionbase:PTR TO lib
ENDOBJECT     /* SIZEOF=70 */

OBJECT rootnode
  taskarray:LONG
  consolesegment:LONG
  time:datestamp
  restartseg:LONG
  info:LONG
  filehandlersegment:LONG
  clilist:mlh
  bootproc:PTR TO mp
  shellsegment:LONG
  flags:LONG
ENDOBJECT     /* SIZEOF=56 */

CONST RNB_WILDSTAR=24,
      RNF_WILDSTAR=$1000000,
      RNB_PRIVATE1=1,
      RNF_PRIVATE1=2

OBJECT cliproclist
  node:mln
  first:LONG
-> Um, this is really PTR TO PTR TO mp
  array:PTR TO LONG
ENDOBJECT     /* SIZEOF=16 */

OBJECT dosinfo
  mcname:LONG
  devinfo:LONG
  devices:LONG
  handlers:LONG
  nethand:LONG
  devlock:ss
  entrylock:ss
  deletelock:ss
ENDOBJECT     /* SIZEOF=158 */

OBJECT segment
  next:LONG
  uc:LONG
  seg:LONG
  name[4]:ARRAY
ENDOBJECT     /* SIZEOF=16 */

CONST CMD_SYSTEM=-1,
      CMD_INTERNAL=-2,
      CMD_DISABLED=$FFFFFC19

OBJECT commandlineinterface
  result2:LONG
  setname:PTR TO CHAR
  commanddir:LONG
  returncode:LONG
  commandname:PTR TO CHAR
  faillevel:LONG
  prompt:PTR TO CHAR
  standardinput:LONG
  currentinput:LONG
  commandfile:PTR TO CHAR
  interactive:LONG
  background:LONG
  currentoutput:LONG
  defaultstack:LONG
  standardoutput:LONG
  module:LONG
ENDOBJECT     /* SIZEOF=64 */

OBJECT devlist
  next:LONG
  type:LONG
  task:PTR TO mp
  lock:LONG
  volumedate:datestamp
  locklist:LONG
  disktype:LONG
  unused:LONG
  name:PTR TO CHAR
ENDOBJECT     /* SIZEOF=44 */

OBJECT devinfo
  next:LONG
  type:LONG
  task:LONG
  lock:LONG
  handler:PTR TO CHAR
  stacksize:LONG
  priority:LONG
  startup:LONG
  seglist:LONG
  globvec:LONG
  name:PTR TO CHAR
ENDOBJECT     /* SIZEOF=44 */

OBJECT doslist
  next:LONG
  type:LONG
  task:PTR TO mp
  lock:LONG

  assignname:PTR TO CHAR
  list:PTR TO assignlist
  priority:LONG
  startup:LONG
  seglist:LONG
  globvec:LONG
  name:PTR TO CHAR

  /* ECX "unions" */
  volumedate:datestamp @ assignname
  handler:PTR TO CHAR @ assignname
  stacksize:LONG @ list
  locklist:LONG @ startup
  disktype:LONG @ seglist

ENDOBJECT     /* SIZEOF=44 */

-> Um, this object was missing
OBJECT assignlist
  next:PTR TO assignlist
  lock:LONG
ENDOBJECT

CONST DLT_DEVICE=0,
      DLT_DIRECTORY=1,
      DLT_VOLUME=2,
      DLT_LATE=3,
      DLT_NONBINDING=4,
      DLT_PRIVATE=-1,
      /*** V51 (MorphOS) ***/
      DLT_FSCONTEXT  =  5

OBJECT devproc
  port:PTR TO mp
  lock:LONG
  flags:LONG
  devnode:PTR TO doslist
ENDOBJECT     /* SIZEOF=16 */

CONST DVPB_UNLOCK=0,
      DVPF_UNLOCK=1,
      DVPB_ASSIGN=1,
      DVPF_ASSIGN=2

      /*** V51 (MorphOS) ***/
CONST DVPB_FSCONTEXT =  2
CONST DVPF_FSCONTEXT =  (1 << DVPB_FSCONTEXT)

CONST LDB_DEVICES=2,
      LDF_DEVICES=4,
      LDB_VOLUMES=3,
      LDF_VOLUMES=8,
      LDB_ASSIGNS=4,
      LDF_ASSIGNS=16,
      LDB_ENTRY=5,
      LDF_ENTRY=$20,
      LDB_DELETE=6,
      LDF_DELETE=$40,
      LDB_READ=0,
      LDF_READ=1,
      LDB_WRITE=1,
      LDF_WRITE=2,
      LDF_ALL=28

OBJECT filelock
  link:LONG
  key:LONG
  access:LONG
  task:PTR TO mp
  volume:LONG
ENDOBJECT     /* SIZEOF=20 */

CONST REPORT_STREAM=0,
      REPORT_TASK=1,
      REPORT_LOCK=2,
      REPORT_VOLUME=3,
      REPORT_INSERT=4,
      ABORT_DISK_ERROR=$128,
      ABORT_BUSY=$120,
      RUN_EXECUTE=-1,
      RUN_SYSTEM=-2,
      RUN_SYSTEM_ASYNCH=-3,
      ST_ROOT=1,
      ST_USERDIR=2,
      ST_SOFTLINK=3,
      ST_LINKDIR=4,
      ST_FILE=-3,
      ST_LINKFILE=-4,
      ST_PIPEFILE=-5

