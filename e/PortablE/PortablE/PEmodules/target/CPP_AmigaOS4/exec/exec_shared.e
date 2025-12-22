OPT NATIVE
->MODULE 'target/exec/types', 'target/exec/libraries', 'target/utility/tagitem', 'target/amiga_compiler', 'target/exec/io'
MODULE 'target/exec/nodes', 'target/exec/types'

NATIVE {Library} OBJECT lib
    {lib_Node}	ln	:ln
    {lib_Flags}	flags	:UBYTE
    {lib_ABIVersion}	abiversion	:UBYTE /* ABI exported by library */
    {lib_NegSize}	negsize	:UINT    /* number of bytes before library */
    {lib_PosSize}	possize	:UINT    /* number of bytes after library */
    {lib_Version}	version	:UINT    /* major */
    {lib_Revision}	revision	:UINT   /* minor */
    {lib_IdString}	idstring	:APTR   /* ASCII identification */
    {lib_Sum}	sum	:ULONG        /* the checksum itself */
    {lib_OpenCnt}	opencnt	:UINT    /* number of current opens */
ENDOBJECT /* Warning: size is not a longword multiple! */

NATIVE {Interface} OBJECT interface
    {Data}	data	:interfacedata /* Interface data area */

    {Obtain}	obtain	:NATIVE {ULONG APICALL              (*) (struct Interface *Self)} PTR /* Increment reference count */
    {Release}	release	:NATIVE {ULONG APICALL              (*)(struct Interface *Self)} PTR /* Decrement reference count */
    {Expunge}	expunge	:NATIVE {void APICALL               (*)(struct Interface *Self)} PTR /* Destroy interface. May be NULL */
    {Clone}	clone	:NATIVE {Interface * APICALL (*)  (struct Interface *Self)} PTR /* Clone interface. May be NULL */
ENDOBJECT

NATIVE {InterfaceData} OBJECT interfacedata
    {Link}	link	:ln              /* Node for linking several interfaces */   
    {LibBase}	libbase	:PTR TO lib           /* Library this interface belongs to */     

    {RefCount}	refcount	:ULONG          /* Reference count */                       
    {Version}	version	:ULONG           /* Version number of the interface */       
    {Flags}	flags	:ULONG             /* Various flags (see below) */             
    {CheckSum}	checksum	:ULONG          /* Checksum of the interface */             
    {PositiveSize}	positivesize	:ULONG      /* Size of the function pointer part */     
    {NegativeSize}	negativesize	:ULONG      /* Size of the data area */
    {IExecPrivate}	iexecprivate	:APTR      /* Private copy of IExec */
    {EnvironmentVector}	environmentvector	:APTR /* Base address for base relative code */
    {Reserved3}	reserved3	:ULONG
    {Reserved4}	reserved4	:ULONG
ENDOBJECT

NATIVE {LibraryManagerInterface} OBJECT librarymanagerinterface
    {Data}	data	:interfacedata

    {Obtain}	obtain	:NATIVE {ULONG              APICALL (*) (struct LibraryManagerInterface *Self)} PTR
    {Release}	release	:NATIVE {ULONG              APICALL (*)(struct LibraryManagerInterface *Self)} PTR
    {Expunge}	expunge	:NATIVE {VOID               APICALL (*)(struct LibraryManagerInterface *Self)} PTR
    {Clone}	clone	:NATIVE {Interface * APICALL (*)  (struct LibraryManagerInterface *Self)} PTR

    {Open}	open	:NATIVE {Library *   APICALL (*)        (struct LibraryManagerInterface *Self, ULONG version)} PTR
    {Close}	close	:NATIVE {APTR               APICALL (*)       (struct LibraryManagerInterface *Self)} PTR
    {LibExpunge}	libexpunge	:NATIVE {APTR               APICALL (*)  (struct LibraryManagerInterface *Self)} PTR
    {GetInterface}	getinterface	:NATIVE {Interface * APICALL (*)(struct LibraryManagerInterface *Self, STRPTR name, ULONG version, struct TagItem *taglist)} PTR
ENDOBJECT

NATIVE {DeviceManagerInterface} OBJECT devicemanagerinterface
    {Data}	data	:interfacedata
    
    {Obtain}	obtain	:NATIVE {ULONG              APICALL (*) (struct DeviceManagerInterface *Self)} PTR
    {Release}	release	:NATIVE {ULONG              APICALL (*)(struct DeviceManagerInterface *Self)} PTR
    {Expunge}	expunge	:NATIVE {VOID               APICALL (*)(struct DeviceManagerInterface *Self)} PTR
    {Clone}	clone	:NATIVE {Interface * APICALL (*)  (struct DeviceManagerInterface *Self)} PTR

    {Open}	open	:NATIVE {LONG               APICALL (*)        (struct DeviceManagerInterface *Self, struct IORequest *ior, ULONG unit, ULONG flags)} PTR
    {Close}	close	:NATIVE {APTR               APICALL (*)       (struct DeviceManagerInterface *Self, struct IORequest *ior)} PTR
    {LibExpunge}	libexpunge	:NATIVE {APTR               APICALL (*)  (struct DeviceManagerInterface *Self)} PTR
    {GetInterface}	getinterface	:NATIVE {Interface * APICALL (*)(struct DeviceManagerInterface *Self, STRPTR name, ULONG version, struct TagItem *taglist)} PTR

    {BeginIO}	beginio	:NATIVE {VOID               APICALL (*)     (struct DeviceManagerInterface *Self, struct IORequest *ior)} PTR
    {AbortIO}	abortio	:NATIVE {VOID               APICALL (*)     (struct DeviceManagerInterface *Self, struct IORequest *ior)} PTR
ENDOBJECT
