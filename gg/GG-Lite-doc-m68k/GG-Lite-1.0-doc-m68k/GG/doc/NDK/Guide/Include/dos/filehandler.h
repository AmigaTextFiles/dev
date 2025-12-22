@DATABASE "gg:doc/NDK/Guide/Include/dos/filehandler.h"
@MASTER   "gg:os-include/dos/filehandler.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:13:02
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "dos/filehandler.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"dos/filehandler.h" LINK File}


@{b}Structures@{ub}

@{"DeviceNode" LINK "gg:doc/NDK/Guide/Include/dos/filehandler.h/File" 100}  @{"DosEnvec" LINK "gg:doc/NDK/Guide/Include/dos/filehandler.h/File" 27}  @{"FileSysStartupMsg" LINK "gg:doc/NDK/Guide/Include/dos/filehandler.h/File" 85}


@{b}#defines@{ub}

@{"DE_BAUD" LINK "gg:doc/NDK/Guide/Include/dos/filehandler.h/File" 77}        @{"DE_BLKSPERTRACK" LINK "gg:doc/NDK/Guide/Include/dos/filehandler.h/File" 61}  @{"DE_BOOTBLOCKS" LINK "gg:doc/NDK/Guide/Include/dos/filehandler.h/File" 79}   @{"DE_BOOTPRI" LINK "gg:doc/NDK/Guide/Include/dos/filehandler.h/File" 73}
@{"DE_BUFMEMTYPE" LINK "gg:doc/NDK/Guide/Include/dos/filehandler.h/File" 69}  @{"DE_CONTROL" LINK "gg:doc/NDK/Guide/Include/dos/filehandler.h/File" 78}       @{"DE_DOSTYPE" LINK "gg:doc/NDK/Guide/Include/dos/filehandler.h/File" 74}      @{"DE_INTERLEAVE" LINK "gg:doc/NDK/Guide/Include/dos/filehandler.h/File" 64}
@{"DE_LOWCYL" LINK "gg:doc/NDK/Guide/Include/dos/filehandler.h/File" 65}      @{"DE_MASK" LINK "gg:doc/NDK/Guide/Include/dos/filehandler.h/File" 72}          @{"DE_MAXTRANSFER" LINK "gg:doc/NDK/Guide/Include/dos/filehandler.h/File" 71}  @{"DE_MEMBUFTYPE" LINK "gg:doc/NDK/Guide/Include/dos/filehandler.h/File" 68}
@{"DE_NUMBUFFERS" LINK "gg:doc/NDK/Guide/Include/dos/filehandler.h/File" 67}  @{"DE_NUMHEADS" LINK "gg:doc/NDK/Guide/Include/dos/filehandler.h/File" 59}      @{"DE_PREFAC" LINK "gg:doc/NDK/Guide/Include/dos/filehandler.h/File" 63}       @{"DE_RESERVEDBLKS" LINK "gg:doc/NDK/Guide/Include/dos/filehandler.h/File" 62}
@{"DE_SECORG" LINK "gg:doc/NDK/Guide/Include/dos/filehandler.h/File" 58}      @{"DE_SECSPERBLK" LINK "gg:doc/NDK/Guide/Include/dos/filehandler.h/File" 60}    @{"DE_SIZEBLOCK" LINK "gg:doc/NDK/Guide/Include/dos/filehandler.h/File" 57}    @{"DE_TABLESIZE" LINK "gg:doc/NDK/Guide/Include/dos/filehandler.h/File" 56}
@{"DE_UPPERCYL" LINK "gg:doc/NDK/Guide/Include/dos/filehandler.h/File" 66}    

@ENDNODE
@NODE File "dos/filehandler.h"
#ifndef DOS_FILEHANDLER_H
#define DOS_FILEHANDLER_H
/*
**      $VER: filehandler.h 44.1 (24.8.99)
**      Includes Release 45.1
**
**      device and file handler specific code for AmigaDOS
**
**      (C) Copyright 1986-2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifndef   EXEC_PORTS_H
#include <@{"exec/ports.h" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File"}>
#endif

#ifndef   DOS_DOS_H
#include <@{"dos/dos.h" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File"}>
#endif


/* The disk "environment" is a longword array that describes the
 * disk geometry.  It is variable sized, with the length at the beginning.
 * Here are the constants for a standard geometry.
 */

struct DosEnvec {
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} de_TableSize;      /* Size of Environment vector */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} de_SizeBlock;      /* in longwords: Physical disk block size */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} de_SecOrg;         /* not used; must be 0 */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} de_Surfaces;       /* # of heads (surfaces). drive specific */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} de_SectorPerBlock; /* N de_SizeBlock sectors per logical block */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} de_BlocksPerTrack; /* blocks per track. drive specific */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} de_Reserved;       /* DOS reserved blocks at start of partition. */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} de_PreAlloc;       /* DOS reserved blocks at end of partition */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} de_Interleave;     /* usually 0 */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} de_LowCyl;         /* starting cylinder. typically 0 */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} de_HighCyl;        /* max cylinder. drive specific */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} de_NumBuffers;     /* Initial # DOS of buffers.  */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} de_BufMemType;     /* type of mem to allocate for buffers */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} de_MaxTransfer;    /* Max number of bytes to transfer at a time */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} de_Mask;           /* Address Mask to block out certain memory */
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}  de_BootPri;        /* Boot priority for autoboot */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} de_DosType;        /* ASCII (HEX) string showing filesystem type;
                              * 0X444F5300 is old filesystem,
                              * 0X444F5301 is fast file system */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} de_Baud;           /* Baud rate for serial handler */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} de_Control;        /* Control word for handler/filesystem */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} de_BootBlocks;     /* Number of blocks containing boot code */

};

/* these are the offsets into the array */
/* @{"DE_TABLESIZE" LINK File 56} is set to the number of longwords in the table minus 1 */

#define DE_TABLESIZE    0       /* minimum value is 11 (includes NumBuffers) */
#define DE_SIZEBLOCK    1       /* in longwords: standard value is 128 */
#define DE_SECORG       2       /* not used; must be 0 */
#define DE_NUMHEADS     3       /* # of heads (surfaces). drive specific */
#define DE_SECSPERBLK   4       /* not used; must be 1 */
#define DE_BLKSPERTRACK 5       /* blocks per track. drive specific */
#define DE_RESERVEDBLKS 6       /* unavailable blocks at start.  usually 2 */
#define DE_PREFAC       7       /* not used; must be 0 */
#define DE_INTERLEAVE   8       /* usually 0 */
#define DE_LOWCYL       9       /* starting cylinder. typically 0 */
#define DE_UPPERCYL     10      /* max cylinder.  drive specific */
#define DE_NUMBUFFERS   11      /* starting # of buffers.  typically 5 */
#define DE_MEMBUFTYPE   12      /* type of mem to allocate for buffers. */
#define DE_BUFMEMTYPE   12      /* same as above, better name
                                 * 1 is public, 3 is chip, 5 is fast */
#define DE_MAXTRANSFER  13      /* Max number bytes to transfer at a time */
#define DE_MASK         14      /* Address Mask to block out certain memory */
#define DE_BOOTPRI      15      /* Boot priority for autoboot */
#define DE_DOSTYPE      16      /* ASCII (HEX) string showing filesystem type;
                                 * 0X444F5300 is old filesystem,
                                 * 0X444F5301 is fast file system */
#define DE_BAUD         17      /* Baud rate for serial handler */
#define DE_CONTROL      18      /* Control word for handler/filesystem */
#define DE_BOOTBLOCKS   19      /* Number of blocks containing boot code */

/* The file system startup message is linked into a device node's startup
** field.  It contains a pointer to the above environment, plus the
** information needed to do an exec @{"OpenDevice()" LINK "gg:doc/NDK/Guide/exec/OpenDevice"}.
*/
struct FileSysStartupMsg {
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}       fssm_Unit;      /* exec unit number for this device */
    @{"BSTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 131}        fssm_Device;    /* null terminated bstring to the device name */
    @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130}        fssm_Environ;   /* ptr to environment table (see above) */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}       fssm_Flags;     /* flags for @{"OpenDevice()" LINK "gg:doc/NDK/Guide/exec/OpenDevice"} */
};


/* The include file "@{"libraries/dosextens.h" LINK "gg:doc/NDK/Guide/Include/libraries/dosextens.h/File"}" has a DeviceList structure.
 * The "device list" can have one of three different things linked onto
 * it.  Dosextens defines the structure for a volume.  @{"DLT_DIRECTORY" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 414}
 * is for an assigned directory.  The following structure is for
 * a dos "device" (@{"DLT_DEVICE" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 413}).
*/

struct DeviceNode {
    @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130}        dn_Next;        /* singly linked list */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}       dn_Type;        /* always 0 for dos "devices" */
    @{"struct MsgPort" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 28} *dn_Task;    /* standard dos "task" field.  If this is
                                 * null when the node is accesses, a task
                                 * will be started up */
    @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130}        dn_Lock;        /* not used for devices -- leave null */
    @{"BSTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 131}        dn_Handler;     /* filename to loadseg (if seglist is null) */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}       dn_StackSize;   /* stacksize to use when starting task */
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}        dn_Priority;    /* task priority when starting task */
    @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130}        dn_Startup;     /* startup msg: FileSysStartupMsg for disks */
    @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130}        dn_SegList;     /* code to run to start new task (if necessary).
                                 * if null then dn_Handler will be loaded. */
    @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130}        dn_GlobalVec;   /* BCPL global vector to use when starting
                                 * a task.  -1 means that dn_SegList is not
                                 * for a bcpl program, so the dos won't
                                 * try and construct one.  0 tell the
                                 * dos that you obey BCPL linkage rules,
                                 * and that it should construct a global
                                 * vector for you.
                                 */
    @{"BSTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 131}        dn_Name;        /* the node name, e.g. '\\3','D','F','3' */
};

#endif  /* DOS_FILEHANDLER_H */
@ENDNODE
