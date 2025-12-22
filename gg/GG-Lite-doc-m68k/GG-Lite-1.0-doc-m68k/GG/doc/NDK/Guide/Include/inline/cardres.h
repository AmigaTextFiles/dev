@DATABASE "gg:doc/NDK/Guide/Include/inline/cardres.h"
@MASTER   "gg:os-include/inline/cardres.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:14:32
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "inline/cardres.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"inline/cardres.h" LINK File}


@{b}#defines@{ub}

@{"BeginCardAccess()" LINK "gg:doc/NDK/Guide/Include/inline/cardres.h/File" 38}     @{"CardAccessSpeed()" LINK "gg:doc/NDK/Guide/Include/inline/cardres.h/File" 58}      @{"CardChangeCount()" LINK "gg:doc/NDK/Guide/Include/inline/cardres.h/File" 86}
@{"CardForceChange()" LINK "gg:doc/NDK/Guide/Include/inline/cardres.h/File" 82}     @{"CardInterface()" LINK "gg:doc/NDK/Guide/Include/inline/cardres.h/File" 90}        @{"CardMiscControl()" LINK "gg:doc/NDK/Guide/Include/inline/cardres.h/File" 54}
@{"CardProgramVoltage()" LINK "gg:doc/NDK/Guide/Include/inline/cardres.h/File" 62}  @{"CARDRES_BASE_NAME" LINK "gg:doc/NDK/Guide/Include/inline/cardres.h/File" 23}      @{"CardResetCard()" LINK "gg:doc/NDK/Guide/Include/inline/cardres.h/File" 66}
@{"CardResetRemove()" LINK "gg:doc/NDK/Guide/Include/inline/cardres.h/File" 50}     @{"CLIB_CARDRES_PROTOS_H" LINK "gg:doc/NDK/Guide/Include/inline/cardres.h/File" 5}  @{"CopyTuple()" LINK "gg:doc/NDK/Guide/Include/inline/cardres.h/File" 70}
@{"DeviceTuple()" LINK "gg:doc/NDK/Guide/Include/inline/cardres.h/File" 74}         @{"EndCardAccess()" LINK "gg:doc/NDK/Guide/Include/inline/cardres.h/File" 42}        @{"GetCardMap()" LINK "gg:doc/NDK/Guide/Include/inline/cardres.h/File" 34}
@{"IfAmigaXIP()" LINK "gg:doc/NDK/Guide/Include/inline/cardres.h/File" 78}          @{"OwnCard()" LINK "gg:doc/NDK/Guide/Include/inline/cardres.h/File" 26}              @{"ReadCardStatus()" LINK "gg:doc/NDK/Guide/Include/inline/cardres.h/File" 46}
@{"ReleaseCard()" LINK "gg:doc/NDK/Guide/Include/inline/cardres.h/File" 30}         

@ENDNODE
@NODE File "inline/cardres.h"
#ifndef _INLINE_CARDRES_H
#define _INLINE_CARDRES_H

#ifndef CLIB_CARDRES_PROTOS_H
#define CLIB_CARDRES_PROTOS_H
#endif

#ifndef __INLINE_MACROS_H
#include <@{"inline/macros.h" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File"}>
#endif

#ifndef  EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#ifndef  EXEC_RESIDENT_H
#include <@{"exec/resident.h" LINK "gg:doc/NDK/Guide/Include/exec/resident.h/File"}>
#endif
#ifndef  RESOURCES_CARD_H
#include <@{"resources/card.h" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File"}>
#endif

#ifndef CARDRES_BASE_NAME
#define CARDRES_BASE_NAME CardResource
#endif

#define @{"OwnCard" LINK "gg:doc/NDK/Guide/cardres/OwnCard"}(handle) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0x6, @{"struct CardHandle" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 30} *, OwnCard, struct CardHandle *, handle, a1, \\
        , CARDRES_BASE_NAME)

#define @{"ReleaseCard" LINK "gg:doc/NDK/Guide/cardres/ReleaseCard"}(handle, flags) \\
        @{"LP2NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 168}(0xc, @{"ReleaseCard" LINK File 30}, @{"struct CardHandle" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 30} *, handle, a1, ULONG, flags, d0, \\
        , CARDRES_BASE_NAME)

#define @{"GetCardMap()" LINK "gg:doc/NDK/Guide/cardres/GetCardMap"} \\
        @{"LP0" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 25}(0x12, @{"struct CardMemoryMap" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 45} *, GetCardMap, \\
        , CARDRES_BASE_NAME)

#define @{"BeginCardAccess" LINK "gg:doc/NDK/Guide/cardres/BeginCardAccess"}(handle) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0x18, @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}, @{"BeginCardAccess" LINK File 38}, @{"struct CardHandle" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 30} *, handle, a1, \\
        , CARDRES_BASE_NAME)

#define @{"EndCardAccess" LINK "gg:doc/NDK/Guide/cardres/EndCardAccess"}(handle) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0x1e, @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}, @{"EndCardAccess" LINK File 42}, @{"struct CardHandle" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 30} *, handle, a1, \\
        , CARDRES_BASE_NAME)

#define @{"ReadCardStatus()" LINK "gg:doc/NDK/Guide/cardres/ReadCardStatus"} \\
        @{"LP0" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 25}(0x24, @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}, @{"ReadCardStatus" LINK File 46}, \\
        , @{"CARDRES_BASE_NAME" LINK File 23})

#define @{"CardResetRemove" LINK "gg:doc/NDK/Guide/cardres/CardResetRemove"}(handle, flag) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x2a, @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}, @{"CardResetRemove" LINK File 50}, @{"struct CardHandle" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 30} *, handle, a1, ULONG, flag, d0, \\
        , CARDRES_BASE_NAME)

#define @{"CardMiscControl" LINK "gg:doc/NDK/Guide/cardres/CardMiscControl"}(handle, control_bits) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x30, @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}, @{"CardMiscControl" LINK File 54}, @{"struct CardHandle" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 30} *, handle, a1, ULONG, control_bits, d1, \\
        , CARDRES_BASE_NAME)

#define @{"CardAccessSpeed" LINK "gg:doc/NDK/Guide/cardres/CardAccessSpeed"}(handle, nanoseconds) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x36, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, @{"CardAccessSpeed" LINK File 58}, @{"struct CardHandle" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 30} *, handle, a1, ULONG, nanoseconds, d0, \\
        , CARDRES_BASE_NAME)

#define @{"CardProgramVoltage" LINK "gg:doc/NDK/Guide/cardres/CardProgramVoltage"}(handle, voltage) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x3c, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, @{"CardProgramVoltage" LINK File 62}, @{"struct CardHandle" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 30} *, handle, a1, ULONG, voltage, d0, \\
        , CARDRES_BASE_NAME)

#define @{"CardResetCard" LINK "gg:doc/NDK/Guide/cardres/CardResetCard"}(handle) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0x42, @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}, @{"CardResetCard" LINK File 66}, @{"struct CardHandle" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 30} *, handle, a1, \\
        , CARDRES_BASE_NAME)

#define @{"CopyTuple" LINK "gg:doc/NDK/Guide/cardres/CopyTuple"}(handle, buffer, tuplecode, size) \\
        @{"LP4" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 362}(0x48, @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}, @{"CopyTuple" LINK File 70}, const @{"struct CardHandle" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 30} *, handle, a1, UBYTE *, buffer, a0, ULONG, tuplecode, d1, ULONG, size, d0, \\
        , CARDRES_BASE_NAME)

#define @{"DeviceTuple" LINK "gg:doc/NDK/Guide/cardres/DeviceTuple"}(tuple_data, storage) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x4e, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, @{"DeviceTuple" LINK File 74}, const @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} *, tuple_data, a0, @{"struct DeviceTData" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 38} *, storage, a1, \\
        , CARDRES_BASE_NAME)

#define @{"IfAmigaXIP" LINK "gg:doc/NDK/Guide/cardres/IfAmigaXIP"}(handle) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0x54, @{"struct Resident" LINK "gg:doc/NDK/Guide/Include/exec/resident.h/File" 18} *, IfAmigaXIP, const struct CardHandle *, handle, a2, \\
        , CARDRES_BASE_NAME)

#define @{"CardForceChange()" LINK "gg:doc/NDK/Guide/cardres/CardForceChange"} \\
        @{"LP0" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 25}(0x5a, @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}, @{"CardForceChange" LINK File 82}, \\
        , @{"CARDRES_BASE_NAME" LINK File 23})

#define @{"CardChangeCount()" LINK "gg:doc/NDK/Guide/cardres/CardChangeCount"} \\
        @{"LP0" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 25}(0x60, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, @{"CardChangeCount" LINK File 86}, \\
        , @{"CARDRES_BASE_NAME" LINK File 23})

#define @{"CardInterface()" LINK "gg:doc/NDK/Guide/cardres/CardInterface"} \\
        @{"LP0" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 25}(0x66, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, @{"CardInterface" LINK File 90}, \\
        , @{"CARDRES_BASE_NAME" LINK File 23})

#endif /*  _INLINE_CARDRES_H  */
@ENDNODE
