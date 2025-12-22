@DATABASE "gg:doc/NDK/Guide/Include/proto/utility.h"
@MASTER   "gg:os-include/proto/utility.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:11
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "proto/utility.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"proto/utility.h" LINK File}

@ENDNODE
@NODE File "proto/utility.h"
#ifndef _PROTO_UTILITY_H
#define _PROTO_UTILITY_H

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#if !defined(CLIB_UTILITY_PROTOS_H) && !defined(__GNUC__)
#include <@{"clib/utility_protos.h" LINK "gg:doc/NDK/Guide/Include/clib/utility_protos.h/File"}>
#endif

#ifndef __NOLIBBASE__
extern @{"struct UtilityBase" LINK "gg:doc/NDK/Guide/Include/utility/utility.h/File" 31} *UtilityBase;
#endif

#ifdef __GNUC__
#include <@{"inline/utility.h" LINK "gg:doc/NDK/Guide/Include/inline/utility.h/File"}>
#elif !defined(__VBCC__)
#include <@{"pragma/utility_lib.h" LINK "gg:doc/NDK/Guide/Include/pragma/utility_lib.h/File"}>
#endif

#endif  /*  _PROTO_UTILITY_H  */
@ENDNODE
