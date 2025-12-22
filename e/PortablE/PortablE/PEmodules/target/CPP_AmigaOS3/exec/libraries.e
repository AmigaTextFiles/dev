/* $VER: libraries.h 39.2 (10.4.1992) */
OPT NATIVE
MODULE 'target/exec/nodes'
MODULE 'target/exec/types'
{#include <exec/libraries.h>}
NATIVE {EXEC_LIBRARIES_H} CONST

CONST LIBF_EXP0CNT = $10

/*------ Special Constants ---------------------------------------*/
NATIVE {LIB_VECTSIZE}	CONST LIB_VECTSIZE	= 6	/* Each library entry takes 6 bytes */
NATIVE {LIB_RESERVED}	CONST LIB_RESERVED	= 4	/* Exec reserves the first 4 vectors */
NATIVE {LIB_BASE}	CONST LIB_BASE	= (-LIB_VECTSIZE)
NATIVE {LIB_USERDEF}	CONST LIB_USERDEF	= (LIB_BASE-(LIB_RESERVED*LIB_VECTSIZE))
NATIVE {LIB_NONSTD}	CONST LIB_NONSTD	= (LIB_USERDEF)

/*------ Standard Functions --------------------------------------*/
NATIVE {LIB_OPEN}	CONST LIB_OPEN	= (-6)
NATIVE {LIB_CLOSE}	CONST LIB_CLOSE	= (-12)
NATIVE {LIB_EXPUNGE}	CONST LIB_EXPUNGE	= (-18)
NATIVE {LIB_EXTFUNC}	CONST LIB_EXTFUNC	= (-24)	/* for future expansion */


/*------ Library Base Structure ----------------------------------*/
/* Also used for Devices and some Resources */
NATIVE {Library} OBJECT lib
    {lib_Node}	ln	:ln
    {lib_Flags}	flags	:UBYTE
    {lib_pad}	pad	:UBYTE
    {lib_NegSize}	negsize	:UINT	    /* number of bytes before library */
    {lib_PosSize}	possize	:UINT	    /* number of bytes after library */
    {lib_Version}	version	:UINT	    /* major */
    {lib_Revision}	revision	:UINT	    /* minor */
    {lib_IdString}	idstring	:APTR	    /* ASCII identification */
    {lib_Sum}	sum	:ULONG		    /* the checksum itself */
    {lib_OpenCnt}	opencnt	:UINT	    /* number of current opens */
ENDOBJECT	/* Warning: size is not a longword multiple! */

/* lib_Flags bit definitions (all others are system reserved) */
NATIVE {LIBF_SUMMING}	CONST LIBF_SUMMING	= $1	    /* we are currently checksumming */
NATIVE {LIBF_CHANGED}	CONST LIBF_CHANGED	= $2	    /* we have just changed the lib */
NATIVE {LIBF_SUMUSED}	CONST LIBF_SUMUSED	= $4	    /* set if we should bother to sum */
NATIVE {LIBF_DELEXP}	CONST LIBF_DELEXP	= $8	    /* delayed expunge */


/* Temporary Compatibility */
NATIVE {lh_Node}	DEF
NATIVE {lh_Flags}	DEF
NATIVE {lh_pad}		DEF
NATIVE {lh_NegSize}	DEF
NATIVE {lh_PosSize}	DEF
NATIVE {lh_Version}	DEF
NATIVE {lh_Revision}	DEF
NATIVE {lh_IdString}	DEF
NATIVE {lh_Sum}		DEF
NATIVE {lh_OpenCnt}	DEF
