@DATABASE "gg:doc/NDK/Guide/Include/proto/window.h"
@MASTER   "gg:os-include/proto/window.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:11
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "proto/window.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"proto/window.h" LINK File}

@ENDNODE
@NODE File "proto/window.h"
#ifndef _PROTO_WINDOW_H
#define _PROTO_WINDOW_H

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#if !defined(CLIB_WINDOW_PROTOS_H) && !defined(__GNUC__)
#include <@{"clib/window_protos.h" LINK "gg:doc/NDK/Guide/Include/clib/window_protos.h/File"}>
#endif

#ifndef __NOLIBBASE__
extern @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34} *WindowBase;
#endif

#ifdef __GNUC__
#include <@{"inline/window.h" LINK "gg:doc/NDK/Guide/Include/inline/window.h/File"}>
#elif !defined(__VBCC__)
#include <@{"pragma/window_lib.h" LINK "gg:doc/NDK/Guide/Include/pragma/window_lib.h/File"}>
#endif

#endif  /*  _PROTO_WINDOW_H  */
@ENDNODE
