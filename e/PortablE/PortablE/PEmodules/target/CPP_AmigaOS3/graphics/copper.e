/* $VER: copper.h 39.10 (31.5.1993) */
OPT NATIVE
PUBLIC MODULE 'target/graphics/gfx_shared1'
MODULE 'target/exec/types'
{#include <graphics/copper.h>}
NATIVE {GRAPHICS_COPPER_H} CONST

NATIVE {COPPER_MOVE} CONST COPPER_MOVE = 0	    /* pseude opcode for move #XXXX,dir */
NATIVE {COPPER_WAIT} CONST COPPER_WAIT = 1	    /* pseudo opcode for wait y,x */
NATIVE {CPRNXTBUF}   CONST CPRNXTBUF   = 2	    /* continue processing with next buffer */
NATIVE {CPR_NT_LOF}  CONST CPR_NT_LOF  = $8000  /* copper instruction only for short frames */
NATIVE {CPR_NT_SHT}  CONST CPR_NT_SHT  = $4000  /* copper instruction only for long frames */
NATIVE {CPR_NT_SYS}  CONST CPR_NT_SYS  = $2000  /* copper user instruction only */

->"OBJECT copins" is on-purposely missing from here (it can be found in 'graphics/gfx_shared1')

/* shorthand for above */
NATIVE {NXTLIST}     CONST
NATIVE {VWAITPOS}    CONST
NATIVE {DESTADDR}    CONST
NATIVE {HWAITPOS}    CONST
NATIVE {DESTDATA}    CONST


/* structure of cprlist that points to list that hardware actually executes */
NATIVE {cprlist} OBJECT cprlist
    {Next}	next	:PTR TO cprlist
    {start}	start	:PTR TO UINT	    /* start of copper list */
    {MaxCount}	maxcount	:INT	   /* number of long instructions */
ENDOBJECT

->"OBJECT coplist" is on-purposely missing from here (it can be found in 'graphics/gfx_shared1')

/* These CopList->Flags are private */
NATIVE {EXACT_LINE} CONST EXACT_LINE = 1
NATIVE {HALF_LINE} CONST HALF_LINE = 2


->"OBJECT ucoplist" is on-purposely missing from here (it can be found in 'graphics/gfx_shared1')

/* Private graphics data structure. This structure has changed in the past,
 * and will continue to change in the future. Do Not Touch!
 */

NATIVE {copinit} OBJECT copinit
    {vsync_hblank}	vsync_hblank[2]	:ARRAY OF UINT
    {diagstrt}	diagstrt[12]	:ARRAY OF UINT      /* copper list for first bitplane */
    {fm0}	fm0[2]	:ARRAY OF UINT
    {diwstart}	diwstart[10]	:ARRAY OF UINT
    {bplcon2}	bplcon2[2]	:ARRAY OF UINT
	{sprfix}	sprfix[2*8]	:ARRAY OF UINT
    {sprstrtup}	sprstrtup[(2*8*2)]	:ARRAY OF UINT
    {wait14}	wait14[2]	:ARRAY OF UINT
    {norm_hblank}	norm_hblank[2]	:ARRAY OF UINT
    {jump}	jump[2]	:ARRAY OF UINT
    {wait_forever}	wait_forever[6]	:ARRAY OF UINT
    {sprstop}	sprstop[8]	:ARRAY OF UINT
ENDOBJECT
