@DATABASE "gg:doc/NDK/Guide/Include/proto/bullet.h"
@MASTER   "gg:os-include/proto/bullet.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:01
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "proto/bullet.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"proto/bullet.h" LINK File}

@ENDNODE
@NODE File "proto/bullet.h"
#ifndef _PROTO_BULLET_H
#define _PROTO_BULLET_H

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#if !defined(CLIB_BULLET_PROTOS_H) && !defined(__GNUC__)
#include <@{"clib/bullet_protos.h" LINK "gg:doc/NDK/Guide/Include/clib/bullet_protos.h/File"}>
#endif

#ifndef __NOLIBBASE__
extern @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34} *BulletBase;
#endif

#ifdef __GNUC__
#include <@{"inline/bullet.h" LINK "gg:doc/NDK/Guide/Include/inline/bullet.h/File"}>
#elif !defined(__VBCC__)
#include <@{"pragma/bullet_lib.h" LINK "gg:doc/NDK/Guide/Include/pragma/bullet_lib.h/File"}>
#endif

#endif  /*  _PROTO_BULLET_H  */
@ENDNODE
