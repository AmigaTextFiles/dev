@DATABASE "gg:doc/NDK/Guide/Include/proto/translator.h"
@MASTER   "gg:os-include/proto/translator.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:11
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "proto/translator.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"proto/translator.h" LINK File}

@ENDNODE
@NODE File "proto/translator.h"
#ifndef _PROTO_TRANSLATOR_H
#define _PROTO_TRANSLATOR_H

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#if !defined(CLIB_TRANSLATOR_PROTOS_H) && !defined(__GNUC__)
#include <@{"clib/translator_protos.h" LINK "gg:doc/NDK/Guide/Include/clib/translator_protos.h/File"}>
#endif

#ifndef __NOLIBBASE__
extern @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34} *TranslatorBase;
#endif

#ifdef __GNUC__
#include <@{"inline/translator.h" LINK "gg:doc/NDK/Guide/Include/inline/translator.h/File"}>
#elif !defined(__VBCC__)
#include <@{"pragma/translator_lib.h" LINK "gg:doc/NDK/Guide/Include/pragma/translator_lib.h/File"}>
#endif

#endif  /*  _PROTO_TRANSLATOR_H  */
@ENDNODE
