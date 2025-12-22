@DATABASE "gg:doc/NDK/Guide/Include/proto/mathieeesingtrans.h"
@MASTER   "gg:os-include/proto/mathieeesingtrans.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:07
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "proto/mathieeesingtrans.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"proto/mathieeesingtrans.h" LINK File}

@ENDNODE
@NODE File "proto/mathieeesingtrans.h"
#ifndef _PROTO_MATHIEEESINGTRANS_H
#define _PROTO_MATHIEEESINGTRANS_H

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#if !defined(CLIB_MATHIEEESINGTRANS_PROTOS_H) && !defined(__GNUC__)
#include <@{"clib/mathieeesingtrans_protos.h" LINK "gg:doc/NDK/Guide/Include/clib/mathieeesingtrans_protos.h/File"}>
#endif

#ifndef __NOLIBBASE__
extern @{"struct MathIEEEBase" LINK "gg:doc/NDK/Guide/Include/libraries/mathlibrary.h/File" 19} *MathIeeeSingTransBase;
#endif

#ifdef __GNUC__
#include <@{"inline/mathieeesingtrans.h" LINK "gg:doc/NDK/Guide/Include/inline/mathieeesingtrans.h/File"}>
#elif !defined(__VBCC__)
#include <@{"pragma/mathieeesingtrans_lib.h" LINK "gg:doc/NDK/Guide/Include/pragma/mathieeesingtrans_lib.h/File"}>
#endif

#endif  /*  _PROTO_MATHIEEESINGTRANS_H  */
@ENDNODE
