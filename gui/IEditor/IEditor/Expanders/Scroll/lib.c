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

#include "DEV_IE:Expanders/defs.h"

extern __geta4 struct Library *LibInit   ( __A0 BPTR );
extern __geta4 struct Library *LibOpen   ( __D0 long, __A0 struct Library * );
extern __geta4 long            LibClose  ( __A0 struct Library * );
extern __geta4 long            LibExpunge( __A0 struct Library * );

struct Expander *LibBase = NULL;

long SysBase        = NULL;
long DOSBase        = NULL;
long IntuitionBase  = NULL;
long GfxBase        = NULL;
long GadToolsBase   = NULL;
BPTR SegList        = 0;
UBYTE *Desc         = NULL;

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

	(long)ALibOpen,         /*  standard lib functions    */
	(long)ALibClose,
	(long)ALibExpunge,
	(long)ALibReserved,

	(long)IEX_Mount,        /*  mount function            */

	(long)IEX_Add,          /*  edit functions            */
	(long)IEX_Remove,
	(long)IEX_Edit,
	(long)IEX_Copy,
	(long)IEX_Make,
	(long)IEX_Free,
	(long)IEX_Refresh,

	(long)IEX_Save,         /*  I/O functions             */
	(long)IEX_Load,

	(long)IEX_StartSrcGen,  /*  source related functions  */
	(long)IEX_WriteGlobals, 
	(long)IEX_WriteSetup,
	(long)IEX_WriteCloseDown,
	(long)IEX_WriteHeaders,
	(long)IEX_WriteRender,
	(long)IEX_GetIDCMP,
	(long)IEX_WriteData,
	(long)IEX_WriteChipData,
	(long)IEX_WriteOpenWnd,
	(long)IEX_WriteCloseWnd,
	-1
    };

    SysBase = *(long *)4;

    if( DOSBase = OpenLibrary( "dos.library", 36 )) {
	if( IntuitionBase = OpenLibrary( "intuition.library", 36 )) {
	    if( GfxBase = OpenLibrary( "graphics.library", 36 )) {
		if( GadToolsBase = OpenLibrary( "gadtools.library", 36 )) {

		    if( LibBase = lib = MakeLibrary( (APTR)Vectors, NULL, NULL, sizeof( struct Expander ), NULL )) {

			lib->lib_Node.ln_Type = NT_LIBRARY;
			lib->lib_Node.ln_Name = LibName;
			lib->lib_Flags        = LIBF_CHANGED | LIBF_SUMUSED;
			lib->lib_Version      = 37;
			lib->lib_Revision     = 0;
			lib->lib_IdString     = (APTR)LibId;

			SegList = segment;

			AddLibrary( lib );
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
	CloseLibrary( (struct Library *)DOSBase );
	DOSBase = NULL;
    }

    if( IntuitionBase ) {
	CloseLibrary( (struct Library *)IntuitionBase );
	IntuitionBase = NULL;
    }

    if( GfxBase ) {
	CloseLibrary( (struct Library *)GfxBase );
	GfxBase = NULL;
    }

    if( GadToolsBase ) {
	CloseLibrary( (struct Library *)GadToolsBase );
	GadToolsBase = NULL;
    }

    if( Desc ) {          /* free the descriptions file  */
	FreeVec( Desc );  /* loaded by IEX_Mount         */
	Desc = NULL;
    }

    return(( long )SegList );
}
