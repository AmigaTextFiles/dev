/*
**      $Filename: Support.c $
**      $Release: 1.0 $
**      $Revision: 38.1 $
**
**      GenGTXSource support routines.
**
**      (C) Copyright 1992 Jaba Development.
**          Written by Jan van den Baard.
**/

#include "GenGTXSource.h"

/*
 *      Exported routines.
 */
Prototype ULONG MyFPrintf( BPTR, UBYTE *, ... );
Prototype ULONG Print( UBYTE *, ... );
Prototype LONG SpecialRequest( UBYTE *, UBYTE *, ... );
Prototype struct Library *OpenDiskLibrary( UBYTE *, ULONG );

/*
 *      Perform formatted output to an AmigaDOS stream.
 */
ULONG MyFPrintf( BPTR stream, UBYTE *format, ... )
{
    va_list         arguments;
    ULONG           rc;

    va_start( arguments, format );

    rc = VFPrintf( stream, format, arguments );

    va_end( arguments );

    return( rc );
}

/*
 *      Print information on the console if:
 *          A) Where not running QUIET
 *          B) Where running quiet and it is an error
 */
ULONG Print( UBYTE *format, ... )
{
    va_list         arguments;
    ULONG           rc;

    va_start( arguments, format );

    if ( stdOut ) {
        if ( ! Arguments.Quiet || ! strncmp( format, STRING( MSG_ERROR ), strlen( STRING( MSG_ERROR ))))
            rc = VFPrintf( stdOut, format, arguments );
    }

    va_end( arguments );

    return( rc );
}

/*
 *      Put up a requester when a disk library failed to open.
 */
LONG SpecialRequest( UBYTE *gadgets, UBYTE *body, ... )
{
    static struct EasyStruct req = {
        sizeof( struct EasyRequest ), NULL, NULL, NULL, NULL };
    va_list                  args;
    LONG                     rc;

    va_start( args, body );

    req.es_Title        = "GenGTXSource";
    req.es_TextFormat   = body;
    req.es_GadgetFormat = gadgets;

    rc = EasyRequestArgs( NULL, &req, NULL, args );

    va_end( args );

    return( rc );
}

/*
 *      A special OpenLibrary routine.
 */
struct Library *OpenDiskLibrary( UBYTE *name, ULONG version )
{
    struct Library  *lib;
    LONG             ok;

    do {
        if ( ! ( lib = OpenLibrary( name, version )))
            ok = SpecialRequest( "Retry|Cancel", "%s V%ld++ failed to open!", name, version );
    } while( ! lib && ok );
    return( lib );
}
