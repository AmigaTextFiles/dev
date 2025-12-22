@DATABASE "gg:doc/NDK/Guide/Include/proto/battmem.h"
@MASTER   "gg:os-include/proto/battmem.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:01
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "proto/battmem.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"proto/battmem.h" LINK File}

@ENDNODE
@NODE File "proto/battmem.h"
#ifndef _PROTO_BATTMEM_H
#define _PROTO_BATTMEM_H

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#if !defined(CLIB_BATTMEM_PROTOS_H) && !defined(__GNUC__)
#include <@{"clib/battmem_protos.h" LINK "gg:doc/NDK/Guide/Include/clib/battmem_protos.h/File"}>
#endif

#ifndef __NOLIBBASE__
extern @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34} *BattMemBase;
#endif

#ifdef __GNUC__
#include <@{"inline/battmem.h" LINK "gg:doc/NDK/Guide/Include/inline/battmem.h/File"}>
#elif !defined(__VBCC__)
#include <@{"pragma/battmem_lib.h" LINK "gg:doc/NDK/Guide/Include/pragma/battmem_lib.h/File"}>
#endif

#endif  /*  _PROTO_BATTMEM_H  */
@ENDNODE
