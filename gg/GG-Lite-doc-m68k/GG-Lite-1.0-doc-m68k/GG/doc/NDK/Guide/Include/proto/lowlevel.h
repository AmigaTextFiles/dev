@DATABASE "gg:doc/NDK/Guide/Include/proto/lowlevel.h"
@MASTER   "gg:os-include/proto/lowlevel.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:07
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "proto/lowlevel.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"proto/lowlevel.h" LINK File}

@ENDNODE
@NODE File "proto/lowlevel.h"
#ifndef _PROTO_LOWLEVEL_H
#define _PROTO_LOWLEVEL_H

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#if !defined(CLIB_LOWLEVEL_PROTOS_H) && !defined(__GNUC__)
#include <@{"clib/lowlevel_protos.h" LINK "gg:doc/NDK/Guide/Include/clib/lowlevel_protos.h/File"}>
#endif

#ifndef __NOLIBBASE__
extern @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34} *LowLevelBase;
#endif

#ifdef __GNUC__
#include <@{"inline/lowlevel.h" LINK "gg:doc/NDK/Guide/Include/inline/lowlevel.h/File"}>
#elif !defined(__VBCC__)
#include <@{"pragma/lowlevel_lib.h" LINK "gg:doc/NDK/Guide/Include/pragma/lowlevel_lib.h/File"}>
#endif

#endif  /*  _PROTO_LOWLEVEL_H  */
@ENDNODE
