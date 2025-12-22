@DATABASE "gg:doc/NDK/Guide/Include/proto/rexxsyslib.h"
@MASTER   "gg:os-include/proto/rexxsyslib.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:09
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "proto/rexxsyslib.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"proto/rexxsyslib.h" LINK File}

@ENDNODE
@NODE File "proto/rexxsyslib.h"
#ifndef _PROTO_REXXSYSLIB_H
#define _PROTO_REXXSYSLIB_H

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#if !defined(CLIB_REXXSYSLIB_PROTOS_H) && !defined(__GNUC__)
#include <@{"clib/rexxsyslib_protos.h" LINK "gg:doc/NDK/Guide/Include/clib/rexxsyslib_protos.h/File"}>
#endif

#ifndef __NOLIBBASE__
extern @{"struct RxsLib" LINK "gg:doc/NDK/Guide/Include/rexx/rxslib.h/File" 25} *RexxSysBase;
#endif

#ifdef __GNUC__
#include <@{"inline/rexxsyslib.h" LINK "gg:doc/NDK/Guide/Include/inline/rexxsyslib.h/File"}>
#elif !defined(__VBCC__)
#include <@{"pragma/rexxsyslib_lib.h" LINK "gg:doc/NDK/Guide/Include/pragma/rexxsyslib_lib.h/File"}>
#endif

#endif  /*  _PROTO_REXXSYSLIB_H  */
@ENDNODE
