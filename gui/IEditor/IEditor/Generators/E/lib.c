/*
 *  LIB.C
 *
 *  Basic Library Resource Handling
 *
 *  NOTE: all data declarations should be initialized since we skip
 *        normal C startup code (unless initial value is don't care)
 *
 *  WARNING: arguments are passed in certain registers from the assembly
 *        tag file, matched to how they are declared below.  Do not change
 *        the argument declarations!
 */

#include "DEV_IE:Generators/defs.h"

extern struct Library *LibInit   ( __A0 BPTR );
extern struct Library *LibOpen   ( __D0 long, __A0 struct Library * );
extern long            LibClose  ( __A0 struct Library * );
extern long            LibExpunge( __A0 struct Library * );

struct Library *LibBase         = NULL;

long           *SysBase         = NULL;

struct Library *DOSBase         = NULL;
struct Library *IntuitionBase   = NULL;
struct Library *GfxBase         = NULL;
struct Library *ReqToolsBase    = NULL;
struct Library *GadToolsBase    = NULL;
BPTR SegList                    = 0L;

/*
 *    The Initialization routine is given only a seglist pointer.  Since
 *    we are NOT AUTOINIT we must construct and add the library ourselves
 *    and return either NULL or the library pointer.  Exec has Forbid()
 *    for us during the call.
 */

struct Library *LibInit( __A0 BPTR segment )
{

    struct Library *lib = NULL;

    static const long Vectors[] = {

	(long)ALibOpen,
	(long)ALibClose,
	(long)ALibExpunge,
	(long)ALibReserved,

	(long)OpenFiles,
	(long)CloseFiles,
	(long)WriteHeaders,
	(long)WriteVars,
	(long)WriteData,
	(long)WriteStrings,
	(long)WriteChipData,
	(long)WriteCode,
//        (long)Config,
	NULL,
	-1
    };

    SysBase = *(( struct Library ** )4 );

    if( DOSBase = OpenLibrary( "dos.library", 36 )) {
	if( IntuitionBase = OpenLibrary( "intuition.library", 36 )) {
	    if( GfxBase = OpenLibrary( "graphics.library", 36 )) {
		if( GadToolsBase = OpenLibrary( "gadtools.library", 36 )) {
		    if( ReqToolsBase = OpenLibrary( "reqtools.library", 37 )) {

			if( LibBase = lib = MakeLibrary( (APTR)Vectors, NULL, NULL, sizeof(struct Generator), NULL )) {

			    lib->lib_Node.ln_Type = NT_LIBRARY;
			    lib->lib_Node.ln_Name = LibName;
			    lib->lib_Flags        = LIBF_CHANGED | LIBF_SUMUSED;
			    lib->lib_Version      = 37;
			    lib->lib_Revision     = 0;
			    lib->lib_IdString     = (APTR)LibId;

			    ((struct Generator *)lib)->Ext      = "e";
			    ((struct Generator *)lib)->Pattern  = "#?.e";

			    SegList = segment;

			    AddLibrary( lib );
			}

		    }
		}
	    }
	}
    }

    return( lib );
}

/*
 *    Open is given the library pointer and the version request.  Either
 *    return the library pointer or NULL.  Remove the DELAYED-EXPUNGE flag.
 *    Exec has Forbid() for us during the call.
 */

struct Library *LibOpen( __D0 long version, __A0 struct Library *lib )
{
    ++lib->lib_OpenCnt;

    lib->lib_Flags &= ~LIBF_DELEXP;

    return( lib );
}

/*
 *    Close is given the library pointer and the version request.  Be sure
 *    not to decrement the open count if already zero.  If the open count
 *    is or becomes zero AND there is a LIBF_DELEXP, we expunge the library
 *    and return the seglist.  Otherwise we return NULL.
 *
 *    Note that this routine never sets LIBF_DELEXP on its own.
 *
 *    Exec has Forbid() for us during the call.
 */

long LibClose( __A0 struct Library *lib )
{
    if( lib->lib_OpenCnt && --lib->lib_OpenCnt )
	return( NULL );

    if( lib->lib_Flags & LIBF_DELEXP )
	return( LibExpunge( lib ));

    return( NULL );
}

/*
 *    We expunge the library and return the Seglist ONLY if the open count
 *    is zero.  If the open count is not zero we set the DELAYED-EXPUNGE
 *    flag and return NULL.
 *
 *    Exec has Forbid() for us during the call.  NOTE ALSO that Expunge
 *    might be called from the memory allocator and thus we CANNOT DO A
 *    Wait() or otherwise take a long time to complete (straight from RKM).
 *
 *    Apparently RemLibrary(lib) calls our expunge routine and would
 *    therefore freeze if we called it ourselves.  As far as I can tell
 *    from RKM, LibExpunge(lib) must remove the library itself as shown
 *    below.
 */

long LibExpunge( __A0 struct Library *lib )
{
    if( lib->lib_OpenCnt ) {

	lib->lib_Flags |= LIBF_DELEXP;
	return( NULL );
    }

    Remove( &lib->lib_Node );

    FreeMem(( char * )lib - lib->lib_NegSize, lib->lib_NegSize + lib->lib_PosSize );

    if( DOSBase ) {
	CloseLibrary( DOSBase );
	DOSBase = NULL;
    }

    if( IntuitionBase ) {
	CloseLibrary( IntuitionBase );
	IntuitionBase = NULL;
    }

    if( GfxBase ) {
	CloseLibrary( GfxBase );
	GfxBase = NULL;
    }

    if( GadToolsBase ) {
	CloseLibrary( GadToolsBase );
	GadToolsBase = NULL;
    }

    if( ReqToolsBase ) {
	CloseLibrary( ReqToolsBase );
	ReqToolsBase = NULL;
    }

    return(( long )SegList );
}
