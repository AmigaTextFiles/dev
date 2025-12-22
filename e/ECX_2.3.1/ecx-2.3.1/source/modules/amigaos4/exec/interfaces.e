-> exec/interfaces.e -> comments from original .h source
OPT MODULE, EXPORT, NATURALALIGN

MODULE 'exec/libraries'
MODULE 'exec/nodes'
MODULE 'utility/tagitem'

/****************************************************************************/

/*
** The interface is the new way for exec libraries.
** Basically, the interface is embedded in a table of
** function pointers similar to the old library jump table.
**
** FIXME: Add some more documentation
*/

OBJECT interfacedata
    link:ln              /* Node for linking several interfaces */
    libbase:PTR TO lib           /* Library this interface belongs to */

    refcount:ULONG          /* Reference count */
    version:ULONG           /* Version number of the interface */
    flags:ULONG             /* Various flags (see below) */
    checksum:ULONG          /* Checksum of the interface */
    positivesize:ULONG      /* Size of the function pointer part */
    negativesize:ULONG      /* Size of the data area */
    iexecprivate:LONG      /* Private copy of IExec */
    environmentvector:LONG /* Base address for base relative code */
    reserved3:LONG
    reserved4:LONG
ENDOBJECT

/*
** Flags for the Flags field in interfaces and as flags parameter for GetInterface
*/
ENUM
    IFLF_NONE       = $0000, /* No flags */
    IFLF_PROTECTED  = $0001, /* This interface can't be SetMethod'd */
    IFLF_NOT_NATIVE = $0002, /* Interface is 68k */
    IFLF_PRIVATE    = $0004, /* Interface is a private,
                               * non-shareable instance */
    IFLF_CHANGED    = $0008, /* Interface has been changed,
                               * ready for re-summing */
    IFLF_UNMODIFIED = $0010, /* Interface is unmodified. This flag will be set
                               * if the interface is created, and reset as soon
                               * as someone uses SetMethod on it. */
    IFLF_CLONED     = $0020  /* Interface was created by Clone method and will
                               * have to be freed by Expunge. */
                              /* Interface implementors must set this bit in
                               * Clone */

/*
** Generic interface
** This is a generic interface structure that can be used
** everywhere when no specific interface is required/available.
*/

OBJECT interface
    data:interfacedata /* Interface data area */

   -> ECX-note: no support for member functions yet
    obtain /* Increment reference count */
    release /* Decrement reference count */
    expunge /* Destroy interface. May be NULL */
    clone /* Clone interface. May be NULL */
ENDOBJECT


/*
** Tag items for MakeInterface taglists
*/

CONST MIT_VectorTable = TAG_USER + 1 /* Pointer to function vectors */
CONST MIT_InitData    = TAG_USER + 2 /* Pointer to an InitData style table */
CONST MIT_InitFunc    = TAG_USER + 3 /* Pointer to a function to be invoked
                                        * when initializing */
CONST MIT_DataSize    = TAG_USER + 4 /* Size of data area */
CONST MIT_Flags       = TAG_USER + 5 /* Interface flags
                                        * (see enInterfaceFlags) */
CONST MIT_Version     = TAG_USER + 6 /* Major version for the interface */
CONST MIT_Name        = TAG_USER + 9 /* Interface name */

/*
** Tags for GetInterface
*/
CONST GIT_FLAGS  = TAG_USER + 1    /* Flags to match */

/*
** Library management and device management interface
** See the NDK for more information
*/

OBJECT librarymanagerinterface
   data:interfacedata

   -> ECX-note: no support for member functions yet
   obtain /* Increment reference count */
   release /* Decrement reference count */
   expunge /* Destroy interface. May be NULL */
   clone /* Clone interface. May be NULL */

   -> ECX-note: no support for member functions yet
   open
   close
   libexpunge
   getinterface
ENDOBJECT

OBJECT devicemanagerinterface

   -> ECX-note: no support for member functions yet
   obtain /* Increment reference count */
   release /* Decrement reference count */
   expunge /* Destroy interface. May be NULL */
   clone /* Clone interface. May be NULL */

   -> ECX-note: no support for member functions yet
   open
   close
   libexpunge
   getinterface

   -> ECX-note: no support for member functions yet
   beginio
   abortio

ENDOBJECT

/****************************************************************************/