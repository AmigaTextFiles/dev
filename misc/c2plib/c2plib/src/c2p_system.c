
#include <exec/execbase.h>
#include <exec/types.h>
#include <graphics/gfx.h>
#include <graphics/gfxbase.h>
#include <intuition/intuition.h>

#include <clib/exec_protos.h>
#include <clib/graphics_protos.h>
#include <clib/intuition_protos.h>

#include "../sdk/C/c2p_system.h"
#include "c2p_system_proto.h"
#include "sys_helpers_proto.h"
#include "memory_proto.h"
#include "librarybase.h"



GLOBAL struct LibraryBase *C2PBase;





/*
	C2P_AkikoDetect

	Detect the Akiko ChunkyToPlanar hardware address, if present.
	NOTE: Needs graphics.library v40+

	This is an internal system function and must be invoked in the library open function.

	result = C2P_AkikoDetect()

		result =    Hardware ChunkyToPlanar address, or NULL if Akiko is not present.

*/
APTR _C2P_AkikoDetect(struct LibraryBase *library_base)
{
	APTR result = NULL;

    UWORD gfxlib_version = library_base->lb_GfxBase->LibNode.lib_Version;
    if (gfxlib_version >= 40)
	{
        result = library_base->lb_GfxBase->HWEmul[0];  //ChunkyToPlanarPtr;
		UWORD *akiko = 0xB80002;
		UWORD cafe = akiko[0];
		BOOL akiko_detected = cafe == 0xCAFE;
		if (!akiko_detected)
			result = NULL;
	}

	return result;

}//_C2P_AkikoDetect





/*
	C2P_AllocMem_System()

	Allocates a PUBLIC memory block.
    On error, returns NULL.

	memptr = C2P_AllocMem_System(bytesize)

        bytesize =  Number of bytes to allocate.

        memptr =    Address of allocated memory block, or NULL on error.
*/
APTR _C2P_AllocMem_System(LONG bytesize, struct LibraryBase *library_base)
{
	APTR result = NULL;

	if (bytesize > 0)
	{
		result = AllocMemory(library_base->lb_MemoryManager, bytesize, MEMF_PUBLIC | MEMF_CLEAR);
	}

	return result;

}//_C2P_AllocMem_System





/*
	C2P_CpuDetect

	Detects the system CPU type.

	This is an internal system function and must be invoked in the library open function.

	result = C2P_CpuDetect()

		result =    C2P_SYSTEM_CPU_* value

*/
ULONG _C2P_CpuDetect(struct LibraryBase *library_base)
{
	UWORD attn_flags = library_base->lb_SysBase->AttnFlags;

	if (attn_flags & AFF_68080) return C2P_SYSTEM_CPU_68080;
	if (attn_flags & AFF_68060) return C2P_SYSTEM_CPU_68060;
	if (attn_flags & AFF_68040) return C2P_SYSTEM_CPU_68040;
	if (attn_flags & AFF_68030) return C2P_SYSTEM_CPU_68030;
	if (attn_flags & AFF_68020) return C2P_SYSTEM_CPU_68020;
	if (attn_flags & AFF_68010) return C2P_SYSTEM_CPU_68010;
	return C2P_SYSTEM_CPU_68000;

}//_C2P_CpuDetect





/*
	C2P_CopyMem()

	Copy a memory block.

	C2P_CopyMem(src, dest, size)

        src =   Address of source memory block.
        dest =  Address of destination memory block.
        size =  Number of bytes to copy.
*/
// see assembly file c2p_copy_mem.s





/*
	C2P_ExitLibrary()

	Deallocates all internal data structures of the library.

	This is an internal system function and must be invoked in the library close function.

	C2P_ExitLibrary(library_base)

		library_base =	ptr to library base.
*/
VOID _C2P_ExitLibrary(struct LibraryBase *library_base)
{
	if (library_base != NULL)
	{
		if (library_base->lb_Initialized && library_base->lb_MemoryManager)
		{
			DeleteMemoryManager(library_base->lb_MemoryManager);
		}

		library_base->lb_MemoryManager = NULL;
		library_base->lb_Initialized = FALSE;
	}

}//_C2P_ExitLibrary





/*
	C2P_FreeMem_System()

	Deallocates a memory block previously allocated using C2P_AllocMem_System().
    If input parameter is NULL, this function does nothing.

	C2P_FreeMem_System(memptr)

        memptr =    Address of memory block to deallocate.
                    It must be previously allocated using C2P_AllocMem_System().
*/
VOID _C2P_FreeMem_System(APTR memptr, struct LibraryBase *library_base)
{
	if (memptr)
	{
		FreeMemory(library_base->lb_MemoryManager, memptr);
	}

}//_C2P_FreeMem_System





/*
	C2P_GetSystemIndexedParameter()

	Gets a system indexed parameter value.

	result = C2P_GetSystemIndexedParameter(parameter, index)

		parameter = Parameter name of type SYSTEM_PARAMETER_*.
        index =     Index of value (0 = first index).

        result =    The parameter value, NULL if the parameter is not found.
*/
OBJECT _C2P_GetSystemIndexedParameter(__reg("d0") ULONG parameter, __reg("d1") ULONG index, __reg("a6") struct LibraryBase *library_base)
{
    LONG result = NULL;
    return result;

}//_C2P_GetSystemIndexedParameter





/*
	C2P_GetSystemParameter()

	Gets a system parameter value.

	result = C2P_GetSystemParameter(parameter)

		parameter = Parameter name of type SYSTEM_PARAMETER_*.

        result =    The parameter value, NULL if the parameter is not found.
*/
OBJECT _C2P_GetSystemParameter(__reg("d0") ULONG parameter, __reg("a6") struct LibraryBase *library_base)
{
    OBJECT result = NULL;

    switch (parameter)
    {
        case C2P_SYSTEM_PARAMETER_AKIKP_C2P_PTR:
            result = (OBJECT) library_base->lb_AkikoC2P;
            break;
        case C2P_SYSTEM_PARAMETER_AKIKO_DETECTED:
            result = library_base->lb_AkikoDetected;
            break;
        case C2P_SYSTEM_PARAMETER_CPU:
            result = library_base->lb_Cpu;
            break;
        case C2P_SYSTEM_PARAMETER_LIBREVISION:
            result = REVISION;
            break;
        case C2P_SYSTEM_PARAMETER_LIBVERSION:
            result = VERSION;
            break;
    }

    return result;

}//_C2P_GetSystemParameter





/*
	C2P_InitLibrary()

	Initialize all internal data structures of the library.
	Returns NULL on success, otherwise an error code.

	This is an internal system function and must be invoked in the library open function.

	result = C2P_InitLibrary(library_base)

		library_base =	ptr to library base.

		result =    NULL on success or error code.
*/
ULONG _C2P_InitLibrary(struct LibraryBase *library_base)
{
    ULONG result = NULL;

    do
    {
		if (library_base == NULL)
		{
			result = ERR_UNALLOCATED;
			break;
		}

        library_base->lb_Initialized = FALSE;

        library_base->lb_MemoryManager = CreateMemoryManager();
        if (!library_base->lb_MemoryManager)
        {
            result = ERR_CANNOT_ALLOCATE_MEMORY;
            break;
        }

		library_base->lb_Cpu = _C2P_CpuDetect(library_base);

		library_base->lb_AkikoC2P = _C2P_AkikoDetect(library_base);
		library_base->lb_AkikoDetected = library_base->lb_AkikoC2P != NULL;

        library_base->lb_Initialized = TRUE;

    } while (FALSE);

    return result;

}//_C2P_InitLibrary

