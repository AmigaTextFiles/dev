@DATABASE "gg:doc/NDK/Guide/Include/proto/mathieeesingbas.h"
@MASTER   "gg:os-include/proto/mathieeesingbas.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:07
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "proto/mathieeesingbas.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"proto/mathieeesingbas.h" LINK File}

@ENDNODE
@NODE File "proto/mathieeesingbas.h"
#ifndef _PROTO_MATHIEEESINGBAS_H
#define _PROTO_MATHIEEESINGBAS_H

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#if !defined(CLIB_MATHIEEESINGBAS_PROTOS_H) && !defined(__GNUC__)
#include <@{"clib/mathieeesingbas_protos.h" LINK "gg:doc/NDK/Guide/Include/clib/mathieeesingbas_protos.h/File"}>
#endif

#ifndef __NOLIBBASE__
extern @{"struct MathIEEEBase" LINK "gg:doc/NDK/Guide/Include/libraries/mathlibrary.h/File" 19} *MathIeeeSingBasBase;
#endif

#ifdef __GNUC__
#include <@{"inline/mathieeesingbas.h" LINK "gg:doc/NDK/Guide/Include/inline/mathieeesingbas.h/File"}>
#elif !defined(__VBCC__)
#include <@{"pragma/mathieeesingbas_lib.h" LINK "gg:doc/NDK/Guide/Include/pragma/mathieeesingbas_lib.h/File"}>
#endif

#endif  /*  _PROTO_MATHIEEESINGBAS_H  */
@ENDNODE
