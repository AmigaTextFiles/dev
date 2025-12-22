@DATABASE "gg:doc/NDK/Guide/Include/dos/dos.h"
@MASTER   "gg:os-include/dos/dos.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:12:52
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "dos/dos.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"dos/dos.h" LINK File}


@{b}Structures@{ub}

@{"DateStamp" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 52}  @{"FileInfoBlock" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 61}  @{"InfoData" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 147}


@{b}Typedefs@{ub}

@{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130}  @{"BSTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 131}


@{b}#defines@{ub}

@{"ACCESS_READ" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 48}                 @{"ACCESS_WRITE" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 50}
@{"BADDR()" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 135}                     @{"BITSPERBYTE" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 40}
@{"BITSPERLONG" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 42}                 @{"BYTESPERLONG" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 41}
@{"CHANGE_FH" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 259}                   @{"CHANGE_LOCK" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 258}
@{"DOS_CLI" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 277}                     @{"DOS_EXALLCONTROL" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 274}
@{"DOS_FIB" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 275}                     @{"DOS_FILEHANDLE" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 273}
@{"DOS_RDARGS" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 278}                  @{"DOS_STDPKT" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 276}
@{"DOSFALSE" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 23}                    @{"DOSNAME" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 18}
@{"DOSTRUE" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 22}                     @{"ERROR_ACTION_NOT_KNOWN" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 199}
@{"ERROR_BAD_HUNK" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 221}              @{"ERROR_BAD_NUMBER" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 184}
@{"ERROR_BAD_STREAM_NAME" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 197}       @{"ERROR_BAD_TEMPLATE" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 183}
@{"ERROR_COMMENT_TOO_BIG" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 210}       @{"ERROR_DELETE_PROTECTED" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 212}
@{"ERROR_DEVICE_NOT_MOUNTED" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 208}    @{"ERROR_DIR_NOT_FOUND" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 195}
@{"ERROR_DIRECTORY_NOT_EMPTY" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 206}   @{"ERROR_DISK_FULL" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 211}
@{"ERROR_DISK_NOT_VALIDATED" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 203}    @{"ERROR_DISK_WRITE_PROTECTED" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 204}
@{"ERROR_FILE_NOT_OBJECT" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 190}       @{"ERROR_INVALID_COMPONENT_NAME" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 200}
@{"ERROR_INVALID_LOCK" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 201}          @{"ERROR_INVALID_RESIDENT_LIBRARY" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 191}
@{"ERROR_IS_SOFT_LINK" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 219}          @{"ERROR_KEY_NEEDS_ARG" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 186}
@{"ERROR_LINE_TOO_LONG" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 189}         @{"ERROR_LOCK_COLLISION" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 224}
@{"ERROR_LOCK_TIMEOUT" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 225}          @{"ERROR_NO_DEFAULT_DIR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 192}
@{"ERROR_NO_DISK" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 216}               @{"ERROR_NO_FREE_STORE" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 181}
@{"ERROR_NO_MORE_ENTRIES" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 217}       @{"ERROR_NOT_A_DOS_DISK" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 215}
@{"ERROR_NOT_IMPLEMENTED" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 222}       @{"ERROR_OBJECT_EXISTS" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 194}
@{"ERROR_OBJECT_IN_USE" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 193}         @{"ERROR_OBJECT_LINKED" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 220}
@{"ERROR_OBJECT_NOT_FOUND" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 196}      @{"ERROR_OBJECT_TOO_LARGE" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 198}
@{"ERROR_OBJECT_WRONG_TYPE" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 202}     @{"ERROR_READ_PROTECTED" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 214}
@{"ERROR_RECORD_NOT_LOCKED" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 223}     @{"ERROR_RENAME_ACROSS_DEVICES" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 205}
@{"ERROR_REQUIRED_ARG_MISSING" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 185}  @{"ERROR_SEEK_ERROR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 209}
@{"ERROR_TASK_TABLE_FULL" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 182}       @{"ERROR_TOO_MANY_ARGS" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 187}
@{"ERROR_TOO_MANY_LEVELS" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 207}       @{"ERROR_UNLOCK_ERROR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 226}
@{"ERROR_UNMATCHED_QUOTES" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 188}      @{"ERROR_WRITE_PROTECTED" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 213}
@{"EXCLUSIVE_LOCK" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 49}              @{"FAULT_MAX" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 126}
@{"FIBB_ARCHIVE" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 100}                @{"FIBB_DELETE" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 104}
@{"FIBB_EXECUTE" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 103}                @{"FIBB_GRP_DELETE" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 96}
@{"FIBB_GRP_EXECUTE" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 95}            @{"FIBB_GRP_READ" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 93}
@{"FIBB_GRP_WRITE" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 94}              @{"FIBB_OTR_DELETE" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 92}
@{"FIBB_OTR_EXECUTE" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 91}            @{"FIBB_OTR_READ" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 89}
@{"FIBB_OTR_WRITE" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 90}              @{"FIBB_PURE" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 99}
@{"FIBB_READ" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 101}                   @{"FIBB_SCRIPT" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 98}
@{"FIBB_WRITE" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 102}                  @{"FIBF_ARCHIVE" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 117}
@{"FIBF_DELETE" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 121}                 @{"FIBF_EXECUTE" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 120}
@{"FIBF_GRP_DELETE" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 113}             @{"FIBF_GRP_EXECUTE" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 112}
@{"FIBF_GRP_READ" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 110}               @{"FIBF_GRP_WRITE" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 111}
@{"FIBF_OTR_DELETE" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 109}             @{"FIBF_OTR_EXECUTE" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 108}
@{"FIBF_OTR_READ" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 106}               @{"FIBF_OTR_WRITE" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 107}
@{"FIBF_PURE" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 116}                   @{"FIBF_READ" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 118}
@{"FIBF_SCRIPT" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 115}                 @{"FIBF_WRITE" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 119}
@{"ID_DOS_DISK" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 170}                 @{"ID_FASTDIR_DOS_DISK" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 174}
@{"ID_FASTDIR_FFS_DISK" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 175}         @{"ID_FFS_DISK" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 171}
@{"ID_INTER_DOS_DISK" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 172}           @{"ID_INTER_FFS_DISK" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 173}
@{"ID_KICKSTART_DISK" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 177}           @{"ID_MSDOS_DISK" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 178}
@{"ID_NO_DISK_PRESENT" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 168}          @{"ID_NOT_REALLY_DOS" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 176}
@{"ID_UNREADABLE_DISK" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 169}          @{"ID_VALIDATED" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 163}
@{"ID_VALIDATING" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 162}               @{"ID_WRITE_PROTECTED" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 161}
@{"ITEM_EQUAL" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 266}                  @{"ITEM_ERROR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 267}
@{"ITEM_NOTHING" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 268}                @{"ITEM_QUOTED" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 270}
@{"ITEM_UNQUOTED" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 269}               @{"LINK_HARD" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 262}
@{"LINK_SOFT" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 263}                   @{"LOCK_DIFFERENT" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 251}
@{"LOCK_SAME" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 252}                   @{"LOCK_SAME_HANDLER" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 254}
@{"LOCK_SAME_VOLUME" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 253}            @{"MAXINT" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 43}
@{"MININT" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 44}                      @{"MKBADDR()" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 141}
@{"MODE_NEWFILE" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 28}                @{"MODE_OLDFILE" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 26}
@{"MODE_READWRITE" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 30}              @{"OFFSET_BEGINING" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 38}
@{"OFFSET_BEGINNING" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 34}            @{"OFFSET_CURRENT" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 35}
@{"OFFSET_END" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 36}                  @{"RETURN_ERROR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 234}
@{"RETURN_FAIL" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 235}                 @{"RETURN_OK" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 232}
@{"RETURN_WARN" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 233}                 @{"SHARED_LOCK" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 47}
@{"SIGBREAKB_CTRL_C" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 238}            @{"SIGBREAKB_CTRL_D" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 239}
@{"SIGBREAKB_CTRL_E" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 240}            @{"SIGBREAKB_CTRL_F" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 241}
@{"SIGBREAKF_CTRL_C" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 245}            @{"SIGBREAKF_CTRL_D" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 246}
@{"SIGBREAKF_CTRL_E" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 247}            @{"SIGBREAKF_CTRL_F" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 248}
@{"TICKS_PER_SECOND" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 58}            

@ENDNODE
@NODE File "dos/dos.h"
#ifndef DOS_DOS_H
#define DOS_DOS_H
/*
**      $VER: dos.h 36.27 (5.4.1992)
**      Includes Release 45.1
**
**      Standard C header for AmigaDOS
**
**      (C) Copyright 1985-2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif


#define  DOSNAME  "dos.library"

/* Predefined Amiga DOS global constants */

#define DOSTRUE (-1L)
#define DOSFALSE (0L)

/* Mode parameter to @{"Open()" LINK "gg:doc/NDK/Guide/dos/Open"} */
#define MODE_OLDFILE         1005   /* Open existing file read/write
                                     * positioned at beginning of file. */
#define MODE_NEWFILE         1006   /* Open freshly created file (delete
                                     * old file) read/write, exclusive lock. */
#define MODE_READWRITE       1004   /* Open old file w/shared lock,
                                     * creates file if doesn't exist. */

/* Relative position to @{"Seek()" LINK "gg:doc/NDK/Guide/dos/Seek"} */
#define OFFSET_BEGINNING    -1      /* relative to Begining Of File */
#define OFFSET_CURRENT       0      /* relative to Current file position */
#define OFFSET_END           1      /* relative to End Of File    */

#define OFFSET_BEGINING     @{"OFFSET_BEGINNING" LINK File 34}  /* ancient compatibility */

#define BITSPERBYTE          8
#define BYTESPERLONG         4
#define BITSPERLONG          32
#define MAXINT               0x7FFFFFFF
#define MININT               0x80000000

/* Passed as type to @{"Lock()" LINK "gg:doc/NDK/Guide/dos/Lock"} */
#define SHARED_LOCK          -2     /* File is readable by others */
#define ACCESS_READ          -2     /* Synonym */
#define EXCLUSIVE_LOCK       -1     /* No other access allowed    */
#define ACCESS_WRITE         -1     /* Synonym */

struct DateStamp {
   @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}  ds_Days;             /* Number of days since Jan. 1, 1978 */
   @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}  ds_Minute;           /* Number of minutes past midnight */
   @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}  ds_Tick;             /* Number of ticks past minute */
}; /* @{"DateStamp" LINK "gg:doc/NDK/Guide/dos/DateStamp"} */

#define TICKS_PER_SECOND      50   /* Number of ticks in one second */

/* Returned by @{"Examine()" LINK "gg:doc/NDK/Guide/dos/Examine"} and @{"ExNext()" LINK "gg:doc/NDK/Guide/dos/ExNext"}, must be on a 4 byte boundary */
struct FileInfoBlock {
   @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}   fib_DiskKey;
   @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}   fib_DirEntryType;  /* Type of Directory. If < 0, then a plain file.
                              * If > 0 a directory */
   char   fib_FileName[108]; /* Null terminated. Max 30 chars used for now */
   @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}   fib_Protection;    /* bit mask of protection, rwxd are 3-0.      */
   @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}   fib_EntryType;
   @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}   fib_Size;          /* Number of bytes in file */
   @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}   fib_NumBlocks;     /* Number of blocks in file */
   @{"struct DateStamp" LINK File 52} fib_Date;/* Date file last changed */
   char   fib_Comment[80];  /* Null terminated comment associated with file */

   /* Note: the following fields are not supported by all filesystems.  */
   /* They should be initialized to 0 sending an ACTION_EXAMINE packet. */
   /* When @{"Examine()" LINK "gg:doc/NDK/Guide/dos/Examine"} is called, these are set to 0 for you.             */
   /* @{"AllocDosObject()" LINK "gg:doc/NDK/Guide/dos/AllocDosObject"} also initializes them to 0.                      */
   @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}  fib_OwnerUID;         /* owner's UID */
   @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}  fib_OwnerGID;         /* owner's GID */

   char   fib_Reserved[32];
}; /* FileInfoBlock */

/* FIB stands for FileInfoBlock */

/* FIBB are bit definitions, FIBF are field definitions */
/* Regular RWED bits are 0 == allowed. */
/* NOTE: GRP and OTR RWED permissions are 0 == not allowed! */
/* Group and Other permissions are not directly handled by the filesystem */
#define FIBB_OTR_READ      15   /* Other: file is readable */
#define FIBB_OTR_WRITE     14   /* Other: file is writable */
#define FIBB_OTR_EXECUTE   13   /* Other: file is executable */
#define FIBB_OTR_DELETE    12   /* Other: prevent file from being deleted */
#define FIBB_GRP_READ      11   /* Group: file is readable */
#define FIBB_GRP_WRITE     10   /* Group: file is writable */
#define FIBB_GRP_EXECUTE   9    /* Group: file is executable */
#define FIBB_GRP_DELETE    8    /* Group: prevent file from being deleted */

#define FIBB_SCRIPT    6        /* program is a script (execute) file */
#define FIBB_PURE      5        /* program is reentrant and rexecutable */
#define FIBB_ARCHIVE   4        /* cleared whenever file is changed */
#define FIBB_READ      3        /* ignored by old filesystem */
#define FIBB_WRITE     2        /* ignored by old filesystem */
#define FIBB_EXECUTE   1        /* ignored by system, used by Shell */
#define FIBB_DELETE    0        /* prevent file from being deleted */

#define FIBF_OTR_READ      (1<<@{"FIBB_OTR_READ" LINK File 89})
#define FIBF_OTR_WRITE     (1<<@{"FIBB_OTR_WRITE" LINK File 90})
#define FIBF_OTR_EXECUTE   (1<<@{"FIBB_OTR_EXECUTE" LINK File 91})
#define FIBF_OTR_DELETE    (1<<@{"FIBB_OTR_DELETE" LINK File 92})
#define FIBF_GRP_READ      (1<<@{"FIBB_GRP_READ" LINK File 93})
#define FIBF_GRP_WRITE     (1<<@{"FIBB_GRP_WRITE" LINK File 94})
#define FIBF_GRP_EXECUTE   (1<<@{"FIBB_GRP_EXECUTE" LINK File 95})
#define FIBF_GRP_DELETE    (1<<@{"FIBB_GRP_DELETE" LINK File 96})

#define FIBF_SCRIPT    (1<<@{"FIBB_SCRIPT" LINK File 98})
#define FIBF_PURE      (1<<@{"FIBB_PURE" LINK File 99})
#define FIBF_ARCHIVE   (1<<@{"FIBB_ARCHIVE" LINK File 100})
#define FIBF_READ      (1<<@{"FIBB_READ" LINK File 101})
#define FIBF_WRITE     (1<<@{"FIBB_WRITE" LINK File 102})
#define FIBF_EXECUTE   (1<<@{"FIBB_EXECUTE" LINK File 103})
#define FIBF_DELETE    (1<<@{"FIBB_DELETE" LINK File 104})

/* Standard maximum length for an error string from fault.  However, most */
/* error strings should be kept under 60 characters if possible.  Don't   */
/* forget space for the header you pass in. */
#define FAULT_MAX       82

/* All BCPL data must be long word aligned.  BCPL pointers are the long word
 *  address (i.e byte address divided by 4 (>>2)) */
typedef long  BPTR;                 /* Long word pointer */
typedef long  BSTR;                 /* Long word pointer to BCPL string  */

/* Convert @{"BPTR" LINK File 130} to typical C pointer */
#ifdef OBSOLETE_LIBRARIES_DOS_H
#define @{"BADDR" LINK "File" 138}( bptr )   (((@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52})bptr) << 2)
#else
/* This one has no problems with CASTing */
#define @{"BADDR" LINK "File" 135}(x)        ((@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49})((@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52})(x) << 2))
#endif
/* Convert address into a @{"BPTR" LINK File 130} */
#define MKBADDR(x)      (((@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51})(x)) >> 2)

/* BCPL strings have a length in the first byte and then the characters.
 * For example:  s[0]=3 s[1]=S s[2]=Y s[3]=S                             */

/* returned by @{"Info()" LINK "gg:doc/NDK/Guide/dos/Info"}, must be on a 4 byte boundary */
struct InfoData {
   @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}   id_NumSoftErrors;     /* number of soft errors on disk */
   @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}   id_UnitNumber;        /* Which unit disk is (was) mounted on */
   @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}   id_DiskState;         /* See defines below */
   @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}   id_NumBlocks;         /* Number of blocks on disk */
   @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}   id_NumBlocksUsed;     /* Number of block in use */
   @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}   id_BytesPerBlock;
   @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}   id_DiskType;          /* Disk Type code */
   @{"BPTR" LINK File 130}   id_VolumeNode;        /* BCPL pointer to volume node (see DosList) */
   @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}   id_InUse;             /* Flag, zero if not in use */
}; /* InfoData */

/* ID stands for InfoData */
        /* Disk states */
#define ID_WRITE_PROTECTED 80    /* Disk is write protected */
#define ID_VALIDATING      81    /* Disk is currently being validated */
#define ID_VALIDATED       82    /* Disk is consistent and writeable */

        /* Disk types */
/* ID_INTER_* use international case comparison routines for hashing */
/* Any other new filesystems should also, if possible. */
#define ID_NO_DISK_PRESENT      (-1)
#define ID_UNREADABLE_DISK      (0x42414400L)   /* 'BAD\\0' */
#define ID_DOS_DISK             (0x444F5300L)   /* 'DOS\\0' */
#define ID_FFS_DISK             (0x444F5301L)   /* 'DOS\\1' */
#define ID_INTER_DOS_DISK       (0x444F5302L)   /* 'DOS\\2' */
#define ID_INTER_FFS_DISK       (0x444F5303L)   /* 'DOS\\3' */
#define ID_FASTDIR_DOS_DISK     (0x444F5304L)   /* 'DOS\\4' */
#define ID_FASTDIR_FFS_DISK     (0x444F5305L)   /* 'DOS\\5' */
#define ID_NOT_REALLY_DOS       (0x4E444F53L)   /* 'NDOS'  */
#define ID_KICKSTART_DISK       (0x4B49434BL)   /* 'KICK'  */
#define ID_MSDOS_DISK           (0x4d534400L)   /* 'MSD\\0' */

/* Errors from @{"IoErr()" LINK "gg:doc/NDK/Guide/dos/IoErr"}, etc. */
#define ERROR_NO_FREE_STORE               103
#define ERROR_TASK_TABLE_FULL             105
#define ERROR_BAD_TEMPLATE                114
#define ERROR_BAD_NUMBER                  115
#define ERROR_REQUIRED_ARG_MISSING        116
#define ERROR_KEY_NEEDS_ARG               117
#define ERROR_TOO_MANY_ARGS               118
#define ERROR_UNMATCHED_QUOTES            119
#define ERROR_LINE_TOO_LONG               120
#define ERROR_FILE_NOT_OBJECT             121
#define ERROR_INVALID_RESIDENT_LIBRARY    122
#define ERROR_NO_DEFAULT_DIR              201
#define ERROR_OBJECT_IN_USE               202
#define ERROR_OBJECT_EXISTS               203
#define ERROR_DIR_NOT_FOUND               204
#define ERROR_OBJECT_NOT_FOUND            205
#define ERROR_BAD_STREAM_NAME             206
#define ERROR_OBJECT_TOO_LARGE            207
#define ERROR_ACTION_NOT_KNOWN            209
#define ERROR_INVALID_COMPONENT_NAME      210
#define ERROR_INVALID_LOCK                211
#define ERROR_OBJECT_WRONG_TYPE           212
#define ERROR_DISK_NOT_VALIDATED          213
#define ERROR_DISK_WRITE_PROTECTED        214
#define ERROR_RENAME_ACROSS_DEVICES       215
#define ERROR_DIRECTORY_NOT_EMPTY         216
#define ERROR_TOO_MANY_LEVELS             217
#define ERROR_DEVICE_NOT_MOUNTED          218
#define ERROR_SEEK_ERROR                  219
#define ERROR_COMMENT_TOO_BIG             220
#define ERROR_DISK_FULL                   221
#define ERROR_DELETE_PROTECTED            222
#define ERROR_WRITE_PROTECTED             223
#define ERROR_READ_PROTECTED              224
#define ERROR_NOT_A_DOS_DISK              225
#define ERROR_NO_DISK                     226
#define ERROR_NO_MORE_ENTRIES             232
/* added for 1.4 */
#define ERROR_IS_SOFT_LINK                233
#define ERROR_OBJECT_LINKED               234
#define ERROR_BAD_HUNK                    235
#define ERROR_NOT_IMPLEMENTED             236
#define ERROR_RECORD_NOT_LOCKED           240
#define ERROR_LOCK_COLLISION              241
#define ERROR_LOCK_TIMEOUT                242
#define ERROR_UNLOCK_ERROR                243

/* error codes 303-305 are defined in dosasl.h */

/* These are the return codes used by convention by AmigaDOS commands */
/* See FAILAT and IF for relvance to EXECUTE files                    */
#define RETURN_OK                           0  /* No problems, success */
#define RETURN_WARN                         5  /* A warning only */
#define RETURN_ERROR                       10  /* Something wrong */
#define RETURN_FAIL                        20  /* Complete or severe failure*/

/* Bit numbers that signal you that a user has issued a break */
#define SIGBREAKB_CTRL_C   12
#define SIGBREAKB_CTRL_D   13
#define SIGBREAKB_CTRL_E   14
#define SIGBREAKB_CTRL_F   15

/* Bit fields that signal you that a user has issued a break */
/* for example:  if (@{"SetSignal" LINK "gg:doc/NDK/Guide/exec/SetSignal"}(0,0) & @{"SIGBREAKF_CTRL_C" LINK File 245}) cleanup_and_exit(); */
#define SIGBREAKF_CTRL_C   (1<<@{"SIGBREAKB_CTRL_C" LINK File 238})
#define SIGBREAKF_CTRL_D   (1<<@{"SIGBREAKB_CTRL_D" LINK File 239})
#define SIGBREAKF_CTRL_E   (1<<@{"SIGBREAKB_CTRL_E" LINK File 240})
#define SIGBREAKF_CTRL_F   ((long)1<<@{"SIGBREAKB_CTRL_F" LINK File 241})

/* Values returned by @{"SameLock()" LINK "gg:doc/NDK/Guide/dos/SameLock"} */
#define LOCK_DIFFERENT          -1
#define LOCK_SAME               0
#define LOCK_SAME_VOLUME        1       /* locks are on same volume */
#define LOCK_SAME_HANDLER       @{"LOCK_SAME_VOLUME" LINK File 253}
/* @{"LOCK_SAME_HANDLER" LINK File 254} was a misleading name, def kept for src compatibility */

/* types for @{"ChangeMode()" LINK "gg:doc/NDK/Guide/dos/ChangeMode"} */
#define CHANGE_LOCK     0
#define CHANGE_FH       1

/* Values for @{"MakeLink()" LINK "gg:doc/NDK/Guide/dos/MakeLink"} */
#define LINK_HARD       0
#define LINK_SOFT       1       /* softlinks are not fully supported yet */

/* values returned by @{"ReadItem" LINK "gg:doc/NDK/Guide/dos/ReadItem"} */
#define ITEM_EQUAL      -2              /* "=" Symbol */
#define ITEM_ERROR      -1              /* error */
#define ITEM_NOTHING    0               /* *N, ;, endstreamch */
#define ITEM_UNQUOTED   1               /* unquoted item */
#define ITEM_QUOTED     2               /* quoted item */

/* types for @{"AllocDosObject" LINK "gg:doc/NDK/Guide/dos/AllocDosObject"}/@{"FreeDosObject" LINK "gg:doc/NDK/Guide/dos/FreeDosObject"} */
#define DOS_FILEHANDLE          0       /* few people should use this */
#define DOS_EXALLCONTROL        1       /* Must be used to allocate this! */
#define DOS_FIB                 2       /* useful */
#define DOS_STDPKT              3       /* for doing packet-level I/O */
#define DOS_CLI                 4       /* for shell-writers, etc */
#define DOS_RDARGS              5       /* for @{"ReadArgs" LINK "gg:doc/NDK/Guide/dos/ReadArgs"} if you pass it in */

#endif  /* DOS_DOS_H */
@ENDNODE
