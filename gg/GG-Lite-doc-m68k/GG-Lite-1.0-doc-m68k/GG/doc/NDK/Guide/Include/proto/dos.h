@DATABASE "gg:doc/NDK/Guide/Include/proto/dos.h"
@MASTER   "gg:os-include/proto/dos.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:03
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "proto/dos.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"proto/dos.h" LINK File}

@ENDNODE
@NODE File "proto/dos.h"
#ifndef _PROTO_DOS_H
#define _PROTO_DOS_H

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#if !defined(CLIB_DOS_PROTOS_H) && !defined(__GNUC__)
#include <@{"clib/dos_protos.h" LINK "gg:doc/NDK/Guide/Include/clib/dos_protos.h/File"}>
#endif

#ifndef __NOLIBBASE__
extern @{"struct DosLibrary" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 237} *DOSBase;
#endif

#ifdef __GNUC__
#include <@{"inline/dos.h" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File"}>
#elif !defined(__VBCC__)
#include <@{"pragma/dos_lib.h" LINK "gg:doc/NDK/Guide/Include/pragma/dos_lib.h/File"}>
#endif

#endif  /*  _PROTO_DOS_H  */
@ENDNODE
