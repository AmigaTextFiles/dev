@DATABASE "gg:doc/NDK/Guide/Include/proto/mathtrans.h"
@MASTER   "gg:os-include/proto/mathtrans.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:08
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "proto/mathtrans.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"proto/mathtrans.h" LINK File}

@ENDNODE
@NODE File "proto/mathtrans.h"
#ifndef _PROTO_MATHTRANS_H
#define _PROTO_MATHTRANS_H

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#if !defined(CLIB_MATHTRANS_PROTOS_H) && !defined(__GNUC__)
#include <@{"clib/mathtrans_protos.h" LINK "gg:doc/NDK/Guide/Include/clib/mathtrans_protos.h/File"}>
#endif

#ifndef __NOLIBBASE__
extern @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34} *MathTransBase;
#endif

#ifdef __GNUC__
#include <@{"inline/mathtrans.h" LINK "gg:doc/NDK/Guide/Include/inline/mathtrans.h/File"}>
#elif !defined(__VBCC__)
#include <@{"pragma/mathtrans_lib.h" LINK "gg:doc/NDK/Guide/Include/pragma/mathtrans_lib.h/File"}>
#endif

#endif  /*  _PROTO_MATHTRANS_H  */
@ENDNODE
