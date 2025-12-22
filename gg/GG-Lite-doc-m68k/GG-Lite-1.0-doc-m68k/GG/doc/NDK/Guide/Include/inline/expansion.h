@DATABASE "gg:doc/NDK/Guide/Include/inline/expansion.h"
@MASTER   "gg:os-include/inline/expansion.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:14:51
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "inline/expansion.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"inline/expansion.h" LINK File}


@{b}#defines@{ub}

@{"AddBootNode()" LINK "gg:doc/NDK/Guide/Include/inline/expansion.h/File" 30}            @{"AddConfigDev()" LINK "gg:doc/NDK/Guide/Include/inline/expansion.h/File" 26}          @{"AddDosNode()" LINK "gg:doc/NDK/Guide/Include/inline/expansion.h/File" 106}
@{"AllocBoardMem()" LINK "gg:doc/NDK/Guide/Include/inline/expansion.h/File" 34}          @{"AllocConfigDev()" LINK "gg:doc/NDK/Guide/Include/inline/expansion.h/File" 38}        @{"AllocExpansionMem()" LINK "gg:doc/NDK/Guide/Include/inline/expansion.h/File" 42}
@{"CLIB_EXPANSION_PROTOS_H" LINK "gg:doc/NDK/Guide/Include/inline/expansion.h/File" 5}  @{"ConfigBoard()" LINK "gg:doc/NDK/Guide/Include/inline/expansion.h/File" 46}           @{"ConfigChain()" LINK "gg:doc/NDK/Guide/Include/inline/expansion.h/File" 50}
@{"EXPANSION_BASE_NAME" LINK "gg:doc/NDK/Guide/Include/inline/expansion.h/File" 23}      @{"FindConfigDev()" LINK "gg:doc/NDK/Guide/Include/inline/expansion.h/File" 54}         @{"FreeBoardMem()" LINK "gg:doc/NDK/Guide/Include/inline/expansion.h/File" 58}
@{"FreeConfigDev()" LINK "gg:doc/NDK/Guide/Include/inline/expansion.h/File" 62}          @{"FreeExpansionMem()" LINK "gg:doc/NDK/Guide/Include/inline/expansion.h/File" 66}      @{"GetCurrentBinding()" LINK "gg:doc/NDK/Guide/Include/inline/expansion.h/File" 98}
@{"MakeDosNode()" LINK "gg:doc/NDK/Guide/Include/inline/expansion.h/File" 102}            @{"ObtainConfigBinding()" LINK "gg:doc/NDK/Guide/Include/inline/expansion.h/File" 86}   @{"ReadExpansionByte()" LINK "gg:doc/NDK/Guide/Include/inline/expansion.h/File" 70}
@{"ReadExpansionRom()" LINK "gg:doc/NDK/Guide/Include/inline/expansion.h/File" 74}       @{"ReleaseConfigBinding()" LINK "gg:doc/NDK/Guide/Include/inline/expansion.h/File" 90}  @{"RemConfigDev()" LINK "gg:doc/NDK/Guide/Include/inline/expansion.h/File" 78}
@{"SetCurrentBinding()" LINK "gg:doc/NDK/Guide/Include/inline/expansion.h/File" 94}      @{"WriteExpansionByte()" LINK "gg:doc/NDK/Guide/Include/inline/expansion.h/File" 82}    

@ENDNODE
@NODE File "inline/expansion.h"
#ifndef _INLINE_EXPANSION_H
#define _INLINE_EXPANSION_H

#ifndef CLIB_EXPANSION_PROTOS_H
#define CLIB_EXPANSION_PROTOS_H
#endif

#ifndef __INLINE_MACROS_H
#include <@{"inline/macros.h" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File"}>
#endif

#ifndef  EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#ifndef  LIBRARIES_CONFIGVARS_H
#include <@{"libraries/configvars.h" LINK "gg:doc/NDK/Guide/Include/libraries/configvars.h/File"}>
#endif
#ifndef  DOS_FILEHANDLER_H
#include <@{"dos/filehandler.h" LINK "gg:doc/NDK/Guide/Include/dos/filehandler.h/File"}>
#endif

#ifndef EXPANSION_BASE_NAME
#define EXPANSION_BASE_NAME ExpansionBase
#endif

#define @{"AddConfigDev" LINK "gg:doc/NDK/Guide/expansion/AddConfigDev"}(configDev) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0x1e, @{"AddConfigDev" LINK File 26}, @{"struct ConfigDev" LINK "gg:doc/NDK/Guide/Include/libraries/configvars.h/File" 32} *, configDev, a0, \\
        , EXPANSION_BASE_NAME)

#define @{"AddBootNode" LINK "gg:doc/NDK/Guide/expansion/AddBootNode"}(bootPri, flags, deviceNode, configDev) \\
        @{"LP4" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 362}(0x24, @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}, @{"AddBootNode" LINK File 30}, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, bootPri, d0, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, flags, d1, @{"struct DeviceNode" LINK "gg:doc/NDK/Guide/Include/dos/filehandler.h/File" 100} *, deviceNode, a0, struct ConfigDev *, configDev, a1, \\
        , EXPANSION_BASE_NAME)

#define AllocBoardMem(slotSpec) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0x2a, @{"AllocBoardMem" LINK File 34}, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, slotSpec, d0, \\
        , @{"EXPANSION_BASE_NAME" LINK File 23})

#define @{"AllocConfigDev()" LINK "gg:doc/NDK/Guide/expansion/AllocConfigDev"} \\
        @{"LP0" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 25}(0x30, @{"struct ConfigDev" LINK "gg:doc/NDK/Guide/Include/libraries/configvars.h/File" 32} *, AllocConfigDev, \\
        , EXPANSION_BASE_NAME)

#define @{"AllocExpansionMem" LINK "gg:doc/NDK/Guide/expansion/AllocExpansionMem"}(numSlots, slotAlign) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x36, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}, @{"AllocExpansionMem" LINK File 42}, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, numSlots, d0, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, slotAlign, d1, \\
        , @{"EXPANSION_BASE_NAME" LINK File 23})

#define @{"ConfigBoard" LINK "gg:doc/NDK/Guide/expansion/ConfigBoard"}(board, configDev) \\
        @{"LP2NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 168}(0x3c, @{"ConfigBoard" LINK File 46}, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}, board, a0, @{"struct ConfigDev" LINK "gg:doc/NDK/Guide/Include/libraries/configvars.h/File" 32} *, configDev, a1, \\
        , EXPANSION_BASE_NAME)

#define ConfigChain(baseAddr) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0x42, @{"ConfigChain" LINK File 50}, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}, baseAddr, a0, \\
        , @{"EXPANSION_BASE_NAME" LINK File 23})

#define @{"FindConfigDev" LINK "gg:doc/NDK/Guide/expansion/FindConfigDev"}(oldConfigDev, manufacturer, product) \\
        @{"LP3" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 229}(0x48, @{"struct ConfigDev" LINK "gg:doc/NDK/Guide/Include/libraries/configvars.h/File" 32} *, FindConfigDev, const struct ConfigDev *, oldConfigDev, a0, LONG, manufacturer, d0, LONG, product, d1, \\
        , EXPANSION_BASE_NAME)

#define FreeBoardMem(startSlot, slotSpec) \\
        @{"LP2NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 168}(0x4e, @{"FreeBoardMem" LINK File 58}, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, startSlot, d0, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, slotSpec, d1, \\
        , @{"EXPANSION_BASE_NAME" LINK File 23})

#define @{"FreeConfigDev" LINK "gg:doc/NDK/Guide/expansion/FreeConfigDev"}(configDev) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0x54, @{"FreeConfigDev" LINK File 62}, @{"struct ConfigDev" LINK "gg:doc/NDK/Guide/Include/libraries/configvars.h/File" 32} *, configDev, a0, \\
        , EXPANSION_BASE_NAME)

#define @{"FreeExpansionMem" LINK "gg:doc/NDK/Guide/expansion/FreeExpansionMem"}(startSlot, numSlots) \\
        @{"LP2NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 168}(0x5a, @{"FreeExpansionMem" LINK File 66}, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, startSlot, d0, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, numSlots, d1, \\
        , @{"EXPANSION_BASE_NAME" LINK File 23})

#define @{"ReadExpansionByte" LINK "gg:doc/NDK/Guide/expansion/ReadExpansionByte"}(board, offset) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x60, @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}, @{"ReadExpansionByte" LINK File 70}, const @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}, board, a0, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, offset, d0, \\
        , @{"EXPANSION_BASE_NAME" LINK File 23})

#define @{"ReadExpansionRom" LINK "gg:doc/NDK/Guide/expansion/ReadExpansionRom"}(board, configDev) \\
        @{"LP2NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 168}(0x66, @{"ReadExpansionRom" LINK File 74}, const @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}, board, a0, @{"struct ConfigDev" LINK "gg:doc/NDK/Guide/Include/libraries/configvars.h/File" 32} *, configDev, a1, \\
        , EXPANSION_BASE_NAME)

#define @{"RemConfigDev" LINK "gg:doc/NDK/Guide/expansion/RemConfigDev"}(configDev) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0x6c, @{"RemConfigDev" LINK File 78}, @{"struct ConfigDev" LINK "gg:doc/NDK/Guide/Include/libraries/configvars.h/File" 32} *, configDev, a0, \\
        , EXPANSION_BASE_NAME)

#define @{"WriteExpansionByte" LINK "gg:doc/NDK/Guide/expansion/WriteExpansionByte"}(board, offset, byte) \\
        @{"LP3NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 251}(0x72, @{"WriteExpansionByte" LINK File 82}, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}, board, a0, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, offset, d0, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, byte, d1, \\
        , @{"EXPANSION_BASE_NAME" LINK File 23})

#define @{"ObtainConfigBinding()" LINK "gg:doc/NDK/Guide/expansion/ObtainConfigBinding"} \\
        @{"LP0NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 41}(0x78, @{"ObtainConfigBinding" LINK File 86}, \\
        , @{"EXPANSION_BASE_NAME" LINK File 23})

#define @{"ReleaseConfigBinding()" LINK "gg:doc/NDK/Guide/expansion/ReleaseConfigBinding"} \\
        @{"LP0NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 41}(0x7e, @{"ReleaseConfigBinding" LINK File 90}, \\
        , @{"EXPANSION_BASE_NAME" LINK File 23})

#define @{"SetCurrentBinding" LINK "gg:doc/NDK/Guide/expansion/SetCurrentBinding"}(currentBinding, bindingSize) \\
        @{"LP2NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 168}(0x84, @{"SetCurrentBinding" LINK File 94}, @{"struct CurrentBinding" LINK "gg:doc/NDK/Guide/Include/libraries/configvars.h/File" 61} *, currentBinding, a0, ULONG, bindingSize, d0, \\
        , EXPANSION_BASE_NAME)

#define @{"GetCurrentBinding" LINK "gg:doc/NDK/Guide/expansion/GetCurrentBinding"}(currentBinding, bindingSize) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x8a, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, @{"GetCurrentBinding" LINK File 98}, const @{"struct CurrentBinding" LINK "gg:doc/NDK/Guide/Include/libraries/configvars.h/File" 61} *, currentBinding, a0, ULONG, bindingSize, d0, \\
        , EXPANSION_BASE_NAME)

#define @{"MakeDosNode" LINK "gg:doc/NDK/Guide/expansion/MakeDosNode"}(parmPacket) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0x90, @{"struct DeviceNode" LINK "gg:doc/NDK/Guide/Include/dos/filehandler.h/File" 100} *, MakeDosNode, const APTR, parmPacket, a0, \\
        , EXPANSION_BASE_NAME)

#define @{"AddDosNode" LINK "gg:doc/NDK/Guide/expansion/AddDosNode"}(bootPri, flags, deviceNode) \\
        @{"LP3" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 229}(0x96, @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}, @{"AddDosNode" LINK File 106}, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, bootPri, d0, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, flags, d1, @{"struct DeviceNode" LINK "gg:doc/NDK/Guide/Include/dos/filehandler.h/File" 100} *, deviceNode, a0, \\
        , EXPANSION_BASE_NAME)

#endif /*  _INLINE_EXPANSION_H  */
@ENDNODE
