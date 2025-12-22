@DATABASE "gg:doc/NDK/Guide/Include/proto/commodities.h"
@MASTER   "gg:os-include/proto/commodities.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:02
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "proto/commodities.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"proto/commodities.h" LINK File}

@ENDNODE
@NODE File "proto/commodities.h"
#ifndef _PROTO_COMMODITIES_H
#define _PROTO_COMMODITIES_H

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#if !defined(CLIB_COMMODITIES_PROTOS_H) && !defined(__GNUC__)
#include <@{"clib/commodities_protos.h" LINK "gg:doc/NDK/Guide/Include/clib/commodities_protos.h/File"}>
#endif

#ifndef __NOLIBBASE__
extern @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34} *CxBase;
#endif

#ifdef __GNUC__
#include <@{"inline/commodities.h" LINK "gg:doc/NDK/Guide/Include/inline/commodities.h/File"}>
#elif !defined(__VBCC__)
#include <@{"pragma/commodities_lib.h" LINK "gg:doc/NDK/Guide/Include/pragma/commodities_lib.h/File"}>
#endif

#endif  /*  _PROTO_COMMODITIES_H  */
@ENDNODE
