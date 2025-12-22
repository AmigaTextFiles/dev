@DATABASE "gg:doc/NDK/Guide/Include/dos/record.h"
@MASTER   "gg:os-include/dos/record.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:13:06
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "dos/record.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"dos/record.h" LINK File}


@{b}Structures@{ub}

@{"RecordLock" LINK "gg:doc/NDK/Guide/Include/dos/record.h/File" 27}


@{b}#defines@{ub}

@{"REC_EXCLUSIVE" LINK "gg:doc/NDK/Guide/Include/dos/record.h/File" 20}  @{"REC_EXCLUSIVE_IMMED" LINK "gg:doc/NDK/Guide/Include/dos/record.h/File" 21}  @{"REC_SHARED" LINK "gg:doc/NDK/Guide/Include/dos/record.h/File" 22}  @{"REC_SHARED_IMMED" LINK "gg:doc/NDK/Guide/Include/dos/record.h/File" 23}

@ENDNODE
@NODE File "dos/record.h"
#ifndef DOS_RECORD_H
#define DOS_RECORD_H
/*
**
**      $VER: record.h 36.5 (12.7.1990)
**      Includes Release 45.1
**
**      include file for record locking
**
**      (C) Copyright 1989-2001 Amiga, Inc.
**          All Rights Reserved
**
*/

#ifndef DOS_DOS_H
#include <@{"dos/dos.h" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File"}>
#endif

/* Modes for @{"LockRecord" LINK "gg:doc/NDK/Guide/dos/LockRecord"}/@{"LockRecords()" LINK "gg:doc/NDK/Guide/dos/LockRecords"} */
#define REC_EXCLUSIVE           0
#define REC_EXCLUSIVE_IMMED     1
#define REC_SHARED              2
#define REC_SHARED_IMMED        3

/* struct to be passed to @{"LockRecords()" LINK "gg:doc/NDK/Guide/dos/LockRecords"}/@{"UnLockRecords()" LINK "gg:doc/NDK/Guide/dos/UnLockRecords"} */

struct RecordLock {
        @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130}    rec_FH;         /* filehandle */
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   rec_Offset;     /* offset in file */
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   rec_Length;     /* length of file to be locked */
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   rec_Mode;       /* Type of lock */
};

#endif /* DOS_RECORD_H */
@ENDNODE
