@DATABASE "gg:doc/NDK/Guide/Include/proto/layout.h"
@MASTER   "gg:os-include/proto/layout.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:06
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "proto/layout.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"proto/layout.h" LINK File}

@ENDNODE
@NODE File "proto/layout.h"
#ifndef _PROTO_LAYOUT_H
#define _PROTO_LAYOUT_H

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#if !defined(CLIB_LAYOUT_PROTOS_H) && !defined(__GNUC__)
#include <@{"clib/layout_protos.h" LINK "gg:doc/NDK/Guide/Include/clib/layout_protos.h/File"}>
#endif

#ifndef __NOLIBBASE__
extern @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34} *LayoutBase;
#endif

#ifdef __GNUC__
#include <@{"inline/layout.h" LINK "gg:doc/NDK/Guide/Include/inline/layout.h/File"}>
#elif !defined(__VBCC__)
#include <@{"pragma/layout_lib.h" LINK "gg:doc/NDK/Guide/Include/pragma/layout_lib.h/File"}>
#endif

#endif  /*  _PROTO_LAYOUT_H  */
@ENDNODE
