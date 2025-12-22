@DATABASE "gg:doc/NDK/Guide/Include/resources/misc.h"
@MASTER   "gg:os-include/resources/misc.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:25
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "resources/misc.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"resources/misc.h" LINK File}


@{b}#defines@{ub}

@{"MISCNAME" LINK "gg:doc/NDK/Guide/Include/resources/misc.h/File" 41}         @{"MR_ALLOCMISCRESOURCE" LINK "gg:doc/NDK/Guide/Include/resources/misc.h/File" 38}  @{"MR_FREEMISCRESOURCE" LINK "gg:doc/NDK/Guide/Include/resources/misc.h/File" 39}  @{"MR_PARALLELBITS" LINK "gg:doc/NDK/Guide/Include/resources/misc.h/File" 32}
@{"MR_PARALLELPORT" LINK "gg:doc/NDK/Guide/Include/resources/misc.h/File" 30}  @{"MR_SERIALBITS" LINK "gg:doc/NDK/Guide/Include/resources/misc.h/File" 29}         @{"MR_SERIALPORT" LINK "gg:doc/NDK/Guide/Include/resources/misc.h/File" 27}        

@ENDNODE
@NODE File "resources/misc.h"
#ifndef RESOURCES_MISC_H
#define RESOURCES_MISC_H
/*
**      $VER: misc.h 36.13 (6.5.1990)
**      Includes Release 45.1
**
**      Unit number definitions for "@{"misc.resource" LINK "gg:doc/NDK/Guide/misc/MAIN"}"
**
**      (C) Copyright 1985-2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif  /* EXEC_TYPES_H */

#ifndef EXEC_LIBRARIES_H
#include <@{"exec/libraries.h" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File"}>
#endif  /* EXEC_LIBRARIES_H */

/*
 * Unit number definitions.  Ownership of a resource grants low-level
 * bit access to the hardware registers.  You are still obligated to follow
 * the rules for shared access of the interrupt system (see
 * @{"exec.library/SetIntVector" LINK "gg:doc/NDK/Guide/exec/SetIntVector"} or @{"cia.resource" LINK "gg:doc/NDK/Guide/cia/MAIN"} as appropriate).
 */
#define MR_SERIALPORT   0 /* Amiga custom chip serial port registers
                             (SERDAT,SERDATR,SERPER,ADKCON, and interrupts) */
#define MR_SERIALBITS   1 /* Serial control bits (DTR,CTS, etc.) */
#define MR_PARALLELPORT 2 /* The 8 bit parallel data port
                             (CIAAPRA & CIAADDRA only!) */
#define MR_PARALLELBITS 3 /* All other parallel bits & interrupts
                             (BUSY,ACK,etc.) */

/*
 * Library vector offset definitions
 */
#define MR_ALLOCMISCRESOURCE    (@{"LIB_BASE" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 21})              /* -6 */
#define MR_FREEMISCRESOURCE     (@{"LIB_BASE" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 21}-@{"LIB_VECTSIZE" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 19}) /* -12 */

#define MISCNAME "misc.resource"

#endif  /* RESOURCES_MISC_H */
@ENDNODE
