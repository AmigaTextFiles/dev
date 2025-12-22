@DATABASE "gg:doc/NDK/Guide/Include/proto/keymap.h"
@MASTER   "gg:os-include/proto/keymap.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:06
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "proto/keymap.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"proto/keymap.h" LINK File}

@ENDNODE
@NODE File "proto/keymap.h"
#ifndef _PROTO_KEYMAP_H
#define _PROTO_KEYMAP_H

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#if !defined(CLIB_KEYMAP_PROTOS_H) && !defined(__GNUC__)
#include <@{"clib/keymap_protos.h" LINK "gg:doc/NDK/Guide/Include/clib/keymap_protos.h/File"}>
#endif

#ifndef __NOLIBBASE__
extern @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34} *KeymapBase;
#endif

#ifdef __GNUC__
#include <@{"inline/keymap.h" LINK "gg:doc/NDK/Guide/Include/inline/keymap.h/File"}>
#elif !defined(__VBCC__)
#include <@{"pragma/keymap_lib.h" LINK "gg:doc/NDK/Guide/Include/pragma/keymap_lib.h/File"}>
#endif

#endif  /*  _PROTO_KEYMAP_H  */
@ENDNODE
