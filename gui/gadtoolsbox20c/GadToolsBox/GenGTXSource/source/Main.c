/*
**      $Filename: Main.c $
**      $Release: 1.0 $
**      $Revision: 38.1 $
**
**      GenGTXSource main source file.
**
**      (C) Copyright 1992 Jaba Development.
**          Written by Jan van den Baard
**/

#include "GenGTXSource.h"

/*
 *      Get the necessary resources.
 */
Local BOOL GetResources( void )
{
    UWORD           n;

    NewList(( struct List * )&Strings );
    NewList(( struct List * )&Arrays );

    LocaleBase = ( struct LocaleBase * )OpenLibrary( "locale.library", 38L );

   /*
    *       Setup catalog.
    */
    if ( LocaleBase ) {
        if ( Catalog = OpenCatalog( NULL, "GenGTXSource.catalog", OC_BuiltInLanguage, "english",
                                                                  OC_Version,         1,
                                                                  TAG_END )) {
            for( n = 0; n < NumAppStrings; n++ )
                AppStrings[ n ].as_Str = GetCatalogStr( Catalog, n, AppStrings[ n ].as_Str );
        }
    }

   /*
    *       Open the libraries.
    */
    if ( ! ( IntuitionBase = ( struct IntuitionBase * )OpenLibrary( "intuition.library", 37L ))) {
        Print( STRING( MSG_INTUITION_ERROR ));
        return( FALSE );
    }

    if ( ! ( GTXBase = ( struct GTXBase * )OpenDiskLibrary( GTXNAME, GTXVERSION ))) {
        Print( STRING( MSG_GTX_ERROR ));
        return( FALSE );
    }

    GfxBase         =   ( struct Library * )GTXBase->GfxBase;
    NoFragBase      =   GTXBase->NoFragBase;
    GadToolsBase    =   GTXBase->GadToolsBase;
    UtilityBase     =   GTXBase->UtilityBase;

   /*
    *       Get a MemoryChain.
    */
    if ( ! ( Chain = GetMemoryChain( 4096L ))) {
        Print( STRING( MSG_OUT_OF_MEMORY ));
        return( FALSE );
    }
}

/*
 *      Free the used resources.
 */
Local VOID FreeResources( void )
{
   /*
    *       Close the libraries and dellocate the memory.
    */
    if ( GTXBase ) {
        FreeDuplicates();
        if ( Chain )            FreeMemoryChain( Chain, TRUE );
        CloseLibrary(( struct Library * )GTXBase );
    }

    if ( IntuitionBase )    CloseLibrary(( struct Library * )IntuitionBase );

   /*
    *       Close up locale stuff.
    */
    if ( LocaleBase ) {
        if ( Catalog )      CloseCatalog( Catalog );
        CloseLibrary(( struct Library * )LocaleBase );
    }
}

/*
 *      Main entry point.
 */
LONG _main( void )
{
    LONG error = 0;

    stdOut = Output();

    if ( GetResources()) {
        if ( SArgs = ReadArgs( Template, (LONG *)&Arguments, NULL )) {
            Print( "GenGTXSource 1.0 - (C) Copyright 1992 Jaba Development\n\t%s Jan van den Baard\n", STRING( MSG_BY ));
            Print( STRING( MSG_LOADING ));
            if ( ! ( error = GTX_LoadGUI( Chain, Arguments.Name, RG_GUI,            &GuiInfo,
                                                                 RG_Config,         &MainConfig,
                                                                 RG_CConfig,        &SourceConfig,
                                                                 RG_WindowList,     &Windows,
                                                                 RG_Valid,          &ValidBits,
                                                                 TAG_END ))) {
                Generate();
                Print( STRING( MSG_DONE ));
            } else {
                switch ( error ) {
                    case    ERROR_NOMEM:
                        Print( STRING( MSG_OUT_OF_MEMORY ));
                        break;
                    case    ERROR_OPEN:
                        Print( STRING( MSG_OPEN_FILE_ERROR ));
                        break;
                    case    ERROR_READ:
                        Print( STRING( MSG_READ_ERROR ));
                        break;
                    case    ERROR_WRITE:
                        Print( STRING( MSG_WRITE_ERROR ));
                        break;
                    case    ERROR_PARSE:
                        Print( STRING( MSG_PARSE_ERROR ));
                        break;
                    case    ERROR_PACKER:
                        Print( STRING( MSG_DECRUNCH_ERROR ));
                        break;
                    case    ERROR_PPLIB:
                        Print( STRING( MSG_PPLIB_ERROR ));
                        break;
                    case    ERROR_NOTGUIFILE:
                        Print( STRING( MSG_NOT_GUI_FILE_ERROR ));
                        break;
                }
                error = 0;
            }
            GTX_FreeWindows( Chain, &Windows );
            FreeArgs( SArgs );
        } else
            PrintFault( error = IoErr(), STRING( MSG_ERROR ));
    }

    FreeResources();

    _exit( error );
}
