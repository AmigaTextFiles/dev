@DATABASE "gg:doc/NDK/Guide/Include/proto/integer.h"
@MASTER   "gg:os-include/proto/integer.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:06
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "proto/integer.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"proto/integer.h" LINK File}

@ENDNODE
@NODE File "proto/integer.h"
#ifndef _PROTO_INTEGER_H
#define _PROTO_INTEGER_H

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#if !defined(CLIB_INTEGER_PROTOS_H) && !defined(__GNUC__)
#include <@{"clib/integer_protos.h" LINK "gg:doc/NDK/Guide/Include/clib/integer_protos.h/File"}>
#endif

#ifndef __NOLIBBASE__
extern @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34} *IntegerBase;
#endif

#ifdef __GNUC__
#include <@{"inline/integer.h" LINK "gg:doc/NDK/Guide/Include/inline/integer.h/File"}>
#elif !defined(__VBCC__)
#include <@{"pragma/integer_lib.h" LINK "gg:doc/NDK/Guide/Include/pragma/integer_lib.h/File"}>
#endif

#endif  /*  _PROTO_INTEGER_H  */
@ENDNODE
