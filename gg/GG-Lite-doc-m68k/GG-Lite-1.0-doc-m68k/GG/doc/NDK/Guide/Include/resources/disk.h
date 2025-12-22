@DATABASE "gg:doc/NDK/Guide/Include/resources/disk.h"
@MASTER   "gg:os-include/resources/disk.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:23
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "resources/disk.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"resources/disk.h" LINK File}


@{b}Structures@{ub}

@{"DiscResource" LINK "gg:doc/NDK/Guide/Include/resources/disk.h/File" 48}  @{"DiscResourceUnit" LINK "gg:doc/NDK/Guide/Include/resources/disk.h/File" 41}


@{b}#defines@{ub}

@{"DISKNAME" LINK "gg:doc/NDK/Guide/Include/resources/disk.h/File" 100}     @{"DR_ALLOCUNIT" LINK "gg:doc/NDK/Guide/Include/resources/disk.h/File" 103}  @{"DR_FREEUNIT" LINK "gg:doc/NDK/Guide/Include/resources/disk.h/File" 104}    @{"DR_GETUNIT" LINK "gg:doc/NDK/Guide/Include/resources/disk.h/File" 105}  @{"DR_GETUNITID" LINK "gg:doc/NDK/Guide/Include/resources/disk.h/File" 107}
@{"DR_GIVEUNIT" LINK "gg:doc/NDK/Guide/Include/resources/disk.h/File" 106}  @{"DR_LASTCOMM" LINK "gg:doc/NDK/Guide/Include/resources/disk.h/File" 110}   @{"DR_READUNITID" LINK "gg:doc/NDK/Guide/Include/resources/disk.h/File" 108}  @{"DRB_ACTIVE" LINK "gg:doc/NDK/Guide/Include/resources/disk.h/File" 68}  @{"DRB_ALLOC0" LINK "gg:doc/NDK/Guide/Include/resources/disk.h/File" 64}
@{"DRB_ALLOC1" LINK "gg:doc/NDK/Guide/Include/resources/disk.h/File" 65}   @{"DRB_ALLOC2" LINK "gg:doc/NDK/Guide/Include/resources/disk.h/File" 66}    @{"DRB_ALLOC3" LINK "gg:doc/NDK/Guide/Include/resources/disk.h/File" 67}     @{"DRF_ACTIVE" LINK "gg:doc/NDK/Guide/Include/resources/disk.h/File" 74}  @{"DRF_ALLOC0" LINK "gg:doc/NDK/Guide/Include/resources/disk.h/File" 70}
@{"DRF_ALLOC1" LINK "gg:doc/NDK/Guide/Include/resources/disk.h/File" 71}   @{"DRF_ALLOC2" LINK "gg:doc/NDK/Guide/Include/resources/disk.h/File" 72}    @{"DRF_ALLOC3" LINK "gg:doc/NDK/Guide/Include/resources/disk.h/File" 73}     @{"DRT_150RPM" LINK "gg:doc/NDK/Guide/Include/resources/disk.h/File" 121}  @{"DRT_37422D2S" LINK "gg:doc/NDK/Guide/Include/resources/disk.h/File" 119}
@{"DRT_AMIGA" LINK "gg:doc/NDK/Guide/Include/resources/disk.h/File" 118}    @{"DRT_EMPTY" LINK "gg:doc/NDK/Guide/Include/resources/disk.h/File" 120}     @{"DSKDMAOFF" LINK "gg:doc/NDK/Guide/Include/resources/disk.h/File" 85}      

@ENDNODE
@NODE File "resources/disk.h"
#ifndef RESOURCES_DISK_H
#define RESOURCES_DISK_H
/*
**      $VER: disk.h 27.11 (21.11.1990)
**      Includes Release 45.1
**
**      disk.h -- external declarations for the disk resource
**
**      (C) Copyright 1985-2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif

#ifndef EXEC_LISTS_H
#include <@{"exec/lists.h" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File"}>
#endif

#ifndef EXEC_PORTS_H
#include <@{"exec/ports.h" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File"}>
#endif

#ifndef EXEC_INTERRUPTS_H
#include <@{"exec/interrupts.h" LINK "gg:doc/NDK/Guide/Include/exec/interrupts.h/File"}>
#endif

#ifndef EXEC_LIBRARIES_H
#include <@{"exec/libraries.h" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File"}>
#endif


/********************************************************************
*
* Resource structures
*
********************************************************************/


struct DiscResourceUnit {
    @{"struct Message" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 47} dru_Message;
    @{"struct Interrupt" LINK "gg:doc/NDK/Guide/Include/exec/interrupts.h/File" 22} dru_DiscBlock;
    @{"struct Interrupt" LINK "gg:doc/NDK/Guide/Include/exec/interrupts.h/File" 22} dru_DiscSync;
    @{"struct Interrupt" LINK "gg:doc/NDK/Guide/Include/exec/interrupts.h/File" 22} dru_Index;
};

struct DiscResource {
    @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34}              dr_Library;
    @{"struct DiscResourceUnit" LINK File 41}     *dr_Current;
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}                       dr_Flags;
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}                       dr_pad;
    @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34}              *dr_SysLib;
    @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34}              *dr_CiaResource;
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}                       dr_UnitID[4];
    @{"struct List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20}         dr_Waiting;
    @{"struct Interrupt" LINK "gg:doc/NDK/Guide/Include/exec/interrupts.h/File" 22}            dr_DiscBlock;
    @{"struct Interrupt" LINK "gg:doc/NDK/Guide/Include/exec/interrupts.h/File" 22}            dr_DiscSync;
    @{"struct Interrupt" LINK "gg:doc/NDK/Guide/Include/exec/interrupts.h/File" 22}            dr_Index;
    @{"struct Task" LINK "gg:doc/NDK/Guide/Include/exec/tasks.h/File" 24}                 *dr_CurrTask;
};

/* dr_Flags entries */
#define DRB_ALLOC0      0       /* unit zero is allocated */
#define DRB_ALLOC1      1       /* unit one is allocated */
#define DRB_ALLOC2      2       /* unit two is allocated */
#define DRB_ALLOC3      3       /* unit three is allocated */
#define DRB_ACTIVE      7       /* is the disc currently busy? */

#define DRF_ALLOC0      (1<<0)  /* unit zero is allocated */
#define DRF_ALLOC1      (1<<1)  /* unit one is allocated */
#define DRF_ALLOC2      (1<<2)  /* unit two is allocated */
#define DRF_ALLOC3      (1<<3)  /* unit three is allocated */
#define DRF_ACTIVE      (1<<7)  /* is the disc currently busy? */



/********************************************************************
*
* Hardware Magic
*
********************************************************************/


#define DSKDMAOFF       0x4000  /* idle command for dsklen register */


/********************************************************************
*
* Resource specific commands
*
********************************************************************/

/*
 * @{"DISKNAME" LINK File 100} is a generic macro to get the name of the resource.
 * This way if the name is ever changed you will pick up the
 *  change automatically.
 */

#define DISKNAME        "disk.resource"


#define DR_ALLOCUNIT    (@{"LIB_BASE" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 21} - 0*@{"LIB_VECTSIZE" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 19})
#define DR_FREEUNIT     (@{"LIB_BASE" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 21} - 1*@{"LIB_VECTSIZE" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 19})
#define DR_GETUNIT      (@{"LIB_BASE" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 21} - 2*@{"LIB_VECTSIZE" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 19})
#define DR_GIVEUNIT     (@{"LIB_BASE" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 21} - 3*@{"LIB_VECTSIZE" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 19})
#define DR_GETUNITID    (@{"LIB_BASE" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 21} - 4*@{"LIB_VECTSIZE" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 19})
#define DR_READUNITID   (@{"LIB_BASE" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 21} - 5*@{"LIB_VECTSIZE" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 19})

#define DR_LASTCOMM     (@{"DR_READUNITID" LINK File 108})

/********************************************************************
*
* drive types
*
********************************************************************/

#define DRT_AMIGA       (0x00000000)
#define DRT_37422D2S    (0x55555555)
#define DRT_EMPTY       (0xFFFFFFFF)
#define DRT_150RPM      (0xAAAAAAAA)

#endif /* RESOURCES_DISK_H */
@ENDNODE
