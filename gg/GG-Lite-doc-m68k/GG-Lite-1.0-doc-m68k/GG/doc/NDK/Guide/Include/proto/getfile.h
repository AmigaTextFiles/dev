@DATABASE "gg:doc/NDK/Guide/Include/proto/getfile.h"
@MASTER   "gg:os-include/proto/getfile.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:04
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "proto/getfile.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"proto/getfile.h" LINK File}

@ENDNODE
@NODE File "proto/getfile.h"
#ifndef _PROTO_GETFILE_H
#define _PROTO_GETFILE_H

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#if !defined(CLIB_GETFILE_PROTOS_H) && !defined(__GNUC__)
#include <@{"clib/getfile_protos.h" LINK "gg:doc/NDK/Guide/Include/clib/getfile_protos.h/File"}>
#endif

#ifndef __NOLIBBASE__
extern @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34} *GetFileBase;
#endif

#ifdef __GNUC__
#include <@{"inline/getfile.h" LINK "gg:doc/NDK/Guide/Include/inline/getfile.h/File"}>
#elif !defined(__VBCC__)
#include <@{"pragma/getfile_lib.h" LINK "gg:doc/NDK/Guide/Include/pragma/getfile_lib.h/File"}>
#endif

#endif  /*  _PROTO_GETFILE_H  */
@ENDNODE
