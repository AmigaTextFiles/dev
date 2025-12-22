@DATABASE "gg:doc/NDK/Guide/Include/clib/expansion_protos.h"
@MASTER   "gg:os-include/clib/expansion_protos.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:11:41
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "clib/expansion_protos.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"clib/expansion_protos.h" LINK File}

@ENDNODE
@NODE File "clib/expansion_protos.h"
#ifndef  CLIB_EXPANSION_PROTOS_H
#define  CLIB_EXPANSION_PROTOS_H

/*
**      $VER: expansion_protos.h 40.2 (6.6.1998)
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
#ifndef  LIBRARIES_CONFIGVARS_H
#include <@{"libraries/configvars.h" LINK "gg:doc/NDK/Guide/Include/libraries/configvars.h/File"}>
#endif
#ifndef  DOS_FILEHANDLER_H
#include <@{"dos/filehandler.h" LINK "gg:doc/NDK/Guide/Include/dos/filehandler.h/File"}>
#endif
/*--- functions in V33 or higher (Release 1.2) ---*/
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"AddConfigDev" LINK "gg:doc/NDK/Guide/Include/inline/expansion.h/File" 26}( @{"struct ConfigDev" LINK "gg:doc/NDK/Guide/Include/libraries/configvars.h/File" 32} *configDev );
/*--- functions in V36 or higher (Release 2.0) ---*/
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"AddBootNode" LINK "gg:doc/NDK/Guide/Include/inline/expansion.h/File" 30}( @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} bootPri, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} flags, @{"struct DeviceNode" LINK "gg:doc/NDK/Guide/Include/dos/filehandler.h/File" 100} *deviceNode, struct ConfigDev *configDev );
/*--- functions in V33 or higher (Release 1.2) ---*/
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"AllocBoardMem" LINK "gg:doc/NDK/Guide/Include/inline/expansion.h/File" 34}( @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} slotSpec );
@{"struct ConfigDev" LINK "gg:doc/NDK/Guide/Include/libraries/configvars.h/File" 32} *AllocConfigDev( VOID );
@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"AllocExpansionMem" LINK "gg:doc/NDK/Guide/Include/inline/expansion.h/File" 42}( @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} numSlots, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} slotAlign );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"ConfigBoard" LINK "gg:doc/NDK/Guide/Include/inline/expansion.h/File" 46}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} board, @{"struct ConfigDev" LINK "gg:doc/NDK/Guide/Include/libraries/configvars.h/File" 32} *configDev );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"ConfigChain" LINK "gg:doc/NDK/Guide/Include/inline/expansion.h/File" 50}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} baseAddr );
@{"struct ConfigDev" LINK "gg:doc/NDK/Guide/Include/libraries/configvars.h/File" 32} *FindConfigDev( CONST struct ConfigDev *oldConfigDev, LONG manufacturer, LONG product );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"FreeBoardMem" LINK "gg:doc/NDK/Guide/Include/inline/expansion.h/File" 58}( @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} startSlot, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} slotSpec );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"FreeConfigDev" LINK "gg:doc/NDK/Guide/Include/inline/expansion.h/File" 62}( @{"struct ConfigDev" LINK "gg:doc/NDK/Guide/Include/libraries/configvars.h/File" 32} *configDev );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"FreeExpansionMem" LINK "gg:doc/NDK/Guide/Include/inline/expansion.h/File" 66}( @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} startSlot, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} numSlots );
@{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} @{"ReadExpansionByte" LINK "gg:doc/NDK/Guide/Include/inline/expansion.h/File" 70}( @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} board, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} offset );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"ReadExpansionRom" LINK "gg:doc/NDK/Guide/Include/inline/expansion.h/File" 74}( @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} board, @{"struct ConfigDev" LINK "gg:doc/NDK/Guide/Include/libraries/configvars.h/File" 32} *configDev );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"RemConfigDev" LINK "gg:doc/NDK/Guide/Include/inline/expansion.h/File" 78}( @{"struct ConfigDev" LINK "gg:doc/NDK/Guide/Include/libraries/configvars.h/File" 32} *configDev );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"WriteExpansionByte" LINK "gg:doc/NDK/Guide/Include/inline/expansion.h/File" 82}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} board, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} offset, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} byte );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"ObtainConfigBinding" LINK "gg:doc/NDK/Guide/Include/inline/expansion.h/File" 86}( @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"ReleaseConfigBinding" LINK "gg:doc/NDK/Guide/Include/inline/expansion.h/File" 90}( @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"SetCurrentBinding" LINK "gg:doc/NDK/Guide/Include/inline/expansion.h/File" 94}( @{"struct CurrentBinding" LINK "gg:doc/NDK/Guide/Include/libraries/configvars.h/File" 61} *currentBinding, ULONG bindingSize );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"GetCurrentBinding" LINK "gg:doc/NDK/Guide/Include/inline/expansion.h/File" 98}( @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"struct CurrentBinding" LINK "gg:doc/NDK/Guide/Include/libraries/configvars.h/File" 61} *currentBinding, ULONG bindingSize );
@{"struct DeviceNode" LINK "gg:doc/NDK/Guide/Include/dos/filehandler.h/File" 100} *MakeDosNode( CONST APTR parmPacket );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"AddDosNode" LINK "gg:doc/NDK/Guide/Include/inline/expansion.h/File" 106}( @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} bootPri, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} flags, @{"struct DeviceNode" LINK "gg:doc/NDK/Guide/Include/dos/filehandler.h/File" 100} *deviceNode );
/*--- functions in V36 or higher (Release 2.0) ---*/

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif   /* CLIB_EXPANSION_PROTOS_H */
@ENDNODE
