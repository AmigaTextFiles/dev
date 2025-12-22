
#ifndef CLIB_C2P_PROTOS_H
#define CLIB_C2P_PROTOS_H

APTR C2P_AllocMem(APTR context, LONG bytesize);
VOID C2P_CopyMem(APTR src, APTR dest, LONG size);
VOID C2P_FreeMem(APTR memptr);
ULONG C2P_Chunky2Planar(APTR context);
APTR C2P_CreateBitMap(APTR context, ULONG width, ULONG height, ULONG planar_format);
APTR C2P_CreateContext(VOID);
VOID C2P_DestroyBitMap(APTR bitmap);
VOID C2P_DestroyContext(APTR context);
ULONG C2P_GetContextIndexedParameter(APTR context, ULONG parameter, ULONG index);
ULONG C2P_GetContextParameter(APTR context, ULONG parameter);
ULONG C2P_GetSystemIndexedParameter(ULONG parameter, ULONG index);
ULONG C2P_GetSystemParameter(ULONG parameter);
ULONG C2P_InitializeContext(APTR context);
ULONG C2P_SetContextIndexedParameter(APTR context, ULONG parameter, ULONG value, ULONG index);
ULONG C2P_SetContextParameter(APTR context, ULONG parameter, ULONG value);
ULONG C2P_WritePixel(APTR context, LONG x, LONG y, ULONG color);

#endif /* CLIB_EXAMPLE_PROTOS_H */
