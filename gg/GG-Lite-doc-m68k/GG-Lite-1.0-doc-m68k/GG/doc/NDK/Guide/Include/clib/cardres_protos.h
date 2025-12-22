@DATABASE "gg:doc/NDK/Guide/Include/clib/cardres_protos.h"
@MASTER   "gg:os-include/clib/cardres_protos.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:11:32
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "clib/cardres_protos.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"clib/cardres_protos.h" LINK File}

@ENDNODE
@NODE File "clib/cardres_protos.h"
#ifndef  CLIB_CARDRES_PROTOS_H
#define  CLIB_CARDRES_PROTOS_H

/*
**      $VER: cardres_protos.h 40.1 (17.5.1996)
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
#ifndef  EXEC_RESIDENT_H
#include <@{"exec/resident.h" LINK "gg:doc/NDK/Guide/Include/exec/resident.h/File"}>
#endif
#ifndef  RESOURCES_CARD_H
#include <@{"resources/card.h" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File"}>
#endif
@{"struct CardHandle" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 30} *OwnCard( struct CardHandle *handle );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"ReleaseCard" LINK "gg:doc/NDK/Guide/Include/inline/cardres.h/File" 30}( @{"struct CardHandle" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 30} *handle, ULONG flags );
@{"struct CardMemoryMap" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 45} *GetCardMap( VOID );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"BeginCardAccess" LINK "gg:doc/NDK/Guide/Include/inline/cardres.h/File" 38}( @{"struct CardHandle" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 30} *handle );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"EndCardAccess" LINK "gg:doc/NDK/Guide/Include/inline/cardres.h/File" 42}( @{"struct CardHandle" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 30} *handle );
@{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} @{"ReadCardStatus" LINK "gg:doc/NDK/Guide/Include/inline/cardres.h/File" 46}( @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"CardResetRemove" LINK "gg:doc/NDK/Guide/Include/inline/cardres.h/File" 50}( @{"struct CardHandle" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 30} *handle, ULONG flag );
@{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} @{"CardMiscControl" LINK "gg:doc/NDK/Guide/Include/inline/cardres.h/File" 54}( @{"struct CardHandle" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 30} *handle, ULONG control_bits );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"CardAccessSpeed" LINK "gg:doc/NDK/Guide/Include/inline/cardres.h/File" 58}( @{"struct CardHandle" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 30} *handle, ULONG nanoseconds );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"CardProgramVoltage" LINK "gg:doc/NDK/Guide/Include/inline/cardres.h/File" 62}( @{"struct CardHandle" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 30} *handle, ULONG voltage );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"CardResetCard" LINK "gg:doc/NDK/Guide/Include/inline/cardres.h/File" 66}( @{"struct CardHandle" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 30} *handle );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"CopyTuple" LINK "gg:doc/NDK/Guide/Include/inline/cardres.h/File" 70}( @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"struct CardHandle" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 30} *handle, UBYTE *buffer, ULONG tuplecode, ULONG size );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"DeviceTuple" LINK "gg:doc/NDK/Guide/Include/inline/cardres.h/File" 74}( @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} *tuple_data, @{"struct DeviceTData" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 38} *storage );
@{"struct Resident" LINK "gg:doc/NDK/Guide/Include/exec/resident.h/File" 18} *IfAmigaXIP( CONST struct CardHandle *handle );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"CardForceChange" LINK "gg:doc/NDK/Guide/Include/inline/cardres.h/File" 82}( @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"CardChangeCount" LINK "gg:doc/NDK/Guide/Include/inline/cardres.h/File" 86}( @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"CardInterface" LINK "gg:doc/NDK/Guide/Include/inline/cardres.h/File" 90}( @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} );

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif   /* CLIB_CARDRES_PROTOS_H */
@ENDNODE
