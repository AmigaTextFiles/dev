/*-- AutoRev header do NOT edit!
*
*   Program         :   Resources.c
*   Copyright       :   © Copyright 1991 Jaba Development
*   Author          :   Jan van den Baard
*   Creation Date   :   21-Sep-91
*   Current version :   1.00
*   Translator      :   DICE v2.6
*
*   REVISION HISTORY
*
*   Date          Version         Comment
*   ---------     -------         ------------------------------------------
*   21-Sep-91     1.00            System resources routines.
*
*-- REV_END --*/

#include	"defs.h"

/*
 * External globals referenced.
 */
extern struct IntuitionBase *IntuitionBase;
extern struct GfxBase       *GfxBase;
extern struct CxBase        *CxBase;
extern struct IconBase      *IconBase;
extern struct UtilityBase   *UtilityBase;
extern struct AslBase       *AslBase;
extern APTR                  MainVisualInfo;
extern struct DrawInfo      *MainDrawInfo;
extern struct DiskfontBase  *DiskfontBase;


/*
 * --- Open the libraries. I don't use the DICE
 * --- auto-init possibility because I'de like
 * --- this source to be compatible with other
 * --- compilers.
 */
long OpenLibraries( void )
{
    if ( NOT( IntuitionBase = ( struct IntuitionBase * )
        OpenLibrary( "intuition.library", 36l )))
        return FALSE;
    if ( NOT( GfxBase = ( struct GfxBase * )
        OpenLibrary( "graphics.library", 36l )))
        return FALSE;
    if ( NOT( CxBase = ( struct CxBase * )
        OpenLibrary( "commodities.library", 36l )))
        return FALSE;
    if ( NOT( IconBase = ( struct IconBase * )
        OpenLibrary( "icon.library", 36l )))
        return FALSE;
    if ( NOT( UtilityBase = ( struct UtilityBase * )
        OpenLibrary( "utility.library", 36l )))
        return FALSE;
    if ( NOT( AslBase = ( struct AslBase * )
        OpenLibrary( "asl.library", 36l )))
        return FALSE;
    if ( NOT( DiskfontBase = ( struct DiskfontBase * )
        OpenLibrary( "diskfont.library", 36l )))
        return FALSE;
    if ( NOT( GadToolsBase = ( struct GadToolsBase * )
        OpenLibrary( "gadtools.library", 36l )))
        return FALSE;
    return TRUE;
}

/*
 * --- Close the libraries which are open.
 */
void CloseLibraries( void )
{
	if (GadToolsBase)	CloseLibrary( GadToolsBase );
    if ( DiskfontBase )         CloseLibrary( DiskfontBase );
    if ( AslBase )              CloseLibrary( AslBase );
    if ( UtilityBase )          CloseLibrary( UtilityBase );
    if ( IconBase )             CloseLibrary( IconBase );
    if ( CxBase )               CloseLibrary( CxBase );
    if ( GfxBase )              CloseLibrary( GfxBase );
    if ( IntuitionBase )        CloseLibrary( IntuitionBase );
}

/*
 * --- Get a screen it's font, drawinfo and visual info.
 */
long GetScreenInfo( struct Screen *screen )
{
    if ( NOT ( MainDrawInfo = GetScreenDrawInfo( screen )))
        return FALSE;
    if ( NOT ( MainVisualInfo = GetVisualInfo( screen, TAG_DONE )))
        return FALSE;
    return TRUE;
}

/*
 * --- Free a screen it's drawinfo and visual info.
 */
void FreeScreenInfo( struct Screen *screen )
{
    if ( MainDrawInfo ) {
        FreeScreenDrawInfo( screen , MainDrawInfo );
        MainDrawInfo = NULL;
    }
    if ( MainVisualInfo ) {
        FreeVisualInfo( MainVisualInfo );
        MainVisualInfo = NULL;
    }
}
