@DATABASE "gg:doc/NDK/Guide/Include/proto/intuition.h"
@MASTER   "gg:os-include/proto/intuition.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:06
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "proto/intuition.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"proto/intuition.h" LINK File}

@ENDNODE
@NODE File "proto/intuition.h"
#ifndef _PROTO_INTUITION_H
#define _PROTO_INTUITION_H

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#if !defined(CLIB_INTUITION_PROTOS_H) && !defined(__GNUC__)
#include <@{"clib/intuition_protos.h" LINK "gg:doc/NDK/Guide/Include/clib/intuition_protos.h/File"}>
#endif

#ifndef __NOLIBBASE__
extern @{"struct IntuitionBase" LINK "gg:doc/NDK/Guide/Include/intuition/intuitionbase.h/File" 66} *IntuitionBase;
#endif

#ifdef __GNUC__
#include <@{"inline/intuition.h" LINK "gg:doc/NDK/Guide/Include/inline/intuition.h/File"}>
#elif !defined(__VBCC__)
#include <@{"pragma/intuition_lib.h" LINK "gg:doc/NDK/Guide/Include/pragma/intuition_lib.h/File"}>
#endif

#endif  /*  _PROTO_INTUITION_H  */
@ENDNODE
