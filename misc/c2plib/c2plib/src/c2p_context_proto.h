
#ifndef C2P_CONTEXT_PROTO_H
#define C2P_CONTEXT_PROTO_H


#include "c2p_system_proto.h"





/*----------------
    PROTOTYPES
----------------*/
GLOBAL APTR _C2P_AllocMem(__reg("a0") APTR context, __reg("d0") LONG bytesize);
GLOBAL ULONG _C2P_Chunky2Planar(__reg("a0") APTR context, __reg("a6") struct LibraryBase *library_base);
GLOBAL APTR _C2P_CreateBitMap(__reg("a0") APTR context, __reg("d0") ULONG width, __reg("d1") ULONG height, __reg("d2") ULONG planar_format, __reg("a6") struct LibraryBase *library_base);
GLOBAL APTR _C2P_CreateContext(__reg("a6") struct LibraryBase *library_base);
GLOBAL VOID _C2P_DestroyBitMap(__reg("a0") APTR bitmap, __reg("a6") struct LibraryBase *library_base);
GLOBAL VOID _C2P_DestroyContext(__reg("a0") APTR context, __reg("a6") struct LibraryBase *library_base);
GLOBAL VOID _C2P_FreeMem(__reg("a0") APTR memptr);
GLOBAL OBJECT _C2P_GetContextIndexedParameter(__reg("a0") APTR context, __reg("d0") ULONG parameter, __reg("d1") ULONG index);
GLOBAL OBJECT _C2P_GetContextParameter(__reg("a0") APTR context, __reg("d0") ULONG parameter);
GLOBAL ULONG _C2P_InitializeContext(__reg("a0") APTR context, __reg("a6") struct LibraryBase *library_base);
GLOBAL ULONG _C2P_SetContextIndexedParameter(__reg("a0") APTR context, __reg("d0") ULONG parameter, __reg("d1") ULONG value, __reg("d2") ULONG index);
GLOBAL ULONG _C2P_SetContextParameter(__reg("a0") APTR context, __reg("d0") ULONG parameter, __reg("d1") ULONG value);
GLOBAL ULONG _C2P_WritePixel(__reg("a0") APTR context, __reg("d0") LONG x, __reg("d1") LONG y, __reg("d2") ULONG color);





/* Private */

APTR __C2P_AllocMem(__reg("a0") APTR context, __reg("d0") LONG bytesize, __reg("d1") ULONG attributes);
struct BitMap * __C2P_CreateBitMap(APTR context, ULONG width, ULONG height, ULONG planar_format, ULONG memory_type, struct LibraryBase *library_base);

/* chunky 2 planar routines */
IMPORT VOID c2p_8x1(__reg("a0") APTR chunky_buffer, __reg("a1") APTR raster, __reg("a2") APTR scrambled, __reg("d0") LONG num_pixels, __reg("d1") LONG bpl_size);
IMPORT VOID c2p_8x2(__reg("a0") APTR chunky_buffer, __reg("a1") APTR raster, __reg("a2") APTR scrambled, __reg("d0") LONG num_pixels, __reg("d1") LONG bpl_size, __reg("d2") LONG bpl_row_size, __reg("d3") LONG row_modulo);
IMPORT VOID c2p_8x3(__reg("a0") APTR chunky_buffer, __reg("a1") APTR raster, __reg("a2") APTR scrambled, __reg("d0") LONG num_pixels, __reg("d1") LONG bpl_size, __reg("d2") LONG bpl_row_size, __reg("d3") LONG row_modulo);
IMPORT VOID c2p_8x4(__reg("a0") APTR chunky_buffer, __reg("a1") APTR raster, __reg("a2") APTR scrambled, __reg("d0") LONG num_pixels, __reg("d1") LONG bpl_size, __reg("d2") LONG bpl_row_size, __reg("d3") LONG row_modulo);
IMPORT VOID c2p_8x5(__reg("a0") APTR chunky_buffer, __reg("a1") APTR raster, __reg("a2") APTR scrambled, __reg("d0") LONG num_pixels, __reg("d1") LONG bpl_size, __reg("d2") LONG bpl_row_size, __reg("d3") LONG row_modulo);
IMPORT VOID c2p_8x6(__reg("a0") APTR chunky_buffer, __reg("a1") APTR raster, __reg("a2") APTR scrambled, __reg("d0") LONG num_pixels, __reg("d1") LONG bpl_size, __reg("d2") LONG bpl_row_size, __reg("d3") LONG row_modulo);
IMPORT VOID c2p_8x7(__reg("a0") APTR chunky_buffer, __reg("a1") APTR raster, __reg("a2") APTR scrambled, __reg("d0") LONG num_pixels, __reg("d1") LONG bpl_size, __reg("d2") LONG bpl_row_size, __reg("d3") LONG row_modulo);
IMPORT VOID c2p_8x8(__reg("a0") APTR chunky_buffer, __reg("a1") APTR raster, __reg("a2") APTR scrambled, __reg("d0") LONG num_pixels, __reg("d1") LONG bpl_size, __reg("d2") LONG bpl_row_size, __reg("d3") LONG row_modulo);

IMPORT VOID c2p_8x1_040(__reg("a0") APTR chunky_buffer, __reg("a1") APTR raster, __reg("d0") LONG num_pixels, __reg("d1") LONG bpl_size);
IMPORT VOID c2p_8x2_040(__reg("a0") APTR chunky_buffer, __reg("a1") APTR raster, __reg("d0") LONG num_pixels, __reg("d1") LONG bpl_size, __reg("d2") LONG bpl_row_size, __reg("d3") LONG row_modulo);
IMPORT VOID c2p_8x3_040(__reg("a0") APTR chunky_buffer, __reg("a1") APTR raster, __reg("d0") LONG num_pixels, __reg("d1") LONG bpl_size, __reg("d2") LONG bpl_row_size, __reg("d3") LONG row_modulo);
IMPORT VOID c2p_8x4_040(__reg("a0") APTR chunky_buffer, __reg("a1") APTR raster, __reg("d0") LONG num_pixels, __reg("d1") LONG bpl_size, __reg("d2") LONG bpl_row_size, __reg("d3") LONG row_modulo);
IMPORT VOID c2p_8x5_040(__reg("a0") APTR chunky_buffer, __reg("a1") APTR raster, __reg("d0") LONG num_pixels, __reg("d1") LONG bpl_size, __reg("d2") LONG bpl_row_size, __reg("d3") LONG row_modulo);
IMPORT VOID c2p_8x6_040(__reg("a0") APTR chunky_buffer, __reg("a1") APTR raster, __reg("d0") LONG num_pixels, __reg("d1") LONG bpl_size, __reg("d2") LONG bpl_row_size, __reg("d3") LONG row_modulo);
IMPORT VOID c2p_8x7_040(__reg("a0") APTR chunky_buffer, __reg("a1") APTR raster, __reg("d0") LONG num_pixels, __reg("d1") LONG bpl_size, __reg("d2") LONG bpl_row_size, __reg("d3") LONG row_modulo);
IMPORT VOID c2p_8x8_040(__reg("a0") APTR chunky_buffer, __reg("a1") APTR raster, __reg("d0") LONG num_pixels, __reg("d1") LONG bpl_size, __reg("d2") LONG bpl_row_size, __reg("d3") LONG row_modulo);
IMPORT VOID c2p_8x1_delta(__reg("a0") APTR scrambled, __reg("a1") APTR raster, __reg("d0") LONG num_pixels, __reg("d1") LONG bpl_size, __reg("a3") APTR reference);
IMPORT VOID c2p_8x2_delta(__reg("a0") APTR scrambled, __reg("a1") APTR raster, __reg("d0") LONG num_pixels, __reg("d1") LONG bpl_size, __reg("d2") LONG bpl_row_size, __reg("d3") LONG row_modulo, __reg("a3") APTR reference);
IMPORT VOID c2p_8x3_delta(__reg("a0") APTR scrambled, __reg("a1") APTR raster, __reg("d0") LONG num_pixels, __reg("d1") LONG bpl_size, __reg("d2") LONG bpl_row_size, __reg("d3") LONG row_modulo, __reg("a3") APTR reference);
IMPORT VOID c2p_8x4_delta(__reg("a0") APTR scrambled, __reg("a1") APTR raster, __reg("d0") LONG num_pixels, __reg("d1") LONG bpl_size, __reg("d2") LONG bpl_row_size, __reg("d3") LONG row_modulo, __reg("a3") APTR reference);
IMPORT VOID c2p_8x5_delta(__reg("a0") APTR scrambled, __reg("a1") APTR raster, __reg("d0") LONG num_pixels, __reg("d1") LONG bpl_size, __reg("d2") LONG bpl_row_size, __reg("d3") LONG row_modulo, __reg("a3") APTR reference);
IMPORT VOID c2p_8x6_delta(__reg("a0") APTR scrambled, __reg("a1") APTR raster, __reg("d0") LONG num_pixels, __reg("d1") LONG bpl_size, __reg("d2") LONG bpl_row_size, __reg("d3") LONG row_modulo, __reg("a3") APTR reference);
IMPORT VOID c2p_8x7_delta(__reg("a0") APTR scrambled, __reg("a1") APTR raster, __reg("d0") LONG num_pixels, __reg("d1") LONG bpl_size, __reg("d2") LONG bpl_row_size, __reg("d3") LONG row_modulo, __reg("a3") APTR reference);
IMPORT VOID c2p_8x8_delta(__reg("a0") APTR scrambled, __reg("a1") APTR raster, __reg("d0") LONG num_pixels, __reg("d1") LONG bpl_size, __reg("d2") LONG bpl_row_size, __reg("d3") LONG row_modulo, __reg("a3") APTR reference);
IMPORT VOID c2p_8x1_delta_writeback(__reg("a0") APTR scrambled, __reg("a1") APTR raster, __reg("d0") LONG num_pixels, __reg("d1") LONG bpl_size, __reg("a3") APTR reference);
IMPORT VOID c2p_8x2_delta_writeback(__reg("a0") APTR scrambled, __reg("a1") APTR raster, __reg("d0") LONG num_pixels, __reg("d1") LONG bpl_size, __reg("d2") LONG bpl_row_size, __reg("d3") LONG row_modulo, __reg("a3") APTR reference);
IMPORT VOID c2p_8x3_delta_writeback(__reg("a0") APTR scrambled, __reg("a1") APTR raster, __reg("d0") LONG num_pixels, __reg("d1") LONG bpl_size, __reg("d2") LONG bpl_row_size, __reg("d3") LONG row_modulo, __reg("a3") APTR reference);
IMPORT VOID c2p_8x4_delta_writeback(__reg("a0") APTR scrambled, __reg("a1") APTR raster, __reg("d0") LONG num_pixels, __reg("d1") LONG bpl_size, __reg("d2") LONG bpl_row_size, __reg("d3") LONG row_modulo, __reg("a3") APTR reference);
IMPORT VOID c2p_8x5_delta_writeback(__reg("a0") APTR scrambled, __reg("a1") APTR raster, __reg("d0") LONG num_pixels, __reg("d1") LONG bpl_size, __reg("d2") LONG bpl_row_size, __reg("d3") LONG row_modulo, __reg("a3") APTR reference);
IMPORT VOID c2p_8x6_delta_writeback(__reg("a0") APTR scrambled, __reg("a1") APTR raster, __reg("d0") LONG num_pixels, __reg("d1") LONG bpl_size, __reg("d2") LONG bpl_row_size, __reg("d3") LONG row_modulo, __reg("a3") APTR reference);
IMPORT VOID c2p_8x7_delta_writeback(__reg("a0") APTR scrambled, __reg("a1") APTR raster, __reg("d0") LONG num_pixels, __reg("d1") LONG bpl_size, __reg("d2") LONG bpl_row_size, __reg("d3") LONG row_modulo, __reg("a3") APTR reference);
IMPORT VOID c2p_8x8_delta_writeback(__reg("a0") APTR scrambled, __reg("a1") APTR raster, __reg("d0") LONG num_pixels, __reg("d1") LONG bpl_size, __reg("d2") LONG bpl_row_size, __reg("d3") LONG row_modulo, __reg("a3") APTR reference);

/* scrambled 2 planar routines */
IMPORT VOID s2p_8x1(__reg("a0") APTR scrambled, __reg("a1") APTR raster, __reg("d0") LONG num_pixels, __reg("d1") LONG bpl_size);
IMPORT VOID s2p_8x2(__reg("a0") APTR scrambled, __reg("a1") APTR raster, __reg("d0") LONG num_pixels, __reg("d1") LONG bpl_size, __reg("d2") LONG bpl_row_size, __reg("d3") LONG row_modulo);
IMPORT VOID s2p_8x3(__reg("a0") APTR scrambled, __reg("a1") APTR raster, __reg("d0") LONG num_pixels, __reg("d1") LONG bpl_size, __reg("d2") LONG bpl_row_size, __reg("d3") LONG row_modulo);
IMPORT VOID s2p_8x4(__reg("a0") APTR scrambled, __reg("a1") APTR raster, __reg("d0") LONG num_pixels, __reg("d1") LONG bpl_size, __reg("d2") LONG bpl_row_size, __reg("d3") LONG row_modulo);
IMPORT VOID s2p_8x5(__reg("a0") APTR scrambled, __reg("a1") APTR raster, __reg("d0") LONG num_pixels, __reg("d1") LONG bpl_size, __reg("d2") LONG bpl_row_size, __reg("d3") LONG row_modulo);
IMPORT VOID s2p_8x6(__reg("a0") APTR scrambled, __reg("a1") APTR raster, __reg("d0") LONG num_pixels, __reg("d1") LONG bpl_size, __reg("d2") LONG bpl_row_size, __reg("d3") LONG row_modulo);
IMPORT VOID s2p_8x7(__reg("a0") APTR scrambled, __reg("a1") APTR raster, __reg("d0") LONG num_pixels, __reg("d1") LONG bpl_size, __reg("d2") LONG bpl_row_size, __reg("d3") LONG row_modulo);
IMPORT VOID s2p_8x8(__reg("a0") APTR scrambled, __reg("a1") APTR raster, __reg("d0") LONG num_pixels, __reg("d1") LONG bpl_size, __reg("d2") LONG bpl_row_size, __reg("d3") LONG row_modulo);
IMPORT VOID s2p_8x1_delta(__reg("a0") APTR scrambled, __reg("a1") APTR raster, __reg("d0") LONG num_pixels, __reg("d1") LONG bpl_size, __reg("a3") APTR reference);
IMPORT VOID s2p_8x2_delta(__reg("a0") APTR scrambled, __reg("a1") APTR raster, __reg("d0") LONG num_pixels, __reg("d1") LONG bpl_size, __reg("d2") LONG bpl_row_size, __reg("d3") LONG row_modulo, __reg("a3") APTR reference);
IMPORT VOID s2p_8x3_delta(__reg("a0") APTR scrambled, __reg("a1") APTR raster, __reg("d0") LONG num_pixels, __reg("d1") LONG bpl_size, __reg("d2") LONG bpl_row_size, __reg("d3") LONG row_modulo, __reg("a3") APTR reference);
IMPORT VOID s2p_8x4_delta(__reg("a0") APTR scrambled, __reg("a1") APTR raster, __reg("d0") LONG num_pixels, __reg("d1") LONG bpl_size, __reg("d2") LONG bpl_row_size, __reg("d3") LONG row_modulo, __reg("a3") APTR reference);
IMPORT VOID s2p_8x5_delta(__reg("a0") APTR scrambled, __reg("a1") APTR raster, __reg("d0") LONG num_pixels, __reg("d1") LONG bpl_size, __reg("d2") LONG bpl_row_size, __reg("d3") LONG row_modulo, __reg("a3") APTR reference);
IMPORT VOID s2p_8x6_delta(__reg("a0") APTR scrambled, __reg("a1") APTR raster, __reg("d0") LONG num_pixels, __reg("d1") LONG bpl_size, __reg("d2") LONG bpl_row_size, __reg("d3") LONG row_modulo, __reg("a3") APTR reference);
IMPORT VOID s2p_8x7_delta(__reg("a0") APTR scrambled, __reg("a1") APTR raster, __reg("d0") LONG num_pixels, __reg("d1") LONG bpl_size, __reg("d2") LONG bpl_row_size, __reg("d3") LONG row_modulo, __reg("a3") APTR reference);
IMPORT VOID s2p_8x8_delta(__reg("a0") APTR scrambled, __reg("a1") APTR raster, __reg("d0") LONG num_pixels, __reg("d1") LONG bpl_size, __reg("d2") LONG bpl_row_size, __reg("d3") LONG row_modulo, __reg("a3") APTR reference);
IMPORT VOID s2p_8x1_delta_writeback(__reg("a0") APTR scrambled, __reg("a1") APTR raster, __reg("d0") LONG num_pixels, __reg("d1") LONG bpl_size, __reg("a3") APTR reference);
IMPORT VOID s2p_8x2_delta_writeback(__reg("a0") APTR scrambled, __reg("a1") APTR raster, __reg("d0") LONG num_pixels, __reg("d1") LONG bpl_size, __reg("d2") LONG bpl_row_size, __reg("d3") LONG row_modulo, __reg("a3") APTR reference);
IMPORT VOID s2p_8x3_delta_writeback(__reg("a0") APTR scrambled, __reg("a1") APTR raster, __reg("d0") LONG num_pixels, __reg("d1") LONG bpl_size, __reg("d2") LONG bpl_row_size, __reg("d3") LONG row_modulo, __reg("a3") APTR reference);
IMPORT VOID s2p_8x4_delta_writeback(__reg("a0") APTR scrambled, __reg("a1") APTR raster, __reg("d0") LONG num_pixels, __reg("d1") LONG bpl_size, __reg("d2") LONG bpl_row_size, __reg("d3") LONG row_modulo, __reg("a3") APTR reference);
IMPORT VOID s2p_8x5_delta_writeback(__reg("a0") APTR scrambled, __reg("a1") APTR raster, __reg("d0") LONG num_pixels, __reg("d1") LONG bpl_size, __reg("d2") LONG bpl_row_size, __reg("d3") LONG row_modulo, __reg("a3") APTR reference);
IMPORT VOID s2p_8x6_delta_writeback(__reg("a0") APTR scrambled, __reg("a1") APTR raster, __reg("d0") LONG num_pixels, __reg("d1") LONG bpl_size, __reg("d2") LONG bpl_row_size, __reg("d3") LONG row_modulo, __reg("a3") APTR reference);
IMPORT VOID s2p_8x7_delta_writeback(__reg("a0") APTR scrambled, __reg("a1") APTR raster, __reg("d0") LONG num_pixels, __reg("d1") LONG bpl_size, __reg("d2") LONG bpl_row_size, __reg("d3") LONG row_modulo, __reg("a3") APTR reference);
IMPORT VOID s2p_8x8_delta_writeback(__reg("a0") APTR scrambled, __reg("a1") APTR raster, __reg("d0") LONG num_pixels, __reg("d1") LONG bpl_size, __reg("d2") LONG bpl_row_size, __reg("d3") LONG row_modulo, __reg("a3") APTR reference);


#endif  /* C2P_CONTEXT_PROTO_H */
