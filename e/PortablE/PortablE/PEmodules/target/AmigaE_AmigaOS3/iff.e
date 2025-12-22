/* $Id: iff.h,v 23.2 93/05/24 16:03:28 chris Exp $ */
OPT NATIVE
PUBLIC MODULE 'target/libraries/iff'
MODULE 'target/exec/types'
MODULE 'target/exec/libraries', 'target/graphics/gfx'
{MODULE 'iff'}

NATIVE {iffbase} DEF iffbase:NATIVE {LONG} PTR TO lib		->AmigaE does not automatically initialise this


NATIVE {IfFL_CloseIFF} PROC
PROC IfFL_CloseIFF( param1:IFFL_HANDLE) IS NATIVE {IfFL_CloseIFF(} param1 {)} ENDNATIVE
NATIVE {IfFL_CompressBlock} PROC
PROC IfFL_CompressBlock( param1:APTR, param2:APTR, param3:ULONG, param4:ULONG) IS NATIVE {IfFL_CompressBlock(} param1 {,} param2 {,} param3 {,} param4 {)} ENDNATIVE !!ULONG
NATIVE {IfFL_DecodePic} PROC
PROC IfFL_DecodePic( param1:IFFL_HANDLE, param2:PTR TO bitmap) IS NATIVE {IfFL_DecodePic(} param1 {,} param2 {)} ENDNATIVE !!INT
NATIVE {IfFL_DecompressBlock} PROC
PROC IfFL_DecompressBlock( param1:APTR, param2:APTR, param3:ULONG, param4:ULONG) IS NATIVE {IfFL_DecompressBlock(} param1 {,} param2 {,} param3 {,} param4 {)} ENDNATIVE !!ULONG
NATIVE {IfFL_FindChunk} PROC
PROC IfFL_FindChunk( param1:IFFL_HANDLE, param2:VALUE) IS NATIVE {IfFL_FindChunk(} param1 {,} param2 {)} ENDNATIVE !!PTR
NATIVE {IfFL_GetBMHD} PROC
PROC IfFL_GetBMHD( param1:IFFL_HANDLE) IS NATIVE {IfFL_GetBMHD(} param1 {)} ENDNATIVE !!PTR TO bmh
NATIVE {IfFL_GetColorTab} PROC
PROC IfFL_GetColorTab( param1:IFFL_HANDLE, param2:PTR TO INT) IS NATIVE {IfFL_GetColorTab(} param1 {,} param2 {)} ENDNATIVE !!VALUE
NATIVE {IfFL_GetViewModes} PROC
PROC IfFL_GetViewModes( param1:IFFL_HANDLE) IS NATIVE {IfFL_GetViewModes(} param1 {)} ENDNATIVE !!ULONG
NATIVE {IfFL_IFFError} PROC
PROC IfFL_IFFError( ) IS NATIVE {IfFL_IFFError()} ENDNATIVE !!VALUE
NATIVE {IfFL_ModifyFrame} PROC
PROC IfFL_ModifyFrame( param1:PTR, param2:PTR TO bitmap) IS NATIVE {IfFL_ModifyFrame(} param1 {,} param2 {)} ENDNATIVE !!INT
NATIVE {IfFL_OpenIFF} PROC
PROC IfFL_OpenIFF( param1:ARRAY OF CHAR, param2:ULONG) IS NATIVE {IfFL_OpenIFF(} param1 {,} param2 {)} ENDNATIVE !!IFFL_HANDLE
NATIVE {IfFL_PopChunk} PROC
PROC IfFL_PopChunk( param1:IFFL_HANDLE) IS NATIVE {IfFL_PopChunk(} param1 {)} ENDNATIVE !!VALUE
NATIVE {IfFL_PushChunk} PROC
PROC IfFL_PushChunk( param1:IFFL_HANDLE, param2:ULONG, param3:ULONG) IS NATIVE {IfFL_PushChunk(} param1 {,} param2 {,} param3 {)} ENDNATIVE !!VALUE
NATIVE {IfFL_SaveBitMap} PROC
PROC IfFL_SaveBitMap( param1:ARRAY OF CHAR, param2:PTR TO bitmap, param3:PTR TO INT, param4:VALUE) IS NATIVE {IfFL_SaveBitMap(} param1 {,} param2 {,} param3 {,} param4 {)} ENDNATIVE !!INT
NATIVE {IfFL_SaveClip} PROC
PROC IfFL_SaveClip( param1:ARRAY OF CHAR, param2:PTR TO bitmap, param3:PTR TO INT, param4:VALUE, param5:VALUE, param6:VALUE, param7:VALUE, param8:VALUE) IS NATIVE {IfFL_SaveClip(} param1 {,} param2 {,} param3 {,} param4 {,} param5 {,} param6 {,} param7 {,} param8 {)} ENDNATIVE !!INT
NATIVE {IfFL_WriteChunkBytes} PROC
PROC IfFL_WriteChunkBytes( param1:IFFL_HANDLE, param2:PTR, param3:VALUE) IS NATIVE {IfFL_WriteChunkBytes(} param1 {,} param2 {,} param3 {)} ENDNATIVE !!VALUE
