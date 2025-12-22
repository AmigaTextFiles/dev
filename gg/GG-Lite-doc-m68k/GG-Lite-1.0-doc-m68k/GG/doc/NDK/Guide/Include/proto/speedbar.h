@DATABASE "gg:doc/NDK/Guide/Include/proto/speedbar.h"
@MASTER   "gg:os-include/proto/speedbar.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:10
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "proto/speedbar.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"proto/speedbar.h" LINK File}

@ENDNODE
@NODE File "proto/speedbar.h"
#ifndef _PROTO_SPEEDBAR_H
#define _PROTO_SPEEDBAR_H

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#if !defined(CLIB_SPEEDBAR_PROTOS_H) && !defined(__GNUC__)
#include <@{"clib/speedbar_protos.h" LINK "gg:doc/NDK/Guide/Include/clib/speedbar_protos.h/File"}>
#endif

#ifndef __NOLIBBASE__
extern @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34} *SpeedBarBase;
#endif

#ifdef __GNUC__
#include <@{"inline/speedbar.h" LINK "gg:doc/NDK/Guide/Include/inline/speedbar.h/File"}>
#elif !defined(__VBCC__)
#include <@{"pragma/speedbar_lib.h" LINK "gg:doc/NDK/Guide/Include/pragma/speedbar_lib.h/File"}>
#endif

#endif  /*  _PROTO_SPEEDBAR_H  */
@ENDNODE
