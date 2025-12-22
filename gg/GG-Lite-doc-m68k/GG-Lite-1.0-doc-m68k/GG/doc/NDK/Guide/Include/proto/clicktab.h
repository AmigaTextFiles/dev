@DATABASE "gg:doc/NDK/Guide/Include/proto/clicktab.h"
@MASTER   "gg:os-include/proto/clicktab.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:02
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "proto/clicktab.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"proto/clicktab.h" LINK File}

@ENDNODE
@NODE File "proto/clicktab.h"
#ifndef _PROTO_CLICKTAB_H
#define _PROTO_CLICKTAB_H

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#if !defined(CLIB_CLICKTAB_PROTOS_H) && !defined(__GNUC__)
#include <@{"clib/clicktab_protos.h" LINK "gg:doc/NDK/Guide/Include/clib/clicktab_protos.h/File"}>
#endif

#ifndef __NOLIBBASE__
extern @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34} *ClickTabBase;
#endif

#ifdef __GNUC__
#include <@{"inline/clicktab.h" LINK "gg:doc/NDK/Guide/Include/inline/clicktab.h/File"}>
#elif !defined(__VBCC__)
#include <@{"pragma/clicktab_lib.h" LINK "gg:doc/NDK/Guide/Include/pragma/clicktab_lib.h/File"}>
#endif

#endif  /*  _PROTO_CLICKTAB_H  */
@ENDNODE
