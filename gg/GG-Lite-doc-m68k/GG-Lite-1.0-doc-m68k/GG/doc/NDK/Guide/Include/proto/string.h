@DATABASE "gg:doc/NDK/Guide/Include/proto/string.h"
@MASTER   "gg:os-include/proto/string.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:10
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "proto/string.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"proto/string.h" LINK File}

@ENDNODE
@NODE File "proto/string.h"
#ifndef _PROTO_STRING_H
#define _PROTO_STRING_H

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#if !defined(CLIB_STRING_PROTOS_H) && !defined(__GNUC__)
#include <@{"clib/string_protos.h" LINK "gg:doc/NDK/Guide/Include/clib/string_protos.h/File"}>
#endif

#ifndef __NOLIBBASE__
extern @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34} *StringBase;
#endif

#ifdef __GNUC__
#include <@{"inline/string.h" LINK "gg:doc/NDK/Guide/Include/inline/string.h/File"}>
#elif !defined(__VBCC__)
#include <@{"pragma/string_lib.h" LINK "gg:doc/NDK/Guide/Include/pragma/string_lib.h/File"}>
#endif

#endif  /*  _PROTO_STRING_H  */
@ENDNODE
