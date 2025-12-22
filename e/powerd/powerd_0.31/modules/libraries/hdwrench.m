MODULE 'exec/libraries','devices/hardblocks'

OBJECT HDWLibrary
  Lib:Library,
  SegList:ULONG,
  Flags:ULONG,
  ExecBase:APTR,                  /* pointer to exec base  */
  relocs:PTR TO LONG,            /* pointer to relocs.    */
  origbase:PTR TO HDWLibrary,    /* pointer to original library base  */
  numjmps:LONG

#define HDWBaseName   'hdwrench.library'

/* === General Constant Defines === */
/* Artificial unassigned value for the RDB structures. */

CONST UNASSIGNED=-131,
 RDBEND=-1,
 DEFAULT_RDBBLOCKSHI=63

/* === Structure & Typedefs === */

OBJECT ValidIDstruct
  ready[16]:UBYTE,    // Tests ready and first block read
  there[16]:UBYTE     // Tests as "there" but fails other tests

/* Actual disk read write return structure: */
OBJECT rw_return
  success:UBYTE,          // Error code
  failed_word:UBYTE,      // 0 on reads.
  block_written:UBYTE     // 0 on reads.

ENUM success=0,
    success_on_retry_write,
    success_on_retry_read,
    failed_on_write,
    failed_on_reread,
    illegal_command,
    io_command_failure,
    scsi_command_failure,
    out_of_memory,
    no_more_disk_blocks,
    rdsk_not_located,
    io_device_not_open,
    invalid_blocksize_found,
    no_callback_hook,
    user_aborted,
    operation_not_permitted

CONST E_NOERROR=0,
 E_ILLEGAL_SLASH=200,
 E_EOF_IN_COMMENT=201,
 E_ILLEGAL_STAR=202,
 E_TOKEN_TO_LONG=203,
 E_MEMORY_PANIC=204,
 E_PREMATURE_EOF=205,
 E_MISSING_EQUALS=206,
 E_ILLEGAL_T_F=207,
 E_ILLEGAL_TOKEN=208,
 E_DUPLICATE_DISK=209,
 E_NOT_LEGAL_NAME=210,
 E_EXCEEDED_SIZE_LIM=211,
 E_FILE_WRITE_ERROR=212,
 E_TOOMANY_FS=213,
 E_FSAVE_CONFUSION=214,
 E_FS_CANNOT_OPEN=215,
 E_LOST_IN_RDB_SPACE=216,
 E_FS_WRITE_ERROR=217,
 E_MULTIPLE_RDSKS=218,
 E_RDSK_NOT_1ST=219,
 E_NO_RDBS_LOADED=220,
 E_RDBS_ALREADY_IN=221,  // RDBs already loaded.
 E_FAILED_FILEOPEN=222,
 E_FILE_READ_FAILED=223,
 E_FILE_NOT_RDBS=224,
 E_NO_BLOCKSIZE_SPEC=225,
 E_FILE_WRITE_FAILED=226,
 E_MEMORYP_NULL=227,   // prospective "memp" is null
 E_ILLEGAL_BLOCKSIZE=228,
 E_INSUFFICIENT_MEM=229,
 E_RENUMBER_FAILED=230,
 E_BLOCKS_EXCEEDED=231,  // Too many RDB blocks
 E_INCOMPLETE_FSDESC=232,
 E_FS_NOT_FOUND=233,
 E_LIST_SCREWEDUP=234,
 E_NO_SUCH_DIR=235,
 E_EXALL_ERROR=236,
 E_UNIT_DIFFERS=237,
 E_CRIT_VALUE_UNDEF=238,
 T_RENUMBER_LEFT=300,
 W_DUPLICATE_FS=100,
 W_FS_NO_WRITE=101,
 DRIVEINIT=0,
 FILESYSTEM=1

OBJECT DefaultsArray
  TotalBlocks:ULONG,
  BytesPerBlock:UWORD,
  BlocksPerSurface:UWORD,
  Surfaces:UWORD,
  Cylinders:UWORD,
  UnusedBlocks:UWORD

CONST DA_NOERRORS=0,
 DA_NO_CAPACITY_REPORT=1,
 DA_NO_OPTIMIZE=2,
 DA_BAD_MODESENSE_4=4,
 DA_BAD_MODESENSE_3=8,
 DA_FAILED=256,
 DA_NO_DRIVE_OPEN=DA_FAILED,
 DA_RIDICULOUS_VALUES=(DA_FAILED << 1),
 DA_OPTIMIZE=1, /* Optimize storage if possible */
 DA_HUGE=2, /* Allow partitioning huge disks */
 DA_HF_WAY=4, /* Use the old HardFrame algorithm */
 INQBUFSIZE=36,      /* Standard size of Inquiry buffer */
 MAGC_INQBUFSIZE=56  /* Special Inquiry Buffer Size. */

OBJECT bootblock
  Node:MinNode,
  allocsize:LONG,
  BlockNum:LONG,
  Changed:WORD,
  unit:LONG,
  DeviceName[32]:CHAR,
  RWErrors:rw_return,
  wflag:BOOL,
  spares[2]:BYTE,
  NEWUNION Data
    RDB:RigidDiskBlock,
    PB:PartitionBlock,
    FHB:FileSysHeaderBlock,
    BB:BadBlockBlock,
    Bytes[512]:UBYTE,
    Words[256]:UWORD,
    Longs[128]:ULONG
  ENDUNION

OBJECT HDCallbackMsg
  devicename:PTR TO UBYTE,
  board:LONG,
  address:LONG,
  lun:LONG,
  messagestring:PTR TO UBYTE,
  extra:LONG,
  param1:LONG,
  param2:LONG,
  param3:LONG

ENUM EXTRA_BEFORE_TEST=0,
 EXTRA_AFTER_TEST,
 EXTRA_BEFORE_FORMAT,         /* with no way to stop once you start.*/
 EXTRA_BEFORE_VERIFY,        /* Setup the verify requester and return "go ahead" */
 EXTRA_UPDATE_VERIFY,         /* New string for requester - return any Abort received */
 EXTRA_VERIFY_REASSIGN,       /* New string - return "Yes" or "No" */
 EXTRA_VERIFY_FINISHED      /* Notify user, accept OK, close */
