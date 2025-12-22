
/*
 *  LIB.C
 *
 *  Basic Library Resource Handling
 *
 *  NOTE: all data declarations should be initialized since we skip
 *	  normal C startup code (unless initial value is don't care)
 *
 *  WARNING: arguments are passed in certain registers from the assembly
 *	  tag file, matched to how they are declared below.  Do not change
 *	  the argument declarations!
 */

#include <exec/lists.h>
#include "defs.h"
#include "producerwindow.h"
#include <clib/dos_protos.h>

Prototype LibCall Library *LibInit(long);
Prototype LibCall Library *LibOpen(long, Library *);
Prototype LibCall long LibClose(long, Library *);
Prototype LibCall long LibExpunge(long, Library *);


Library *LibBase = NULL;	/*  Library Base pointer    */
long	SegList  = 0;
long	SysBase  = NULL;	/*  EXEC calls		    */
long	DOSBase  = NULL;	/*  if we used it ...	    */
long	IFFParseBase  = NULL;	/*  if we used it ...	    */
long	UtilityBase  = NULL;	/*  if we used it ...	    */
long	IntuitionBase  = NULL;	/*  if we used it ...	    */
long	GadToolsBase  = NULL;	/*  if we used it ...	    */

/*
 *    The Initialization routine is given only a seglist pointer.  Since
 *    we are NOT AUTOINIT we must construct and add the library ourselves
 *    and return either NULL or the library pointer.  Exec has Forbid()
 *    for us during the call.
 *
 *    If you have an extended library structure you must specify the size
 *    of the extended structure in MakeLibrary().
 */

LibCall Library *
LibInit(segment)
long segment;
{
    Library *lib;
    static const long Vectors[] = {
	(long)ALibOpen,
	(long)ALibClose,
	(long)ALibExpunge,
	(long)ALibReserved,

	(long)GetProducer,
	(long)FreeProducer,
	
	(long)LoadDesignerData,
	(long)FreeDesignerData,
	
	(long)OpenProducerWindow,
	(long)CloseProducerWindow,
	(long)SetProducerWindowFileName,
	(long)SetProducerWindowAction,
	(long)SetProducerWindowLineNumber,
	(long)ProducerWindowUserAbort,
	(long)ProducerWindowWriteMain,
	
	(long)AddLocaleString,
	(long)FreeLocaleStrings,
	(long)WriteLocaleCT,
	(long)WriteLocaleCD,
	-1
    };
    
    SysBase = *(long *)4;
    DOSBase = OpenLibrary("dos.library", 0);
	if (DOSBase == NULL)
		return(NULL);
	IFFParseBase = OpenLibrary("iffparse.library", 0);
	if (IFFParseBase == NULL)
		{
		CloseLibrary((struct Library *)DOSBase);
		DOSBase = NULL;
		return(NULL);
		}
    UtilityBase = OpenLibrary("utility.library", 0);
	if (UtilityBase == NULL)
		{
		CloseLibrary((struct Library *)DOSBase);
		DOSBase = NULL;
	    CloseLibrary((struct Library *)IFFParseBase);
	    IFFParseBase = NULL;
		return(NULL);
        }
    GadToolsBase = OpenLibrary("gadtools.library", 0);
	if (GadToolsBase == NULL)
		{
		CloseLibrary((struct Library *)UtilityBase);
		UtilityBase = NULL;
		CloseLibrary((struct Library *)DOSBase);
		DOSBase = NULL;
	    CloseLibrary((struct Library *)IFFParseBase);
	    IFFParseBase = NULL;
		return(NULL);
        }
    IntuitionBase = OpenLibrary("intuition.library", 0);
	if (IntuitionBase == NULL)
		{
		CloseLibrary((struct Library *)GadToolsBase);
		GadToolsBase = NULL;
		CloseLibrary((struct Library *)UtilityBase);
		UtilityBase = NULL;
		CloseLibrary((struct Library *)DOSBase);
		DOSBase = NULL;
	    CloseLibrary((struct Library *)IFFParseBase);
	    IFFParseBase = NULL;
		return(NULL);
        }
   if ( MakeImages() != 0)
   		{
   		CloseLibrary((struct Library *)IntuitionBase);
		IntuitionBase = NULL;
   		CloseLibrary((struct Library *)GadToolsBase);
		GadToolsBase = NULL;
		CloseLibrary((struct Library *)UtilityBase);
		UtilityBase = NULL;
		CloseLibrary((struct Library *)DOSBase);
		DOSBase = NULL;
	    CloseLibrary((struct Library *)IFFParseBase);
	    IFFParseBase = NULL;
		return(NULL);
   		}
    LibBase = lib = MakeLibrary((APTR)Vectors,NULL,NULL,sizeof(Library),NULL);
    if ( lib )
    	{
	    lib->lib_Node.ln_Type = NT_LIBRARY;
   		lib->lib_Node.ln_Name = LibName;
   	 	lib->lib_Flags = LIBF_CHANGED|LIBF_SUMUSED;
   	 	lib->lib_Version  = 1;
   		lib->lib_Revision = 54;
   	 	lib->lib_IdString = (APTR)LibId;
   		SegList = segment;
   		AddLibrary(lib);
	    InitC();
		}
    return(lib);
}

/*
 *    Open is given the library pointer and the version request.  Either
 *    return the library pointer or NULL.  Remove the DELAYED-EXPUNGE flag.
 *    Exec has Forbid() for us during the call.
 */

LibCall Library *
LibOpen(version, lib)
Library *lib;
long version;
{
    ++lib->lib_OpenCnt;
    lib->lib_Flags &= ~LIBF_DELEXP;
    return(lib);
}

/*
 *    Close is given the library pointer and the version request.  Be sure
 *    not to decrement the open count if already zero.	If the open count
 *    is or becomes zero AND there is a LIBF_DELEXP, we expunge the library
 *    and return the seglist.  Otherwise we return NULL.
 *
 *    Note that this routine never sets LIBF_DELEXP on its own.
 *
 *    Exec has Forbid() for us during the call.
 */

LibCall long
LibClose(dummy, lib)
long dummy;
Library *lib;
{
    if (lib->lib_OpenCnt && --lib->lib_OpenCnt)
	return(NULL);
    if (lib->lib_Flags & LIBF_DELEXP)
	return(LibExpunge(0, lib));
    return(NULL);
}

/*
 *    We expunge the library and return the Seglist ONLY if the open count
 *    is zero.	If the open count is not zero we set the DELAYED-EXPUNGE
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

LibCall long
LibExpunge(dummy, lib)
long dummy;
Library *lib;
{
    if (lib->lib_OpenCnt) {
	lib->lib_Flags |= LIBF_DELEXP;
	return(NULL);
    }
    Remove(&lib->lib_Node);
    FreeMem((char *)lib-lib->lib_NegSize, lib->lib_NegSize+lib->lib_PosSize);
    if (DOSBase) {
	CloseLibrary((Library *)DOSBase);
	DOSBase = NULL;
    }
    FreeImages();
    if (IFFParseBase) {
	CloseLibrary((Library *)IFFParseBase);
	IFFParseBase = NULL;
    }
	if (UtilityBase) {
	CloseLibrary((Library *)UtilityBase);
	UtilityBase = NULL;
    }
    if (IntuitionBase) {
	CloseLibrary((Library *)IntuitionBase);
	IntuitionBase = NULL;
    }
	if (GadToolsBase) {
	CloseLibrary((Library *)GadToolsBase);
	GadToolsBase = NULL;
    }

    UnInitC();
    return((long)SegList);
}

