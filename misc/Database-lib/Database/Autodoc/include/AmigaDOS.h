@DATABASE "AmigaDOS.h"
@MASTER   "include:joinOS/dos/AmigaDOS.h"
@REMARK   This file was created by ADtoHT 2.1 on 07-May-04 15:18:33
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "AmigaDOS.h"

@{"AmigaDOS.h" LINK File}


@{b}Structures@{ub}

@{"DateStamp" LINK File 147}   @{"DateTime" LINK File 529}       @{"DeviceInfoData" LINK File 584}  @{"ExAllControl" LINK File 282}  @{"ExAllData" LINK File 257}
@{"FileHandle" LINK File 455}  @{"FileInfoBlock" LINK File 156}  @{"FileLock" LINK File 443}        @{"InfoData" LINK File 291}      


@{b}Typedefs@{ub}

@{"BPTR" LINK File 126}  @{"BSTR" LINK File 130}


@{b}#defines@{ub}

@{"ABORT_BUSY" LINK File 383}                   @{"ABORT_DISK_ERROR" LINK File 384}
@{"ACCESS_READ" LINK File 119}                  @{"ACCESS_WRITE" LINK File 121}
@{"ADO_CommFileLen" LINK File 517}              @{"ADO_CommNameLen" LINK File 515}
@{"ADO_DirLen" LINK File 513}                   @{"ADO_Dummy" LINK File 500}
@{"ADO_FH_Mode" LINK File 501}                  @{"ADO_PromptLen" LINK File 519}
@{"AMIGA_ERROR" LINK File 51}                  @{"BADDR()" LINK File 135}
@{"BITSPERBYTE" LINK File 101}                  @{"BITSPERLONG" LINK File 103}
@{"BUF_FULL" LINK File 484}                     @{"BUF_LINE" LINK File 483}
@{"BUF_NONE" LINK File 485}                     @{"BYTESPERLONG" LINK File 102}
@{"CHANGE_FH" LINK File 431}                    @{"CHANGE_LOCK" LINK File 430}
@{"DEFAULT_SEPARATOR" LINK File 55}            @{"DEVINFO_DEVICETYPE" LINK File 574}
@{"DEVINFO_VOLUMEINFO" LINK File 576}           @{"DEVINFO_VOLUMENAME" LINK File 575}
@{"DEVINFO_VOLUMESIZES" LINK File 577}          @{"DOS_CLI" LINK File 495}
@{"DOS_EXALLCONTROL" LINK File 492}             @{"DOS_FIB" LINK File 493}
@{"DOS_FILEHANDLE" LINK File 491}               @{"DOS_RDARGS" LINK File 496}
@{"DOS_STDPKT" LINK File 494}                   @{"DOSFALSE" LINK File 91}
@{"DOSMEMBLOCKSIZE" LINK File 81}              @{"DOSTRUE" LINK File 90}
@{"DRIVE_CDROM" LINK File 45}                  @{"DRIVE_FIXED" LINK File 43}
@{"DRIVE_NOT_ROOT_DIR" LINK File 569}           @{"DRIVE_RAMDISK" LINK File 46}
@{"DRIVE_REMOTE" LINK File 44}                 @{"DRIVE_REMOVABLE" LINK File 42}
@{"DRIVE_UNKNOWN" LINK File 565}                @{"DTB_FUTURE" LINK File 545}
@{"DTB_SUBST" LINK File 543}                    @{"DTF_FUTURE" LINK File 546}
@{"DTF_SUBST" LINK File 544}                    @{"ED_COMMENT" LINK File 249}
@{"ED_DATE" LINK File 248}                      @{"ED_NAME" LINK File 244}
@{"ED_OWNER" LINK File 250}                     @{"ED_PROTECTION" LINK File 247}
@{"ED_SIZE" LINK File 246}                      @{"ED_TYPE" LINK File 245}
@{"ENDSTREAMCH" LINK File 488}                  @{"ERROR_ACTION_NOT_KNOWN" LINK File 351}
@{"ERROR_BAD_HUNK" LINK File 375}               @{"ERROR_BAD_NUMBER" LINK File 336}
@{"ERROR_BAD_STREAM_NAME" LINK File 349}        @{"ERROR_BAD_TEMPLATE" LINK File 335}
@{"ERROR_BREAK" LINK File 389}                  @{"ERROR_BUFFER_OVERFLOW" LINK File 387}
@{"ERROR_COMMENT_TOO_BIG" LINK File 362}        @{"ERROR_DELETE_PROTECTED" LINK File 366}
@{"ERROR_DEVICE_NOT_MOUNTED" LINK File 360}     @{"ERROR_DIR_NOT_FOUND" LINK File 347}
@{"ERROR_DIRECTORY_NOT_EMPTY" LINK File 358}    @{"ERROR_DISK_FULL" LINK File 364}
@{"ERROR_DISK_NOT_VALIDATED" LINK File 355}     @{"ERROR_DISK_WRITE_PROTECTED" LINK File 356}
@{"ERROR_FILE_NOT_OBJECT" LINK File 342}        @{"ERROR_INVALID_COMPONENT_NAME" LINK File 352}
@{"ERROR_INVALID_LOCK" LINK File 353}           @{"ERROR_INVALID_RESIDENT_LIBRARY" LINK File 343}
@{"ERROR_IS_SOFT_LINK" LINK File 373}           @{"ERROR_KEY_NEEDS_ARG" LINK File 338}
@{"ERROR_LINE_TOO_LONG" LINK File 341}          @{"ERROR_LOCK_COLLISION" LINK File 378}
@{"ERROR_LOCK_TIMEOUT" LINK File 379}           @{"ERROR_NO_DEFAULT_DIR" LINK File 344}
@{"ERROR_NO_DISK" LINK File 370}                @{"ERROR_NO_FREE_STORE" LINK File 333}
@{"ERROR_NO_MORE_ENTRIES" LINK File 371}        @{"ERROR_NOT_A_DOS_DISK" LINK File 369}
@{"ERROR_NOT_EXECUTABLE" LINK File 390}         @{"ERROR_NOT_IMPLEMENTED" LINK File 376}
@{"ERROR_OBJECT_EXISTS" LINK File 346}          @{"ERROR_OBJECT_IN_USE" LINK File 345}
@{"ERROR_OBJECT_LINKED" LINK File 374}          @{"ERROR_OBJECT_NOT_FOUND" LINK File 348}
@{"ERROR_OBJECT_TOO_LARGE" LINK File 350}       @{"ERROR_OBJECT_WRONG_TYPE" LINK File 354}
@{"ERROR_READ_PROTECTED" LINK File 368}         @{"ERROR_RECORD_NOT_LOCKED" LINK File 377}
@{"ERROR_RENAME_ACROSS_DEVICES" LINK File 357}  @{"ERROR_REQUIRED_ARG_MISSING" LINK File 337}
@{"ERROR_SEEK_ERROR" LINK File 361}             @{"ERROR_TASK_TABLE_FULL" LINK File 334}
@{"ERROR_TOO_MANY_ARGS" LINK File 339}          @{"ERROR_TOO_MANY_LEVELS" LINK File 359}
@{"ERROR_UNLOCK_ERROR" LINK File 380}           @{"ERROR_UNMATCHED_QUOTES" LINK File 340}
@{"ERROR_WRITE_PROTECTED" LINK File 367}        @{"EXCLUSIVE_LOCK" LINK File 120}
@{"FAULT_MAX" LINK File 393}                    @{"FIBB_ARCHIVE" LINK File 197}
@{"FIBB_DELETE" LINK File 201}                  @{"FIBB_EXECUTE" LINK File 200}
@{"FIBB_GRP_DELETE" LINK File 193}              @{"FIBB_GRP_EXECUTE" LINK File 192}
@{"FIBB_GRP_READ" LINK File 190}                @{"FIBB_GRP_WRITE" LINK File 191}
@{"FIBB_OTR_DELETE" LINK File 189}              @{"FIBB_OTR_EXECUTE" LINK File 188}
@{"FIBB_OTR_READ" LINK File 186}                @{"FIBB_OTR_WRITE" LINK File 187}
@{"FIBB_PURE" LINK File 196}                    @{"FIBB_READ" LINK File 198}
@{"FIBB_SCRIPT" LINK File 195}                  @{"FIBB_WRITE" LINK File 199}
@{"FIBF_ARCHIVE" LINK File 214}                 @{"FIBF_DELETE" LINK File 218}
@{"FIBF_EXECUTE" LINK File 217}                 @{"FIBF_GRP_DELETE" LINK File 210}
@{"FIBF_GRP_EXECUTE" LINK File 209}             @{"FIBF_GRP_READ" LINK File 207}
@{"FIBF_GRP_WRITE" LINK File 208}               @{"FIBF_OTR_DELETE" LINK File 206}
@{"FIBF_OTR_EXECUTE" LINK File 205}             @{"FIBF_OTR_READ" LINK File 203}
@{"FIBF_OTR_WRITE" LINK File 204}               @{"FIBF_PURE" LINK File 213}
@{"FIBF_READ" LINK File 215}                    @{"FIBF_SCRIPT" LINK File 212}
@{"FIBF_WRITE" LINK File 216}                   @{"FOREIGN_SEPARATOR" LINK File 56}
@{"FORMAT_CDN" LINK File 555}                   @{"FORMAT_DOS" LINK File 552}
@{"FORMAT_INT" LINK File 553}                   @{"FORMAT_MAX" LINK File 556}
@{"FORMAT_USA" LINK File 554}                   @{"ID_CON" LINK File 61}
@{"ID_DOS_DISK" LINK File 314}                  @{"ID_FASTDIR_DOS_DISK" LINK File 318}
@{"ID_FASTDIR_FFS_DISK" LINK File 319}          @{"ID_FFS_DISK" LINK File 315}
@{"ID_INTER_DOS_DISK" LINK File 316}            @{"ID_INTER_FFS_DISK" LINK File 317}
@{"ID_KICKSTART_DISK" LINK File 321}            @{"ID_MSDOS_DISK" LINK File 322}
@{"ID_NO_DISK_PRESENT" LINK File 312}           @{"ID_NOT_REALLY_DOS" LINK File 320}
@{"ID_RAWCON" LINK File 62}                    @{"ID_UNREADABLE_DISK" LINK File 313}
@{"ID_VALIDATED" LINK File 307}                 @{"ID_VALIDATING" LINK File 306}
@{"ID_WRITE_PROTECTED" LINK File 305}           @{"IOF_BUFFREE" LINK File 478}
@{"IOF_EOF" LINK File 477}                      @{"IOF_INPUT" LINK File 476}
@{"IOF_IOFLAGS" LINK File 480}                  @{"IOF_OUTPUT" LINK File 475}
@{"ITEM_EQUAL" LINK File 434}                   @{"ITEM_ERROR" LINK File 435}
@{"ITEM_NOTHING" LINK File 436}                 @{"ITEM_QUOTED" LINK File 438}
@{"ITEM_UNQUOTED" LINK File 437}                @{"LEN_DATSTRING" LINK File 539}
@{"LOCK_DIFFERENT" LINK File 423}               @{"LOCK_SAME" LINK File 424}
@{"LOCK_SAME_HANDLER" LINK File 426}            @{"LOCK_SAME_VOLUME" LINK File 425}
@{"MAX_PATH" LINK File 68}                     @{"MAXINT" LINK File 105}
@{"MININT" LINK File 109}                       @{"MKBADDR()" LINK File 140}
@{"MODE_NEWFILE" LINK File 96}                 @{"MODE_OLDFILE" LINK File 94}
@{"MODE_READWRITE" LINK File 98}               @{"OFFSET_BEGINNING" LINK File 113}
@{"OFFSET_CURRENT" LINK File 114}               @{"OFFSET_END" LINK File 115}
@{"REPORT_INSERT" LINK File 400}                @{"REPORT_LOCK" LINK File 398}
@{"REPORT_STREAM" LINK File 396}                @{"REPORT_TASK" LINK File 397}
@{"REPORT_VOLUME" LINK File 399}                @{"RETURN_ERROR" LINK File 406}
@{"RETURN_FAIL" LINK File 407}                  @{"RETURN_OK" LINK File 404}
@{"RETURN_WARN" LINK File 405}                  @{"SHARED_LOCK" LINK File 118}
@{"SIGBREAKB_CTRL_C" LINK File 410}             @{"SIGBREAKB_CTRL_D" LINK File 411}
@{"SIGBREAKB_CTRL_E" LINK File 412}             @{"SIGBREAKB_CTRL_F" LINK File 413}
@{"SIGBREAKF_CTRL_C" LINK File 417}             @{"SIGBREAKF_CTRL_D" LINK File 418}
@{"SIGBREAKF_CTRL_E" LINK File 419}             @{"SIGBREAKF_CTRL_F" LINK File 420}
@{"ST_FILE" LINK File 229}                      @{"ST_LINKDIR" LINK File 228}
@{"ST_LINKFILE" LINK File 230}                  @{"ST_PIPEFILE" LINK File 231}
@{"ST_ROOT" LINK File 225}                      @{"ST_SOFTLINK" LINK File 227}
@{"ST_USERDIR" LINK File 226}                   @{"TICKS_PER_SECOND" LINK File 153}

@ENDNODE
@NODE File "AmigaDOS.h"
#ifndef _AMIGADOS_H_
#define _AMIGADOS_H_

/* AmigaDOS.h
 *
 * Defines, structures, and function prototypes for AmigaDOS.
 */

#ifndef _DEFINES_H_
#include <joinOS/exec/defines.h>
#endif

#ifdef _AMIGA

#ifndef EXEC_TASKS_H
#include <exec/tasks.h>
#endif

#ifndef DOS_DOS_H
#include <dos/dos.h>
#endif

#ifndef DOS_DOSEXTENS_H
#include <dos/dosextens.h>
#endif

#ifndef DOS_DATETIME_H
#include <dos/datetime.h>
#endif

#ifndef DOS_EXALL_H
#include <dos/exall.h>
#endif

#ifndef DOS_STDIO_H
#include <dos/stdio.h>
#endif

/* Devicetypes for di_DeviceType member of DeviceInfo structure,
 * on Windoof systems defined in <WinBase.h>
 */
#define DRIVE_REMOVABLE    2  /* the volume could be removed from drive (Floppy) */
#define DRIVE_FIXED        3  /* the volume could NOT be removed from drive */
#define DRIVE_REMOTE       4  /* network drive */
#define DRIVE_CDROM        5  /* CD-ROM drive */
#define DRIVE_RAMDISK      6  /* RAM disk */

/* Identifier to identify AmigaDOS error codes:
 * if (IoErr() & @{"AMIGA_ERROR" LINK File 51}) -> AmigaDOS-error-code
 */
#define @{"AMIGA_ERROR" LINK "File" 329} 0xFFFFFFFF

/* The default separator-character for a path
 */
#define @{"DEFAULT_SEPARATOR" LINK "File" 85} '/'
#define @{"FOREIGN_SEPARATOR" LINK "File" 86} '\\\\'

/* Additonal disk-type identifier for fib_DiskType of FileInfoBlock structure,
 * returned by ACTION_DISK_INFO
 */
#define @{"ID_CON" LINK "File" 323}       (0x434F4E00L)  /* 'CON\\0' */
#define @{"ID_RAWCON" LINK "File" 324}    (0x52415700L)  /* 'RAW\\0' */

/* Maximum path length of Windoof-paths.
 * Use a buffer of this size in application-code for retrieving filepaths, so
 * you can be shure, the buffer is always large enough.
 */
#define MAX_PATH 260

#else             /* _AMIGA */

#ifndef _PORTS_H_
#include <joinOS/exec/ports.h>
#endif

/* The default size of the memory pools (shared and non-shared) used by the
 * AmigaDOS library.
 * Don't alter this value without good reasons, and if you alter it use a
 * multiple of 64K (65536).
 */
#define DOSMEMBLOCKSIZE 65536

/* The default separator-character for a path
 */
#define @{"DEFAULT_SEPARATOR" LINK "File" 55} '\\\\'
#define @{"FOREIGN_SEPARATOR" LINK "File" 56} '/'

/* Predefined Amiga DOS global constants */

#define DOSTRUE (-1L)
#define DOSFALSE (0L)

/* Mode parameter to Open() */
#define MODE_OLDFILE      1005   /* Open existing file read/write
                                  * positioned at beginning of file. */
#define MODE_NEWFILE      1006   /* Open freshly created file (delete
                                  * old file) read/write, exclusive lock. */
#define MODE_READWRITE       1004   /* Open old file w/shared lock,
                                     * creates file if doesn't exist. */

#define BITSPERBYTE       8
#define BYTESPERLONG      4
#define BITSPERLONG       32
#ifndef MAXINT
#define MAXINT         0x7FFFFFFF
#endif

#ifndef MININT
#define MININT         0x80000000
#endif

/* Relative position to Seek() */
#define OFFSET_BEGINNING    -1       /* relative to Begining Of File */
#define OFFSET_CURRENT       0       /* relative to Current file position */
#define OFFSET_END        1       /* relative to End Of File     */

/* Passed as type to Lock() */
#define SHARED_LOCK     -2     /* File is readable by others */
#define ACCESS_READ     -2     /* Synonym */
#define EXCLUSIVE_LOCK  -1     /* No other access allowed     */
#define ACCESS_WRITE    -1     /* Synonym */

/* All BCPL data must be long word aligned.  BCPL pointers are the long word
 *  address (i.e byte address divided by 4 (>>2)) */
#ifndef BPTR
typedef long BPTR;       /* Long word pointer */
#endif

#ifndef BSTR
typedef long BSTR;      /* Long word pointer to BCPL string  */
#endif

/* Convert @{"BPTR" LINK File 126} to typical C pointer */
#ifndef BADDR
#define BADDR(x)  ((APTR)(x))
#endif

/* Convert address into a @{"BPTR" LINK File 126} */
#ifndef MKBADDR
#define MKBADDR(x)   ((LONG)(x))
#endif

/* BCPL strings have a length in the first byte and then the characters.
 * For example:    s[0]=3 s[1]=S s[2]=Y s[3]=S            */


struct DateStamp {
   LONG   ds_Days;         /* Number of days since Jan. 1, 1978 */
   LONG   ds_Minute;       /* Number of minutes past midnight */
   LONG   ds_Tick;         /* Number of ticks past minute */
}; /* DateStamp */

#define TICKS_PER_SECOND      50   /* Number of ticks in one second */

/* Returned by Examine() and ExNext(), must be on a 4 byte boundary */
struct FileInfoBlock {
   LONG    fib_DiskKey;
   LONG    fib_DirEntryType;  /* Type of Directory. If < 0, then a plain file.
                               * If > 0 a directory */
   char    fib_FileName[108]; /* Null terminated. Max 30 chars used for now,
                               * Windoof uses up to 255 chars ! */
   LONG    fib_Protection;    /* bit mask of protection, rwxd are 3-0.     */
   LONG    fib_EntryType;
   LONG    fib_Size;          /* Number of bytes in file */
   LONG    fib_NumBlocks;     /* Number of blocks in file, not used */
   @{"struct DateStamp" LINK File 147} fib_Date; /* Date file last changed */
   char    fib_Comment[80];   /* Null terminated comment associated with file
                               * Not supported by Windoof systems */

   /* Note: the following fields are not supported by all filesystems.  */
   /* They should be initialized to 0 sending an ACTION_EXAMINE packet. */
   /* When Examine() is called, these are set to 0 for you.    */
   /* AllocDosObject() also initializes them to 0.       */
   UWORD  fib_OwnerUID;    /* owner's UID */
   UWORD  fib_OwnerGID;    /* owner's GID */

   char    fib_Reserved[32];
}; /* FileInfoBlock */

/* FIB stands for FileInfoBlock */

/* FIBB are bit definitions, FIBF are field definitions */
/* Regular RWED bits are 0 == allowed. */
/* NOTE: GRP and OTR RWED permissions are 0 == not allowed! */
/* Group and Other permissions are not directly handled by the filesystem */
#define FIBB_OTR_READ      15 /* Other: file is readable */
#define FIBB_OTR_WRITE     14 /* Other: file is writable */
#define FIBB_OTR_EXECUTE   13 /* Other: file is executable */
#define FIBB_OTR_DELETE    12 /* Other: prevent file from being deleted */
#define FIBB_GRP_READ      11 /* Group: file is readable */
#define FIBB_GRP_WRITE     10 /* Group: file is writable */
#define FIBB_GRP_EXECUTE   9  /* Group: file is executable */
#define FIBB_GRP_DELETE    8  /* Group: prevent file from being deleted */

#define FIBB_SCRIPT    6   /* program is a script (execute) file */
#define FIBB_PURE      5   /* program is reentrant and rexecutable */
#define FIBB_ARCHIVE   4   /* cleared whenever file is changed */
#define FIBB_READ      3   /* ignored by old filesystem */
#define FIBB_WRITE     2   /* ignored by old filesystem */
#define FIBB_EXECUTE   1   /* ignored by system, used by Shell */
#define FIBB_DELETE    0   /* prevent file from being deleted */

#define FIBF_OTR_READ      (1<<@{"FIBB_OTR_READ" LINK File 186})      /* ignored by Windoof */
#define FIBF_OTR_WRITE     (1<<@{"FIBB_OTR_WRITE" LINK File 187})     /* ignored by Windoof */
#define FIBF_OTR_EXECUTE   (1<<@{"FIBB_OTR_EXECUTE" LINK File 188})   /* ignored by Windoof */
#define FIBF_OTR_DELETE    (1<<@{"FIBB_OTR_DELETE" LINK File 189})    /* ignored by Windoof */
#define FIBF_GRP_READ      (1<<@{"FIBB_GRP_READ" LINK File 190})
#define FIBF_GRP_WRITE     (1<<@{"FIBB_GRP_WRITE" LINK File 191})
#define FIBF_GRP_EXECUTE   (1<<@{"FIBB_GRP_EXECUTE" LINK File 192})   /* ignored by Windoof */
#define FIBF_GRP_DELETE    (1<<@{"FIBB_GRP_DELETE" LINK File 193})    /* ignored by Windoof */

#define FIBF_SCRIPT    (1<<@{"FIBB_SCRIPT" LINK File 195})   /* ignored by Windoof */
#define FIBF_PURE      (1<<@{"FIBB_PURE" LINK File 196})     /* ignored by Windoof */
#define FIBF_ARCHIVE   (1<<@{"FIBB_ARCHIVE" LINK File 197})
#define FIBF_READ      (1<<@{"FIBB_READ" LINK File 198})
#define FIBF_WRITE     (1<<@{"FIBB_WRITE" LINK File 199})
#define FIBF_EXECUTE   (1<<@{"FIBB_EXECUTE" LINK File 200})  /* ignored by Windoof */
#define FIBF_DELETE    (1<<@{"FIBB_DELETE" LINK File 201})   /* ignored by Windoof */

/* Types for fib_DirEntryType.   NOTE that both USERDIR and ROOT are  */
/* directories, and that directory/file checks should use <0 and >=0.    */
/* This is not necessarily exhaustive! Some handlers may use other    */
/* values as needed, though <0 and >=0 should remain as supported as  */
/* possible.                         */
#define ST_ROOT      1
#define ST_USERDIR   2
#define ST_SOFTLINK  3  /* looks like dir, but may point to a file! */
#define ST_LINKDIR   4  /* hard link to dir */
#define ST_FILE      -3 /* must be negative for FIB! */
#define ST_LINKFILE  -4 /* hard link to file */
#define ST_PIPEFILE  -5 /* for pipes that support ExamineFH */

/* --- ExAll() data structures ---------------------------------------------- */

/* NOTE: V37 dos.library, when doing ExAll() emulation, and V37 filesystems  */
/* will return an error if passed @{"ED_OWNER" LINK File 250}.  If you get @{"ERROR_BAD_NUMBER" LINK File 336},    */
/* retry with @{"ED_COMMENT" LINK File 249} to get everything but owner info.  All filesystems  */
/* supporting ExAll() must support through @{"ED_COMMENT" LINK File 249}, and must check Type   */
/* and return @{"ERROR_BAD_NUMBER" LINK File 336} if they don't support the type.         */

/* values that can be passed for what data you want from ExAll() */
/* each higher value includes those below it (numerically)   */
/* you MUST chose one of these values */
#define ED_NAME      1
#define ED_TYPE      2
#define ED_SIZE      3
#define ED_PROTECTION   4
#define ED_DATE      5
#define ED_COMMENT   6
#define ED_OWNER     7

/*
 *   Structure in which exall results are returned in.   Note that only the
 *   fields asked for will exist!
 */

struct ExAllData {
   struct ExAllData *ed_Next;
   UBYTE  *ed_Name;
   LONG  ed_Type;
   ULONG ed_Size;
   ULONG ed_Prot;
   ULONG ed_Days;
   ULONG ed_Mins;
   ULONG ed_Ticks;
   UBYTE  *ed_Comment;  /* strings will be after last used field */
   UWORD ed_OwnerUID;   /* new for V39 */
   UWORD ed_OwnerGID;
};

/*
 *   Control structure passed to ExAll.  Unused fields MUST be initialized to
 *   0, expecially eac_LastKey.
 *
 *   eac_MatchFunc is a hook (see utility.library documentation for usage)
 *   It should return true if the entry is to returned, false if it is to be
 *   ignored.
 *
 *   This structure MUST be allocated by AllocDosObject()!
 */

struct ExAllControl {
   ULONG eac_Entries;   /* number of entries returned in buffer      */
   ULONG eac_LastKey;   /* Don't touch inbetween linked ExAll calls! */
   UBYTE  *eac_MatchString; /* wildcard string for pattern match or NULL */
   void *eac_MatchFunc; /* optional private wildcard function (struct Hook *)
                         * Currently not implemented. */
};

/* returned by Info(), must be on a 4 byte boundary */
struct InfoData {
   LONG    id_NumSoftErrors;  /* number of soft errors on disk */
   LONG    id_UnitNumber;     /* Which unit disk is (was) mounted on */
   LONG    id_DiskState;      /* See defines below */
   LONG    id_NumBlocks;      /* Number of blocks on disk */
   LONG    id_NumBlocksUsed;  /* Number of block in use */
   LONG    id_BytesPerBlock;
   LONG    id_DiskType;       /* Disk Type code */
   @{"BPTR" LINK File 126}    id_VolumeNode;     /* BCPL pointer to volume node */
   LONG    id_InUse;          /* Flag, zero if not in use */
}; /* InfoData */

/* ID stands for InfoData */
   /* Disk states */
#define ID_WRITE_PROTECTED 80  /* Disk is write protected */
#define ID_VALIDATING      81  /* Disk is currently being validated */
#define ID_VALIDATED       82  /* Disk is consistent and writeable */

   /* Disk types */
/* ID_INTER_* use international case comparison routines for hashing */
/* Any other new filesystems should also, if possible. */
#define ID_NO_DISK_PRESENT    (-1)
#define ID_UNREADABLE_DISK    (0x00444142L)  /* 'BAD\\0' */
#define ID_DOS_DISK           (0x00534F44L)  /* 'DOS\\0' (FAT32) */
#define ID_FFS_DISK           (0x01534F44L)  /* 'DOS\\1' (NTFS) */
#define ID_INTER_DOS_DISK     (0x02534F44L)  /* 'DOS\\2' */
#define ID_INTER_FFS_DISK     (0x03534F44L)  /* 'DOS\\3' */
#define ID_FASTDIR_DOS_DISK   (0x04534F44L)  /* 'DOS\\4' */
#define ID_FASTDIR_FFS_DISK   (0x05534F44L)  /* 'DOS\\5' */
#define ID_NOT_REALLY_DOS     (0x534F444EL)  /* 'NDOS' (unknown) */
#define ID_KICKSTART_DISK     (0x4B43494BL)  /* 'KICK'  */
#define ID_MSDOS_DISK         (0x0044534dL)  /* 'MSD\\0' (FAT16) */
#define ID_CON                (0x004E4F43L)  /* 'CON\\0' */
#define ID_RAWCON             (0x00574152L)  /* 'RAW\\0' */

/* Identifier to identify AmigaDOS error codes:
 * if (IoErr() & @{"AMIGA_ERROR" LINK File 51}) -> AmigaDOS-error-code
 */
#define AMIGA_ERROR 0x20000000

/* Error codes returned from IoErr(): */

#define ERROR_NO_FREE_STORE            (AMIGA_ERROR | 103)
#define ERROR_TASK_TABLE_FULL          (AMIGA_ERROR | 105)
#define ERROR_BAD_TEMPLATE             (AMIGA_ERROR | 114)
#define ERROR_BAD_NUMBER               (AMIGA_ERROR | 115)
#define ERROR_REQUIRED_ARG_MISSING     (AMIGA_ERROR | 116)
#define ERROR_KEY_NEEDS_ARG            (AMIGA_ERROR | 117)
#define ERROR_TOO_MANY_ARGS            (AMIGA_ERROR | 118)
#define ERROR_UNMATCHED_QUOTES         (AMIGA_ERROR | 119)
#define ERROR_LINE_TOO_LONG            (AMIGA_ERROR | 120)
#define ERROR_FILE_NOT_OBJECT          (AMIGA_ERROR | 121)
#define ERROR_INVALID_RESIDENT_LIBRARY (AMIGA_ERROR | 122)
#define ERROR_NO_DEFAULT_DIR           (AMIGA_ERROR | 201)
#define ERROR_OBJECT_IN_USE            (AMIGA_ERROR | 202)
#define ERROR_OBJECT_EXISTS            (AMIGA_ERROR | 203)
#define ERROR_DIR_NOT_FOUND            (AMIGA_ERROR | 204)
#define ERROR_OBJECT_NOT_FOUND         (AMIGA_ERROR | 205)
#define ERROR_BAD_STREAM_NAME          (AMIGA_ERROR | 206)
#define ERROR_OBJECT_TOO_LARGE         (AMIGA_ERROR | 207)
#define ERROR_ACTION_NOT_KNOWN         (AMIGA_ERROR | 209)
#define ERROR_INVALID_COMPONENT_NAME   (AMIGA_ERROR | 210)
#define ERROR_INVALID_LOCK             (AMIGA_ERROR | 211)
#define ERROR_OBJECT_WRONG_TYPE        (AMIGA_ERROR | 212)
#define ERROR_DISK_NOT_VALIDATED       (AMIGA_ERROR | 213)
#define ERROR_DISK_WRITE_PROTECTED     (AMIGA_ERROR | 214)
#define ERROR_RENAME_ACROSS_DEVICES    (AMIGA_ERROR | 215)
#define ERROR_DIRECTORY_NOT_EMPTY      (AMIGA_ERROR | 216)
#define ERROR_TOO_MANY_LEVELS          (AMIGA_ERROR | 217)
#define ERROR_DEVICE_NOT_MOUNTED       (AMIGA_ERROR | 218)
#define ERROR_SEEK_ERROR               (AMIGA_ERROR | 219)
#define ERROR_COMMENT_TOO_BIG          (AMIGA_ERROR | 220)
#ifndef ERROR_DISK_FULL
#define ERROR_DISK_FULL                (AMIGA_ERROR | 221)
#endif
#define ERROR_DELETE_PROTECTED         (AMIGA_ERROR | 222)
#define ERROR_WRITE_PROTECTED          (AMIGA_ERROR | 223)
#define ERROR_READ_PROTECTED           (AMIGA_ERROR | 224)
#define ERROR_NOT_A_DOS_DISK           (AMIGA_ERROR | 225)
#define ERROR_NO_DISK                  (AMIGA_ERROR | 226)
#define ERROR_NO_MORE_ENTRIES          (AMIGA_ERROR | 232)
/* added for 1.4 */
#define ERROR_IS_SOFT_LINK             (AMIGA_ERROR | 233)
#define ERROR_OBJECT_LINKED            (AMIGA_ERROR | 234)
#define ERROR_BAD_HUNK                 (AMIGA_ERROR | 235)
#define ERROR_NOT_IMPLEMENTED          (AMIGA_ERROR | 236)
#define ERROR_RECORD_NOT_LOCKED        (AMIGA_ERROR | 240)
#define ERROR_LOCK_COLLISION           (AMIGA_ERROR | 241)
#define ERROR_LOCK_TIMEOUT             (AMIGA_ERROR | 242)
#define ERROR_UNLOCK_ERROR             (AMIGA_ERROR | 243)

/* Special codes for ErrorRequest() */
#define ABORT_BUSY            (AMIGA_ERROR | 288)     /* "You MUST replace volume ... in device .." */
#define ABORT_DISK_ERROR      (AMIGA_ERROR | 296)  /* "Volume ... has a read/write error" */
/* error codes 303-305 from dosasl.h */
#ifndef ERROR_BUFFER_OVERFLOW
#define ERROR_BUFFER_OVERFLOW (AMIGA_ERROR | 303)  /* User or internal buffer overflow */
#endif
#define ERROR_BREAK           (AMIGA_ERROR | 304)  /* A break character was received */
#define ERROR_NOT_EXECUTABLE  (AMIGA_ERROR | 305)  /* A file has E bit cleared */

/* These are the maximum number of characters for a AmigaDOS error message. */
#define FAULT_MAX 82

/* error report types for ErrorReport() */
#define REPORT_STREAM      0  /* a stream */
#define REPORT_TASK        1  /* a process - unused */
#define REPORT_LOCK        2  /* a lock */
#define REPORT_VOLUME      3  /* a volume node */
#define REPORT_INSERT      4  /* please insert volume */

/* These are the return codes used by convention by AmigaDOS commands */
/* See FAILAT and IF for relvance to EXECUTE files          */
#define RETURN_OK              0  /* No problems, success */
#define RETURN_WARN            5  /* A warning only */
#define RETURN_ERROR          10  /* Something wrong */
#define RETURN_FAIL           20  /* Complete or severe failure*/

/* Bit numbers that signal you that a user has issued a break */
#define SIGBREAKB_CTRL_C   12
#define SIGBREAKB_CTRL_D   13
#define SIGBREAKB_CTRL_E   14
#define SIGBREAKB_CTRL_F   15

/* Bit fields that signal you that a user has issued a break */
/* for example:    if (SetSignal(0,0) & SIGBREAKF_CTRL_C) cleanup_and_exit(); */
#define SIGBREAKF_CTRL_C   (1<<SIGBREAKB_CTRL_C)
#define SIGBREAKF_CTRL_D   (1<<SIGBREAKB_CTRL_D)
#define SIGBREAKF_CTRL_E   (1<<SIGBREAKB_CTRL_E)
#define SIGBREAKF_CTRL_F   ((long)1<<SIGBREAKB_CTRL_F)

/* Values returned by SameLock() */
#define LOCK_DIFFERENT     -1
#define LOCK_SAME    0
#define LOCK_SAME_VOLUME   1  /* locks are on same volume */
#define LOCK_SAME_HANDLER  LOCK_SAME_VOLUME
/* LOCK_SAME_HANDLER was a misleading name, def kept for src compatibility */

/* types for ChangeMode() */
#define CHANGE_LOCK  0
#define CHANGE_FH 1

/* values returned by ReadItem */
#define ITEM_EQUAL      -2 /* "=" Symbol */
#define ITEM_ERROR      -1 /* error */
#define ITEM_NOTHING    0  /* '\\n', '\\r', ';', endstreamch */
#define ITEM_UNQUOTED   1  /* unquoted item */
#define ITEM_QUOTED     2  /* quoted item */

/* FileLock structure as returned from Lock(), used to access filesystem
 * objects and to manage the common use of an object...
 */
struct FileLock
{
   @{"BPTR" LINK File 126} fl_Link;              /* bcpl pointer used to link the locks */
   LONG fl_Key;               /* descriptor of the according disk object */
   LONG fl_Access;            /* exclusive or shared */
   struct MsgPort *fl_Task;   /* pointer to MsgPort of the handler's port */
   @{"BPTR" LINK File 126} fl_Volume;            /* bptr to DLT_VOLUME DosList entry */
};

/* a Filehandle structure for an open file, returned by Open() or OpenFromLock().
 * STRICTLY PRIVATE: Don't use it at any way for application programs.
 */
struct FileHandle
{
   LONG *fh_Link; /* should be (struct Message *) (NULL) */
   LONG *fh_Port; /* actually: LONG (DOS boolean), see IsInteractive() */
   struct MsgPort *fh_Type;   /* pointer to MsgPort of a handler task's port
                               * or NULL if no handler started for this handle */
   LONG fh_Buf;   /* pointer to buffer for buffered I/O (UBYTE *) */
   LONG fh_Pos;   /* pointer to actual position in buffer (UBYTE *) */
   LONG fh_End;   /* pointer BEHIND last databyte in buffer (UBYTE *) */
   LONG fh_Func1; /* flags describing the usage of the buffer, see below... */
   LONG fh_Func2; /* current buffersize (ULONG) */
   LONG fh_Func3; /* current buffering mode */
   LONG fh_Arg1;  /* (@{"struct FileLock" LINK File 443} *), the underlying lock of the file */
   LONG fh_Arg2;  /* the openmode of the file */
};

/* flags for fh_Func1.
 * STRICTLY PRIVATE: The use of fh_Func1 is private to the handler and differs
 * from handler to handler.
 */
#define IOF_OUTPUT   1  /* if set, this is an output-buffer */
#define IOF_INPUT    2  /* if set, this is an input-buffer  */
#define IOF_EOF      8  /* set, if EOF is put back using UnGetC() */
#define IOF_BUFFREE  16 /* set, if a new buffer is allocated by SetVBuf() */
/* mask for testing I/O-direction */
#define IOF_IOFLAGS  3  /* if (!(fh_Func1 & @{"IOF_IOFLAGS" LINK File 480})) -> no direction set */

/* types for SetVBuf */
#define BUF_LINE  0  /* flush on \\n, etc */
#define BUF_FULL  1  /* never flush except when needed */
#define BUF_NONE  2  /* no buffering */

/* EOF return value */
#define ENDSTREAMCH  -1

/* types for AllocDosObject/FreeDosObject */
#define DOS_FILEHANDLE     0  /* few people should use this */
#define DOS_EXALLCONTROL   1  /* Must be used to allocate this! */
#define DOS_FIB            2  /* useful */
#define DOS_STDPKT         3  /* for doing packet-level I/O */
#define DOS_CLI            4  /* for shell-writers, etc */
#define DOS_RDARGS         5  /* for ReadArgs if you pass it in */

/* tags for AllocDosObject */

#define ADO_Dummy (TAG_USER + 2000)
#define  ADO_FH_Mode (ADO_Dummy + 1)
            /* for type DOS_FILEHANDLE only        */
            /* sets up FH for mode specified.
               This can make a big difference for buffered
               files.               */
   /* The following are for DOS_CLI */
   /* If you do not specify these, dos will use it's preferred values */
   /* which may change from release to release.  The BPTRs to these   */
   /* will be set up correctly for you.  Everything will be zero,    */
   /* except cli_FailLevel (10) and cli_Background (@{"DOSTRUE" LINK File 90}).     */
   /* NOTE: you may also use these 4 tags with CreateNewProc.     */

#define  ADO_DirLen  (ADO_Dummy + 2)
            /* size in bytes for current dir buffer    */
#define  ADO_CommNameLen   (ADO_Dummy + 3)
            /* size in bytes for command name buffer   */
#define  ADO_CommFileLen   (ADO_Dummy + 4)
            /* size in bytes for command file buffer   */
#define  ADO_PromptLen  (ADO_Dummy + 5)
            /* size in bytes for the prompt buffer    */

/*
 * Data structures and equates used by the V1.4 DOS functions
 * StrtoDate() and DatetoStr()
 */

/*--------- String/Date structures etc */

struct DateTime {
   @{"struct DateStamp" LINK File 147} dat_Stamp;   /* DOS DateStamp */
   UBYTE dat_Format;       /* controls appearance of dat_StrDate */
   UBYTE dat_Flags;        /* see BITDEF's below */
   UBYTE *dat_StrDay;      /* day of the week string */
   UBYTE *dat_StrDate;     /* date string */
   UBYTE *dat_StrTime;     /* time string */
};

/* You need this much room for each of the DateTime strings: */
#define  LEN_DATSTRING  16

/* flags for dat_Flags */

#define DTB_SUBST    0     /* substitute Today, Tomorrow, etc. */
#define DTF_SUBST    1
#define DTB_FUTURE   1     /* day of the week is in future */
#define DTF_FUTURE   2

/*
 * date format values
 */

#define FORMAT_DOS   0     /* dd-mmm-yy */
#define FORMAT_INT   1     /* yy-mm-dd  */
#define FORMAT_USA   2     /* mm-dd-yy  */
#define FORMAT_CDN   3     /* dd-mm-yy  */
#define FORMAT_MAX   FORMAT_CDN

#endif         /* _AMIGA */

/* Devicetypes for di_DeviceType member of DeviceInfo structure,
 * on Windoof systems they should be defined in <WinBase.h>.
 * See above for more defines.
 */
#ifndef DRIVE_UNKNOWN
#define DRIVE_UNKNOWN      0  /* Device type cannot be determined */
#endif

#ifndef DRIVE_NOT_ROOT_DIR
#define DRIVE_NOT_ROOT_DIR 1  /* the root directory does not exist (not partitioned)*/
#endif

/* --- defines used for DeviceInfo() ---------------------------------------- */

#define DEVINFO_DEVICETYPE    1L /* get the devicetype identifier */
#define DEVINFO_VOLUMENAME    2L /* get the label of the inserted volume */
#define DEVINFO_VOLUMEINFO    4L /* get information about the volume */
#define DEVINFO_VOLUMESIZES   8L /* get the size-information about the volume */

/* --- structure used for DeviceInfo() -------------------------------------- */

/* Structure to retrieve informations about devices and there inserted volumes
 * by calling the function DeviceInfo().
 */
      /* size = 146 */struct DeviceInfoData
{
   LONG did_DeviceType;
   /* the type of device,
    * on AmigOS:
    *    DRIVE_UNKNOWN: this is no device (volume or assignment)
    *    DRIVE_NOT_ROOT_DIR: IsFileSystem() returns FALSE.
    *    DRIVE_REMOVEABLE:    "Df0","Df1", "Df2", or "Df3"
    *    DRIVE_FIXED: every other drive, because there is no easy way in
    *                 AmigaOS to discover if a volume is removeable or a CD-Rom
    * on Windoof the id returned by GetDriveType()
    */
   char did_VolumeName[108];        /* buffer for volume label */
   LONG did_DiskType;               /* same as InfoData->id_DiskType */
   ULONG did_MaxComponentLength;    /* system's maximum filename length */
   BOOL  did_CaseSensitiv;    /* boolean flag if filesystem is case sensitiv */
   /* the following union is used to identify volumes with equal labels on the
    * different systems.
    */
   union
      @{"struct DateStamp" LINK File 147} did_VolumeDate; /* creation date of volume Amiga-only */
      ULONG did_SerialNo;              /* volume serial number Windoof-only */
   } did_Id;
   LONG did_NumBlocks;        /* total number of blocks on disk */
   LONG did_NumBlocksUsed;    /* number of blocks in use */
   LONG did_BytesPerBlock;    /* size of a single block in bytes */
};

#endif         /* _AMIGADOS_H_ */
@ENDNODE
