@DATABASE "gg:doc/NDK/Guide/Include/proto/misc.h"
@MASTER   "gg:os-include/proto/misc.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:08
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "proto/misc.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"proto/misc.h" LINK File}

@ENDNODE
@NODE File "proto/misc.h"
#ifndef _PROTO_MISC_H
#define _PROTO_MISC_H

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#if !defined(CLIB_MISC_PROTOS_H) && !defined(__GNUC__)
#include <@{"clib/misc_protos.h" LINK "gg:doc/NDK/Guide/Include/clib/misc_protos.h/File"}>
#endif

#ifndef __NOLIBBASE__
extern @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34} *MiscBase;
#endif

#ifdef __GNUC__
#include <@{"inline/misc.h" LINK "gg:doc/NDK/Guide/Include/inline/misc.h/File"}>
#elif !defined(__VBCC__)
#include <@{"pragma/misc_lib.h" LINK "gg:doc/NDK/Guide/Include/pragma/misc_lib.h/File"}>
#endif

#endif  /*  _PROTO_MISC_H  */
@ENDNODE
