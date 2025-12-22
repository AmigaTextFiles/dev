@DATABASE "gg:doc/NDK/Guide/Include/clib/amigaguide_protos.h"
@MASTER   "gg:os-include/clib/amigaguide_protos.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:11:28
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "clib/amigaguide_protos.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"clib/amigaguide_protos.h" LINK File}

@ENDNODE
@NODE File "clib/amigaguide_protos.h"
#ifndef  CLIB_AMIGAGUIDE_PROTOS_H
#define  CLIB_AMIGAGUIDE_PROTOS_H

/*
**      $VER: amigaguide_protos.h 39.4 (17.6.1993)
**
**      C prototypes. For use with 32 bit integers only.
**
**      Copyright © 2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

#ifndef  EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#ifndef  EXEC_PORTS_H
#include <@{"exec/ports.h" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File"}>
#endif
#ifndef  DOS_DOS_H
#include <@{"dos/dos.h" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File"}>
#endif
#ifndef  LIBRARIES_AMIGAGUIDE_H
#include <@{"libraries/amigaguide.h" LINK "gg:doc/NDK/Guide/Include/libraries/amigaguide.h/File"}>
#endif
#ifndef  UTILITY_TAGITEM_H
#include <@{"utility/tagitem.h" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File"}>
#endif
#ifndef  UTILITY_HOOKS_H
#include <@{"utility/hooks.h" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File"}>
#endif
#ifndef  REXX_STORAGE_H
#include <@{"rexx/storage.h" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File"}>
#endif
/*--- functions in V40 or higher (Release 3.1) ---*/

/* Public entries */

@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"LockAmigaGuideBase" LINK "gg:doc/NDK/Guide/Include/inline/amigaguide.h/File" 38}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} handle );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"UnlockAmigaGuideBase" LINK "gg:doc/NDK/Guide/Include/inline/amigaguide.h/File" 42}( @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} key );
@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"OpenAmigaGuideA" LINK "gg:doc/NDK/Guide/Include/inline/amigaguide.h/File" 46}( @{"struct NewAmigaGuide" LINK "gg:doc/NDK/Guide/Include/libraries/amigaguide.h/File" 103} *nag, struct TagItem *tags );
@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"OpenAmigaGuide" LINK "gg:doc/NDK/Guide/Include/inline/amigaguide.h/File" 51}( @{"struct NewAmigaGuide" LINK "gg:doc/NDK/Guide/Include/libraries/amigaguide.h/File" 103} *nag, Tag tag1, ... );
@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"OpenAmigaGuideAsyncA" LINK "gg:doc/NDK/Guide/Include/inline/amigaguide.h/File" 55}( @{"struct NewAmigaGuide" LINK "gg:doc/NDK/Guide/Include/libraries/amigaguide.h/File" 103} *nag, struct TagItem *attrs );
@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"OpenAmigaGuideAsync" LINK "gg:doc/NDK/Guide/Include/inline/amigaguide.h/File" 60}( @{"struct NewAmigaGuide" LINK "gg:doc/NDK/Guide/Include/libraries/amigaguide.h/File" 103} *nag, Tag tag1, ... );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"CloseAmigaGuide" LINK "gg:doc/NDK/Guide/Include/inline/amigaguide.h/File" 64}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} cl );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"AmigaGuideSignal" LINK "gg:doc/NDK/Guide/Include/inline/amigaguide.h/File" 68}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} cl );
@{"struct AmigaGuideMsg" LINK "gg:doc/NDK/Guide/Include/libraries/amigaguide.h/File" 89} *GetAmigaGuideMsg( APTR cl );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"ReplyAmigaGuideMsg" LINK "gg:doc/NDK/Guide/Include/inline/amigaguide.h/File" 76}( @{"struct AmigaGuideMsg" LINK "gg:doc/NDK/Guide/Include/libraries/amigaguide.h/File" 89} *amsg );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"SetAmigaGuideContextA" LINK "gg:doc/NDK/Guide/Include/inline/amigaguide.h/File" 80}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} cl, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} id, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *attrs );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"SetAmigaGuideContext" LINK "gg:doc/NDK/Guide/Include/inline/amigaguide.h/File" 85}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} cl, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} id, @{"Tag" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 30} tag1, ... );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"SendAmigaGuideContextA" LINK "gg:doc/NDK/Guide/Include/inline/amigaguide.h/File" 89}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} cl, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *attrs );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"SendAmigaGuideContext" LINK "gg:doc/NDK/Guide/Include/inline/amigaguide.h/File" 94}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} cl, @{"Tag" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 30} tag1, ... );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"SendAmigaGuideCmdA" LINK "gg:doc/NDK/Guide/Include/inline/amigaguide.h/File" 98}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} cl, @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} cmd, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *attrs );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"SendAmigaGuideCmd" LINK "gg:doc/NDK/Guide/Include/inline/amigaguide.h/File" 103}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} cl, @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} cmd, @{"Tag" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 30} tag1, ... );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"SetAmigaGuideAttrsA" LINK "gg:doc/NDK/Guide/Include/inline/amigaguide.h/File" 107}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} cl, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *attrs );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"SetAmigaGuideAttrs" LINK "gg:doc/NDK/Guide/Include/inline/amigaguide.h/File" 112}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} cl, @{"Tag" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 30} tag1, ... );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"GetAmigaGuideAttr" LINK "gg:doc/NDK/Guide/Include/inline/amigaguide.h/File" 116}( @{"Tag" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 30} tag, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} cl, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} *storage );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"LoadXRef" LINK "gg:doc/NDK/Guide/Include/inline/amigaguide.h/File" 120}( @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} lock, @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} name );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"ExpungeXRef" LINK "gg:doc/NDK/Guide/Include/inline/amigaguide.h/File" 124}( @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} );
@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"AddAmigaGuideHostA" LINK "gg:doc/NDK/Guide/Include/inline/amigaguide.h/File" 128}( @{"struct Hook" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File" 28} *h, STRPTR name, struct TagItem *attrs );
@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"AddAmigaGuideHost" LINK "gg:doc/NDK/Guide/Include/inline/amigaguide.h/File" 133}( @{"struct Hook" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File" 28} *h, STRPTR name, Tag tag1, ... );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"RemoveAmigaGuideHostA" LINK "gg:doc/NDK/Guide/Include/inline/amigaguide.h/File" 137}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} hh, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *attrs );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"RemoveAmigaGuideHost" LINK "gg:doc/NDK/Guide/Include/inline/amigaguide.h/File" 142}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} hh, @{"Tag" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 30} tag1, ... );
@{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} @{"GetAmigaGuideString" LINK "gg:doc/NDK/Guide/Include/inline/amigaguide.h/File" 146}( @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} id );

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif   /* CLIB_AMIGAGUIDE_PROTOS_H */
@ENDNODE
