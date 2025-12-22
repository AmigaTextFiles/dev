@DATABASE "gg:doc/NDK/Guide/Include/graphics/copper.h"
@MASTER   "gg:os-include/graphics/copper.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:13:51
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "graphics/copper.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"graphics/copper.h" LINK File}


@{b}Structures@{ub}

@{"copinit" LINK "gg:doc/NDK/Guide/Include/graphics/copper.h/File" 100}  @{"CopIns" LINK "gg:doc/NDK/Guide/Include/graphics/copper.h/File" 24}  @{"CopList" LINK "gg:doc/NDK/Guide/Include/graphics/copper.h/File" 62}  @{"cprlist" LINK "gg:doc/NDK/Guide/Include/graphics/copper.h/File" 55}  @{"UCopList" LINK "gg:doc/NDK/Guide/Include/graphics/copper.h/File" 89}


@{b}#defines@{ub}

@{"COPPER_MOVE" LINK "gg:doc/NDK/Guide/Include/graphics/copper.h/File" 17}  @{"COPPER_WAIT" LINK "gg:doc/NDK/Guide/Include/graphics/copper.h/File" 18}  @{"CPR_NT_LOF" LINK "gg:doc/NDK/Guide/Include/graphics/copper.h/File" 20}  @{"CPR_NT_SHT" LINK "gg:doc/NDK/Guide/Include/graphics/copper.h/File" 21}  @{"CPR_NT_SYS" LINK "gg:doc/NDK/Guide/Include/graphics/copper.h/File" 22}
@{"CPRNXTBUF" LINK "gg:doc/NDK/Guide/Include/graphics/copper.h/File" 19}    @{"DESTADDR" LINK "gg:doc/NDK/Guide/Include/graphics/copper.h/File" 49}     @{"DESTDATA" LINK "gg:doc/NDK/Guide/Include/graphics/copper.h/File" 51}    @{"EXACT_LINE" LINK "gg:doc/NDK/Guide/Include/graphics/copper.h/File" 85}  @{"HALF_LINE" LINK "gg:doc/NDK/Guide/Include/graphics/copper.h/File" 86}
@{"HWAITPOS" LINK "gg:doc/NDK/Guide/Include/graphics/copper.h/File" 50}     @{"NXTLIST" LINK "gg:doc/NDK/Guide/Include/graphics/copper.h/File" 47}      @{"VWAITPOS" LINK "gg:doc/NDK/Guide/Include/graphics/copper.h/File" 48}    

@ENDNODE
@NODE File "graphics/copper.h"
#ifndef GRAPHICS_COPPER_H
#define GRAPHICS_COPPER_H
/*
**      $VER: copper.h 39.10 (31.5.1993)
**      Includes Release 45.1
**
**      graphics copper list intstruction definitions
**
**      (C) Copyright 1985-2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif

#define COPPER_MOVE 0       /* pseude opcode for move #XXXX,dir */
#define COPPER_WAIT 1       /* pseudo opcode for wait y,x */
#define CPRNXTBUF   2       /* continue processing with next buffer */
#define CPR_NT_LOF  0x8000  /* copper instruction only for short frames */
#define CPR_NT_SHT  0x4000  /* copper instruction only for long frames */
#define CPR_NT_SYS  0x2000  /* copper user instruction only */

struct CopIns
{
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}   OpCode; /* 0 = move, 1 = wait */
    union
            @{"struct CopList" LINK File 62} *nxtlist;
            struct
                        union
                                @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54} VWaitPos;        /* vertical beam wait */
                                @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54} DestAddr;        /* destination address of copper move */
                        } u1;
                        union
                                @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54} HWaitPos;        /* horizontal beam wait position */
                                @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54} DestData;        /* destination immediate data to send */
                        } u2;
                } u4;
    } u3;
};

/* shorthand for above */
#define NXTLIST     u3.nxtlist
#define VWAITPOS    u3.u4.u1.VWaitPos
#define DESTADDR    u3.u4.u1.DestAddr
#define HWAITPOS    u3.u4.u2.HWaitPos
#define DESTDATA    u3.u4.u2.DestData


/* structure of cprlist that points to list that hardware actually executes */
struct cprlist
{
    struct cprlist *Next;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   *start;         /* start of copper list */
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}   MaxCount;       /* number of long instructions */
};

struct CopList
{
    struct  CopList *Next;  /* next block for this copper list */
    struct  CopList *_CopList;  /* system use */
    @{"struct  ViewPort" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 47} *_ViewPort;    /* system use */
    @{"struct  CopIns" LINK File 24} *CopIns; /* start of this block */
    @{"struct  CopIns" LINK File 24} *CopPtr; /* intermediate ptr */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   *CopLStart;     /* mrgcop fills this in for Long Frame*/
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   *CopSStart;     /* mrgcop fills this in for Short Frame*/
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}   Count;          /* intermediate counter */
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}   MaxCount;       /* max # of copins for this block */
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}   DyOffset;       /* offset this copper list vertical waits */
#ifdef V1_3
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   *Cop2Start;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   *Cop3Start;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   *Cop4Start;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   *Cop5Start;
#endif
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}  SLRepeat;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}  Flags;
};

/* These CopList->Flags are private */
#define EXACT_LINE 1
#define HALF_LINE 2


struct UCopList
{
    struct UCopList *Next;
    @{"struct CopList" LINK File 62}  *FirstCopList; /* head node of this copper list */
    @{"struct CopList" LINK File 62}  *CopList;      /* node in use */
};

/* Private graphics data structure. This structure has changed in the past,
 * and will continue to change in the future. Do Not Touch!
 */

struct copinit
{
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} vsync_hblank[2];
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} diagstrt[12];      /* copper list for first bitplane */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} fm0[2];
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} diwstart[10];
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} bplcon2[2];
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} sprfix[2*8];
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} sprstrtup[(2*8*2)];
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} wait14[2];
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} norm_hblank[2];
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} jump[2];
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} wait_forever[6];
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   sprstop[8];
};

#endif  /* GRAPHICS_COPPER_H */
@ENDNODE
