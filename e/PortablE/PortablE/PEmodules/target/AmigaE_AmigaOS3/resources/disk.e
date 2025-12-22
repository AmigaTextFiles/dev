/* $VER: disk.h 27.11 (21.11.1990) */
OPT NATIVE, PREPROCESS
MODULE 'target/exec/types', 'target/exec/lists', 'target/exec/ports', 'target/exec/interrupts', 'target/exec/libraries'
MODULE 'target/exec/tasks'
{MODULE 'resources/disk'}

NATIVE {discresourceunit} OBJECT discresourceunit
    {mn}	mn	:mn
    {discblock}	discblock	:is
    {discsync}	discsync	:is
    {index}	index	:is
ENDOBJECT

NATIVE {discresource} OBJECT discresource
    {lib}	lib	:lib
    {current}	current	:PTR TO discresourceunit
    {flags}	flags	:UBYTE
    {pad}	pad	:UBYTE
    {syslib}	syslib	:PTR TO lib
    {ciaresource}	ciaresource	:PTR TO lib
    {unitid}	unitid[4]	:ARRAY OF ULONG
    {waiting}	waiting	:lh
    {discblock}	discblock	:is
    {discsync}	discsync	:is
    {index}	index	:is
    {currtask}	currtask	:PTR TO tc
ENDOBJECT

/* dr_Flags entries */
NATIVE {DRB_ALLOC0}	CONST DRB_ALLOC0	= 0	/* unit zero is allocated */
NATIVE {DRB_ALLOC1}	CONST DRB_ALLOC1	= 1	/* unit one is allocated */
NATIVE {DRB_ALLOC2}	CONST DRB_ALLOC2	= 2	/* unit two is allocated */
NATIVE {DRB_ALLOC3}	CONST DRB_ALLOC3	= 3	/* unit three is allocated */
NATIVE {DRB_ACTIVE}	CONST DRB_ACTIVE	= 7	/* is the disc currently busy? */

NATIVE {DRF_ALLOC0}	CONST DRF_ALLOC0	= $1	/* unit zero is allocated */
NATIVE {DRF_ALLOC1}	CONST DRF_ALLOC1	= $2	/* unit one is allocated */
NATIVE {DRF_ALLOC2}	CONST DRF_ALLOC2	= $4	/* unit two is allocated */
NATIVE {DRF_ALLOC3}	CONST DRF_ALLOC3	= $8	/* unit three is allocated */
NATIVE {DRF_ACTIVE}	CONST DRF_ACTIVE	= $80	/* is the disc currently busy? */



NATIVE {DSKDMAOFF}	CONST DSKDMAOFF	= $4000	/* idle command for dsklen register */


NATIVE {DISKNAME}	CONST
#define DISKNAME diskname
STATIC diskname	= 'disk.resource'


NATIVE {DR_ALLOCUNIT}	CONST DR_ALLOCUNIT	= (LIB_BASE - 0*LIB_VECTSIZE)
NATIVE {DR_FREEUNIT}	CONST DR_FREEUNIT	= (LIB_BASE - 1*LIB_VECTSIZE)
NATIVE {DR_GETUNIT}	CONST DR_GETUNIT	= (LIB_BASE - 2*LIB_VECTSIZE)
NATIVE {DR_GIVEUNIT}	CONST DR_GIVEUNIT	= (LIB_BASE - 3*LIB_VECTSIZE)
NATIVE {DR_GETUNITID}	CONST DR_GETUNITID	= (LIB_BASE - 4*LIB_VECTSIZE)
NATIVE {DR_READUNITID}	CONST DR_READUNITID	= (LIB_BASE - 5*LIB_VECTSIZE)

NATIVE {DR_LASTCOMM}	CONST DR_LASTCOMM	= (DR_READUNITID)

NATIVE {DRT_AMIGA}	CONST DRT_AMIGA	= ($00000000)
NATIVE {DRT_37422D2S}	CONST DRT_37422D2S	= ($55555555)
NATIVE {DRT_EMPTY}	CONST DRT_EMPTY	= ($FFFFFFFF)
NATIVE {DRT_150RPM}	CONST DRT_150RPM	= ($AAAAAAAA)
