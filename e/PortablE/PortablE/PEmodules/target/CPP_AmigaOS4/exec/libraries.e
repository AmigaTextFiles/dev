/* $Id: libraries.h,v 1.14 2005/11/10 15:33:07 hjfrieden Exp $ */
OPT NATIVE
MODULE 'target/exec/nodes', 'target/exec/lists', 'target/utility/tagitem'
MODULE 'target/exec/types'
PUBLIC MODULE 'target/exec/exec_shared'
{#include <exec/libraries.h>}
NATIVE {EXEC_LIBRARIES_H} CONST

/*------ Special Constants ---------------------------------------*/
/* Note: This only applies to "legacy" 68k-based functions */
NATIVE {enLibConstants} DEF
NATIVE {LIB_VECTSIZE} CONST LIB_VECTSIZE = 6    /* Each library entry takes 6 bytes */
NATIVE {LIB_RESERVED} CONST LIB_RESERVED = 4    /* Exec reserves the first 4 vectors */
NATIVE {LIB_BASE}     CONST LIB_BASE     = (-LIB_VECTSIZE)
NATIVE {LIB_USERDEF}  CONST LIB_USERDEF  = (LIB_BASE-(LIB_RESERVED*LIB_VECTSIZE))
NATIVE {LIB_NONSTD}   CONST LIB_NONSTD   = (LIB_USERDEF)


/*------ Standard Functions --------------------------------------*/
/* Note: This only applies to "legacy" 68k-based functions */
NATIVE {enStandardFunctions} DEF
NATIVE {LIB_OPEN}    CONST LIB_OPEN    = (- 6)
NATIVE {LIB_CLOSE}   CONST LIB_CLOSE   = (-12)
NATIVE {LIB_EXPUNGE} CONST LIB_EXPUNGE = (-18)
NATIVE {LIB_EXTFUNC} CONST LIB_EXTFUNC = (-24) /* for future expansion */


/*------ Library Base Structure ----------------------------------*/
/* Also used for Devices and some Resources */
->"OBJECT lib" is on-purposely missing from here (it can be found in 'exec/exec_shared')

NATIVE {lib_pad} DEF

/* lib_ABIVersion definitions */
NATIVE {enABIVersion} DEF
NATIVE {LIBABI_68K}    CONST LIBABI_68K    = 0 /* A 68k library (pre OS4) */
NATIVE {LIBABI_MIFACE} CONST LIBABI_MIFACE = 1  /* V50 multi interface library */
      

/* lib_Flags bit definitions (all others are system reserved) */
NATIVE {enLibraryFlags} DEF
NATIVE {LIBF_SUMMING} CONST LIBF_SUMMING = $1 /* we are currently checksumming */
NATIVE {LIBF_CHANGED} CONST LIBF_CHANGED = $2 /* we have just changed the lib */
NATIVE {LIBF_SUMUSED} CONST LIBF_SUMUSED = $4 /* set if we should bother to sum */
NATIVE {LIBF_DELEXP}  CONST LIBF_DELEXP  = $8 /* delayed expunge */
NATIVE {LIBF_EXP0CNT} CONST LIBF_EXP0CNT = $10


/* Temporary Compatibility */
NATIVE {lh_Node}     CONST
NATIVE {lh_Flags}    CONST
NATIVE {lh_pad}      CONST
NATIVE {lh_NegSize}  CONST
NATIVE {lh_PosSize}  CONST
NATIVE {lh_Version}  CONST
NATIVE {lh_Revision} CONST
NATIVE {lh_IdString} CONST
NATIVE {lh_Sum}      CONST
NATIVE {lh_OpenCnt}  CONST

/* Warning: Everything below is default alignment */

/*------ Extended Library Base Structure ----------------------------------*/
/* Used to extend the standard library for V50 */
NATIVE {ExtendedLibrary} OBJECT extendedlibrary
    {Parent}	parent	:PTR TO lib     /* Back pointer to self */
    {ILibrary}	ilibrary	:PTR TO librarymanagerinterface   /* Library interface */
    {IDevice}	idevice	:PTR TO devicemanagerinterface    /* Device interface */
    {Interfaces}	interfaces	:lh /* List of interfaces
                                                  * exported by this library */
    {ExtFlags}	extflags	:ULONG   /* Extended flags */
    {MainIFace}	mainiface	:PTR TO interface  /* For 68k cross-calls */
ENDOBJECT

/* Extended flags */
NATIVE {enExtFlags} DEF
NATIVE {LIBEF_DEVICE} CONST LIBEF_DEVICE = $00000001 /* Library is a device library */
 


/****************************************************************************/



NATIVE {LIBINITFUNC} CONST
