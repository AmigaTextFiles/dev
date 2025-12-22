@DATABASE "gg:doc/NDK/Guide/Include/inline/cia.h"
@MASTER   "gg:os-include/inline/cia.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:14:33
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "inline/cia.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"inline/cia.h" LINK File}


@{b}#defines@{ub}

@{"AbleICR()" LINK "gg:doc/NDK/Guide/Include/inline/cia.h/File" 28}  @{"AddICRVector()" LINK "gg:doc/NDK/Guide/Include/inline/cia.h/File" 22}  @{"CLIB_CIA_PROTOS_H" LINK "gg:doc/NDK/Guide/Include/inline/cia.h/File" 5}  @{"RemICRVector()" LINK "gg:doc/NDK/Guide/Include/inline/cia.h/File" 25}
@{"SetICR()" LINK "gg:doc/NDK/Guide/Include/inline/cia.h/File" 31}   

@ENDNODE
@NODE File "inline/cia.h"
#ifndef _INLINE_CIA_H
#define _INLINE_CIA_H

#ifndef CLIB_CIA_PROTOS_H
#define CLIB_CIA_PROTOS_H
#endif

#ifndef __INLINE_MACROS_H
#include <@{"inline/macros.h" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File"}>
#endif

#ifndef  EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#ifndef  EXEC_INTERRUPTS_H
#include <@{"exec/interrupts.h" LINK "gg:doc/NDK/Guide/Include/exec/interrupts.h/File"}>
#endif
#ifndef  EXEC_LIBRARIES_H
#include <@{"exec/libraries.h" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File"}>
#endif

#define @{"AddICRVector" LINK "gg:doc/NDK/Guide/cia/AddICRVector"}(resource, iCRBit, interrupt) \\
        @{"LP3UB" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 273}(0x6, @{"struct Interrupt" LINK "gg:doc/NDK/Guide/Include/exec/interrupts.h/File" 22} *, AddICRVector, struct Library *, resource, a6, LONG, iCRBit, d0, struct Interrupt *, interrupt, a1)

#define @{"RemICRVector" LINK "gg:doc/NDK/Guide/cia/RemICRVector"}(resource, iCRBit, interrupt) \\
        @{"LP3NRUB" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 295}(0xc, @{"RemICRVector" LINK File 25}, @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34} *, resource, a6, LONG, iCRBit, d0, struct Interrupt *, interrupt, a1)

#define @{"AbleICR" LINK "gg:doc/NDK/Guide/cia/AbleICR"}(resource, mask) \\
        @{"LP2UB" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 188}(0x12, @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}, @{"AbleICR" LINK File 28}, @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34} *, resource, a6, LONG, mask, d0)

#define @{"SetICR" LINK "gg:doc/NDK/Guide/cia/SetICR"}(resource, mask) \\
        @{"LP2UB" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 188}(0x18, @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}, @{"SetICR" LINK File 31}, @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34} *, resource, a6, LONG, mask, d0)

#endif /*  _INLINE_CIA_H  */
@ENDNODE
