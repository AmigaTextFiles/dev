
#ifndef c2p_akiko_PROTO_H
#define c2p_akiko_PROTO_H



#include <exec/types.h>
#include <exec/memory.h>

#include <clib/exec_protos.h>
#include <clib/graphics_protos.h>

#include "librarybase.h"

#include "sys_helpers_proto.h"





/*----------------
    PROTOTYPES
----------------*/

IMPORT VOID c2p_akiko_8x1(__reg("a0") APTR src_chunky, __reg("a1") APTR dest_planar, __reg("d0") ULONG num_pixel_to_convert, __reg("d1") ULONG bitplane_byte_size, __reg("a5") struct GfxBase *gfx_base);
IMPORT VOID c2p_akiko_8x2(__reg("a0") APTR src_chunky, __reg("a1") APTR dest_planar, __reg("d0") ULONG num_pixel_to_convert, __reg("d1") ULONG bitplane_byte_size, __reg("d2") LONG bpl_row_size, __reg("d3") LONG row_modulo, __reg("a5") struct GfxBase *gfx_base);
IMPORT VOID c2p_akiko_8x3(__reg("a0") APTR src_chunky, __reg("a1") APTR dest_planar, __reg("d0") ULONG num_pixel_to_convert, __reg("d1") ULONG bitplane_byte_size, __reg("d2") LONG bpl_row_size, __reg("d3") LONG row_modulo, __reg("a5") struct GfxBase *gfx_base);
IMPORT VOID c2p_akiko_8x4(__reg("a0") APTR src_chunky, __reg("a1") APTR dest_planar, __reg("d0") ULONG num_pixel_to_convert, __reg("d1") ULONG bitplane_byte_size, __reg("d2") LONG bpl_row_size, __reg("d3") LONG row_modulo, __reg("a5") struct GfxBase *gfx_base);
IMPORT VOID c2p_akiko_8x5(__reg("a0") APTR src_chunky, __reg("a1") APTR dest_planar, __reg("d0") ULONG num_pixel_to_convert, __reg("d1") ULONG bitplane_byte_size, __reg("d2") LONG bpl_row_size, __reg("d3") LONG row_modulo, __reg("a5") struct GfxBase *gfx_base);
IMPORT VOID c2p_akiko_8x6(__reg("a0") APTR src_chunky, __reg("a1") APTR dest_planar, __reg("d0") ULONG num_pixel_to_convert, __reg("d1") ULONG bitplane_byte_size, __reg("d2") LONG bpl_row_size, __reg("d3") LONG row_modulo, __reg("a5") struct GfxBase *gfx_base);
IMPORT VOID c2p_akiko_8x7(__reg("a0") APTR src_chunky, __reg("a1") APTR dest_planar, __reg("d0") ULONG num_pixel_to_convert, __reg("d1") ULONG bitplane_byte_size, __reg("d2") LONG bpl_row_size, __reg("d3") LONG row_modulo, __reg("a5") struct GfxBase *gfx_base);
IMPORT VOID c2p_akiko_8x8(__reg("a0") APTR src_chunky, __reg("a1") APTR dest_planar, __reg("d0") ULONG num_pixel_to_convert, __reg("d1") ULONG bitplane_byte_size, __reg("d2") LONG bpl_row_size, __reg("d3") LONG row_modulo, __reg("a5") struct GfxBase *gfx_base);


#endif  /* c2p_akiko_PROTO_H */
