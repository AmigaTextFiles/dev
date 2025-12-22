@DATABASE "gg:doc/NDK/Guide/Include/proto/wb.h"
@MASTER   "gg:os-include/proto/wb.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:11
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "proto/wb.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"proto/wb.h" LINK File}

@ENDNODE
@NODE File "proto/wb.h"
#ifndef _PROTO_WB_H
#define _PROTO_WB_H

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#if !defined(CLIB_WB_PROTOS_H) && !defined(__GNUC__)
#include <@{"clib/wb_protos.h" LINK "gg:doc/NDK/Guide/Include/clib/wb_protos.h/File"}>
#endif

#ifndef __NOLIBBASE__
extern @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34} *WorkbenchBase;
#endif

#ifdef __GNUC__
#include <@{"inline/wb.h" LINK "gg:doc/NDK/Guide/Include/inline/wb.h/File"}>
#elif !defined(__VBCC__)
#include <@{"pragma/wb_lib.h" LINK "gg:doc/NDK/Guide/Include/pragma/wb_lib.h/File"}>
#endif

#endif  /*  _PROTO_WB_H  */
@ENDNODE
