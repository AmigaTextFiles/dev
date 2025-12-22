
#include <exec/types.h>
#include <graphics/gfx.h>
#include <intuition/intuition.h>

#include <clib/exec_protos.h>
#include <clib/graphics_protos.h>
#include <clib/intuition_protos.h>

#include "../sdk/C/c2p_context.h"
#include "c2p_context_proto.h"
#include "sys_helpers_proto.h"
#include "c2p_akiko_proto.h"
#include "memory_proto.h"
#include "librarybase.h"



/*
    IMPORTANT: DON'T RELY ON THE STRUCTURES DATA FIELDS
    The internal data structure may change in future versions.
    Use appropriate getter/setters functions instead.
*/





typedef struct c2p_Context
{
    BOOL IsInitialized;
    BOOL ForceScrambled;    /* TRUE to force only scrambled buffer (skip chunky2scrambled conversion) */
    APTR MemoryManager;
    ULONG Width;            /* width in pixels */
    ULONG Height;           /* height in pixels */
    struct BitMap *BitMap;
    APTR Raster;            /* ptr to bitplane #0 */
    UBYTE *Chunky;          /* chunky buffer */
    UBYTE *_Chunky;         /* internal ptr to chunky buffer */
    LONG _ChunkySize;
    UBYTE *Scrambled;       /* scrambled buffer */
    UBYTE *_Scrambled;      /* internal ptr to scrambled buffer */
    LONG ScrambledOffsets[32];
    UBYTE *Reference;       /* reference buffer for delta conversion */
    BOOL ReferenceWriteback; /* TRUE to writeback to reference buffer during conversion */
    UWORD ContextType;
    UWORD PlanarFormat;
    BOOL InterleavedBitMap;
    LONG SourceOffset;      /* num of pixel to skip in the chunky or scrambled buffer */
    LONG TargetOffset;      /* num of pixel to skip in the planar bitmap */
    LONG ConvertCount;      /* num of pixel to convert */

} c2p_Context;





/*
	C2P_AllocMem()

	Allocates a PUBLIC memory block.
    On error, returns NULL.

	memptr = C2P_AllocMem(context, bytesize)

        context  =  Address of the context.
        bytesize =  Number of bytes to allocate.

        memptr =    Address of allocated memory block, or NULL on error.
*/
APTR _C2P_AllocMem(__reg("a0") APTR context, __reg("d0") LONG bytesize)
{
	return __C2P_AllocMem(context, bytesize, MEMF_PUBLIC | MEMF_CLEAR);

}//_C2P_AllocMem





/*
	C2P_Chunky2Planar()

	Perform the c2p conversion.

	result = C2P_Chunky2Planar(context)

		context =   Address of the context.

		result =    NULL on success or error code.
*/
ULONG _C2P_Chunky2Planar(__reg("a0") APTR context, __reg("a6") struct LibraryBase *library_base)
{
    ULONG result = NULL;

    do
    {
        struct c2p_Context *ctx = (struct c2p_Context *) context;

        if (ctx == NULL)
        {
            result = ERR_CONTEXT_UNALLOCATED;
            break;
        }
        if (!ctx->IsInitialized)
        {
            result = ERR_CONTEXT_NOT_INITIALIZED;
            break;
        }

        struct BitMap * bmp = ctx->BitMap;
        int row_size = bmp->BytesPerRow;        // number og bytes per row (Note: interleaved rows weights N times)
        int bpl_row_size = ctx->Width >> 3;     // number of bytes in a single bitplane row

        // Note: fast initialization as use in interleaved bitmaps
        int bpl_size = bpl_row_size;            // bitplane as a single row in interleaved bitmaps
        int row_modulo = row_size;              // number of bytes to add after a row to reach next row
        // else:
        if (!ctx->InterleavedBitMap)
        {
            bpl_size = (long)bpl_row_size * (long)bmp->Rows;
            row_modulo = 0;                     // NEEDED by cs2p_8 asm routine to detect a non interleaved bitmap
        }

        UBYTE * chunky_ptr = ctx->Chunky + ctx->SourceOffset;
        UBYTE * reference_ptr = ctx->Reference;
        if (reference_ptr != NULL)
            reference_ptr += ctx->SourceOffset;
        UBYTE * scrambled_ptr = ctx->Scrambled + ctx->SourceOffset;
        APTR raster_ptr = (UBYTE *)ctx->Raster;
        if (ctx->TargetOffset > 0)
        {
            if (ctx->InterleavedBitMap)
                raster_ptr = (UBYTE *)ctx->Raster + (ctx->TargetOffset >> 3) * (LONG)ctx->PlanarFormat;
            else
                raster_ptr = (UBYTE *)ctx->Raster + (ctx->TargetOffset >> 3);
        }

        LONG num_pixels = ctx->_ChunkySize;
        if (ctx->ConvertCount >= 0)
            num_pixels = ctx->ConvertCount;

        switch (ctx->PlanarFormat)
        {
            case C2P_CONTEXT_PLANAR_FORMAT_1_BIT:
            {
                if (ctx->ForceScrambled)
                {
                    if (reference_ptr == NULL)
                        s2p_8x1(scrambled_ptr, raster_ptr, num_pixels, bpl_size);
                    else if (ctx->ReferenceWriteback)
                        s2p_8x1_delta_writeback(scrambled_ptr, raster_ptr, num_pixels, bpl_size, reference_ptr);
                    else
                        s2p_8x1_delta(scrambled_ptr, raster_ptr, num_pixels, bpl_size, reference_ptr);
                }
                else
                {
                    if (reference_ptr == NULL)
                    {
                        if (library_base->lb_AkikoDetected && (library_base->lb_Cpu <= C2P_SYSTEM_CPU_68020))
                            c2p_akiko_8x1(chunky_ptr, raster_ptr, num_pixels, bpl_size, library_base->lb_GfxBase);
                        //else if (library_base->lb_Cpu <= C2P_SYSTEM_CPU_68030)
                        //    c2p_8x1(chunky_ptr, raster_ptr, scrambled_ptr, num_pixels, bpl_size);
                        else
                            c2p_8x1_040(chunky_ptr, raster_ptr, num_pixels, bpl_size);
                    }
                    else if (ctx->ReferenceWriteback)
                        c2p_8x1_delta_writeback(chunky_ptr, raster_ptr, num_pixels, bpl_size, reference_ptr);                        
                    else
                        c2p_8x1_delta(chunky_ptr, raster_ptr, num_pixels, bpl_size, reference_ptr);                        
                }
                break;
            }
            case C2P_CONTEXT_PLANAR_FORMAT_2_BIT:
            {
                if (ctx->ForceScrambled)
                {
                    if (reference_ptr == NULL)
                        s2p_8x2(scrambled_ptr, raster_ptr, num_pixels, bpl_size, bpl_row_size, row_modulo);
                    else if (ctx->ReferenceWriteback)
                        s2p_8x2_delta_writeback(scrambled_ptr, raster_ptr, num_pixels, bpl_size, bpl_row_size, row_modulo, reference_ptr);
                    else
                        s2p_8x2_delta(scrambled_ptr, raster_ptr, num_pixels, bpl_size, bpl_row_size, row_modulo, reference_ptr);
                }
                else
                {
                    if (reference_ptr == NULL)
                    {
                        if (library_base->lb_AkikoDetected && (library_base->lb_Cpu <= C2P_SYSTEM_CPU_68020))
                            c2p_akiko_8x2(chunky_ptr, raster_ptr, num_pixels, bpl_size, bpl_row_size, row_modulo, library_base->lb_GfxBase);
                        else if (library_base->lb_Cpu <= C2P_SYSTEM_CPU_68030)
                            c2p_8x2(chunky_ptr, raster_ptr, scrambled_ptr, num_pixels, bpl_size, bpl_row_size, row_modulo);
                        else
                            c2p_8x2_040(chunky_ptr, raster_ptr, num_pixels, bpl_size, bpl_row_size, row_modulo);
                    }
                    else if (ctx->ReferenceWriteback)
                        c2p_8x2_delta_writeback(chunky_ptr, raster_ptr, num_pixels, bpl_size, bpl_row_size, row_modulo, reference_ptr);                        
                    else
                        c2p_8x2_delta(chunky_ptr, raster_ptr, num_pixels, bpl_size, bpl_row_size, row_modulo, reference_ptr);                        
                }
                break;
            }
            case C2P_CONTEXT_PLANAR_FORMAT_3_BIT:
            {
                if (ctx->ForceScrambled)
                {
                    if (reference_ptr == NULL)
                        s2p_8x3(scrambled_ptr, raster_ptr, num_pixels, bpl_size, bpl_row_size, row_modulo);
                    else if (ctx->ReferenceWriteback)
                        s2p_8x3_delta_writeback(scrambled_ptr, raster_ptr, num_pixels, bpl_size, bpl_row_size, row_modulo, reference_ptr);
                    else
                        s2p_8x3_delta(scrambled_ptr, raster_ptr, num_pixels, bpl_size, bpl_row_size, row_modulo, reference_ptr);
                }
                else
                {
                    if (reference_ptr == NULL)
                    {
                        if (library_base->lb_AkikoDetected && (library_base->lb_Cpu <= C2P_SYSTEM_CPU_68020))
                            c2p_akiko_8x3(chunky_ptr, raster_ptr, num_pixels, bpl_size, bpl_row_size, row_modulo, library_base->lb_GfxBase);
                        else if (library_base->lb_Cpu <= C2P_SYSTEM_CPU_68030)
                            c2p_8x3(chunky_ptr, raster_ptr, scrambled_ptr, num_pixels, bpl_size, bpl_row_size, row_modulo);
                        else
                            c2p_8x3_040(chunky_ptr, raster_ptr, num_pixels, bpl_size, bpl_row_size, row_modulo);
                    }
                    else if (ctx->ReferenceWriteback)
                        c2p_8x3_delta_writeback(chunky_ptr, raster_ptr, num_pixels, bpl_size, bpl_row_size, row_modulo, reference_ptr);                        
                    else
                        c2p_8x3_delta(chunky_ptr, raster_ptr, num_pixels, bpl_size, bpl_row_size, row_modulo, reference_ptr);                        
                }
                break;
            }
            case C2P_CONTEXT_PLANAR_FORMAT_4_BIT:
            {
                if (ctx->ForceScrambled)
                {
                    if (reference_ptr == NULL)
                        s2p_8x4(scrambled_ptr, raster_ptr, num_pixels, bpl_size, bpl_row_size, row_modulo);
                    else if (ctx->ReferenceWriteback)
                        s2p_8x4_delta_writeback(scrambled_ptr, raster_ptr, num_pixels, bpl_size, bpl_row_size, row_modulo, reference_ptr);
                    else
                        s2p_8x4_delta(scrambled_ptr, raster_ptr, num_pixels, bpl_size, bpl_row_size, row_modulo, reference_ptr);
                }
                else
                {
                    if (reference_ptr == NULL)
                    {
                        if (library_base->lb_AkikoDetected && (library_base->lb_Cpu <= C2P_SYSTEM_CPU_68020))
                            c2p_akiko_8x4(chunky_ptr, raster_ptr, num_pixels, bpl_size, bpl_row_size, row_modulo, library_base->lb_GfxBase);
                        else if (library_base->lb_Cpu <= C2P_SYSTEM_CPU_68030)
                            c2p_8x4(chunky_ptr, raster_ptr, scrambled_ptr, num_pixels, bpl_size, bpl_row_size, row_modulo);
                        else
                            c2p_8x4_040(chunky_ptr, raster_ptr, num_pixels, bpl_size, bpl_row_size, row_modulo);
                    }
                    else if (ctx->ReferenceWriteback)
                        c2p_8x4_delta_writeback(chunky_ptr, raster_ptr, num_pixels, bpl_size, bpl_row_size, row_modulo, reference_ptr);                        
                    else
                        c2p_8x4_delta(chunky_ptr, raster_ptr, num_pixels, bpl_size, bpl_row_size, row_modulo, reference_ptr);                        
                }
                break;
            }
            case C2P_CONTEXT_PLANAR_FORMAT_5_BIT:
            {
                if (ctx->ForceScrambled)
                {
                    if (reference_ptr == NULL)
                        s2p_8x5(scrambled_ptr, raster_ptr, num_pixels, bpl_size, bpl_row_size, row_modulo);
                    else if (ctx->ReferenceWriteback)
                        s2p_8x5_delta_writeback(scrambled_ptr, raster_ptr, num_pixels, bpl_size, bpl_row_size, row_modulo, reference_ptr);
                    else
                        s2p_8x5_delta(scrambled_ptr, raster_ptr, num_pixels, bpl_size, bpl_row_size, row_modulo, reference_ptr);
                }
                else
                {
                    if (reference_ptr == NULL)
                    {
                        if (library_base->lb_AkikoDetected && (library_base->lb_Cpu <= C2P_SYSTEM_CPU_68020))
                            c2p_akiko_8x5(chunky_ptr, raster_ptr, num_pixels, bpl_size, bpl_row_size, row_modulo, library_base->lb_GfxBase);
                        else if (library_base->lb_Cpu <= C2P_SYSTEM_CPU_68030)
                            c2p_8x5(chunky_ptr, raster_ptr, scrambled_ptr, num_pixels, bpl_size, bpl_row_size, row_modulo);
                        else
                            c2p_8x5_040(chunky_ptr, raster_ptr, num_pixels, bpl_size, bpl_row_size, row_modulo);
                    }
                    else if (ctx->ReferenceWriteback)
                        c2p_8x5_delta_writeback(chunky_ptr, raster_ptr, num_pixels, bpl_size, bpl_row_size, row_modulo, reference_ptr);                        
                    else
                        c2p_8x5_delta(chunky_ptr, raster_ptr, num_pixels, bpl_size, bpl_row_size, row_modulo, reference_ptr);                        
                }
                break;
            }
            case C2P_CONTEXT_PLANAR_FORMAT_6_BIT:
            {
                if (ctx->ForceScrambled)
                {
                    if (reference_ptr == NULL)
                        s2p_8x6(scrambled_ptr, raster_ptr, num_pixels, bpl_size, bpl_row_size, row_modulo);
                    else if (ctx->ReferenceWriteback)
                        s2p_8x6_delta_writeback(scrambled_ptr, raster_ptr, num_pixels, bpl_size, bpl_row_size, row_modulo, reference_ptr);
                    else
                        s2p_8x6_delta(scrambled_ptr, raster_ptr, num_pixels, bpl_size, bpl_row_size, row_modulo, reference_ptr);
                }
                else
                {
                    if (reference_ptr == NULL)
                    {
                        if (library_base->lb_AkikoDetected && (library_base->lb_Cpu <= C2P_SYSTEM_CPU_68020))
                            c2p_akiko_8x6(chunky_ptr, raster_ptr, num_pixels, bpl_size, bpl_row_size, row_modulo, library_base->lb_GfxBase);
                        else if (library_base->lb_Cpu <= C2P_SYSTEM_CPU_68030)
                            c2p_8x6(chunky_ptr, raster_ptr, scrambled_ptr, num_pixels, bpl_size, bpl_row_size, row_modulo);
                        else
                            c2p_8x6_040(chunky_ptr, raster_ptr, num_pixels, bpl_size, bpl_row_size, row_modulo);
                    }
                    else if (ctx->ReferenceWriteback)
                        c2p_8x6_delta_writeback(chunky_ptr, raster_ptr, num_pixels, bpl_size, bpl_row_size, row_modulo, reference_ptr);                        
                    else
                        c2p_8x6_delta(chunky_ptr, raster_ptr, num_pixels, bpl_size, bpl_row_size, row_modulo, reference_ptr);                        
                }
                break;
            }
            case C2P_CONTEXT_PLANAR_FORMAT_7_BIT:
            {
                if (ctx->ForceScrambled)
                {
                    if (reference_ptr == NULL)
                        s2p_8x7(scrambled_ptr, raster_ptr, num_pixels, bpl_size, bpl_row_size, row_modulo);
                    else if (ctx->ReferenceWriteback)
                        s2p_8x7_delta_writeback(scrambled_ptr, raster_ptr, num_pixels, bpl_size, bpl_row_size, row_modulo, reference_ptr);
                    else
                        s2p_8x7_delta(scrambled_ptr, raster_ptr, num_pixels, bpl_size, bpl_row_size, row_modulo, reference_ptr);
                }
                else
                {
                    if (reference_ptr == NULL)
                    {
                        if (library_base->lb_AkikoDetected && (library_base->lb_Cpu <= C2P_SYSTEM_CPU_68020))
                            c2p_akiko_8x7(chunky_ptr, raster_ptr, num_pixels, bpl_size, bpl_row_size, row_modulo, library_base->lb_GfxBase);
                        else if (library_base->lb_Cpu <= C2P_SYSTEM_CPU_68030)
                            c2p_8x7(chunky_ptr, raster_ptr, scrambled_ptr, num_pixels, bpl_size, bpl_row_size, row_modulo);
                        else
                            c2p_8x7_040(chunky_ptr, raster_ptr, num_pixels, bpl_size, bpl_row_size, row_modulo);
                    }
                    else if (ctx->ReferenceWriteback)
                        c2p_8x7_delta_writeback(chunky_ptr, raster_ptr, num_pixels, bpl_size, bpl_row_size, row_modulo, reference_ptr);                        
                    else
                        c2p_8x7_delta(chunky_ptr, raster_ptr, num_pixels, bpl_size, bpl_row_size, row_modulo, reference_ptr);                        
                }
                break;
            }
            case C2P_CONTEXT_PLANAR_FORMAT_8_BIT:
            {
                if (ctx->ForceScrambled)
                {
                    if (reference_ptr == NULL)
                        s2p_8x8(scrambled_ptr, raster_ptr, num_pixels, bpl_size, bpl_row_size, row_modulo);
                    else if (ctx->ReferenceWriteback)
                        s2p_8x8_delta_writeback(scrambled_ptr, raster_ptr, num_pixels, bpl_size, bpl_row_size, row_modulo, reference_ptr);
                    else
                        s2p_8x8_delta(scrambled_ptr, raster_ptr, num_pixels, bpl_size, bpl_row_size, row_modulo, reference_ptr);
                }
                else
                {
                    if (reference_ptr == NULL)
                    {
                        if (library_base->lb_AkikoDetected && (library_base->lb_Cpu <= C2P_SYSTEM_CPU_68020))
                            c2p_akiko_8x8(chunky_ptr, raster_ptr, num_pixels, bpl_size, bpl_row_size, row_modulo, library_base->lb_GfxBase);
                        else if (library_base->lb_Cpu <= C2P_SYSTEM_CPU_68030)
                            c2p_8x8(chunky_ptr, raster_ptr, scrambled_ptr, num_pixels, bpl_size, bpl_row_size, row_modulo);
                        else
                            c2p_8x8_040(chunky_ptr, raster_ptr, num_pixels, bpl_size, bpl_row_size, row_modulo);
                    }
                    else if (ctx->ReferenceWriteback)
                        c2p_8x8_delta_writeback(chunky_ptr, raster_ptr, num_pixels, bpl_size, bpl_row_size, row_modulo, reference_ptr);                        
                    else
                        c2p_8x8_delta(chunky_ptr, raster_ptr, num_pixels, bpl_size, bpl_row_size, row_modulo, reference_ptr);                        
                }
                break;
            }
        }

    } while (FALSE);

    return result;

}//_C2P_Chunky2Planar





/*
	C2P_CreateBitMap()

	Helper function to create a BitMap.

	result = C2P_CreateBitMap(context, width, height, planar_format)

		context       = Address of the context.
		width         = Width in pixel.
		height        = Height in pixel.
		planar_format = Planar format, see C2P_CONTEXT_PLANAR_FORMAT_*.

		result =    Address of the BitMap.
*/
APTR _C2P_CreateBitMap(__reg("a0") APTR context, __reg("d0") ULONG width, __reg("d1") ULONG height, __reg("d2") ULONG planar_format, __reg("a6") struct LibraryBase *library_base)
{
    struct BitMap *result = __C2P_CreateBitMap(
        context,
        width,
        height,
        planar_format,
        MEMF_CHIP | MEMF_CLEAR,
        library_base
        );

    return result;

}//_C2P_CreateBitMap





/*
	C2P_CreateContext()

	Creates an empty context.

	result = C2P_CreateContext()

		result =    Address of the context or NULL if error.
*/
APTR _C2P_CreateContext(__reg("a6") struct LibraryBase *library_base)
{
    BOOL error = FALSE;
    c2p_Context *result = NULL;
    APTR memory_manager = NULL;

    do
    {
        result = _C2P_AllocMem_System(sizeof(struct c2p_Context), library_base);
        if (result == NULL)
        {
            error = TRUE;
            break;
        }

        memory_manager = CreateMemoryManager();
        if (memory_manager == NULL)
        {
            error = TRUE;
            break;
        }

        result->MemoryManager = memory_manager;

        LONG scrambled_offsets[] = {
            0, 3, 6, 9, 12, 15, 18, 21, -7, -4, -1, 2, 5, 8, 11, 14,
            -14, -11, -8, -5, -2, 1, 4, 7, -21, -18, -15, -12, -9, -6, -3, 0
            };
        for (int i = 0; i < 32; i++)
            result->ScrambledOffsets[i] = scrambled_offsets[i];

        result->SourceOffset = 0;
        result->TargetOffset = 0;
        result->ConvertCount = -1;

        result->ReferenceWriteback = TRUE;

    } while (FALSE);

    if (error)
    {
        if (memory_manager != NULL)
        {
            DeleteMemoryManager(memory_manager);
            memory_manager = NULL;
        }
        if (result != NULL)
        {
            _C2P_FreeMem_System(result, library_base);
            result = NULL;
        }
    }

    return result;

}//_C2P_CreateContext





/*
	C2P_DestroyBitMap()

	Destroy a previously created bitmap.
	If input parameter is NULL, this function does nothing.

	C2P_DestroyBitMap(bitmap)

		bitmap =    Address of the bitmap.
*/
VOID _C2P_DestroyBitMap(__reg("a0") APTR bitmap, __reg("a6") struct LibraryBase *library_base)
{
    if (bitmap)
    {
        struct BitMap *bmp = (struct BitMap *) bitmap;
        APTR raster = bmp->Planes[0];

        if (raster != NULL)
        {
            // NOTE: Raster may be allocated in CHIP RAM
            _C2P_FreeMem(raster);
        }
        _C2P_FreeMem(bitmap);
    }

}//_C2P_DestroyBitMap





/*
	C2P_DestroyContext()

	Destroy a previously created context.
    If input parameter is NULL, this function does nothing.

	C2P_DestroyContext(context)

		context =   Address of the context.
*/
VOID _C2P_DestroyContext(__reg("a0") APTR context, __reg("a6") struct LibraryBase *library_base)
{
    if (context)
    {
        struct c2p_Context *ctx = (struct c2p_Context *) context;

        if (ctx->MemoryManager != NULL)
        {
            DeleteMemoryManager(ctx->MemoryManager);
            ctx->MemoryManager = NULL;
        }
        _C2P_FreeMem_System(context, library_base);
    }

}//_C2P_DestroyContext





/*
	C2P_FreeMem()

	Deallocates a memory block previously allocated using C2P_AllocMem().
    If input parameter is NULL, this function does nothing.

	C2P_FreeMem(memptr)

        memptr =    Address of memory block to deallocate.
                    It must be previously allocated using C2P_AllocMem().
*/
VOID _C2P_FreeMem(__reg("a0") APTR memptr)
{
	struct c2p_Context *context;
	ULONG *ptr;

	if (memptr)
	{
		ptr = (ULONG *) memptr;
		ptr -= 1;
		context = (struct c2p_Context *) ptr[0];
		FreeMemory(context->MemoryManager, ptr);
	}

}//_C2P_FreeMem





/*
	C2P_GetContextIndexedParameter()

	Gets a context indexed parameter value.

	result = C2P_GetContextIndexedParameter(context, parameter, index)

		context =   Address of the context.
		parameter = Parameter name of type CONTEXT_PARAMETER_*.
        index =     Index of value (0 = first index).

        result =    The parameter value, NULL if the parameter is not found.
*/
OBJECT _C2P_GetContextIndexedParameter(__reg("a0") APTR context, __reg("d0") ULONG parameter, __reg("d1") ULONG index)
{
    LONG result = NULL;

    struct c2p_Context *ctx = (struct c2p_Context *) context;

    switch (parameter)
    {
        case C2P_CONTEXT_PARAMETER_SCRAMBLED_OFFSET:
        {
            LONG i = index & 0x1F;
            result = ctx->ScrambledOffsets[i];
            break;
        }
    }

    return result;

}//_C2P_GetContextIndexedParameter





/*
	C2P_GetContextParameter()

	Gets a context parameter value.

	result = C2P_GetContextParameter(context, parameter)

		context =   Address of the context.
		parameter = Parameter name of type CONTEXT_PARAMETER_*.

        result =    The parameter value, NULL if the parameter is not found.
*/
OBJECT _C2P_GetContextParameter(__reg("a0") APTR context, __reg("d0") ULONG parameter)
{
    ULONG result = NULL;

    struct c2p_Context *ctx = (struct c2p_Context *) context;

    switch (parameter)
    {
        case C2P_CONTEXT_PARAMETER_BITMAP:
            result = (OBJECT) ctx->BitMap;
            break;
        case C2P_CONTEXT_PARAMETER_CHUNKY:
            result = ctx->ForceScrambled ? (OBJECT) ctx->Scrambled : (OBJECT) ctx->Chunky;
            break;
        case C2P_CONTEXT_PARAMETER_CONVERT_COUNT:
            if (ctx->ConvertCount >= 0)             // if C2P_CONTEXT_PARAMETER_CONVERT_COUNT has been specified
                result = ctx->ConvertCount;
            else
                result = ctx->Width * ctx->Height;  // deafult value
            break;
        case C2P_CONTEXT_PARAMETER_FORCE_SCRAMBLED:
            result = ctx->ForceScrambled;
            break;
        case C2P_CONTEXT_PARAMETER_HEIGHT:
            result = ctx->Height;
            break;
        case C2P_CONTEXT_PARAMETER_INTERLEAVED_BITMAP:
            result = ctx->InterleavedBitMap;
            break;
        case C2P_CONTEXT_PARAMETER_PLANAR_FORMAT:
            result = ctx->PlanarFormat;
            break;
        case C2P_CONTEXT_PARAMETER_REFERENCE:
            result = (OBJECT) ctx->Reference;
            break;
        case C2P_CONTEXT_PARAMETER_REFERENCE_WRITEBACK:
            result = ctx->ReferenceWriteback;
            break;
        case C2P_CONTEXT_PARAMETER_SCRAMBLED_OFFSETS_COUNT:
            result = 32;
            break;
        case C2P_CONTEXT_PARAMETER_SOURCE_OFFSET:
            result = ctx->SourceOffset;
            break;
        case C2P_CONTEXT_PARAMETER_TARGET_OFFSET:
            result = ctx->TargetOffset;
            break;
        case C2P_CONTEXT_PARAMETER_TYPE:
            result = ctx->ContextType;
            break;
        case C2P_CONTEXT_PARAMETER_WIDTH:
            result = ctx->Width;
            break;
    }

    return result;

}//_C2P_GetContextParameter





/*
	C2P_InitializeContext()

	Initialize a previously created context.

	result = C2P_InitializeContext(context)

		context =   Address of the context.

        result =    NULL on success or error code type ERR_CONTEXT_*
*/
ULONG _C2P_InitializeContext(__reg("a0") APTR context, __reg("a6") struct LibraryBase *library_base)
{
    ULONG result = ERR_NONE;

    do
    {
        struct c2p_Context *ctx = (struct c2p_Context *) context;

        if (ctx == NULL)
        {
            result = ERR_CONTEXT_UNALLOCATED;
            break;
        }
        if (ctx->IsInitialized)
        {
            result = ERR_CONTEXT_ALREADY_INITIALIZED;
            break;
        }

        ctx->_ChunkySize = ctx->Width * ctx->Height;
        ctx->_Chunky = NULL;
        // we need to allocate Chunky only if it's not passed by SetParameter
        if (ctx->Chunky == NULL)
        {
            // Chunky ptr could be changed via the SetParameter function
            // we need to keep track of the initial value using _Chunky
            if (!ctx->ForceScrambled)
            {
                ctx->_Chunky = _C2P_AllocMem(ctx, ctx->_ChunkySize);
                if (ctx->_Chunky == NULL)
                {
                    result = ERR_CANNOT_ALLOCATE_MEMORY;
                    break;
                }
            }
            ctx->Chunky = ctx->_Chunky;
        }

        ctx->_Scrambled = NULL;
        // we need to allocate Scrambled only if it's not passed by SetParameter
        if (ctx->Scrambled == NULL)
        {
            // Scrambled ptr could be changed via the SetParameter function
            // we need to keep track of the initial value using _Scrambled
            ctx->_Scrambled = _C2P_AllocMem(ctx, ctx->_ChunkySize);
            if (ctx->_Scrambled == NULL)
            {
                result = ERR_CANNOT_ALLOCATE_MEMORY;
                break;
            }
            ctx->Scrambled = ctx->_Scrambled;
        }

        ULONG planar_format = ctx->PlanarFormat;
        if (planar_format == C2P_CONTEXT_PLANAR_FORMAT_DEFAULT)
            planar_format = C2P_CONTEXT_PLANAR_FORMAT_8_BIT;
        ULONG depth = planar_format;

        switch (ctx->ContextType)
        {
            case C2P_CONTEXT_TYPE_BITMAP:
            case C2P_CONTEXT_TYPE_FAST_BITMAP:
            {
                ULONG byte_size = ctx->Width * ctx->Height;
                ULONG bitplane_size = byte_size / 8;
                ULONG raster_size = bitplane_size * depth;

                ULONG memory_type = MEMF_CHIP | MEMF_CLEAR;
                if (ctx->ContextType == C2P_CONTEXT_TYPE_FAST_BITMAP)
                    memory_type = MEMF_ANY | MEMF_CLEAR;

                ctx->BitMap = __C2P_CreateBitMap(ctx, ctx->Width, ctx->Height, planar_format, memory_type, library_base);
                if (ctx->BitMap == NULL)
                {
                    result = ERR_CANNOT_ALLOCATE_MEMORY;
                    break;
                }
                ctx->Raster = ctx->BitMap->Planes[0];

                break;
            }

            case C2P_CONTEXT_TYPE_CUSTOM_BITMAP:
            {
                // Note: external custom Bitmap MUST already be specified using SetContextParameter()
                if (ctx->BitMap == NULL)
                {
                    result = ERR_CONTEXT_MISSING_CUSTOM_BITMAP;
                    break;
                }
                if (ctx->BitMap->Depth != depth)
                {
                    result = ERR_CONTEXT_INCOMPATIBLE_CUSTOM_BITMAP;
                    break;
                }
                // [2023-05-13 GB] TODO: Follow constraint suspended, need more investigation
                //BOOL custom_bitmap_interleaved = (ctx->BitMap->Flags & BMF_INTERLEAVED) != 0;
                //BOOL context_interleaved = ctx->InterleavedBitMap != 0;
                //if (custom_bitmap_interleaved ^ context_interleaved)
                //{
                //    result = ERR_CONTEXT_INCOMPATIBLE_CUSTOM_BITMAP;
                //    break;
                //}
                ctx->Raster = ctx->BitMap->Planes[0];

                break;
            }

            default:
                result = ERR_UNIMPLEMENTED;
                break;
        }

        if (result != ERR_NONE)
            break;

        ctx->PlanarFormat = planar_format;

        ctx->IsInitialized = TRUE;

    } while (FALSE);

    return result;

}//_C2P_InitializeContext





/*
	C2P_SetContextIndexedParameter()

	Sets a context's parameter value.

	result = C2P_SetContextIndexedParameter(context, parameter, value, index)

		context =   Address of the context.
		parameter = Parameter name of type CONTEXT_PARAMETER_*.
        value =     Value of the parameter.
        index =     Index of value for indexed parameters (0 = first index).

        result =    NULL on success or error code type ERR_CONTEXT_*
*/
ULONG _C2P_SetContextIndexedParameter(__reg("a0") APTR context, __reg("d0") ULONG parameter, __reg("d1") ULONG value, __reg("d2") ULONG index)
{
    ULONG result = ERR_NONE;

    do
    {
        struct c2p_Context *ctx = (struct c2p_Context *) context;

        if (ctx == NULL)
        {
            result = ERR_CONTEXT_UNALLOCATED;
            break;
        }
        if (ctx->IsInitialized)
        {
            result = ERR_CONTEXT_ALREADY_INITIALIZED;
            break;
        }

        switch (parameter)
        {
            /* errors */
            case C2P_CONTEXT_PARAMETER_SCRAMBLED_OFFSET:
                result = ERR_CONTEXT_READONLY_PARAMETER;
                break;
            default:
                result = ERR_CONTEXT_UNKNOWN_PARAMETER;
                break;
        }
    } while (FALSE);

    return result;

}//_C2P_SetContextIndexedParameter





/*
	C2P_SetContextParameter()

	Sets a context's parameter value.

	result = C2P_SetContextParameter(context, parameter, value)

		context =   Address of the context.
		parameter = Parameter name of type CONTEXT_PARAMETER_*.
        value =     Value of the parameter.

        result =    NULL on success or error code type ERR_CONTEXT_*
*/
ULONG _C2P_SetContextParameter(__reg("a0") APTR context, __reg("d0") ULONG parameter, __reg("d1") ULONG value)
{
    ULONG result = ERR_NONE;

    // list of parameters allowed even if the context is already initialized
    ULONG allowed_parameters[] = {
        C2P_CONTEXT_PARAMETER_BITMAP,
        C2P_CONTEXT_PARAMETER_CHUNKY,
        C2P_CONTEXT_PARAMETER_CONVERT_COUNT,
        C2P_CONTEXT_PARAMETER_REFERENCE,
        C2P_CONTEXT_PARAMETER_REFERENCE_WRITEBACK,
        C2P_CONTEXT_PARAMETER_SOURCE_OFFSET,
        C2P_CONTEXT_PARAMETER_TARGET_OFFSET,
        0   // last element must be 0
        };

    do
    {
        struct c2p_Context *ctx = (struct c2p_Context *) context;

        if (ctx == NULL)
        {
            result = ERR_CONTEXT_UNALLOCATED;
            break;
        }

        if (ctx->IsInitialized)
        {
            BOOL parameter_allowed = FALSE;
            LONG i = 0;
            LONG p;
            while ((p = allowed_parameters[i++]) != 0)
            {
                if (p == parameter)
                {
                    parameter_allowed = TRUE;
                    break;
                }
            }
            if (!parameter_allowed)
            {
                result = ERR_CONTEXT_ALREADY_INITIALIZED;
                break;
            }
        }

        switch (parameter)
        {
            case C2P_CONTEXT_PARAMETER_BITMAP:
            {
                struct BitMap *bmp = (struct BitMap *) value;
                if (ctx->IsInitialized)
                {
                    if (ctx->ContextType == C2P_CONTEXT_TYPE_CUSTOM_BITMAP)
                    {
                        result = ERR_CONTEXT_INVALID_PARAMETER_VALUE;
                        break;
                    }
                    ULONG planar_format = ctx->PlanarFormat;
                    ULONG depth = planar_format;
                    if (bmp->Depth != depth)
                    {
                        result = ERR_CONTEXT_INCOMPATIBLE_CUSTOM_BITMAP;
                        break;
                    }
                    BOOL custom_bitmap_interleaved = (ctx->BitMap->Flags & BMF_INTERLEAVED) != 0;
                    BOOL context_interleaved = ctx->InterleavedBitMap != 0;
                    if (custom_bitmap_interleaved ^ context_interleaved)
                    {
                        result = ERR_CONTEXT_INCOMPATIBLE_CUSTOM_BITMAP;
                        break;
                    }
                }
                ctx->BitMap = bmp;
                ctx->Raster = ctx->BitMap->Planes[0];
                break;
            }
            case C2P_CONTEXT_PARAMETER_CHUNKY:
                if (ctx->ForceScrambled)
                    ctx->Scrambled = (UBYTE *) value;
                else
                    ctx->Chunky = (UBYTE *) value;
                break;
            case C2P_CONTEXT_PARAMETER_CONVERT_COUNT:
            {
                LONG val = (LONG) value;

                if (val < 0)
                    result = ERR_CONTEXT_INVALID_PARAMETER_VALUE;
                else if (val > ctx->Width * ctx->Height)
                    result = ERR_CONTEXT_INVALID_PARAMETER_VALUE;
                else if ((val & 0x1F) != 0)
                    result = ERR_CONTEXT_INVALID_PARAMETER_VALUE;
                else
                    ctx->ConvertCount = val;

                break;
            }
            case C2P_CONTEXT_PARAMETER_FORCE_SCRAMBLED:
                ctx->ForceScrambled = value;
                break;
            case C2P_CONTEXT_PARAMETER_HEIGHT:
                if (value < 1)
                    result = ERR_CONTEXT_INVALID_PARAMETER_VALUE;
                else
                    ctx->Height = value;
                break;
            case C2P_CONTEXT_PARAMETER_INTERLEAVED_BITMAP:
                if (
                    (ctx->PlanarFormat == C2P_CONTEXT_PLANAR_FORMAT_1_BIT)
                    && (value != FALSE)
                    )
                    result = ERR_CONTEXT_INVALID_PARAMETER_VALUE;
                else
                    ctx->InterleavedBitMap = value;
                break;
            case C2P_CONTEXT_PARAMETER_PLANAR_FORMAT:
                if (
                    (value != C2P_CONTEXT_PLANAR_FORMAT_1_BIT)
                    && (value != C2P_CONTEXT_PLANAR_FORMAT_2_BIT)
                    && (value != C2P_CONTEXT_PLANAR_FORMAT_3_BIT)
                    && (value != C2P_CONTEXT_PLANAR_FORMAT_4_BIT)
                    && (value != C2P_CONTEXT_PLANAR_FORMAT_5_BIT)
                    && (value != C2P_CONTEXT_PLANAR_FORMAT_6_BIT)
                    && (value != C2P_CONTEXT_PLANAR_FORMAT_7_BIT)
                    && (value != C2P_CONTEXT_PLANAR_FORMAT_8_BIT)
                    )
                {
                    result = ERR_CONTEXT_INVALID_PARAMETER_VALUE;
                }
                else
                {
                    ctx->PlanarFormat = value;

                    if (value == C2P_CONTEXT_PLANAR_FORMAT_1_BIT)
                        ctx->InterleavedBitMap = FALSE;
                }
                break;
            case C2P_CONTEXT_PARAMETER_REFERENCE:
                ctx->Reference = (UBYTE *) value;
                break;
            case C2P_CONTEXT_PARAMETER_REFERENCE_WRITEBACK:
                ctx->ReferenceWriteback = value;
                break;
            case C2P_CONTEXT_PARAMETER_SOURCE_OFFSET:
            {
                LONG val = (LONG) value;

                if (val < 0)
                    result = ERR_CONTEXT_INVALID_PARAMETER_VALUE;
                else if ((val & 0x1F) != 0)
                    result = ERR_CONTEXT_INVALID_PARAMETER_VALUE;
                else
                    ctx->SourceOffset = val;

                break;
            }
            case C2P_CONTEXT_PARAMETER_TARGET_OFFSET:
            {
                LONG val = (LONG) value;

                if (val < 0)
                    result = ERR_CONTEXT_INVALID_PARAMETER_VALUE;
                else if ((val & 0x1F) != 0)
                    result = ERR_CONTEXT_INVALID_PARAMETER_VALUE;
                else
                    ctx->TargetOffset = val;

                break;
            }
            case C2P_CONTEXT_PARAMETER_TYPE:
                if (
                    (value != C2P_CONTEXT_TYPE_BITMAP)
                    && (value != C2P_CONTEXT_TYPE_CUSTOM_BITMAP)
                    && (value != C2P_CONTEXT_TYPE_FAST_BITMAP)
                    )
                    result = ERR_CONTEXT_INVALID_PARAMETER_VALUE;
                else
                    ctx->ContextType = value;
                break;
            case C2P_CONTEXT_PARAMETER_WIDTH:
                if ((ctx->Width & 0x1F) != 0)   // width must be a multiple of 32px
                    result = ERR_CONTEXT_INVALID_PARAMETER_VALUE;
                else
                    ctx->Width = value;
                break;

            /* errors */
            case C2P_CONTEXT_PARAMETER_SCRAMBLED_OFFSETS_COUNT:
                result = ERR_CONTEXT_READONLY_PARAMETER;
                break;
            default:
                result = ERR_CONTEXT_UNKNOWN_PARAMETER;
                break;
        }
    } while (FALSE);

    return result;

}//_C2P_SetContextParameter





/*
	C2P_WritePixel()

	Write a chunky pixel.
    This function is quite slow, use it only for debugging purposes.

	result = C2P_WritePixel(context, x, y, color)

		context =   Address of the context.
		x =         Pixel's point, from 0 (left) to width-1 (right).
		y =         Pixel's point, from 0 (top) to height-1 (bottom).
        color =     Pixel's color.

        result =    NULL on success or error code.
*/
ULONG _C2P_WritePixel(__reg("a0") APTR context, __reg("d0") LONG x, __reg("d1") LONG y, __reg("d2") ULONG color)
{
    ULONG result = ERR_NONE;

    do
    {
        struct c2p_Context *ctx = (struct c2p_Context *) context;

        if (ctx == NULL)
        {
            result = ERR_CONTEXT_UNALLOCATED;
            break;
        }
        if (!ctx->IsInitialized)
        {
            result = ERR_CONTEXT_NOT_INITIALIZED;
            break;
        }

        if ((x < 0) || (x >= ctx->Width)
            || (y < 0) || (y >= ctx->Height))
            break;

        if (ctx->ForceScrambled)
        {
            LONG offset = ctx->ScrambledOffsets[x & 0x1F];
            ULONG pos = y * ctx->Width + (x + offset);
            ctx->Scrambled[pos] = color;
        }
        else
        {
            ULONG pos = y * ctx->Width + x;
            ctx->Chunky[pos] = color;
        }

    } while (FALSE);

    return result;

}//_C2P_WritePixel





/*
    PRIVATE FUNCTIONS
*/





/*
	_C2P_AllocMem()

	Allocates a memory block.
    On error, returns NULL.

	memptr = _C2P_AllocMem(context, bytesize, attributes)

        context  =   Address of the context.
        bytesize =   Number of bytes to allocate.
        attributes = Type of memory to allocate

        memptr =     Address of allocated memory block, or NULL on error.
*/
APTR __C2P_AllocMem(__reg("a0") APTR context, __reg("d0") LONG bytesize, __reg("d1") ULONG attributes)
{
	ULONG *memptr;
    struct c2p_Context *ctx = (struct c2p_Context *) context;

	memptr = (ULONG *) NULL;

	if ((bytesize > 0) && (ctx != NULL))
	{
		bytesize += 1 * sizeof(ULONG);
		memptr = (ULONG *) AllocMemory(ctx->MemoryManager, bytesize, attributes);
		if (memptr)
		{
			memptr[0] = (ULONG)ctx;
			memptr += 1;
		}
	}

	return (APTR) memptr;

}//__C2P_AllocMem





/*
	_C2P_CreateBitMap()

	Private function to create a BitMap.

	result = _C2P_CreateBitMap(context, width, height, planar_format, memory_type)

		context       = Address of the context.
		width         = Width in pixel.
		height        = Height in pixel.
		planar_format = Planar format, see C2P_CONTEXT_PLANAR_FORMAT_*.
        memory_type   = Type of memory to allocate for raster

		result =    Address of the BitMap.
*/
struct BitMap * __C2P_CreateBitMap(APTR context, ULONG width, ULONG height, ULONG planar_format, ULONG memory_type, struct LibraryBase *library_base)
{
    struct BitMap *result = NULL;

    ULONG depth = planar_format;
    if (planar_format == C2P_CONTEXT_PLANAR_FORMAT_DEFAULT)
        depth = C2P_CONTEXT_PLANAR_FORMAT_8_BIT;

    if ((depth < 1) || (depth > 8))
    {
        // only 1 to 8 bitplanes allowed
        return result;
    }

    ULONG byte_size = width * height;
    ULONG bitplane_size = byte_size / 8;
    ULONG raster_size = bitplane_size * depth;
    
    struct c2p_Context *ctx = (struct c2p_Context *) context;

    result = _C2P_AllocMem(context, sizeof(struct BitMap));
    if (result != NULL)
    {
        ULONG raster_flags = memory_type;
        APTR raster = __C2P_AllocMem(ctx, raster_size, raster_flags);
        if (raster == NULL)
        {
            _C2P_FreeMem(result);
            result = NULL;
        }
        else
        {
            if (ctx->InterleavedBitMap)
                result->Flags |= BMF_INTERLEAVED;

            if (ctx->ContextType != C2P_CONTEXT_TYPE_FAST_BITMAP)
                result->Flags |= BMF_DISPLAYABLE;

            SYS_InitBitMap(result, depth, width, height, library_base->lb_GfxBase);

            ULONG memptr = (ULONG) raster;
            for (int k = 0; k < depth; k++)
            {
                result->Planes[k] = (PLANEPTR) memptr;

                if (ctx->InterleavedBitMap)
                {
                    SHORT bytes_per_bitplane_row = width >> 3;
                    memptr += bytes_per_bitplane_row;
                    result->BytesPerRow = bytes_per_bitplane_row * depth;
                }
                else
                {
                    memptr += bitplane_size;
                }
            }
        }
    }

    return result;

}//__C2P_CreateBitMap

