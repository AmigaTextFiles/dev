/* $Id: copper.h 12757 2001-12-08 22:23:57Z chodorowski $ */
OPT NATIVE
PUBLIC MODULE 'target/graphics/gfx_shared1'
MODULE 'target/exec/types'
{#include <graphics/copper.h>}
NATIVE {GRAPHICS_COPPER_H} CONST

->"OBJECT copins" is on-purposely missing from here (it can be found in 'graphics/gfx_shared1')
NATIVE {NXTLIST}  CONST
NATIVE {VWAITPOS} CONST
NATIVE {DESTADDR} CONST
NATIVE {HWAITPOS} CONST
NATIVE {DESTDATA} CONST

->"OBJECT coplist" is on-purposely missing from here (it can be found in 'graphics/gfx_shared1')

/* Flags (PRIVATE) */
NATIVE {EXACT_LINE} CONST EXACT_LINE = 1
NATIVE {HALF_LINE}  CONST HALF_LINE  = 2

->"OBJECT ucoplist" is on-purposely missing from here (it can be found in 'graphics/gfx_shared1')

NATIVE {cprlist} OBJECT cprlist
    {Next}	next	:PTR TO cprlist
    {start}	start	:PTR TO UINT
    {MaxCount}	maxcount	:INT
ENDOBJECT

NATIVE {COPPER_MOVE} CONST COPPER_MOVE = 0
NATIVE {COPPER_WAIT} CONST COPPER_WAIT = 1
NATIVE {CPRNXTBUF}   CONST CPRNXTBUF   = 2
NATIVE {CPR_NT_SYS}  CONST CPR_NT_SYS  = $2000
NATIVE {CPR_NT_SHT}  CONST CPR_NT_SHT  = $4000
NATIVE {CPR_NT_LOF}  CONST CPR_NT_LOF  = $8000

NATIVE {copinit} OBJECT copinit
    {vsync_hblank}	vsync_hblank[2]	:ARRAY OF UINT
    {diagstrt}	diagstrt[12]	:ARRAY OF UINT
    {fm0}	fm0[2]	:ARRAY OF UINT
    {diwstart}	diwstart[10]	:ARRAY OF UINT
    {bplcon2}	bplcon2[2]	:ARRAY OF UINT
    {sprfix}	sprfix[16]	:ARRAY OF UINT
    {sprstrtup}	sprstrtup[32]	:ARRAY OF UINT
    {wait14}	wait14[2]	:ARRAY OF UINT
    {norm_hblank}	norm_hblank[2]	:ARRAY OF UINT
    {jump}	jump[2]	:ARRAY OF UINT
    {wait_forever}	wait_forever[6]	:ARRAY OF UINT
    {sprstop}	sprstop[8]	:ARRAY OF UINT
ENDOBJECT
