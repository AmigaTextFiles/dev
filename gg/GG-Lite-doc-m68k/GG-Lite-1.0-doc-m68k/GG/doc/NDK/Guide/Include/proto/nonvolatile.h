@DATABASE "gg:doc/NDK/Guide/Include/proto/nonvolatile.h"
@MASTER   "gg:os-include/proto/nonvolatile.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:08
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "proto/nonvolatile.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"proto/nonvolatile.h" LINK File}

@ENDNODE
@NODE File "proto/nonvolatile.h"
#ifndef _PROTO_NONVOLATILE_H
#define _PROTO_NONVOLATILE_H

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#if !defined(CLIB_NONVOLATILE_PROTOS_H) && !defined(__GNUC__)
#include <@{"clib/nonvolatile_protos.h" LINK "gg:doc/NDK/Guide/Include/clib/nonvolatile_protos.h/File"}>
#endif

#ifndef __NOLIBBASE__
extern @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34} *NVBase;
#endif

#ifdef __GNUC__
#include <@{"inline/nonvolatile.h" LINK "gg:doc/NDK/Guide/Include/inline/nonvolatile.h/File"}>
#elif !defined(__VBCC__)
#include <@{"pragma/nonvolatile_lib.h" LINK "gg:doc/NDK/Guide/Include/pragma/nonvolatile_lib.h/File"}>
#endif

#endif  /*  _PROTO_NONVOLATILE_H  */
@ENDNODE
