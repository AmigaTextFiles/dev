@DATABASE "gg:doc/NDK/Guide/Include/proto/icon.h"
@MASTER   "gg:os-include/proto/icon.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:05
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "proto/icon.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"proto/icon.h" LINK File}

@ENDNODE
@NODE File "proto/icon.h"
#ifndef _PROTO_ICON_H
#define _PROTO_ICON_H

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#if !defined(CLIB_ICON_PROTOS_H) && !defined(__GNUC__)
#include <@{"clib/icon_protos.h" LINK "gg:doc/NDK/Guide/Include/clib/icon_protos.h/File"}>
#endif

#ifndef __NOLIBBASE__
extern @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34} *IconBase;
#endif

#ifdef __GNUC__
#include <@{"inline/icon.h" LINK "gg:doc/NDK/Guide/Include/inline/icon.h/File"}>
#elif !defined(__VBCC__)
#include <@{"pragma/icon_lib.h" LINK "gg:doc/NDK/Guide/Include/pragma/icon_lib.h/File"}>
#endif

#endif  /*  _PROTO_ICON_H  */
@ENDNODE
