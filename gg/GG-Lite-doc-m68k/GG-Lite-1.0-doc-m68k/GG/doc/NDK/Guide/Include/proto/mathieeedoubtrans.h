@DATABASE "gg:doc/NDK/Guide/Include/proto/mathieeedoubtrans.h"
@MASTER   "gg:os-include/proto/mathieeedoubtrans.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:07
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "proto/mathieeedoubtrans.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"proto/mathieeedoubtrans.h" LINK File}

@ENDNODE
@NODE File "proto/mathieeedoubtrans.h"
#ifndef _PROTO_MATHIEEEDOUBTRANS_H
#define _PROTO_MATHIEEEDOUBTRANS_H

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#if !defined(CLIB_MATHIEEEDOUBTRANS_PROTOS_H) && !defined(__GNUC__)
#include <@{"clib/mathieeedoubtrans_protos.h" LINK "gg:doc/NDK/Guide/Include/clib/mathieeedoubtrans_protos.h/File"}>
#endif

#ifndef __NOLIBBASE__
extern @{"struct MathIEEEBase" LINK "gg:doc/NDK/Guide/Include/libraries/mathlibrary.h/File" 19} *MathIeeeDoubTransBase;
#endif

#ifdef __GNUC__
#include <@{"inline/mathieeedoubtrans.h" LINK "gg:doc/NDK/Guide/Include/inline/mathieeedoubtrans.h/File"}>
#elif !defined(__VBCC__)
#include <@{"pragma/mathieeedoubtrans_lib.h" LINK "gg:doc/NDK/Guide/Include/pragma/mathieeedoubtrans_lib.h/File"}>
#endif

#endif  /*  _PROTO_MATHIEEEDOUBTRANS_H  */
@ENDNODE
