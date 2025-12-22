@DATABASE "gg:doc/NDK/Guide/Include/proto/arexx.h"
@MASTER   "gg:os-include/proto/arexx.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:00
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "proto/arexx.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"proto/arexx.h" LINK File}

@ENDNODE
@NODE File "proto/arexx.h"
#ifndef _PROTO_AREXX_H
#define _PROTO_AREXX_H

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#if !defined(CLIB_AREXX_PROTOS_H) && !defined(__GNUC__)
#include <@{"clib/arexx_protos.h" LINK "gg:doc/NDK/Guide/Include/clib/arexx_protos.h/File"}>
#endif

#ifndef __NOLIBBASE__
extern @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34} *ARexxBase;
#endif

#ifdef __GNUC__
#include <@{"inline/arexx.h" LINK "gg:doc/NDK/Guide/Include/inline/arexx.h/File"}>
#elif !defined(__VBCC__)
#include <@{"pragma/arexx_lib.h" LINK "gg:doc/NDK/Guide/Include/pragma/arexx_lib.h/File"}>
#endif

#endif  /*  _PROTO_AREXX_H  */
@ENDNODE
