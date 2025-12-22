@DATABASE "gg:doc/NDK/Guide/Include/proto/expansion.h"
@MASTER   "gg:os-include/proto/expansion.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:04
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "proto/expansion.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"proto/expansion.h" LINK File}

@ENDNODE
@NODE File "proto/expansion.h"
#ifndef _PROTO_EXPANSION_H
#define _PROTO_EXPANSION_H

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#if !defined(CLIB_EXPANSION_PROTOS_H) && !defined(__GNUC__)
#include <@{"clib/expansion_protos.h" LINK "gg:doc/NDK/Guide/Include/clib/expansion_protos.h/File"}>
#endif

#ifndef __NOLIBBASE__
extern @{"struct ExpansionBase" LINK "gg:doc/NDK/Guide/Include/libraries/expansionbase.h/File" 44} *ExpansionBase;
#endif

#ifdef __GNUC__
#include <@{"inline/expansion.h" LINK "gg:doc/NDK/Guide/Include/inline/expansion.h/File"}>
#elif !defined(__VBCC__)
#include <@{"pragma/expansion_lib.h" LINK "gg:doc/NDK/Guide/Include/pragma/expansion_lib.h/File"}>
#endif

#endif  /*  _PROTO_EXPANSION_H  */
@ENDNODE
