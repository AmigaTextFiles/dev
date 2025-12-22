@DATABASE "gg:doc/NDK/Guide/Include/proto/getscreenmode.h"
@MASTER   "gg:os-include/proto/getscreenmode.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:05
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "proto/getscreenmode.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"proto/getscreenmode.h" LINK File}

@ENDNODE
@NODE File "proto/getscreenmode.h"
#ifndef _PROTO_GETSCREENMODE_H
#define _PROTO_GETSCREENMODE_H

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#if !defined(CLIB_GETSCREENMODE_PROTOS_H) && !defined(__GNUC__)
#include <@{"clib/getscreenmode_protos.h" LINK "gg:doc/NDK/Guide/Include/clib/getscreenmode_protos.h/File"}>
#endif

#ifndef __NOLIBBASE__
extern @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34} *GetScreenModeBase;
#endif

#ifdef __GNUC__
#include <@{"inline/getscreenmode.h" LINK "gg:doc/NDK/Guide/Include/inline/getscreenmode.h/File"}>
#elif !defined(__VBCC__)
#include <@{"pragma/getscreenmode_lib.h" LINK "gg:doc/NDK/Guide/Include/pragma/getscreenmode_lib.h/File"}>
#endif

#endif  /*  _PROTO_GETSCREENMODE_H  */
@ENDNODE
