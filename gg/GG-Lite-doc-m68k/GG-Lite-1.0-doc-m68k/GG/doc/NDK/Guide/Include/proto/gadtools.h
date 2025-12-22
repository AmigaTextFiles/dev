@DATABASE "gg:doc/NDK/Guide/Include/proto/gadtools.h"
@MASTER   "gg:os-include/proto/gadtools.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:04
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "proto/gadtools.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"proto/gadtools.h" LINK File}

@ENDNODE
@NODE File "proto/gadtools.h"
#ifndef _PROTO_GADTOOLS_H
#define _PROTO_GADTOOLS_H

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#if !defined(CLIB_GADTOOLS_PROTOS_H) && !defined(__GNUC__)
#include <@{"clib/gadtools_protos.h" LINK "gg:doc/NDK/Guide/Include/clib/gadtools_protos.h/File"}>
#endif

#ifndef __NOLIBBASE__
extern @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34} *GadToolsBase;
#endif

#ifdef __GNUC__
#include <@{"inline/gadtools.h" LINK "gg:doc/NDK/Guide/Include/inline/gadtools.h/File"}>
#elif !defined(__VBCC__)
#include <@{"pragma/gadtools_lib.h" LINK "gg:doc/NDK/Guide/Include/pragma/gadtools_lib.h/File"}>
#endif

#endif  /*  _PROTO_GADTOOLS_H  */
@ENDNODE
