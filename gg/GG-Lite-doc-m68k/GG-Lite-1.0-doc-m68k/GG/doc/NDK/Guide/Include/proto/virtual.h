@DATABASE "gg:doc/NDK/Guide/Include/proto/virtual.h"
@MASTER   "gg:os-include/proto/virtual.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:11
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "proto/virtual.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"proto/virtual.h" LINK File}

@ENDNODE
@NODE File "proto/virtual.h"
#ifndef _PROTO_VIRTUAL_H
#define _PROTO_VIRTUAL_H

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#if !defined(CLIB_VIRTUAL_PROTOS_H) && !defined(__GNUC__)
#include <@{"clib/virtual_protos.h" LINK "gg:doc/NDK/Guide/Include/clib/virtual_protos.h/File"}>
#endif

#ifndef __NOLIBBASE__
extern @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34} *VirtualBase;
#endif

#ifdef __GNUC__
#include <@{"inline/virtual.h" LINK "gg:doc/NDK/Guide/Include/inline/virtual.h/File"}>
#elif !defined(__VBCC__)
#include <@{"pragma/virtual_lib.h" LINK "gg:doc/NDK/Guide/Include/pragma/virtual_lib.h/File"}>
#endif

#endif  /*  _PROTO_VIRTUAL_H  */
@ENDNODE
