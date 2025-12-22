@DATABASE "gg:doc/NDK/Guide/Include/proto/drawlist.h"
@MASTER   "gg:os-include/proto/drawlist.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:04
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "proto/drawlist.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"proto/drawlist.h" LINK File}

@ENDNODE
@NODE File "proto/drawlist.h"
#ifndef _PROTO_DRAWLIST_H
#define _PROTO_DRAWLIST_H

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#if !defined(CLIB_DRAWLIST_PROTOS_H) && !defined(__GNUC__)
#include <@{"clib/drawlist_protos.h" LINK "gg:doc/NDK/Guide/Include/clib/drawlist_protos.h/File"}>
#endif

#ifndef __NOLIBBASE__
extern @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34} *DrawListBase;
#endif

#ifdef __GNUC__
#include <@{"inline/drawlist.h" LINK "gg:doc/NDK/Guide/Include/inline/drawlist.h/File"}>
#elif !defined(__VBCC__)
#include <@{"pragma/drawlist_lib.h" LINK "gg:doc/NDK/Guide/Include/pragma/drawlist_lib.h/File"}>
#endif

#endif  /*  _PROTO_DRAWLIST_H  */
@ENDNODE
