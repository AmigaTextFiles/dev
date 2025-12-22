@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "dos/dos.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT infodata
@{fg shine}(   0)@{fg text}   numsofterrors:LONG
@{fg shine}(   4)@{fg text}   unitnumber:LONG
@{fg shine}(   8)@{fg text}   diskstate:LONG
@{fg shine}(  12)@{fg text}   numblocks:LONG
@{fg shine}(  16)@{fg text}   numblocksused:LONG
@{fg shine}(  20)@{fg text}   bytesperblock:LONG
@{fg shine}(  24)@{fg text}   disktype:LONG
@{fg shine}(  28)@{fg text}   volumenode:LONG
@{fg shine}(  32)@{fg text}   inuse:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=36 */

@{fg shine}(----)@{fg text} OBJECT fileinfoblock
@{fg shine}(   0)@{fg text}   diskkey:LONG
@{fg shine}(   4)@{fg text}   direntrytype:LONG
@{fg shine}(   8)@{fg text}   filename[108]:ARRAY OF CHAR
@{fg shine}( 116)@{fg text}   protection:LONG
@{fg shine}( 120)@{fg text}   entrytype:LONG
@{fg shine}( 124)@{fg text}   size:LONG
@{fg shine}( 128)@{fg text}   numblocks:LONG
@{fg shine}( 132)@{fg text}   datestamp:datestamp @{fg shine}(or ARRAY OF datestamp)@{fg text}
@{fg shine}( 144)@{fg text}   comment[80]:ARRAY OF CHAR
@{fg shine}( 224)@{fg text}   owneruid:INT
@{fg shine}( 226)@{fg text}   ownergid:INT
@{fg shine}( 228)@{fg text}   reserved[32]:ARRAY OF CHAR
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=260 */

@{fg shine}(----)@{fg text} OBJECT datestamp
@{fg shine}(   0)@{fg text}   days:LONG
@{fg shine}(   4)@{fg text}   minute:LONG
@{fg shine}(   8)@{fg text}   tick:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=12 */

CONST ERROR_KEY_NEEDS_ARG=$75,
      ERROR_NO_DEFAULT_DIR=$C9,
      ERROR_NO_MORE_ENTRIES=$E8,
      ERROR_OBJECT_WRONG_TYPE=$D4,
      LOCK_SAME=0,
      ID_NO_DISK_PRESENT=-1,
      ITEM_QUOTED=2,
      ITEM_UNQUOTED=1,
      FIBF_EXECUTE=2,
      FIBF_GRP_EXECUTE=$200,
      FIBF_OTR_EXECUTE=$2000,
      FIBB_EXECUTE=1,
      FIBB_GRP_EXECUTE=9,
      FIBB_OTR_EXECUTE=13,
      LOCK_SAME_HANDLER=1,
      FIBF_WRITE=4,
      FIBF_GRP_WRITE=$400,
      FIBF_OTR_WRITE=$4000,
      FIBB_WRITE=2,
      FIBB_GRP_WRITE=10,
      FIBB_OTR_WRITE=14,
      ACCESS_WRITE=-1,
      MODE_READWRITE=$3EC,
      ERROR_UNMATCHED_QUOTES=$77,
      ERROR_TOO_MANY_LEVELS=$D9,
      RETURN_OK=0,
      ERROR_OBJECT_EXISTS=$CB,
      CHANGE_LOCK=0,
      ERROR_INVALID_LOCK=$D3,
      EXCLUSIVE_LOCK=-1,
      SHARED_LOCK=-2,
      RETURN_FAIL=20,
      ID_VALIDATING=$51,
      ID_NOT_REALLY_DOS=$4E444F53,
      DOS_EXALLCONTROL=1,
      ERROR_FILE_NOT_OBJECT=$79,
      ERROR_INVALID_RESIDENT_LIBRARY=$7A,
      OFFSET_END=1,
      RETURN_WARN=5,
      ERROR_OBJECT_IN_USE=$CA,
      ERROR_LOCK_TIMEOUT=$F2,
      DOS_FIB=2,
      LINK_SOFT=1,
      LOCK_SAME_VOLUME=1,
      ERROR_BAD_NUMBER=$73,
      ITEM_ERROR=-1,
      RETURN_ERROR=10,
      ERROR_UNLOCK_ERROR=$F3,
      ERROR_SEEK_ERROR=$DB,
      ERROR_BAD_HUNK=$EB,
      BITSPERBYTE=8,
      ERROR_DISK_FULL=$DD,
      ERROR_TASK_TABLE_FULL=$69,
      ERROR_COMMENT_TOO_BIG=$DC,
      DOS_FILEHANDLE=0,
      CHANGE_FH=1,
      ERROR_ACTION_NOT_KNOWN=$D1,
      DOS_STDPKT=3,
      ERROR_OBJECT_TOO_LARGE=$CF,
      ERROR_DIRECTORY_NOT_EMPTY=$D8,
      ERROR_RENAME_ACROSS_DEVICES=$D7,
      ERROR_NO_FREE_STORE=$67,
      LOCK_DIFFERENT=-1,
      OFFSET_CURRENT=0,
      ERROR_NOT_IMPLEMENTED=$EC,
      ERROR_DEVICE_NOT_MOUNTED=$DA,
      FIBF_PURE=$20,
      FIBB_PURE=5,
      DOS_RDARGS=5,
      ERROR_TOO_MANY_ARGS=$76,
      TICKS_PER_SECOND=$32,
      LINK_HARD=0,
      ERROR_READ_PROTECTED=$E0,
      ERROR_WRITE_PROTECTED=$DF,
      ERROR_DELETE_PROTECTED=$DE,
      ERROR_DISK_WRITE_PROTECTED=$D6,
      ID_WRITE_PROTECTED=$50,
      FIBF_ARCHIVE=16,
      FIBB_ARCHIVE=4,
      ERROR_OBJECT_LINKED=$EA,
      ERROR_OBJECT_NOT_FOUND=$CD,
      ERROR_DIR_NOT_FOUND=$CC,
      FIBF_DELETE=1,
      FIBF_GRP_DELETE=$100,
      FIBF_OTR_DELETE=$1000,
      FIBB_DELETE=0,
      FIBB_GRP_DELETE=8,
      FIBB_OTR_DELETE=12,
      DOS_CLI=4,
      OFFSET_BEGINING=-1,
      OFFSET_BEGINNING=-1,
      ERROR_RECORD_NOT_LOCKED=$F0,
      FIBF_READ=8,
      FIBF_GRP_READ=$800,
      FIBF_OTR_READ=$8000,
      FIBB_READ=3,
      FIBB_GRP_READ=11,
      FIBB_OTR_READ=15,
      ACCESS_READ=-2,
      ERROR_LINE_TOO_LONG=$78,
      BITSPERLONG=$20,
      BYTESPERLONG=4,
      ITEM_EQUAL=-2,
      DOSFALSE=0,
      ERROR_REQUIRED_ARG_MISSING=$74,
      MININT=$80000000,
      FIBF_SCRIPT=$40,
      FIBB_SCRIPT=6,
      ERROR_NO_DISK=$E2,
      ERROR_NOT_A_DOS_DISK=$E1,
      ID_MSDOS_DISK=$4D534400,
      ID_KICKSTART_DISK=$4B49434B,
      ID_FASTDIR_FFS_DISK=$444F5305,
      ID_FASTDIR_DOS_DISK=$444F5304,
      ID_INTER_FFS_DISK=$444F5303,
      ID_INTER_DOS_DISK=$444F5302,
      ID_FFS_DISK=$444F5301,
      ID_DOS_DISK=$444F5300,
      ID_UNREADABLE_DISK=$42414400,
      ERROR_DISK_NOT_VALIDATED=$D5,
      ID_VALIDATED=$52,
      ITEM_NOTHING=0,
      ERROR_BAD_TEMPLATE=$72,
      DOSTRUE=-1,
      MODE_NEWFILE=$3EE,
      MODE_OLDFILE=$3ED,
      SIGBREAKB_CTRL_C=12,
      SIGBREAKF_CTRL_C=$1000,
      SIGBREAKB_CTRL_D=13,
      SIGBREAKF_CTRL_D=$2000,
      SIGBREAKB_CTRL_E=14,
      SIGBREAKF_CTRL_E=$4000,
      SIGBREAKB_CTRL_F=15,
      SIGBREAKF_CTRL_F=$8000,
      FAULT_MAX=$52,
      ERROR_LOCK_COLLISION=$F1,
      MAXINT=$7FFFFFFF,
      ERROR_IS_SOFT_LINK=$E9,
      ERROR_INVALID_COMPONENT_NAME=$D2,
      ERROR_BAD_STREAM_NAME=$CE

#define MKBADDR/1
#define BADDR/1
#define DOSNAME/0
@endnode
