@DATABASE "gg:doc/NDK/Guide/Include/inline/iffparse.h"
@MASTER   "gg:os-include/inline/iffparse.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:15:02
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "inline/iffparse.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"inline/iffparse.h" LINK File}


@{b}#defines@{ub}

@{"AllocIFF()" LINK "gg:doc/NDK/Guide/Include/inline/iffparse.h/File" 26}          @{"AllocLocalItem()" LINK "gg:doc/NDK/Guide/Include/inline/iffparse.h/File" 126}     @{"CLIB_IFFPARSE_PROTOS_H" LINK "gg:doc/NDK/Guide/Include/inline/iffparse.h/File" 5}
@{"CloseClipboard()" LINK "gg:doc/NDK/Guide/Include/inline/iffparse.h/File" 170}    @{"CloseIFF()" LINK "gg:doc/NDK/Guide/Include/inline/iffparse.h/File" 38}           @{"CollectionChunk()" LINK "gg:doc/NDK/Guide/Include/inline/iffparse.h/File" 94}
@{"CollectionChunks()" LINK "gg:doc/NDK/Guide/Include/inline/iffparse.h/File" 98}  @{"CurrentChunk()" LINK "gg:doc/NDK/Guide/Include/inline/iffparse.h/File" 118}       @{"EntryHandler()" LINK "gg:doc/NDK/Guide/Include/inline/iffparse.h/File" 70}
@{"ExitHandler()" LINK "gg:doc/NDK/Guide/Include/inline/iffparse.h/File" 74}       @{"FindCollection()" LINK "gg:doc/NDK/Guide/Include/inline/iffparse.h/File" 110}     @{"FindLocalItem()" LINK "gg:doc/NDK/Guide/Include/inline/iffparse.h/File" 142}
@{"FindProp()" LINK "gg:doc/NDK/Guide/Include/inline/iffparse.h/File" 106}          @{"FindPropContext()" LINK "gg:doc/NDK/Guide/Include/inline/iffparse.h/File" 114}    @{"FreeIFF()" LINK "gg:doc/NDK/Guide/Include/inline/iffparse.h/File" 42}
@{"FreeLocalItem()" LINK "gg:doc/NDK/Guide/Include/inline/iffparse.h/File" 138}     @{"GoodID()" LINK "gg:doc/NDK/Guide/Include/inline/iffparse.h/File" 174}             @{"GoodType()" LINK "gg:doc/NDK/Guide/Include/inline/iffparse.h/File" 178}
@{"IDtoStr()" LINK "gg:doc/NDK/Guide/Include/inline/iffparse.h/File" 182}           @{"IFFPARSE_BASE_NAME" LINK "gg:doc/NDK/Guide/Include/inline/iffparse.h/File" 23}   @{"InitIFF()" LINK "gg:doc/NDK/Guide/Include/inline/iffparse.h/File" 154}
@{"InitIFFasClip()" LINK "gg:doc/NDK/Guide/Include/inline/iffparse.h/File" 162}     @{"InitIFFasDOS()" LINK "gg:doc/NDK/Guide/Include/inline/iffparse.h/File" 158}       @{"LocalItemData()" LINK "gg:doc/NDK/Guide/Include/inline/iffparse.h/File" 130}
@{"OpenClipboard()" LINK "gg:doc/NDK/Guide/Include/inline/iffparse.h/File" 166}     @{"OpenIFF()" LINK "gg:doc/NDK/Guide/Include/inline/iffparse.h/File" 30}            @{"ParentChunk()" LINK "gg:doc/NDK/Guide/Include/inline/iffparse.h/File" 122}
@{"ParseIFF()" LINK "gg:doc/NDK/Guide/Include/inline/iffparse.h/File" 34}          @{"PopChunk()" LINK "gg:doc/NDK/Guide/Include/inline/iffparse.h/File" 66}           @{"PropChunk()" LINK "gg:doc/NDK/Guide/Include/inline/iffparse.h/File" 78}
@{"PropChunks()" LINK "gg:doc/NDK/Guide/Include/inline/iffparse.h/File" 82}        @{"PushChunk()" LINK "gg:doc/NDK/Guide/Include/inline/iffparse.h/File" 62}          @{"ReadChunkBytes()" LINK "gg:doc/NDK/Guide/Include/inline/iffparse.h/File" 46}
@{"ReadChunkRecords()" LINK "gg:doc/NDK/Guide/Include/inline/iffparse.h/File" 54}  @{"SetLocalItemPurge()" LINK "gg:doc/NDK/Guide/Include/inline/iffparse.h/File" 134}  @{"StopChunk()" LINK "gg:doc/NDK/Guide/Include/inline/iffparse.h/File" 86}
@{"StopChunks()" LINK "gg:doc/NDK/Guide/Include/inline/iffparse.h/File" 90}        @{"StopOnExit()" LINK "gg:doc/NDK/Guide/Include/inline/iffparse.h/File" 102}         @{"StoreItemInContext()" LINK "gg:doc/NDK/Guide/Include/inline/iffparse.h/File" 150}
@{"StoreLocalItem()" LINK "gg:doc/NDK/Guide/Include/inline/iffparse.h/File" 146}    @{"WriteChunkBytes()" LINK "gg:doc/NDK/Guide/Include/inline/iffparse.h/File" 50}    @{"WriteChunkRecords()" LINK "gg:doc/NDK/Guide/Include/inline/iffparse.h/File" 58}

@ENDNODE
@NODE File "inline/iffparse.h"
#ifndef _INLINE_IFFPARSE_H
#define _INLINE_IFFPARSE_H

#ifndef CLIB_IFFPARSE_PROTOS_H
#define CLIB_IFFPARSE_PROTOS_H
#endif

#ifndef __INLINE_MACROS_H
#include <@{"inline/macros.h" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File"}>
#endif

#ifndef  EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#ifndef  LIBRARIES_IFFPARSE_H
#include <@{"libraries/iffparse.h" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File"}>
#endif
#ifndef  UTILITY_HOOKS_H
#include <@{"utility/hooks.h" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File"}>
#endif

#ifndef IFFPARSE_BASE_NAME
#define IFFPARSE_BASE_NAME IFFParseBase
#endif

#define @{"AllocIFF()" LINK "gg:doc/NDK/Guide/iffparse/AllocIFF"} \\
        @{"LP0" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 25}(0x1e, @{"struct IFFHandle" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 44} *, AllocIFF, \\
        , IFFPARSE_BASE_NAME)

#define @{"OpenIFF" LINK "gg:doc/NDK/Guide/iffparse/OpenIFF"}(iff, rwMode) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x24, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, @{"OpenIFF" LINK File 30}, @{"struct IFFHandle" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 44} *, iff, a0, LONG, rwMode, d0, \\
        , IFFPARSE_BASE_NAME)

#define @{"ParseIFF" LINK "gg:doc/NDK/Guide/iffparse/ParseIFF"}(iff, control) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x2a, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, @{"ParseIFF" LINK File 34}, @{"struct IFFHandle" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 44} *, iff, a0, LONG, control, d0, \\
        , IFFPARSE_BASE_NAME)

#define @{"CloseIFF" LINK "gg:doc/NDK/Guide/iffparse/CloseIFF"}(iff) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0x30, @{"CloseIFF" LINK File 38}, @{"struct IFFHandle" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 44} *, iff, a0, \\
        , IFFPARSE_BASE_NAME)

#define @{"FreeIFF" LINK "gg:doc/NDK/Guide/iffparse/FreeIFF"}(iff) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0x36, @{"FreeIFF" LINK File 42}, @{"struct IFFHandle" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 44} *, iff, a0, \\
        , IFFPARSE_BASE_NAME)

#define @{"ReadChunkBytes" LINK "gg:doc/NDK/Guide/iffparse/ReadChunkBytes"}(iff, buf, numBytes) \\
        @{"LP3" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 229}(0x3c, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, @{"ReadChunkBytes" LINK File 46}, @{"struct IFFHandle" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 44} *, iff, a0, APTR, buf, a1, LONG, numBytes, d0, \\
        , IFFPARSE_BASE_NAME)

#define @{"WriteChunkBytes" LINK "gg:doc/NDK/Guide/iffparse/WriteChunkBytes"}(iff, buf, numBytes) \\
        @{"LP3" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 229}(0x42, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, @{"WriteChunkBytes" LINK File 50}, @{"struct IFFHandle" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 44} *, iff, a0, const APTR, buf, a1, LONG, numBytes, d0, \\
        , IFFPARSE_BASE_NAME)

#define @{"ReadChunkRecords" LINK "gg:doc/NDK/Guide/iffparse/ReadChunkRecords"}(iff, buf, bytesPerRecord, numRecords) \\
        @{"LP4" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 362}(0x48, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, @{"ReadChunkRecords" LINK File 54}, @{"struct IFFHandle" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 44} *, iff, a0, APTR, buf, a1, LONG, bytesPerRecord, d0, LONG, numRecords, d1, \\
        , IFFPARSE_BASE_NAME)

#define @{"WriteChunkRecords" LINK "gg:doc/NDK/Guide/iffparse/WriteChunkRecords"}(iff, buf, bytesPerRecord, numRecords) \\
        @{"LP4" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 362}(0x4e, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, @{"WriteChunkRecords" LINK File 58}, @{"struct IFFHandle" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 44} *, iff, a0, const APTR, buf, a1, LONG, bytesPerRecord, d0, LONG, numRecords, d1, \\
        , IFFPARSE_BASE_NAME)

#define @{"PushChunk" LINK "gg:doc/NDK/Guide/iffparse/PushChunk"}(iff, type, id, size) \\
        @{"LP4" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 362}(0x54, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, @{"PushChunk" LINK File 62}, @{"struct IFFHandle" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 44} *, iff, a0, LONG, type, d0, LONG, id, d1, LONG, size, d2, \\
        , IFFPARSE_BASE_NAME)

#define @{"PopChunk" LINK "gg:doc/NDK/Guide/iffparse/PopChunk"}(iff) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0x5a, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, @{"PopChunk" LINK File 66}, @{"struct IFFHandle" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 44} *, iff, a0, \\
        , IFFPARSE_BASE_NAME)

#define @{"EntryHandler" LINK "gg:doc/NDK/Guide/iffparse/EntryHandler"}(iff, type, id, position, handler, object) \\
        @{"LP6" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 541}(0x66, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, @{"EntryHandler" LINK File 70}, @{"struct IFFHandle" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 44} *, iff, a0, LONG, type, d0, LONG, id, d1, LONG, position, d2, struct Hook *, handler, a1, APTR, object, a2, \\
        , IFFPARSE_BASE_NAME)

#define @{"ExitHandler" LINK "gg:doc/NDK/Guide/iffparse/ExitHandler"}(iff, type, id, position, handler, object) \\
        @{"LP6" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 541}(0x6c, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, @{"ExitHandler" LINK File 74}, @{"struct IFFHandle" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 44} *, iff, a0, LONG, type, d0, LONG, id, d1, LONG, position, d2, struct Hook *, handler, a1, APTR, object, a2, \\
        , IFFPARSE_BASE_NAME)

#define @{"PropChunk" LINK "gg:doc/NDK/Guide/iffparse/PropChunk"}(iff, type, id) \\
        @{"LP3" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 229}(0x72, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, @{"PropChunk" LINK File 78}, @{"struct IFFHandle" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 44} *, iff, a0, LONG, type, d0, LONG, id, d1, \\
        , IFFPARSE_BASE_NAME)

#define @{"PropChunks" LINK "gg:doc/NDK/Guide/iffparse/PropChunks"}(iff, propArray, numPairs) \\
        @{"LP3" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 229}(0x78, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, @{"PropChunks" LINK File 82}, @{"struct IFFHandle" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 44} *, iff, a0, const LONG *, propArray, a1, LONG, numPairs, d0, \\
        , IFFPARSE_BASE_NAME)

#define @{"StopChunk" LINK "gg:doc/NDK/Guide/iffparse/StopChunk"}(iff, type, id) \\
        @{"LP3" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 229}(0x7e, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, @{"StopChunk" LINK File 86}, @{"struct IFFHandle" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 44} *, iff, a0, LONG, type, d0, LONG, id, d1, \\
        , IFFPARSE_BASE_NAME)

#define @{"StopChunks" LINK "gg:doc/NDK/Guide/iffparse/StopChunks"}(iff, propArray, numPairs) \\
        @{"LP3" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 229}(0x84, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, @{"StopChunks" LINK File 90}, @{"struct IFFHandle" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 44} *, iff, a0, const LONG *, propArray, a1, LONG, numPairs, d0, \\
        , IFFPARSE_BASE_NAME)

#define @{"CollectionChunk" LINK "gg:doc/NDK/Guide/iffparse/CollectionChunk"}(iff, type, id) \\
        @{"LP3" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 229}(0x8a, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, @{"CollectionChunk" LINK File 94}, @{"struct IFFHandle" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 44} *, iff, a0, LONG, type, d0, LONG, id, d1, \\
        , IFFPARSE_BASE_NAME)

#define @{"CollectionChunks" LINK "gg:doc/NDK/Guide/iffparse/CollectionChunks"}(iff, propArray, numPairs) \\
        @{"LP3" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 229}(0x90, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, @{"CollectionChunks" LINK File 98}, @{"struct IFFHandle" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 44} *, iff, a0, const LONG *, propArray, a1, LONG, numPairs, d0, \\
        , IFFPARSE_BASE_NAME)

#define @{"StopOnExit" LINK "gg:doc/NDK/Guide/iffparse/StopOnExit"}(iff, type, id) \\
        @{"LP3" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 229}(0x96, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, @{"StopOnExit" LINK File 102}, @{"struct IFFHandle" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 44} *, iff, a0, LONG, type, d0, LONG, id, d1, \\
        , IFFPARSE_BASE_NAME)

#define @{"FindProp" LINK "gg:doc/NDK/Guide/iffparse/FindProp"}(iff, type, id) \\
        @{"LP3" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 229}(0x9c, @{"struct StoredProperty" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 119} *, FindProp, const struct IFFHandle *, iff, a0, LONG, type, d0, LONG, id, d1, \\
        , IFFPARSE_BASE_NAME)

#define @{"FindCollection" LINK "gg:doc/NDK/Guide/iffparse/FindCollection"}(iff, type, id) \\
        @{"LP3" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 229}(0xa2, @{"struct CollectionItem" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 133} *, FindCollection, const struct IFFHandle *, iff, a0, LONG, type, d0, LONG, id, d1, \\
        , IFFPARSE_BASE_NAME)

#define @{"FindPropContext" LINK "gg:doc/NDK/Guide/iffparse/FindPropContext"}(iff) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0xa8, @{"struct ContextNode" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 85} *, FindPropContext, const struct IFFHandle *, iff, a0, \\
        , IFFPARSE_BASE_NAME)

#define @{"CurrentChunk" LINK "gg:doc/NDK/Guide/iffparse/CurrentChunk"}(iff) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0xae, @{"struct ContextNode" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 85} *, CurrentChunk, const struct IFFHandle *, iff, a0, \\
        , IFFPARSE_BASE_NAME)

#define @{"ParentChunk" LINK "gg:doc/NDK/Guide/iffparse/ParentChunk"}(contextNode) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0xb4, @{"struct ContextNode" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 85} *, ParentChunk, const struct ContextNode *, contextNode, a0, \\
        , IFFPARSE_BASE_NAME)

#define @{"AllocLocalItem" LINK "gg:doc/NDK/Guide/iffparse/AllocLocalItem"}(type, id, ident, dataSize) \\
        @{"LP4" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 362}(0xba, @{"struct LocalContextItem" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 104} *, AllocLocalItem, LONG, type, d0, LONG, id, d1, LONG, ident, d2, LONG, dataSize, d3, \\
        , IFFPARSE_BASE_NAME)

#define @{"LocalItemData" LINK "gg:doc/NDK/Guide/iffparse/LocalItemData"}(localItem) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0xc0, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}, @{"LocalItemData" LINK File 130}, const @{"struct LocalContextItem" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 104} *, localItem, a0, \\
        , IFFPARSE_BASE_NAME)

#define @{"SetLocalItemPurge" LINK "gg:doc/NDK/Guide/iffparse/SetLocalItemPurge"}(localItem, purgeHook) \\
        @{"LP2NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 168}(0xc6, @{"SetLocalItemPurge" LINK File 134}, @{"struct LocalContextItem" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 104} *, localItem, a0, const struct Hook *, purgeHook, a1, \\
        , IFFPARSE_BASE_NAME)

#define @{"FreeLocalItem" LINK "gg:doc/NDK/Guide/iffparse/FreeLocalItem"}(localItem) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0xcc, @{"FreeLocalItem" LINK File 138}, @{"struct LocalContextItem" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 104} *, localItem, a0, \\
        , IFFPARSE_BASE_NAME)

#define @{"FindLocalItem" LINK "gg:doc/NDK/Guide/iffparse/FindLocalItem"}(iff, type, id, ident) \\
        @{"LP4" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 362}(0xd2, @{"struct LocalContextItem" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 104} *, FindLocalItem, const struct IFFHandle *, iff, a0, LONG, type, d0, LONG, id, d1, LONG, ident, d2, \\
        , IFFPARSE_BASE_NAME)

#define @{"StoreLocalItem" LINK "gg:doc/NDK/Guide/iffparse/StoreLocalItem"}(iff, localItem, position) \\
        @{"LP3" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 229}(0xd8, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, @{"StoreLocalItem" LINK File 146}, @{"struct IFFHandle" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 44} *, iff, a0, struct LocalContextItem *, localItem, a1, LONG, position, d0, \\
        , IFFPARSE_BASE_NAME)

#define @{"StoreItemInContext" LINK "gg:doc/NDK/Guide/iffparse/StoreItemInContext"}(iff, localItem, contextNode) \\
        @{"LP3NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 251}(0xde, @{"StoreItemInContext" LINK File 150}, @{"struct IFFHandle" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 44} *, iff, a0, struct LocalContextItem *, localItem, a1, struct ContextNode *, contextNode, a2, \\
        , IFFPARSE_BASE_NAME)

#define @{"InitIFF" LINK "gg:doc/NDK/Guide/iffparse/InitIFF"}(iff, flags, streamHook) \\
        @{"LP3NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 251}(0xe4, @{"InitIFF" LINK File 154}, @{"struct IFFHandle" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 44} *, iff, a0, LONG, flags, d0, const struct Hook *, streamHook, a1, \\
        , IFFPARSE_BASE_NAME)

#define @{"InitIFFasDOS" LINK "gg:doc/NDK/Guide/iffparse/InitIFFasDOS"}(iff) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0xea, @{"InitIFFasDOS" LINK File 158}, @{"struct IFFHandle" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 44} *, iff, a0, \\
        , IFFPARSE_BASE_NAME)

#define @{"InitIFFasClip" LINK "gg:doc/NDK/Guide/iffparse/InitIFFasClip"}(iff) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0xf0, @{"InitIFFasClip" LINK File 162}, @{"struct IFFHandle" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 44} *, iff, a0, \\
        , IFFPARSE_BASE_NAME)

#define @{"OpenClipboard" LINK "gg:doc/NDK/Guide/iffparse/OpenClipboard"}(unitNumber) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0xf6, @{"struct ClipboardHandle" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 148} *, OpenClipboard, LONG, unitNumber, d0, \\
        , IFFPARSE_BASE_NAME)

#define @{"CloseClipboard" LINK "gg:doc/NDK/Guide/iffparse/CloseClipboard"}(clipHandle) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0xfc, @{"CloseClipboard" LINK File 170}, @{"struct ClipboardHandle" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 148} *, clipHandle, a0, \\
        , IFFPARSE_BASE_NAME)

#define @{"GoodID" LINK "gg:doc/NDK/Guide/iffparse/GoodID"}(id) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0x102, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, @{"GoodID" LINK File 174}, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, id, d0, \\
        , @{"IFFPARSE_BASE_NAME" LINK File 23})

#define @{"GoodType" LINK "gg:doc/NDK/Guide/iffparse/GoodType"}(type) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0x108, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, @{"GoodType" LINK File 178}, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, type, d0, \\
        , @{"IFFPARSE_BASE_NAME" LINK File 23})

#define @{"IDtoStr" LINK "gg:doc/NDK/Guide/iffparse/IDtoStr"}(id, buf) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x10e, @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}, @{"IDtoStr" LINK File 182}, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, id, d0, @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}, buf, a0, \\
        , @{"IFFPARSE_BASE_NAME" LINK File 23})

#endif /*  _INLINE_IFFPARSE_H  */
@ENDNODE
