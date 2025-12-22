@DATABASE "gg:doc/NDK/Guide/Include/proto/cybergraphics.h"
@MASTER   "gg:os-include/proto/cybergraphics.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:03
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "proto/cybergraphics.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"proto/cybergraphics.h" LINK File}

@ENDNODE
@NODE File "proto/cybergraphics.h"
#ifndef _PROTO_CYBERGRAPHICS_H
#define _PROTO_CYBERGRAPHICS_H

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#if !defined(CLIB_CYBERGRAPHICS_PROTOS_H) && !defined(__GNUC__)
#include <@{"clib/cybergraphics_protos.h" LINK "gg:doc/NDK/Guide/Include/clib/cybergraphics_protos.h/File"}>
#endif

#ifndef __NOLIBBASE__
extern @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34} *CyberGfxBase;
#endif

#ifdef __GNUC__
#include <@{"inline/cybergraphics.h" LINK "gg:doc/NDK/Guide/Include/inline/cybergraphics.h/File"}>
#elif !defined(__VBCC__)
#include <pragma/cybergraphics_lib.h>
#endif

#endif  /*  _PROTO_CYBERGRAPHICS_H  */
@ENDNODE
