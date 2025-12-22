/* --------------------------------------------------------------------

       Fragit -- A simple memory thrasher/debugging tool.

  Copyright © 1989 Justin V. McCormick.  All Rights Reserved.

     Thanks to Bryce Nesbitt for bug fixes and suggestions.


Notices:

  This code may be freely used, modified, and distributed in any
form for either commercial or personal profit or non-profit, so
long as this copyright notice remains prominently attached to
the source code.

  In any case, the author makes no specific performance claims
for this code and assumes no responsibility to maintain or
support this code.  Additionally, the author bears no liability
or responsibility should the use of this code result in loss of
data or sleep.  This is your final notice - you've been warned!


Modification History:

V1.0 88-12-27 - Buggy original version released.
V1.1 89-04-01 - Fixed Exec list bug (thanks Bryce!). Never released.
V2.0 89-07-04 - Many enhancements, added gadgets, Workbench support.

-------------------------------------------------------------------- */

/* Includes */
#include <exec/types.h>
#include <exec/nodes.h>
#include <exec/lists.h>
#include <exec/memory.h>
#include <exec/ports.h>
#include <exec/io.h>
#include <exec/libraries.h>
#include <exec/interrupts.h>
#include <exec/semaphores.h>
#include <graphics/gfx.h>
#include <graphics/view.h>
#include <graphics/rastport.h>
#include <graphics/layers.h>
#include <graphics/clip.h>
#include <graphics/text.h>
#include <libraries/dos.h>
#include <devices/timer.h>
#include <devices/inputevent.h>
#include <intuition/intuition.h>
#include <intuition/intuitionbase.h>
#include <workbench/workbench.h>
#include <workbench/startup.h>

/* Special defines for Gimpel Lint */
#ifdef _lint
#define LATTICE 1
#define __stdargs
#define __regargs
#define __fARGS(a) ()
#else
#ifdef LATTICE
#define __fARGS(a) a
#endif
#endif

#include <stdio.h>
#include <ctype.h>

/* Lattice 5.02 or later specifics */
#ifdef LATTICE
#include <string.h>
#include <stdlib.h>
#include <proto/exec.h>
#include <proto/graphics.h>
#include <proto/intuition.h>
#include <proto/dos.h>
#include <proto/icon.h>
#endif

/* Manx 3.6a or later specifics */
#ifdef AZTEC_C
#include <functions.h>
#ifdef _lint
#define __ARGS(a) a
#else
#define __ARGS(a) ()
#define __fARGS(a) ()
#define __stdargs
#define __regargs
#endif
extern int strlen __ARGS((BYTE *));
extern LONG atol __ARGS((BYTE *));
extern VOID exit __ARGS((int));
extern VOID printf __ARGS((BYTE *, BYTE *, ));
extern VOID sprintf __ARGS((BYTE *, BYTE *, ));
extern struct IORequest *CreateExtIO __ARGS((struct MsgPort *, LONG));
#endif

/* From amiga.lib (or c.lib in Manx) */
extern struct Library *IconBase;
extern ULONG __stdargs RangeRand __ARGS((ULONG));

/* Local Structure Definitions */
struct FragNode			/* For dynamic list of memory blocks	*/
{
  struct MinNode fn_Node;	/* Exec node linkage			*/
  ULONG fn_Size;		/* Size of allocated block		*/
  BYTE *fn_Data;		/* Pointer to allocated block		*/
};
/* Easy access for struct size */
#define FSIZE sizeof (struct FragNode)

/* Local CODE */
LONG AddRandomFrag __ARGS((struct MinList *, LONG, LONG));
LONG CreateVBTimer __ARGS((BYTE *, struct MsgPort **, struct timerequest **));
LONG FreeRandomFrag __ARGS((struct MinList *));
struct FragNode *AllocFragNode __ARGS((LONG));
struct MinList *AllocMinList __ARGS((VOID));
VOID AbortAsyncIO __ARGS((struct MsgPort *, struct IORequest *));
VOID AllocAllMem __ARGS((struct MinList *, LONG));
VOID CleanUp __ARGS((LONG));
VOID DoFragBoolGad __ARGS((struct Gadget *));
VOID DoFragIDCMP __ARGS((VOID));
VOID DoFragStringGad __ARGS((struct Gadget *));
VOID FreeAllFragNodes __ARGS((struct MinList *));
VOID FreeFragNode __ARGS((struct FragNode *));
VOID FreeFSVBDelay __ARGS((VOID));
VOID FreeMinList __ARGS((struct MinList *));
VOID FreeVBTimer __ARGS((struct MsgPort **, struct timerequest **));
VOID InitTimer __ARGS((VOID));
VOID main __ARGS((int, BYTE **));
VOID ParseToolTypes __ARGS((BYTE *));
VOID PrintMemoryStats __ARGS((VOID));
VOID RattleDice __ARGS((VOID));
VOID SetMicroTimer __ARGS((LONG));
VOID ThrashMem __ARGS((LONG, LONG, LONG));

/* Global DATA */
struct GfxBase *GfxBase;
struct IntuitionBase *IntuitionBase;
struct MinList *FragList;
struct MsgPort *TimerPort1; 	/* Micro timer events come here		*/
struct timerequest *STimeReq;	/* Short delay timer request		*/
struct Window *FragWin;

/* Gadgets and associated baggage */
struct TextAttr Def8Text =
{
  (UBYTE *)"topaz.font",	/* Font Name   */
  8,				/* Font Height */
  FS_NORMAL,			/* Style       */
  FPF_ROMFONT			/* Preferences */
};

/* -------------------------------------------------------------------- */
#define NWWIDE 255		/* Window width */
#define NWHIGH 152		/* Window height */

#define FHDTL	8
#define FHDTT	28

#define FDLGL	32		/* Left edge of first string gadget */
#define FDLGT	(FHDTT+60)	/* Top edge of first string gadget */

#define FDLW	(9*8)		/* 9 char wide string gadgets */
#define FDLH	8		/* Height of string gadgets */
#define FDSPC	50		/* Spacing between string gadgets */

#define FHDL (FHDTL - (FDLGL + FDLW + FDSPC))
#define FHDT (FHDTT - (FDLGT + FDLH + 36))


#define FGLEFT	8
#define FGTOP	135
#define FGWIDE	51
#define FGHIGH	13

/* -------------------------------------------------------------------- */
UBYTE OldBinStr[12];		/* Shared undo space for string gadgets */

WORD BinBData[] = { 0,0, FDLW+5,0, FDLW+5,FDLH+4, 0,FDLH+4, 0,0 };
struct Border BinBorder = { -3, -3, 1, 0, JAM2, 5, BinBData, 0L };

/* -------------------------------------------------------------------- */
struct Image FGadBlk1 = { 1, 1, FGWIDE-2, FGHIGH-2, 0, 0L,  0,  1, 0L };
struct Image FGadBlk0 = { 0, 0, FGWIDE, FGHIGH, 0, 0L,  0,  3, &FGadBlk1 };

/* -------------------------------------------------------------------- */
UBYTE FPurgeStr[] = "PURGE";
struct IntuiText FPurgeTxt = { 0, 1, JAM1, 6, 3, &Def8Text, FPurgeStr, 0L };
struct Gadget FPurgeGad =
{
  0L, FGLEFT+3*(FGWIDE+10)+5, FGTOP, FGWIDE, FGHIGH, GADGHCOMP | GADGIMAGE,
  RELVERIFY, BOOLGADGET, (APTR)&FGadBlk0, 0L, &FPurgeTxt, 0L, 0L, 23, 0L
};

/* -------------------------------------------------------------------- */
UBYTE FAllocStr[] = "ALLOC";
struct IntuiText FAllocTxt = { 0, 1, JAM1, 6, 3, &Def8Text, FAllocStr, 0L };
struct Gadget FAllocGad =
{
  &FPurgeGad, FGLEFT+2*(FGWIDE+10)+5, FGTOP, FGWIDE, FGHIGH, GADGHCOMP | GADGIMAGE,
  RELVERIFY, BOOLGADGET, (APTR)&FGadBlk0, 0L, &FAllocTxt, 0L, 0L, 22, 0L
};

/* -------------------------------------------------------------------- */
UBYTE FStartStr[] = "START";
struct IntuiText FStartTxt = { 0, 1, JAM1, 6, 3, &Def8Text, FStartStr, 0L };
struct Gadget FStartGad =
{
  &FAllocGad, FGLEFT+(FGWIDE+10), FGTOP, FGWIDE, FGHIGH, GADGHCOMP | GADGIMAGE,
  RELVERIFY, BOOLGADGET, (APTR)&FGadBlk0, 0L, &FStartTxt, 0L, 0L, 21, 0L
};

/* -------------------------------------------------------------------- */
UBYTE FStopStr[] = "STOP";
struct IntuiText FStopTxt = { 0, 1, JAM1, 10, 3, &Def8Text, FStopStr, 0L };
struct Gadget FStopGad =
{
  &FStartGad, FGLEFT, FGTOP, FGWIDE, FGHIGH, GADGHCOMP | GADGIMAGE,
  RELVERIFY, BOOLGADGET, (APTR)&FGadBlk0, 0L, &FStopTxt, 0L, 0L, 20, 0L
};

/* -------------------------------------------------------------------- */
UBYTE FHeaderLbl4[] = "total";
struct IntuiText FHeaderTxt4 = { 3, 0, JAM2, FHDL+20, FHDT+50, &Def8Text, FHeaderLbl4, 0L };

UBYTE FHeaderLbl3[] = "fast";
struct IntuiText FHeaderTxt3 = { 3, 0, JAM2, FHDL+20, FHDT+40, &Def8Text, FHeaderLbl3, &FHeaderTxt4 };

UBYTE FHeaderLbl2[] = "chip";
struct IntuiText FHeaderTxt2 = { 3, 0, JAM2, FHDL+20, FHDT+30, &Def8Text, FHeaderLbl2, &FHeaderTxt3 };

UBYTE FHeaderLbl1[] = "Type  Available   Largest";
struct IntuiText FHeaderTxt1 = { 3, 0, JAM2, FHDL+20, FHDT+20, &Def8Text, FHeaderLbl1, &FHeaderTxt2 };

UBYTE FHeaderLbl0[] = "Fragments  Failures  Allocated"; 
struct IntuiText FHeaderTxt0 = { 3, 0, JAM2, FHDL, FHDT, &Def8Text, FHeaderLbl0, &FHeaderTxt1 };

/* -------------------------------------------------------------------- */
UBYTE FMaxFragLbl[]  = "Max Frag Size";
UBYTE FMaxFragStr[12];
struct StringInfo FMaxFragStrInfo =
{
  (UBYTE *)FMaxFragStr, (UBYTE *)OldBinStr, 0, 9, 0, 0, 0, 0, 0, 0, 0L, 0L, 0L
};
struct IntuiText FMaxFragTxt0 = { 3, 0, JAM2, -15, -13, &Def8Text, FMaxFragLbl, &FHeaderTxt0 };
struct Gadget FMaxFragGad =
{
  &FStopGad, FDLGL+(FDLW+FDSPC), FDLGT+(FDLH+20), FDLW, FDLH, GADGHCOMP,
  RELVERIFY | LONGINT | STRINGCENTER, STRGADGET,
  (APTR)&BinBorder, 0L, &FMaxFragTxt0, 0L, (APTR)&FMaxFragStrInfo, 13, 0L
};
/* -------------------------------------------------------------------- */
UBYTE FMinFragLbl[]  = "Min Frag Size";
UBYTE FMinFragStr[12];
struct StringInfo FMinFragStrInfo =
{
  (UBYTE *)FMinFragStr, (UBYTE *)OldBinStr, 0, 9, 0, 0, 0, 0, 0, 0, 0L, 0L, 0L
};
struct IntuiText FMinFragTxt0 = { 3, 0, JAM2, -15, -13, &Def8Text, FMinFragLbl, 0L };
struct Gadget FMinFragGad =
{
  &FMaxFragGad, FDLGL, FDLGT+(FDLH+20), FDLW, FDLH, GADGHCOMP,
  RELVERIFY | LONGINT | STRINGCENTER, STRGADGET,
  (APTR)&BinBorder, 0L, &FMinFragTxt0, 0L, (APTR)&FMinFragStrInfo, 12, 0L
};
/* -------------------------------------------------------------------- */
UBYTE FAllocSpeedLbl[]  = "Timer Speed";
UBYTE FAllocSpeedStr[12];
struct StringInfo FAllocSpeedStrInfo =
{
  (UBYTE *)FAllocSpeedStr, (UBYTE *)OldBinStr, 0, 9, 0, 0, 0, 0, 0, 0, 0L, 0L, 0L
};
struct IntuiText FAllocSpeedTxt0 = { 3, 0, JAM2, -7, -13, &Def8Text, FAllocSpeedLbl, 0L };
struct Gadget FAllocSpeedGad =
{
  &FMinFragGad, FDLGL+(FDLW+FDSPC), FDLGT, FDLW, FDLH, GADGHCOMP,
  RELVERIFY | LONGINT | STRINGCENTER, STRGADGET,
  (APTR)&BinBorder, 0L, &FAllocSpeedTxt0, 0L, (APTR)&FAllocSpeedStrInfo, 11, 0L
};
/* -------------------------------------------------------------------- */
UBYTE FMinMemLbl[]  = "Low Mem Limit";
UBYTE FMinMemStr[12];
struct StringInfo FMinMemStrInfo =
{
  (UBYTE *)FMinMemStr, (UBYTE *)OldBinStr, 0, 9, 0, 0, 0, 0, 0, 0, 0L, 0L, 0L
};
struct IntuiText FMinMemTxt0 = { 3, 0, JAM2, -15, -13, &Def8Text, FMinMemLbl, 0L };
struct Gadget FMinMemGad =
{
  &FAllocSpeedGad, FDLGL, FDLGT, FDLW, FDLH, GADGHCOMP,
  RELVERIFY | LONGINT | STRINGCENTER, STRGADGET,
  (APTR)&BinBorder, 0L, &FMinMemTxt0, 0L, (APTR)&FMinMemStrInfo, 10, 0L
};

UBYTE FragWinTitle[] = "Fragit 2.0 by JVM";
UBYTE Author[] = "Copyright \251 1989 by Justin V. McCormick 89-07-25";

struct NewWindow NewFragWin =
{
  0,11, NWWIDE,NWHIGH, 0,1, CLOSEWINDOW | VANILLAKEY | GADGETUP,
  WINDOWDRAG | WINDOWDEPTH | WINDOWCLOSE | SMART_REFRESH | NOCAREREFRESH,
  &FMinMemGad, 0, FragWinTitle, 0, 0, 0,0, 0,0, WBENCHSCREEN
};
BYTE LongFmtStr[] = "%ld";

LONG AllocCount;		/* Number of FragNodes in list		*/
LONG FailCount;			/* Number of allocs that failed 	*/
LONG FAllocSpeed;		/* Timer delay between thrashings	*/
LONG FMaxFrag;			/* Maximum fragment size		*/
LONG FMinFrag;			/* Minimum fragment size		*/
LONG FMinMem;			/* Minimum memory limit			*/
LONG FragDone;			/* Global "Done" flag			*/
LONG FragGoFlag;		/* 0=Stop,1=GO				*/
LONG TotalFragBytes;		/* Number of bytes due to fn_Data frags	*/
ULONG FragIDCMPMask;		/* Precomp FragWin UserPort bitmask	*/
ULONG FragTimerMask;		/* Precomp FragTimer UserPort bitmask	*/
ULONG FMemType;			/* Type of memory to allocate		*/

/* --------------------------------------------------------------------
 * Free memory allocated to a MinList structure, if allocated.
 * -------------------------------------------------------------------- */
VOID FreeMinList (list)
  struct MinList *list;
{
  if (list != 0)
    FreeMem ((VOID *) list, (LONG) sizeof (struct MinList));
}

/* --------------------------------------------------------------------
 * Free memory allocated to a FragNode structure, if allocated.
 * -------------------------------------------------------------------- */
VOID FreeFragNode (mnode)
  struct FragNode *mnode;
{
  if (mnode != 0)
    FreeMem ((VOID *) mnode, (LONG)mnode->fn_Size);
}

/* --------------------------------------------------------------------
 * Walk list of allocated FragNodes in a MinList and free each one,
 * then deallocate the MinList itself.
 * -------------------------------------------------------------------- */
VOID FreeAllFragNodes (list)
  struct MinList *list;
{
  struct FragNode *tnode;

  if (list != 0)
  {
    while ((tnode = (struct FragNode *) RemHead ((struct List *)list)) != 0)
    {
      FreeFragNode (tnode);
    }
  }
}

/* --------------------------------------------------------------------
 * Clean out any pending async IO in a given IORequest type struct.
 * Make sure the port signal bit is cleared.
 * --------------------------------------------------------------------	*/
VOID AbortAsyncIO (port, req)
  struct MsgPort *port;
  struct IORequest *req;
{
  if (req->io_Command != 0 && CheckIO (req) == 0)
  {
    (VOID)AbortIO (req);
    (VOID)WaitIO (req);
  }
  (VOID) SetSignal (0L, (LONG)(1L << port->mp_SigBit));
}

/* -------------------------------------------------------------------- */
VOID FreeVBTimer (pport, ptreq)
  struct MsgPort **pport;
  struct timerequest **ptreq;
{
  struct timerequest *treq;

  if (*pport != 0)
  {
    if ((treq = *ptreq) != 0)
    {
      if (treq->tr_node.io_Device != 0)
      {
        AbortAsyncIO (*pport, (struct IORequest *)treq);
        CloseDevice ((struct IORequest *)treq);
      }
      DeleteExtIO ((struct IORequest *)treq);
      *ptreq = 0;
    }
    DeletePort (*pport);
    *pport = 0;
  }
}

/* --------------------------------------------------------------------
 * Universal exit point for entire program.
 * -------------------------------------------------------------------- */
VOID CleanUp (exitcode)
  LONG exitcode;
{
  FreeVBTimer (&TimerPort1, &STimeReq);
  if (FragWin != 0)
    CloseWindow (FragWin);
  FreeAllFragNodes (FragList);
  FreeMinList (FragList);
  if (IntuitionBase != 0)
    CloseLibrary ((struct Library *)IntuitionBase);
  if (GfxBase != 0)
    CloseLibrary ((struct Library *)GfxBase);
  exit ((int)exitcode);
}

/* --------------------------------------------------------------------
 * Allocate and initialize a FragNode structure, return pointer or 0L
 * -------------------------------------------------------------------- */
struct FragNode *AllocFragNode (datasize)
  LONG datasize;
{
  struct FragNode *mnode;

  mnode = (struct FragNode *) AllocMem ((LONG)datasize, (LONG)FMemType);
  if (mnode != 0)
  {
    mnode->fn_Size = (ULONG)datasize;

#ifdef NOTREALLYNEEDED
    mnode->fn_Data = (BYTE *)((LONG)mnode + FSIZE);
#endif

  }
  return (mnode);
}

/* --------------------------------------------------------------------
 * Given pointer to MinList and a maximum fragment size, allocate a
 * FragNode with a fragment size minfrag <= size <= maxfrag and insert
 * it at the head of the FragNode list.	Return actual size of fragment.
 * -------------------------------------------------------------------- */
LONG AddRandomFrag(list, minfrag, maxfrag)
  struct MinList *list;
  LONG minfrag, maxfrag;
{
  struct FragNode *tnode;
  LONG tsize;

  if (minfrag >= maxfrag)
    tsize = minfrag;
  else
    tsize = (LONG) RangeRand ((ULONG) (maxfrag - minfrag)) + minfrag;

/* Alloc a random sized node */
  if ((tnode = AllocFragNode (tsize)) != 0)
  {
    AddHead ((struct List *)list, (struct Node *)tnode);
#ifdef DEBUGIT
    printf("Adding a %7ld byte frag SUCCEEDED\n", tsize);
#endif
    AllocCount++;
    TotalFragBytes += tsize;
    return (tsize);
  }
  else
  {
#ifdef DEBUGIT
    printf("Adding a %7ld byte frag FAILED!\n", tsize);
#endif
    FailCount++;
    return (0L);
  }
}

/* --------------------------------------------------------------------
 * Given a pointer to a MinList of FragNodes, remove one FragNode
 * at random from the list, deallocate it, and return the fragment
 * size that was deallocated.  Return NULL (0L) if the list is empty.
 * -------------------------------------------------------------------- */
LONG FreeRandomFrag (list)
  struct MinList *list;
{
  LONG i, j;
  struct FragNode *tnode;

  tnode = (struct FragNode *) list->mlh_Head;

/* Empty list? just return NULL */
  if (tnode->fn_Node.mln_Succ == 0)
    return (0L);
  else
  {
/* Generate a random number N, such that 0 <= N < AllocCount/2 */
    j = (LONG) RangeRand ((ULONG)AllocCount >> 1);

/* Walk through the MinList N elements, restarting at lh_Head if we
 * hit the end of the list before finding the Nth node.
 */
    for (i = 0; i < j; i++)
    {
      tnode = (struct FragNode *) tnode->fn_Node.mln_Succ;
      if (tnode->fn_Node.mln_Succ == 0)
        tnode = (struct FragNode *) list->mlh_Head;
    }

/* Remove this node from the list, grab it's size and deallocate */
    Remove ((struct Node *)tnode);
    i = (LONG)tnode->fn_Size;

#ifdef DEBUGIT
    printf ("Freeing %7ld byte frag ($%08lx)\n", i, tnode);
#endif

    FreeFragNode (tnode);
    AllocCount--;
    TotalFragBytes -= i;

/* Return the actual size of fragment deallocated */
    return (i);
  }
}

/* --------------------------------------------------------------------
 * Show current fragmentation and memory statistics in FragWin window
 * -------------------------------------------------------------------- */
VOID PrintMemoryStats()
{
  static BYTE fmtstr1[] = "%9ld %9ld %10ld";
  static BYTE fmtstr2[] = "%7ld   %7ld";

  BYTE tstr[80];
  LONG chipavail, chiplargest;
  LONG fastavail, fastlargest;
  LONG totalavail, abslargest;
  struct RastPort *rp;

  chipavail = (LONG)AvailMem ((LONG)MEMF_CHIP);
  chiplargest = (LONG)AvailMem ((LONG)(MEMF_CHIP|MEMF_LARGEST));
  fastavail = (LONG)AvailMem ((LONG)MEMF_FAST);
  fastlargest = (LONG)AvailMem ((LONG)(MEMF_FAST|MEMF_LARGEST));

  totalavail = chipavail + fastavail;
  if (chiplargest > fastlargest)
    abslargest = chiplargest;
  else
    abslargest = fastlargest;
  
  sprintf (tstr, fmtstr1, AllocCount, FailCount, TotalFragBytes);
  rp = FragWin->RPort;

  SetAPen (rp, 1L);
  Move (rp, (LONG)FHDTL, (LONG)FHDTT);
  Text (rp, tstr, (LONG) strlen (tstr));

  sprintf (tstr, fmtstr2, chipavail, chiplargest);
  Move (rp, (LONG)(FHDTL+84), (LONG)(FHDTT+20));
  Text (rp, tstr, (LONG) strlen (tstr));

  sprintf (tstr, fmtstr2, fastavail, fastlargest);
  Move (rp, (LONG)(FHDTL+84), (LONG)(FHDTT+30));
  Text (rp, tstr, (LONG) strlen (tstr));

  sprintf (tstr, fmtstr2, totalavail, abslargest);
  Move (rp, (LONG)(FHDTL+84), (LONG)(FHDTT+40));
  Text (rp, tstr, (LONG) strlen (tstr));
}


/* --------------------------------------------------------------------
 * Allocate all memory down to MinMem threshold.
 */
VOID AllocAllMem (list, limit)
  struct MinList *list;
  LONG limit;
{
  struct FragNode *tnode;
  LONG csize, tsize;

/* While available memory is greater than Min threshold...*/
  while ((csize = AvailMem((LONG)FMemType)) > limit)
  {

/* What is the largest block available for allocation? */
    tsize = AvailMem ((LONG)(MEMF_LARGEST | FMemType));

/* If the largest block is larger than min frag size, allocate less. */
    if (tsize > FMaxFrag)
      tsize = FMaxFrag;

/* If allocating a new min frag would put us below min level, allocate
 * only what we need.
 */
    if ((csize - tsize) < limit)
      tsize = csize - limit;

/* Allocate the new node, if there is sufficient memory */
    if (tsize >= 0 && (tnode = AllocFragNode (tsize)) != 0)
    {
      AddHead ((struct List *)list, (struct Node *)tnode);
  
#ifdef DEBUGIT
      printf("Adding a %7ld byte frag SUCCEEDED\n", tsize);
#endif
      AllocCount++;

/* Add to allocation totals, account for struct size! */
      TotalFragBytes += tsize;
      if ((AllocCount % 100) == 0)
        PrintMemoryStats ();

/* See if there is a message at the window...might want to abort */
      if (FragWin->UserPort->mp_MsgList.lh_Head->ln_Succ != 0)
        return;
    }
    else
    {
#ifdef DEBUGIT
      printf("Adding a %7ld byte frag FAILED!\n", tsize);
#endif
      FailCount++;
      return;		/* Shouldn't Fail since we asked for a known size */
    }
  }
}

/* --------------------------------------------------------------------
 * Play with random sized memory chunks, where:
 *   minfrag <= random size <= maxfrag
 * -------------------------------------------------------------------- */
VOID ThrashMem(minmem, minfrag, maxfrag)
  LONG minmem, minfrag, maxfrag;
{
  LONG tmem, lfrag;

/* If available ram is greater than "minmem", attempt to allocate a random
 * sized fragment and add it to the MinList.  Otherwise, free an entry
 * picked at random from the linked-list of FragNodes.
 */
  tmem = AvailMem ((LONG)FMemType);
  lfrag = AvailMem ((LONG)(MEMF_LARGEST | FMemType));

  if (tmem < minmem || lfrag < minfrag)
  {
    (VOID) FreeRandomFrag (FragList);
  }
  else
  {
    if (maxfrag > lfrag)
      maxfrag = lfrag;
    (VOID) AddRandomFrag (FragList, minfrag, maxfrag);
  }
}

/* --------------------------------------------------------------------
 * Given a pointer to a Boolean gadget, determine which function to perform.
 * -------------------------------------------------------------------- */
VOID DoFragBoolGad (tgad)
  struct Gadget *tgad;
{
  switch (tgad->GadgetID)
  {
    case 20:	/* STOP */
      FragGoFlag = 0;
      break;
    case 21:	/* START */
      FragGoFlag = 1;
      break;
    case 22:	/* ALLOC */
      AllocAllMem (FragList, FMinMem);
      PrintMemoryStats ();
      break;
    case 23:	/* PURGE */
      FreeAllFragNodes (FragList);
      AllocCount = FailCount = TotalFragBytes = 0;
      PrintMemoryStats ();
      break;
  }
}

/* --------------------------------------------------------------------
 * Given a pointer to a string gadget, determine which number to update.
 * Bound check new number appropriately.
 * -------------------------------------------------------------------- */
VOID DoFragStringGad (tgad)
  struct Gadget *tgad;
{
  LONG temp;
  LONG *dest;
  LONG nmin, nmax;

  temp = ((struct StringInfo *)tgad->SpecialInfo)->LongInt;
  nmin = 0;
  nmax = 0x00ffffffL;
  switch (tgad->GadgetID)
  {
    case 10:	/* FMinMemGad */
      dest = &FMinMem;
      break;
    case 11:	/* FAllocSpeedGad */
      dest = &FAllocSpeed;
      nmin = 1;
      break;
    case 12:	/* FMinFragGad */
      dest = &FMinFrag;
      nmin = FSIZE;
      nmax = FMaxFrag;
      break;
    case 13:	/* FMaxFragGad */
      dest = &FMaxFrag;
      nmin = FMinFrag;
      break;
  }

  if (temp < nmin)
    temp = nmin;
  else if (temp > nmax)
    temp = nmax;
  sprintf (((struct StringInfo *)tgad->SpecialInfo)->Buffer, LongFmtStr, temp);
  RefreshGList (tgad, FragWin, 0L, 1L);
  *dest = temp;

/* If user changed the Speed, abort old timer request and queue new one */
  if (tgad->GadgetID == 11)
  {
    AbortAsyncIO (TimerPort1, (struct IORequest *)STimeReq);
    SetMicroTimer (FAllocSpeed);
  }
}

/* --------------------------------------------------------------------
 * Function to process FragWin IDCMP messages received.  If we receive
 * a VANILLAKEY == ESCAPE or CLOSEWINDOW event, set the global FragDone flag.
 * -------------------------------------------------------------------- */
VOID DoFragIDCMP ()
{
  struct Gadget *tgadget;
  struct IntuiMessage *imsg;
  ULONG class;
  ULONG code;

  while ((imsg = (struct IntuiMessage *) GetMsg (FragWin->UserPort)) != 0)
  {
    class = imsg->Class;
    code = imsg->Code;
    tgadget = (struct Gadget *)imsg->IAddress;
    ReplyMsg ((struct Message *)imsg);

    switch (class)
    {
      case GADGETUP:
       ((VOID (*) __fARGS((struct Gadget *)))tgadget->UserData)(tgadget);
        break;
      case VANILLAKEY:
        switch (code)
        {
          case 'a':	/* 'a' for Alloc */
            DoFragBoolGad (&FAllocGad);
            break;
          case 'p':	/* 'p' for Purge */
            DoFragBoolGad (&FPurgeGad);
            break;
          case 's':	/* 's' - Start/Stop */
          case ' ':	/* SPACE */
            FragGoFlag ^= 1;
            break;
          case 0x1b:	/* ESC - quit */
            FragDone = 1;
            break;
#ifdef DEBUGIT
          default:
	    printf ("Unknown VANILLAKEY char: $%02ld\n", (LONG)code);
	    break;
#endif
          
        }
        break;
      case CLOSEWINDOW:
        FragDone = 1;
        break;
    }
  }
}

/* -------------------------------------------------------------------- */
LONG CreateVBTimer (name, pport, ptreq)
  BYTE *name;
  struct MsgPort **pport;
  struct timerequest **ptreq;
{
  if ((*pport = CreatePort (name, 0L)) != 0)
  {
    if ((*ptreq = (struct timerequest *) CreateExtIO (*pport, (LONG)sizeof(struct timerequest))) != 0)
    {
      if (OpenDevice (TIMERNAME, (LONG)UNIT_VBLANK, (struct IORequest *)*ptreq, 0L) == 0)
      {
        return (1L);
      }
    }
  }
  return (0L);
}

/* --------------------------------------------------------------------
 * Queue a timer request for delay microseconds
 * -------------------------------------------------------------------- */
VOID SetMicroTimer (delay)
  LONG delay;
{
  STimeReq->tr_node.io_Command = TR_ADDREQUEST;
  STimeReq->tr_time.tv_secs = delay / 1000000L;
  STimeReq->tr_time.tv_micro = delay % 1000000L;
  SendIO ((struct IORequest *)STimeReq);
}

/* --------------------------------------------------------------------
 * Initialize timer devices
 * --------------------------------------------------------------------	*/
VOID InitTimer ()
{
  if (CreateVBTimer (0L, &TimerPort1, &STimeReq) == 0)
    CleanUp (140L);

/* Set wakeup signal mask for the timer ports */
  FragTimerMask = 1L << TimerPort1->mp_SigBit;

/* Queue up first timer request */
  SetMicroTimer (100L);
}

/* --------------------------------------------------------------------
 * Attempt to make RangeRand() a little less predictable between runs.
 * -------------------------------------------------------------------- */
VOID RattleDice ()
{
  LONG i, j;
  struct DateStamp stime;
  ULONG seedval;

  DateStamp ((LONG *)&stime);
  seedval = stime.ds_Tick;
  j = (LONG)(RangeRand (seedval + 0xaa) & 0xffL);
  for (i = 0; i < j; i++)
    (VOID) RangeRand (seedval);
}

/* --------------------------------------------------------------------
 * Allocate and initialize a MinList structure, return pointer to same.
 * -------------------------------------------------------------------- */
struct MinList *AllocMinList ()
{
  struct MinList *mlist;

  mlist = (struct MinList *) AllocMem ((LONG)sizeof(struct MinList), (LONG)FMemType);
  if (mlist != 0)
    NewList ((struct List *) mlist);
  return (mlist);
}

/* --------------------------------------------------------------------
 * Given pointer to a filename, parse the Tool Type array of its,
 * associated icon, if any, and set Fragit parameters
 * accordingly.
 * -------------------------------------------------------------------- */
VOID ParseToolTypes(wbmsg)
  BYTE *wbmsg;
{
  BYTE *cp;
  struct DiskObject *dop;

  if ((IconBase = OpenLibrary ("icon.library", 33L)) == 0L)
    CleanUp(122L);

  if ((dop = GetDiskObject(wbmsg)) != 0)
  {

    if ((cp = FindToolType(dop->do_ToolTypes, "MINMEM")) != 0)
    {
      FMinMem = atol (cp);
      if (FMinMem < 0)
        FMinMem = 0;
    }

    if ((cp = FindToolType(dop->do_ToolTypes, "MINFRAG")) != 0)
    {
      FMinFrag = atol (cp);
      if (FMinFrag < FSIZE)
        FMinFrag = FSIZE;
    }

    if ((cp = FindToolType(dop->do_ToolTypes, "MAXFRAG")) != 0)
    {
      FMaxFrag = atol (cp);
      if (FMaxFrag < FMinFrag)
        FMaxFrag = FMinFrag;
    }

    if ((cp = FindToolType(dop->do_ToolTypes, "SPEED")) != 0)
      FAllocSpeed = atol (cp);

    if (FindToolType(dop->do_ToolTypes, "CHIP") != 0)
      FMemType = MEMF_CHIP;

    if (FindToolType(dop->do_ToolTypes, "FAST") != 0)
      FMemType = MEMF_FAST;

    if ((cp = FindToolType(dop->do_ToolTypes, "MEMTYPE")) != 0)
      FMemType = atol (cp);

/* Free the DiskObject pointer */
    FreeDiskObject(dop);
  }
  CloseLibrary (IconBase);
  IconBase = 0;
}

/* --------------------------------------------------------------------
 * Fragit program main entry point.
 * -------------------------------------------------------------------- */
VOID main(argc, argv)
  int argc;
  BYTE **argv;
{
  struct WBStartup *wbm;
  ULONG signals;

/* Open libraries */
  if ( (GfxBase = (struct GfxBase *)OpenLibrary ("graphics.library", 0L)) == 0)
    CleanUp (120L);
  if ( (IntuitionBase = (struct IntuitionBase *)OpenLibrary ("intuition.library", 0L)) == 0)
    CleanUp (121L);

/* Allocate and initialize MinList of FragNode fragments */
  if ((FragList = AllocMinList ()) == 0)
    CleanUp (103L);

/* Set defaults */
  FMinMem = 100000L;		/* Minimum memory limit = 100K */
  FMinFrag = FSIZE;		/* Minimum fragment size = node size */
  FMaxFrag = 50000L;		/* Maximum fragment size = 50K */
  FAllocSpeed = 50000L;		/* 0.05 secs between allocs */
  FMemType = 0L;		/* Any Memory */

  if (argc == 0) /* It's from Workbench, see if there are tooltypes */
  {
    wbm = (struct WBStartup *)argv;
    ParseToolTypes (wbm->sm_ArgList->wa_Name);
  }
  else		 /* It's from CLI, see if the ICON is around for INFO anyhow */
  {
    ParseToolTypes (argv[0]);
  }

#ifdef DEBUGIT
  printf ("MinMemLevel: %ld MinFragSize: %ld MaxFragSize: %ld\n", FMinMem, FMinFrag, FMaxFrag);
  Delay (50L);
#endif

/* Init RangeRand() seed */
  RattleDice ();

/* Initialize timer device */
  InitTimer ();

/* Initialize string gadget texts */
  sprintf (FMinMemStr, LongFmtStr, FMinMem);
  sprintf (FAllocSpeedStr, LongFmtStr, FAllocSpeed);
  sprintf (FMinFragStr, LongFmtStr, FMinFrag);
  sprintf (FMaxFragStr, LongFmtStr, FMaxFrag);

/* Initialize gadget UserData fields to point to their handler functions */
  FMinMemGad.UserData = (APTR)DoFragStringGad;
  FAllocSpeedGad.UserData = (APTR)DoFragStringGad;
  FMinFragGad.UserData = (APTR)DoFragStringGad;
  FMaxFragGad.UserData = (APTR)DoFragStringGad;

  FStopGad.UserData = (APTR)DoFragBoolGad;
  FStartGad.UserData = (APTR)DoFragBoolGad;
  FAllocGad.UserData = (APTR)DoFragBoolGad;
  FPurgeGad.UserData = (APTR)DoFragBoolGad;

/* Open control window */
  if ((FragWin = OpenWindow (&NewFragWin)) == 0)
    CleanUp (130L);
  FragIDCMPMask = 1L << FragWin->UserPort->mp_SigBit;

/* Handle IDCMP events till done... */
  while (FragDone == 0)
  {
    signals = Wait ((LONG)(FragIDCMPMask | FragTimerMask));

    if ((signals & FragTimerMask) != 0)
    {
      if (GetMsg (TimerPort1) != 0)
      {
        SetMicroTimer (FAllocSpeed);
        if (FragGoFlag != 0)
          ThrashMem (FMinMem, FMinFrag, FMaxFrag);
        PrintMemoryStats ();
      }
    }
    if ((signals & FragIDCMPMask) != 0)
      DoFragIDCMP ();
  }

/* All done, free everything */
  CleanUp (0L);
}
