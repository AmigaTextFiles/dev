@DATABASE "gg:doc/NDK/Guide/Include/proto/iffparse.h"
@MASTER   "gg:os-include/proto/iffparse.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:05
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "proto/iffparse.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"proto/iffparse.h" LINK File}

@ENDNODE
@NODE File "proto/iffparse.h"
#ifndef _PROTO_IFFPARSE_H
#define _PROTO_IFFPARSE_H

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#if !defined(CLIB_IFFPARSE_PROTOS_H) && !defined(__GNUC__)
#include <@{"clib/iffparse_protos.h" LINK "gg:doc/NDK/Guide/Include/clib/iffparse_protos.h/File"}>
#endif

#ifndef __NOLIBBASE__
extern @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34} *IFFParseBase;
#endif

#ifdef __GNUC__
#include <@{"inline/iffparse.h" LINK "gg:doc/NDK/Guide/Include/inline/iffparse.h/File"}>
#elif !defined(__VBCC__)
#include <@{"pragma/iffparse_lib.h" LINK "gg:doc/NDK/Guide/Include/pragma/iffparse_lib.h/File"}>
#endif

#endif  /*  _PROTO_IFFPARSE_H  */
@ENDNODE
