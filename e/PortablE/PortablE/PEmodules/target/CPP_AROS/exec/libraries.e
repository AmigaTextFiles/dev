/* $Id: libraries.h 18668 2003-07-19 02:59:06Z iaint $ */
OPT NATIVE
MODULE 'target/exec/nodes'
MODULE 'target/exec/types'
{#include <exec/libraries.h>}
NATIVE {EXEC_LIBRARIES_H} CONST

/* Library constants */
/* LIB_VECTSIZE is in aros/machine.h */
NATIVE {LIB_RESERVED}	CONST LIB_RESERVED	= 4	/* Exec reserves the first 4 vectors */
NATIVE {LIB_BASE}	CONST ->LIB_BASE	= (-LIB_VECTSIZE)
NATIVE {LIB_USERDEF}	CONST ->LIB_USERDEF	= (LIB_BASE-(LIB_RESERVED*LIB_VECTSIZE))
NATIVE {LIB_NONSTD}	CONST ->LIB_NONSTD	= (LIB_USERDEF)

/* Standard vectors */
NATIVE {LIB_OPEN}	CONST ->LIB_OPEN	= (LIB_BASE*1)
NATIVE {LIB_CLOSE}	CONST ->LIB_CLOSE	= (LIB_BASE*2)
NATIVE {LIB_EXPUNGE}	CONST ->LIB_EXPUNGE	= (LIB_BASE*3)
NATIVE {LIB_EXTFUNC}	CONST ->LIB_EXTFUNC	= (LIB_BASE*4)  /* for future expansion */


/* Library structure. Also used by Devices and some Resources. */
NATIVE {Library} OBJECT lib
    {lib_Node}	ln	:ln
    {lib_Flags}	flags	:UBYTE
    {lib_pad}	pad	:UBYTE
    {lib_NegSize}	negsize	:UINT	    /* number of bytes before library */
    {lib_PosSize}	possize	:UINT	    /* number of bytes after library */
    {lib_Version}	version	:UINT	    /* major */
    {lib_Revision}	revision	:UINT	    /* minor */
    ->{lib_pad1}		    /* make sure it is longword aligned */
    {lib_IdString}	idstring	:APTR	    /* ASCII identification */
    {lib_Sum}	sum	:ULONG		    /* the checksum */
    {lib_OpenCnt}	opencnt	:UINT	    /* How many people use us right now ? */
    ->{lib_pad2}		    /* make sure it is longword aligned */
ENDOBJECT

/* lib_Flags bits (all others are reserved by the system) */
NATIVE {LIBF_SUMMING}	CONST LIBF_SUMMING	= $1      /* lib is currently beeing checksummed */
NATIVE {LIBF_CHANGED}	CONST LIBF_CHANGED	= $2      /* lib has changed */
NATIVE {LIBF_SUMUSED}	CONST LIBF_SUMUSED	= $4      /* sum should be checked */
NATIVE {LIBF_DELEXP}	CONST LIBF_DELEXP	= $8      /* delayed expunge */

->#ifdef AROS_LIB_OBSOLETE
/* Temporary Compatibility */
NATIVE {lh_Node} 	DEF
NATIVE {lh_Flags}	DEF
NATIVE {lh_pad}		DEF
NATIVE {lh_NegSize}	DEF
NATIVE {lh_PosSize}	DEF
NATIVE {lh_Version}	DEF
NATIVE {lh_Revision}	DEF
NATIVE {lh_IdString}	DEF
NATIVE {lh_Sum}		DEF
NATIVE {lh_OpenCnt}	DEF
->#endif
