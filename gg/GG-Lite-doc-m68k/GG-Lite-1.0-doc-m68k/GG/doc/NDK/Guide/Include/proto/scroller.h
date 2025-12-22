@DATABASE "gg:doc/NDK/Guide/Include/proto/scroller.h"
@MASTER   "gg:os-include/proto/scroller.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:10
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "proto/scroller.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"proto/scroller.h" LINK File}

@ENDNODE
@NODE File "proto/scroller.h"
#ifndef _PROTO_SCROLLER_H
#define _PROTO_SCROLLER_H

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#if !defined(CLIB_SCROLLER_PROTOS_H) && !defined(__GNUC__)
#include <@{"clib/scroller_protos.h" LINK "gg:doc/NDK/Guide/Include/clib/scroller_protos.h/File"}>
#endif

#ifndef __NOLIBBASE__
extern @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34} *ScrollerBase;
#endif

#ifdef __GNUC__
#include <@{"inline/scroller.h" LINK "gg:doc/NDK/Guide/Include/inline/scroller.h/File"}>
#elif !defined(__VBCC__)
#include <@{"pragma/scroller_lib.h" LINK "gg:doc/NDK/Guide/Include/pragma/scroller_lib.h/File"}>
#endif

#endif  /*  _PROTO_SCROLLER_H  */
@ENDNODE
