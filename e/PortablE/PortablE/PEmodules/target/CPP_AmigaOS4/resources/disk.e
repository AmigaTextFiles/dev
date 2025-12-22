/* $Id: disk.h,v 1.10 2005/11/10 15:39:42 hjfrieden Exp $ */
OPT NATIVE, PREPROCESS
MODULE 'target/exec/types', 'target/exec/lists', 'target/exec/ports', 'target/exec/interrupts', 'target/exec/libraries'
MODULE 'target/exec/tasks'
{#include <resources/disk.h>}
NATIVE {RESOURCES_DISK_H} CONST

/********************************************************************
*
* Resource structures
*
********************************************************************/


NATIVE {DiscResourceUnit} OBJECT discresourceunit
    {dru_Message}	mn	:mn
    {dru_DiscBlock}	discblock	:is
    {dru_DiscSync}	discsync	:is
    {dru_Index}	index	:is
ENDOBJECT

NATIVE {DiscResource} OBJECT discresource
    {dr_Library}	lib	:lib
    {dr_Current}	current	:PTR TO discresourceunit
    {dr_Flags}	flags	:UBYTE
    {dr_pad}	pad	:UBYTE
    {dr_SysLib}	syslib	:PTR TO lib
    {dr_CiaResource}	ciaresource	:PTR TO lib
    {dr_UnitID}	unitid[4]	:ARRAY OF ULONG
    {dr_Waiting}	waiting	:lh
    {dr_DiscBlock}	discblock	:is
    {dr_DiscSync}	discsync	:is
    {dr_Index}	index	:is
    {dr_CurrTask}	currtask	:PTR TO tc
ENDOBJECT

/* dr_Flags entries */
NATIVE {DRB_ALLOC0}  CONST DRB_ALLOC0  = 0      /* unit zero is allocated      */
NATIVE {DRB_ALLOC1}  CONST DRB_ALLOC1  = 1      /* unit one is allocated       */
NATIVE {DRB_ALLOC2}  CONST DRB_ALLOC2  = 2      /* unit two is allocated       */
NATIVE {DRB_ALLOC3}  CONST DRB_ALLOC3  = 3      /* unit three is allocated     */
NATIVE {DRB_ACTIVE}  CONST DRB_ACTIVE  = 7      /* is the disc currently busy? */

NATIVE {DRF_ALLOC0}  CONST DRF_ALLOC0  = $1 /* unit zero is allocated      */
NATIVE {DRF_ALLOC1}  CONST DRF_ALLOC1  = $2 /* unit one is allocated       */
NATIVE {DRF_ALLOC2}  CONST DRF_ALLOC2  = $4 /* unit two is allocated       */
NATIVE {DRF_ALLOC3}  CONST DRF_ALLOC3  = $8 /* unit three is allocated     */
NATIVE {DRF_ACTIVE}  CONST DRF_ACTIVE  = $80 /* is the disc currently busy? */



/********************************************************************
*
* Hardware Magic
*
********************************************************************/


NATIVE {DSKDMAOFF} CONST DSKDMAOFF = $4000 /* idle command for dsklen register */


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

NATIVE {DISKNAME} CONST
#define DISKNAME diskname
STATIC diskname = 'disk.resource'


NATIVE {DR_ALLOCUNIT}  CONST DR_ALLOCUNIT  = (LIB_BASE - 0*LIB_VECTSIZE)
NATIVE {DR_FREEUNIT}   CONST DR_FREEUNIT   = (LIB_BASE - 1*LIB_VECTSIZE)
NATIVE {DR_GETUNIT}    CONST DR_GETUNIT    = (LIB_BASE - 2*LIB_VECTSIZE)
NATIVE {DR_GIVEUNIT}   CONST DR_GIVEUNIT   = (LIB_BASE - 3*LIB_VECTSIZE)
NATIVE {DR_GETUNITID}  CONST DR_GETUNITID  = (LIB_BASE - 4*LIB_VECTSIZE)
NATIVE {DR_READUNITID} CONST DR_READUNITID = (LIB_BASE - 5*LIB_VECTSIZE)

NATIVE {DR_LASTCOMM}   CONST DR_LASTCOMM   = (DR_READUNITID)

/********************************************************************
*
* drive types
*
********************************************************************/

NATIVE {DRT_AMIGA}    CONST DRT_AMIGA    = ($00000000)
NATIVE {DRT_37422D2S} CONST DRT_37422D2S = ($55555555)
NATIVE {DRT_EMPTY}    CONST DRT_EMPTY    = ($FFFFFFFF)
NATIVE {DRT_150RPM}   CONST DRT_150RPM   = ($AAAAAAAA)
