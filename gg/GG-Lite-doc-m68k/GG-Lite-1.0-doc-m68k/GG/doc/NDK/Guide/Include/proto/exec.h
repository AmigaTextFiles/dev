@DATABASE "gg:doc/NDK/Guide/Include/proto/exec.h"
@MASTER   "gg:os-include/proto/exec.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:04
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "proto/exec.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"proto/exec.h" LINK File}

@ENDNODE
@NODE File "proto/exec.h"
#ifndef _PROTO_EXEC_H
#define _PROTO_EXEC_H

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#if !defined(CLIB_EXEC_PROTOS_H) && !defined(__GNUC__)
#include <@{"clib/exec_protos.h" LINK "gg:doc/NDK/Guide/Include/clib/exec_protos.h/File"}>
#endif

#ifndef __NOLIBBASE__
extern @{"struct ExecBase" LINK "gg:doc/NDK/Guide/Include/exec/execbase.h/File" 34} *SysBase;
#endif

#ifdef __GNUC__
#include <@{"inline/exec.h" LINK "gg:doc/NDK/Guide/Include/inline/exec.h/File"}>
#elif !defined(__VBCC__)
#include <@{"pragma/exec_lib.h" LINK "gg:doc/NDK/Guide/Include/pragma/exec_lib.h/File"}>
#endif

#endif  /*  _PROTO_EXEC_H  */
@ENDNODE
