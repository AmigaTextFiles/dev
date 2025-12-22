#ifndef  CLIB_PCHGLIB_PROTOS_H
#define  CLIB_PCHGLIB_PROTOS_H
/*
**	$Filename: clib/pchglib_protos.h $
**	$Release: 0.6 $
**
*/
#ifndef  EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef  PCHG_H
#include <iff/pchg.h>
#endif

/* If you're using SAS/C 5.0, you can directly access PCHG_FastDecomp. Otherwise,
you have to use PCHG_CFastDecomp. */

#ifdef LATTICE_50
VOID __asm PCHG_FastDecomp(register __a0 APTR Source, register __a1 APTR Dest, register __a2 WORD *TreeCode, register __d0 ULONG OriginalSize);
#endif

VOID PCHG_CFastDecomp(APTR Source, APTR Dest, WORD *TreeCode, ULONG OriginalSize);
UBYTE *PCHG_CompHuffmann(APTR Source, ULONG SourceSize, ULONG *DataSize, ULONG *TreeSize);
VOID PCHG_SetUserCopList(WORD Offset, UWORD Length, struct ViewPort *ViewPort, struct PCHGHeader *PCHG, APTR LineMask, APTR LineData);
LONG PCHG_ParsePCHG(struct PCHGHeader *PCHG, struct ViewPort *ViewPort);
struct PCHGHeader *PCHG_SHAM2PCHG(UWORD *SHAMChunk, ULONG SHAMSize, WORD Increment);

#endif
