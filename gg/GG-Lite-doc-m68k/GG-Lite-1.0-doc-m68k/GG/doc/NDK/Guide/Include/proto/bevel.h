@DATABASE "gg:doc/NDK/Guide/Include/proto/bevel.h"
@MASTER   "gg:os-include/proto/bevel.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:01
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "proto/bevel.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"proto/bevel.h" LINK File}

@ENDNODE
@NODE File "proto/bevel.h"
#ifndef _PROTO_BEVEL_H
#define _PROTO_BEVEL_H

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#if !defined(CLIB_BEVEL_PROTOS_H) && !defined(__GNUC__)
#include <@{"clib/bevel_protos.h" LINK "gg:doc/NDK/Guide/Include/clib/bevel_protos.h/File"}>
#endif

#ifndef __NOLIBBASE__
extern @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34} *BevelBase;
#endif

#ifdef __GNUC__
#include <@{"inline/bevel.h" LINK "gg:doc/NDK/Guide/Include/inline/bevel.h/File"}>
#elif !defined(__VBCC__)
#include <@{"pragma/bevel_lib.h" LINK "gg:doc/NDK/Guide/Include/pragma/bevel_lib.h/File"}>
#endif

#endif  /*  _PROTO_BEVEL_H  */
@ENDNODE
