@DATABASE "gg:doc/NDK/Guide/Include/proto/amigaguide.h"
@MASTER   "gg:os-include/proto/amigaguide.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:00
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "proto/amigaguide.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"proto/amigaguide.h" LINK File}

@ENDNODE
@NODE File "proto/amigaguide.h"
#ifndef _PROTO_AMIGAGUIDE_H
#define _PROTO_AMIGAGUIDE_H

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#if !defined(CLIB_AMIGAGUIDE_PROTOS_H) && !defined(__GNUC__)
#include <@{"clib/amigaguide_protos.h" LINK "gg:doc/NDK/Guide/Include/clib/amigaguide_protos.h/File"}>
#endif

#ifndef __NOLIBBASE__
extern @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34} *AmigaGuideBase;
#endif

#ifdef __GNUC__
#include <@{"inline/amigaguide.h" LINK "gg:doc/NDK/Guide/Include/inline/amigaguide.h/File"}>
#elif !defined(__VBCC__)
#include <@{"pragma/amigaguide_lib.h" LINK "gg:doc/NDK/Guide/Include/pragma/amigaguide_lib.h/File"}>
#endif

#endif  /*  _PROTO_AMIGAGUIDE_H  */
@ENDNODE
