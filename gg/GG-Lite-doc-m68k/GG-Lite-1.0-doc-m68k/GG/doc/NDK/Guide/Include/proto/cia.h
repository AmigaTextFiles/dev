@DATABASE "gg:doc/NDK/Guide/Include/proto/cia.h"
@MASTER   "gg:os-include/proto/cia.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:02
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "proto/cia.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"proto/cia.h" LINK File}

@ENDNODE
@NODE File "proto/cia.h"
#ifndef _PROTO_CIA_H
#define _PROTO_CIA_H

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#if !defined(CLIB_CIA_PROTOS_H) && !defined(__GNUC__)
#include <@{"clib/cia_protos.h" LINK "gg:doc/NDK/Guide/Include/clib/cia_protos.h/File"}>
#endif

#ifdef __GNUC__
#include <@{"inline/cia.h" LINK "gg:doc/NDK/Guide/Include/inline/cia.h/File"}>
#elif !defined(__VBCC__)
#include <@{"pragma/cia_lib.h" LINK "gg:doc/NDK/Guide/Include/pragma/cia_lib.h/File"}>
#endif

#endif  /*  _PROTO_CIA_H  */
@ENDNODE
