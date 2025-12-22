MODULE 'exec/ports'
MODULE 'exec/interrupts'
MODULE 'exec/libraries'

/********************************************************************
*
* Resource structures
*
********************************************************************/

OBJECT DiscResourceUnit
 Message:Message,
 DiscBlock:Interrupt,
 DiscSync:Interrupt,
 Index:Interrupt

OBJECT DiscResource
 Library:Library,
 Current:PTR TO DiscResourceUnit,
 Flags:UBYTE,
 pad:UBYTE,
 SysLib:PTR TO Library,
 CiaResource:PTR TO Library,
 UnitID[4]:ULONG,
 Waiting:List,
 DiscBlock:Interrupt,
 DiscSync:Interrupt,
 Index:Interrupt,
 CurrTask:PTR TO Task

/* dr_Flags entries */
FLAG DR_ALLOC0,  /* unit zero is allocated */
 DR_ALLOC1,  /* unit one is allocated */
 DR_ALLOC2,  /* unit two is allocated */
 DR_ALLOC3,  /* unit three is allocated */
 DR_ACTIVE   /* is the disc currently busy? */

/********************************************************************
*
* Hardware Magic
*
********************************************************************/
CONST DSKDMAOFF=$4000    /* idle command for dsklen register */
/********************************************************************
*
* Resource specific commands
*
********************************************************************/
/*
 * DISKNAME is a generic macro to get the name of the resource.
 * This way if the name is ever changed you will pick up the
 *  change automatically.
 */

#define DISKNAME 'disk.resource'

CONST DR_ALLOCUNIT=LIB_BASE - 0*LIB_VECTSIZE,
 DR_FREEUNIT=LIB_BASE - 1*LIB_VECTSIZE,
 DR_GETUNIT=LIB_BASE - 2*LIB_VECTSIZE,
 DR_GIVEUNIT=LIB_BASE - 3*LIB_VECTSIZE,
 DR_GETUNITID=LIB_BASE - 4*LIB_VECTSIZE,
 DR_READUNITID=LIB_BASE - 5*LIB_VECTSIZE,
 DR_LASTCOMM=DR_READUNITID

/********************************************************************
*
* drive types
*
********************************************************************/
CONST DRT_AMIGA=$00000000,
 DRT_37422D2S=$55555555,
 DRT_EMPTY=$FFFFFFFF,
 DRT_150RPM=$AAAAAAAA
