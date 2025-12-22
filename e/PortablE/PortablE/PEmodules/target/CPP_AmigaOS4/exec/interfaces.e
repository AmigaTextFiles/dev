/* $Id: interfaces.h,v 1.15 2005/11/10 15:33:07 hjfrieden Exp $ */
OPT NATIVE
MODULE 'target/exec/types', 'target/exec/libraries', 'target/utility/tagitem', 'target/amiga_compiler', 'target/exec/io'
PUBLIC MODULE 'target/exec/exec_shared'
{#include <exec/interfaces.h>}
NATIVE {EXEC_INTERFACES_H} CONST

/*
** The interface is the new way for exec libraries.
** Basically, the interface is embedded in a table of
** function pointers similar to the old library jump table.
**
** FIXME: Add some more documentation
*/

->"OBJECT interfacedata" is on-purposely missing from here (it can be found in 'exec/exec_shared')

/*
** Flags for the Flags field in interfaces and as flags parameter for GetInterface
*/
NATIVE {enInterfaceFlags} DEF
NATIVE {IFLF_NONE}       CONST IFLF_NONE       = $0000 /* No flags */
NATIVE {IFLF_PROTECTED}  CONST IFLF_PROTECTED  = $0001 /* This interface can't be SetMethod'd */
NATIVE {IFLF_NOT_NATIVE} CONST IFLF_NOT_NATIVE = $0002 /* Interface is 68k */
NATIVE {IFLF_PRIVATE}    CONST IFLF_PRIVATE    = $0004 /* Interface is a private,
                               * non-shareable instance */
NATIVE {IFLF_CHANGED}    CONST IFLF_CHANGED    = $0008 /* Interface has been changed,
                               * ready for re-summing */
NATIVE {IFLF_UNMODIFIED} CONST IFLF_UNMODIFIED = $0010 /* Interface is unmodified. This flag will be set
                               * if the interface is created, and reset as soon
                               * as someone uses SetMethod on it. */
NATIVE {IFLF_CLONED}     CONST IFLF_CLONED     = $0020  /* Interface was created by Clone method and will
                               * have to be freed by Expunge. */
                              /* Interface implementors must set this bit in
                               * Clone */


/*
** Generic interface
** This is a generic interface structure that can be used
** everywhere when no specific interface is required/available.
*/

->"OBJECT interface" is on-purposely missing from here (it can be found in 'exec/exec_shared')

/*
** Init function used by MakeInterface
*/
NATIVE {IFACEINITFUNC} CONST

/*
** Tag items for MakeInterface taglists
*/

NATIVE {MIT_VectorTable} CONST MIT_VECTORTABLE = (TAG_USER + 1) /* Pointer to function vectors */
NATIVE {MIT_InitData}    CONST MIT_INITDATA    = (TAG_USER + 2) /* Pointer to an InitData() style table */
NATIVE {MIT_InitFunc}    CONST MIT_INITFUNC    = (TAG_USER + 3) /* Pointer to a function to be invoked
                                        * when initializing */
NATIVE {MIT_DataSize}    CONST MIT_DATASIZE    = (TAG_USER + 4) /* Size of data area */
NATIVE {MIT_Flags}       CONST MIT_FLAGS       = (TAG_USER + 5) /* Interface flags 
                                        * (see enInterfaceFlags) */
NATIVE {MIT_Version}     CONST MIT_VERSION     = (TAG_USER + 6) /* Major version for the interface */
NATIVE {MIT_Name}        CONST MIT_NAME        = (TAG_USER + 9) /* Interface name */

/*
** Tags for GetInterface
*/
NATIVE {GIT_FLAGS} CONST GIT_FLAGS = (TAG_USER + 1)    /* Flags to match */

/*
** Library management and device management interface
** See the NDK for more information
*/

->"OBJECT librarymanagerinterface" is on-purposely missing from here (it can be found in 'exec/exec_shared')

->"OBJECT devicemanagerinterface" is on-purposely missing from here (it can be found in 'exec/exec_shared')
