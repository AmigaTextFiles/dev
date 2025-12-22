@DATABASE "gg:doc/NDK/Guide/Include/clib/asl_protos.h"
@MASTER   "gg:os-include/clib/asl_protos.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:11:30
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "clib/asl_protos.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"clib/asl_protos.h" LINK File}

@ENDNODE
@NODE File "clib/asl_protos.h"
#ifndef  CLIB_ASL_PROTOS_H
#define  CLIB_ASL_PROTOS_H

/*
**      $VER: asl_protos.h 38.3 (19.3.1992)
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
#ifndef  UTILITY_TAGITEM_H
#include <@{"utility/tagitem.h" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File"}>
#endif
#ifndef  LIBRARIES_ASL_H
#include <@{"libraries/asl.h" LINK "gg:doc/NDK/Guide/Include/libraries/asl.h/File"}>
#endif
/*--- functions in V36 or higher (Release 2.0) ---*/

/* OBSOLETE -- Please use the generic requester functions instead */

@{"struct FileRequester" LINK "gg:doc/NDK/Guide/Include/libraries/asl.h/File" 71} *AllocFileRequest( VOID );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"FreeFileRequest" LINK "gg:doc/NDK/Guide/Include/inline/asl.h/File" 30}( @{"struct FileRequester" LINK "gg:doc/NDK/Guide/Include/libraries/asl.h/File" 71} *fileReq );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"RequestFile" LINK "gg:doc/NDK/Guide/Include/inline/asl.h/File" 34}( @{"struct FileRequester" LINK "gg:doc/NDK/Guide/Include/libraries/asl.h/File" 71} *fileReq );
@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"AllocAslRequest" LINK "gg:doc/NDK/Guide/Include/inline/asl.h/File" 38}( @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} reqType, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *tagList );
@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"AllocAslRequestTags" LINK "gg:doc/NDK/Guide/Include/inline/asl.h/File" 43}( @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} reqType, @{"Tag" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 30} tag1, ... );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"FreeAslRequest" LINK "gg:doc/NDK/Guide/Include/inline/asl.h/File" 47}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} requester );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"AslRequest" LINK "gg:doc/NDK/Guide/Include/inline/asl.h/File" 51}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} requester, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *tagList );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"AslRequestTags" LINK "gg:doc/NDK/Guide/Include/inline/asl.h/File" 56}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} requester, @{"Tag" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 30} tag1, ... );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"AbortAslRequest" LINK "gg:doc/NDK/Guide/Include/inline/asl.h/File" 60}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} requester );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"ActivateAslRequest" LINK "gg:doc/NDK/Guide/Include/inline/asl.h/File" 64}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} requester );

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif   /* CLIB_ASL_PROTOS_H */
@ENDNODE
