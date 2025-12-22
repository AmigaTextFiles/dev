/* $VER: libraries.h 39.2 (10.4.1992) */
OPT NATIVE
MODULE 'target/exec/nodes'
MODULE 'target/exec/types'
{MODULE 'exec/libraries'}

NATIVE {LIBF_EXP0CNT} CONST LIBF_EXP0CNT = $10

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
NATIVE {lib} OBJECT lib
    {ln}	ln	:ln
    {flags}	flags	:UBYTE
    {pad}	pad	:UBYTE
    {negsize}	negsize	:UINT	    /* number of bytes before library */
    {possize}	possize	:UINT	    /* number of bytes after library */
    {version}	version	:UINT	    /* major */
    {revision}	revision	:UINT	    /* minor */
    {idstring}	idstring	:APTR	    /* ASCII identification */
    {sum}	sum	:ULONG		    /* the checksum itself */
    {opencnt}	opencnt	:UINT	    /* number of current opens */
ENDOBJECT	/* Warning: size is not a longword multiple! */

/* lib_Flags bit definitions (all others are system reserved) */
NATIVE {LIBF_SUMMING}	CONST LIBF_SUMMING	= $1	    /* we are currently checksumming */
NATIVE {LIBF_CHANGED}	CONST LIBF_CHANGED	= $2	    /* we have just changed the lib */
NATIVE {LIBF_SUMUSED}	CONST LIBF_SUMUSED	= $4	    /* set if we should bother to sum */
NATIVE {LIBF_DELEXP}	CONST LIBF_DELEXP	= $8	    /* delayed expunge */
