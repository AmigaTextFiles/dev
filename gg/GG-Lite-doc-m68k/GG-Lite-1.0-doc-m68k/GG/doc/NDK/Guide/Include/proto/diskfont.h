@DATABASE "gg:doc/NDK/Guide/Include/proto/diskfont.h"
@MASTER   "gg:os-include/proto/diskfont.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:03
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "proto/diskfont.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"proto/diskfont.h" LINK File}

@ENDNODE
@NODE File "proto/diskfont.h"
#ifndef _PROTO_DISKFONT_H
#define _PROTO_DISKFONT_H

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#if !defined(CLIB_DISKFONT_PROTOS_H) && !defined(__GNUC__)
#include <@{"clib/diskfont_protos.h" LINK "gg:doc/NDK/Guide/Include/clib/diskfont_protos.h/File"}>
#endif

#ifndef __NOLIBBASE__
extern @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34} *DiskfontBase;
#endif

#ifdef __GNUC__
#include <@{"inline/diskfont.h" LINK "gg:doc/NDK/Guide/Include/inline/diskfont.h/File"}>
#elif !defined(__VBCC__)
#include <@{"pragma/diskfont_lib.h" LINK "gg:doc/NDK/Guide/Include/pragma/diskfont_lib.h/File"}>
#endif

#endif  /*  _PROTO_DISKFONT_H  */
@ENDNODE
