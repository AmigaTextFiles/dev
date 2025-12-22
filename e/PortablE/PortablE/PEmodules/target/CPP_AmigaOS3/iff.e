OPT NATIVE
PUBLIC MODULE 'target/libraries/iff_shared1'
MODULE 'target/exec/types', 'target/graphics/gfx'

PROC IfFL_CloseIFF( param1:IFFL_HANDLE) IS NATIVE {IFFL_CloseIFF(} param1 {)} ENDNATIVE
PROC IfFL_CompressBlock( param1:APTR, param2:APTR, param3:ULONG, param4:ULONG) IS NATIVE {IFFL_CompressBlock(} param1 {,} param2 {,} param3 {,} param4 {)} ENDNATIVE !!ULONG
PROC IfFL_DecodePic( param1:IFFL_HANDLE, param2:PTR TO bitmap) IS NATIVE {-IFFL_DecodePic(} param1 {,} param2 {)} ENDNATIVE !!INT
PROC IfFL_DecompressBlock( param1:APTR, param2:APTR, param3:ULONG, param4:ULONG) IS NATIVE {IFFL_DecompressBlock(} param1 {,} param2 {,} param3 {,} param4 {)} ENDNATIVE !!ULONG
PROC IfFL_FindChunk( param1:IFFL_HANDLE, param2:VALUE) IS NATIVE {IFFL_FindChunk(} param1 {,} param2 {)} ENDNATIVE !!PTR
PROC IfFL_GetBMHD( param1:IFFL_HANDLE) IS NATIVE {IFFL_GetBMHD(} param1 {)} ENDNATIVE !!PTR TO bmh
PROC IfFL_GetColorTab( param1:IFFL_HANDLE, param2:PTR TO INT) IS NATIVE {IFFL_GetColorTab(} param1 {,} param2 {)} ENDNATIVE !!VALUE
PROC IfFL_GetViewModes( param1:IFFL_HANDLE) IS NATIVE {IFFL_GetViewModes(} param1 {)} ENDNATIVE !!ULONG
PROC IfFL_IFFError( ) IS NATIVE {IFFL_IFFError()} ENDNATIVE !!VALUE
PROC IfFL_ModifyFrame( param1:PTR, param2:PTR TO bitmap) IS NATIVE {-IFFL_ModifyFrame(} param1 {,} param2 {)} ENDNATIVE !!INT
->PROC IfFL_NewOpenIFF( param1:ARRAY OF CHAR, param2:VALUE) IS NATIVE {IFFL_NewOpenIFF(} param1 {,} param2 {)} ENDNATIVE !!APTR
PROC IfFL_OpenIFF( param1:ARRAY OF CHAR, param2:ULONG) IS NATIVE {IFFL_OpenIFF(} param1 {,} param2 {)} ENDNATIVE !!IFFL_HANDLE
PROC IfFL_PopChunk( param1:IFFL_HANDLE) IS NATIVE {IFFL_PopChunk(} param1 {)} ENDNATIVE !!VALUE
->PROC IfFL_PPOpenIFF( param1:ARRAY OF CHAR, param2:ARRAY OF CHAR) IS NATIVE {IFFL_PPOpenIFF(} param1 {,} param2 {)} ENDNATIVE !!IFFL_HANDLE
PROC IfFL_PushChunk( param1:IFFL_HANDLE, param2:ULONG, param3:ULONG) IS NATIVE {IFFL_PushChunk(} param1 {,} param2 {,} param3 {)} ENDNATIVE !!VALUE
PROC IfFL_SaveBitMap( param1:ARRAY OF CHAR, param2:PTR TO bitmap, param3:PTR TO INT, param4:VALUE) IS NATIVE {-IFFL_SaveBitMap(} param1 {,} param2 {,} param3 {,} param4 {)} ENDNATIVE !!INT
PROC IfFL_SaveClip( param1:ARRAY OF CHAR, param2:PTR TO bitmap, param3:PTR TO INT, param4:VALUE, param5:VALUE, param6:VALUE, param7:VALUE, param8:VALUE) IS NATIVE {-IFFL_SaveClip(} param1 {,} param2 {,} param3 {,} param4 {,} param5 {,} param6 {,} param7 {,} param8 {)} ENDNATIVE !!INT
PROC IfFL_WriteChunkBytes( param1:IFFL_HANDLE, param2:PTR, param3:VALUE) IS NATIVE {IFFL_WriteChunkBytes(} param1 {,} param2 {,} param3 {)} ENDNATIVE !!VALUE
