@DATABASE "gg:doc/NDK/Guide/Include/proto/asl.h"
@MASTER   "gg:os-include/proto/asl.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:00
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "proto/asl.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"proto/asl.h" LINK File}

@ENDNODE
@NODE File "proto/asl.h"
#ifndef _PROTO_ASL_H
#define _PROTO_ASL_H

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#if !defined(CLIB_ASL_PROTOS_H) && !defined(__GNUC__)
#include <@{"clib/asl_protos.h" LINK "gg:doc/NDK/Guide/Include/clib/asl_protos.h/File"}>
#endif

#ifndef __NOLIBBASE__
extern @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34} *AslBase;
#endif

#ifdef __GNUC__
#include <@{"inline/asl.h" LINK "gg:doc/NDK/Guide/Include/inline/asl.h/File"}>
#elif !defined(__VBCC__)
#include <@{"pragma/asl_lib.h" LINK "gg:doc/NDK/Guide/Include/pragma/asl_lib.h/File"}>
#endif

#endif  /*  _PROTO_ASL_H  */
@ENDNODE
