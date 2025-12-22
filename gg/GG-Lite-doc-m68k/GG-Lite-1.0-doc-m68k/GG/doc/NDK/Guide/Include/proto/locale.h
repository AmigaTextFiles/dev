@DATABASE "gg:doc/NDK/Guide/Include/proto/locale.h"
@MASTER   "gg:os-include/proto/locale.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:07
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "proto/locale.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"proto/locale.h" LINK File}

@ENDNODE
@NODE File "proto/locale.h"
#ifndef _PROTO_LOCALE_H
#define _PROTO_LOCALE_H

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#if !defined(CLIB_LOCALE_PROTOS_H) && !defined(__GNUC__)
#include <@{"clib/locale_protos.h" LINK "gg:doc/NDK/Guide/Include/clib/locale_protos.h/File"}>
#endif

#ifndef __NOLIBBASE__
extern @{"struct LocaleBase" LINK "gg:doc/NDK/Guide/Include/libraries/locale.h/File" 107} *LocaleBase;
#endif

#ifdef __GNUC__
#include <@{"inline/locale.h" LINK "gg:doc/NDK/Guide/Include/inline/locale.h/File"}>
#elif !defined(__VBCC__)
#include <@{"pragma/locale_lib.h" LINK "gg:doc/NDK/Guide/Include/pragma/locale_lib.h/File"}>
#endif

#endif  /*  _PROTO_LOCALE_H  */
@ENDNODE
