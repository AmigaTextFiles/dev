#include <exec/types.h>
#include <iff/pchg.h>
#include <clib/pchglib_protos.h>

/****** pchg.lib/--background-- ******************************************

   The purpose of this library is to give programmers an easy way to
   implement PCHG display technology in their programs. The library
   allows to read and write easily PCHG chunks by providing
   compression/decompression routines and CopperList building
   functions.

   When reading PCHG chunks, you have three function you can use:
   PCHG_ParsePCHG() will automagically parse the chunk (possibly using
   decompression) and build the Copperlist for your ViewPort. If you're
   using the ViewPort of an Intuition Screen, when you will call
   CloseScreen() the Copperlist will be automatically deallocated.

   Otherwise, you can use PCHG_SetUserCopList(), which gives you a finer
   control (for instance, you can build a Copperlist with an offset).
   However, the chunk parsing is left to you, apart from the
   decompression, which is handled by PCHG_FastDecomp(). This routine
   is called with register parameter passing, so if you're not using
   SAS C or Assembly, you'd better call PCHG_CFastDecomp(), which has
   standard parameter passing.

   When writing a PCHG chunk, the function PCHG_CompHuffmann() will
   pack with static Huffmann encoding your LINEDATA (i.e., the line mask
   followed by a SmallLineChanges or BigLineChanges array, as from
   the PCHG specification).

   Finally, the function PCHG_SHAM2PCHG() will build a fake PCHG chunk from
   a SHAM chunk, making easy for people to partially support the old
   "standard".

   There are two versions of this library: pchg.lib has stack parameter
   passing, while pchgr.lib was compiled with the SAS/C -rr (registerized
   parameter passing) option.

   The prototypes for pchg.lib can be found in clib/pchglib_protos.h, while
   the general PCHG include file is iff/pchg.h.

   This library was written by Sebastiano Vigna, and it's placed in
   the public domain.

*************************************************************************/


#if INCLUDE_VERSION<36
FAILURE!! Amiga includes version<36
#endif

/* The following structures are used by pchg.lib, and shouldn't be used by
any other program. */

struct TreeInternalNode {
	struct TreeNode *Left;
	struct TreeNode *Right;
};

struct TreeExternalNode {
	ULONG CodeLength;
	ULONG Code;
};

struct TreeNode {
	struct TreeNode *Parent;
	UWORD IsExternal;
	UWORD IsRight;
	union {
		struct TreeInternalNode Int;
		struct TreeExternalNode Ext;
	} n;
};

/* This routine is here for historical interest. Is a C version of
PCHG_FastDecomp(). */

VOID PCHG_Decompress(ULONG *Source, UBYTE *Dest, WORD *Tree, ULONG OriginalSize) {
	ULONG i = 0, bits = 0;
	ULONG CurLongword;
	SHORT *p = Tree;

	while(i<OriginalSize) {
		if (!bits) {
			CurLongword = *(Source++);
			bits = 32;
		}
		if (CurLongword & 0x80000000) {
			if (*p>=0) {
				*(Dest++) = (unsigned char)*p;
				i++;
				p = Tree;
			}
			else p+=(*p/2);
		}
		else {
			p--;
			if (*p>0 && (*p & 0x100)) {
				*(Dest++) = (unsigned char)*p;
				i++;
				p = Tree;
			}
		}
		CurLongword <<= 1;
		bits--;
	}
}


