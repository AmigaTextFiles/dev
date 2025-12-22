#include <exec/types.h>
#include <proto/exec.h>
#include <exec/memory.h>
#include <iff/pchg.h>
#include <clib/pchglib_protos.h>

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

struct CompVars {
	ULONG Freq[256];
	struct TreeNode Nodes[511], *N[256];
	UWORD TreeCode[511];
};

VOID __asm PCHG_BuildFreqTable(register __a0 APTR Source, register __d0 ULONG Length, register __a1 ULONG *FreqTable);


/* This function takes a tree represented with TreeNode structures,
and sets the Code and CodeLength fields of its internal nodes. If
the CodeLength fields are previously filled with the frequency
of the associated character, the total length in bits of the
compressed data will be returned. Note that if the CodeLength is
greater than 32, Code is useless. */


ULONG PCHG_SetUpTree(struct TreeNode *Tree, ULONG Depth, ULONG Bits) {
	if (Tree->IsExternal) {
		Tree->n.Ext.Code = Bits;
		Bits = Tree->n.Ext.CodeLength*Depth;
		Tree->n.Ext.CodeLength = Depth;
		return(Bits);
	}
	return(PCHG_SetUpTree(Tree->n.Int.Left, Depth+1, Bits<<1)+PCHG_SetUpTree(Tree->n.Int.Right, Depth+1, Bits<<1 | 1));
}

/* This function converts a tree represented via TreeNodes in
a tree code ready for writing it in a PCHG compressed chunk. The
real length in bytes of the tree is returned */

LONG PCHG_BuildTreeCode(struct TreeNode *Tree, WORD *TreeCode) {
	register LONG t;

	if (Tree->IsExternal) {
		*TreeCode = (unsigned char)Tree->IsExternal | 0x100;
		return(1);
	}
	t = PCHG_BuildTreeCode(Tree->n.Int.Left, TreeCode-1);
	if (Tree->n.Int.Right->IsExternal) {
		*TreeCode = (unsigned char)Tree->n.Int.Right->IsExternal;
		return(t+1);
	}
	*TreeCode = (-t-1)*2;
	return(t+1+PCHG_BuildTreeCode(Tree->n.Int.Right, TreeCode-t-1));
}

/* The compression routine. Given the tree in linked form, source
and destination it performs the compression. */

ULONG PCHG_Compress(UBYTE *Source, ULONG *Dest, struct TreeNode *ExtNodes, ULONG SourceLen) {

	register LONG i;
	LONG j;
	register LONG codelen, freebits = 32;
	register UBYTE c;
	register ULONG CurLongword = 0;
	ULONG *StartDest = Dest;
	struct TreeNode *Tree;

	for(i=0; i<SourceLen; i++) {
		if ((codelen = ExtNodes[c = *(Source++)].n.Ext.CodeLength)<33) {
			if (codelen>freebits) {
				if (!freebits) {
					*(Dest++) = CurLongword;
					CurLongword = ExtNodes[c].n.Ext.Code<<(freebits = 32-codelen);
				}
				else {
					*(Dest++) = CurLongword | ExtNodes[c].n.Ext.Code>>(codelen-freebits);
					CurLongword = ExtNodes[c].n.Ext.Code<<(freebits += 32-codelen);
				}
			}
			else {
				CurLongword |= ExtNodes[c].n.Ext.Code<<(freebits-=codelen);
			}
		}
		else {
			Tree = &ExtNodes[c];
			*Dest = CurLongword;
			freebits = 32-freebits;
			for(j=codelen-1; j>=0; j--) {
				Dest[(freebits+j)/32] |= Tree->IsRight << (31-((freebits+j)%32));
				Tree = Tree->Parent;
			}
			Dest += (freebits+codelen)/32;
			CurLongword = *Dest;
			freebits = 32-((freebits+codelen)%32);
		}
	}
	if (freebits != 32) *(Dest++) = CurLongword;
	return((ULONG)(Dest-StartDest)*4);
}

/****** pchg.lib/PCHG_CompHuffmann ******************************************

   NAME
       PCHG_CompHuffmann -- Compress a memory block with static Huffmann

   SYNOPSIS
       compData = CompHuffmann(Source, SourceSize, DataSize, TreeSize);

       UBYTE *PCHG_CompHuffmann(APTR, ULONG, ULONG *, ULONG *);

   FUNCTION
       Compress a block of memory into the typical PCHG compression
       format: static Huffmann encoding. A pointer to the compressed data
       (tree+code) is returned. After use, the block of
       *DataSize+*TreeSize length pointed by compData has to be
       FreeMem()ed. The longword pointed by TreeSize will be set to the
       number of bytes used by the tree coding, the one pointed by DataSize
       to the number of bytes of Huffmann code (rounded to longword bounds).

   INPUTS
       Source        - A pointer to the start of the data to be compressed.
       SourceSize    - Size in bytes of the data to be compressed
       DataSize      - A pointer to a longword that will receive the length
                       in bytes of the data part of the compressed chunk.
       TreeSize      - A pointer to a longword that will receive the length
                       in bytes of the tree part of the compressed chunk.

   RESULT
       compData      - A pointer to the compressed data (tree+data,
                       *DataSize+*TreeSize bytes) or NULL if a
                       memory allocation failed. You have to free
                       this memory after you use it with a
                       FreeMem(compData, *TreeSize+*DataSize).

   EXAMPLE

   NOTES

   BUGS

   SEE ALSO
       PCHG_FastDecomp(), PCHG_CFastDecomp()

*****************************************************************************
*
*/

UBYTE *PCHG_CompHuffmann(APTR Source, ULONG SourceSize, ULONG *DataSize, ULONG *TreeSize) {

	register LONG i,j;
	register UBYTE *p;
	register struct CompVars *cv;
	struct TreeNode *Tree;
	ULONG LastMin0, LastMin1, LastMinVal0, LastMinVal1;

	if (!(cv = AllocMem(sizeof(struct CompVars), MEMF_PUBLIC | MEMF_CLEAR))) return(NULL);

	PCHG_BuildFreqTable(Source, SourceSize, cv->Freq);

	for(i=0; i<256; i++) {
		cv->Nodes[i].n.Ext.CodeLength = cv->Freq[i];
		cv->Nodes[i].IsExternal = i | (1<<15);
		cv->N[i] = &cv->Nodes[i];
	}

	for(i=1; i<256; i++) {

		LastMinVal0 = LastMinVal1 = 0xFFFFFFFFU;

		for(j=i-1; j<256; j++)
			if (cv->Freq[j]<LastMinVal0) {
				LastMinVal0 = cv->Freq[j];
				LastMin0 = j;
			}
		cv->Freq[LastMin0] = cv->Freq[i-1];
		cv->Freq[i-1] = LastMinVal0;
		Tree = cv->N[i-1];
		cv->N[i-1] = cv->N[LastMin0];
		cv->N[LastMin0] = Tree;

		for(j=i; j<256; j++)
			if (cv->Freq[j]<LastMinVal1) {
				LastMinVal1 = cv->Freq[j];
				LastMin1 = j;
			}
		cv->Freq[LastMin1] = LastMinVal0+LastMinVal1;
		cv->Nodes[255+i].n.Int.Left = cv->N[i-1];
		cv->Nodes[255+i].n.Int.Right = cv->N[LastMin1];
		cv->N[i-1]->Parent = cv->N[LastMin1]->Parent = &cv->Nodes[255+i];
		cv->N[LastMin1]->IsRight = 1;
		cv->N[LastMin1] = &cv->Nodes[255+i];
	}

	*DataSize = ((PCHG_SetUpTree(&cv->Nodes[510], 0, 0)+31)/32)*4;
	*TreeSize = 2*PCHG_BuildTreeCode(&cv->Nodes[510], &cv->TreeCode[510]);

	if (p = AllocMem(*DataSize+*TreeSize, MEMF_PUBLIC | MEMF_CLEAR)) {
		CopyMem(&cv->TreeCode[510]-(*TreeSize/2-1), p, *TreeSize);
		PCHG_Compress(Source, (void  *)(p+*TreeSize), cv->Nodes, SourceSize);
	}
	FreeMem(cv, sizeof(struct CompVars));
	return(p);
}
