/****h* GTBScanner.c [2.2] *********************************************
*
* NAME
*    GTBScanner.c 
*
* DESCRIPTION
*    Parse through a GadToolsBox .gui file & send the output data to
*    the specified .ini output fileName.
* 
* SYNOPSIS 
*    GTBScanner <inputFile.gui> <outputFile.ini>
*
* HISTORY
*    01-Nov-2004 - Added AmigaOS4 & gcc support.
*    24-Sep-2003 - Removed IniFuncs from this file & replaced it with
*                  stdio FILE functions.
* NOTES
*    Derived from CData:Graphics/NewIFF/ilbmscan.c
*
*    $VER: GTBScanner.c 2.2 (01-Nov-2004) by J.T. Steichen
************************************************************************
*
*/

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include <exec/types.h>
#include <exec/memory.h>

#include <AmigaDOSErrs.h>

#include <libraries/dos.h>
#include <libraries/gadtools.h>
#include <libraries/iffparse.h>

#ifndef __amigaos4__

# include <clib/exec_protos.h>
# include <clib/dos_protos.h>
# include <clib/iffparse_protos.h>

# include <proto/locale.h>

PRIVATE struct Library    *IFFParseBase = NULL;

IMPORT struct LocaleBase  *LocaleBase;

#else

# define __USE_INLINE__

# include <proto/dos.h>
# include <proto/exec.h>
# include <proto/iffparse.h>
# include <proto/locale.h>

IMPORT struct Library *SysBase;
IMPORT struct Library *DOSBase;
IMPORT struct Library *LocaleBase;
IMPORT struct Library *IFFParseBase;

PUBLIC struct Library *GadToolsBase; //  For CommonFuncsPPC.o 

IMPORT struct ExecIFace     *IExec;
IMPORT struct DOSIFace      *IDOS;
IMPORT struct LocaleIFace   *ILocale;
IMPORT struct IFFParseIFace *IIFFParse;

PUBLIC struct GadToolsIFace *IGadTools;

#endif

#include <graphics/rastport.h> // for JAM1, JAM2, etc

#include <StringFunctions.h>

PUBLIC struct Catalog *scanCatalog = NULL;

#define   CATCOMP_ARRAY    1
#include "GTBProjectLocale.h"

#define  MY_LANGUAGE "english"

#include "GadToolsBoxIFFs.h"

#include "CPGM:GlobalObjects/CommonFuncs.h"

/* Moved into CommonFuncs.h file!
#ifdef   DEBUG
# define DBG(p) p
#else
# define DBG(p)
#endif

#define BUFF_SIZE 512
*/

// ----------------------------------------------------

PRIVATE char em[BUFF_SIZE] = { 0, }, *ErrMsg = &em[0];

PRIVATE char *usage = NULL; // "Usage: %s IFFfilename outputFileName\n";

/*
** Text error messages for possible IFFERR_#? returns from various
** IFF routines.  To get the index into this array, take your IFFERR code,
** negate it, and subtract one:
**
**        idx = -error - 1;
*/

PRIVATE char errIFF[13][80] = {

   "IFF ERROR: End of file (not an error).",
   "IFF ERROR: End of context (not an error).",
   "IFF ERROR: No lexical scope.",
   "IFF ERROR: Insufficient memory.",
   "IFF ERROR: Stream read error.",
   "IFF ERROR: Stream write error.",
   "IFF ERROR: Stream seek error.",
   "IFF ERROR: File is corrupt.",
   "IFF ERROR: IFF syntax error.",
   "IFF ERROR: Not an IFF file.",
   "IFF ERROR: Required call-back hook missing.",
   "IFF ERROR: Return to client.  You should never see this.",
   0, // NULL
};

PRIVATE char inFileName[BUFF_SIZE]    = "Unnamed.gui";         // argv[1]
PRIVATE char outFileName[BUFF_SIZE]   = "Unnamed.st";          // argv[2]
PRIVATE char GeneratorName[BUFF_SIZE] = "AmigaTalk:c/GTBGenC"; // argv[3]

PRIVATE struct IFFHandle *iff     = (struct IFFHandle *) NULL; // Input   IFF stream
PRIVATE FILE             *outFile =             (FILE *) NULL; // Output .ini file.

// ----------------------------------------------------------------

//#ifdef LATTICE
//int CXBRK(    void ) { return( 0 ); } // Disable Lattice CTRL/C handling
//int chkabort( void ) { return( 0 ); } // really
//#endif

// ---------------------------------------------------------------

PRIVATE void SetupChunks( void )
{
   // We want to collect these chunks:

   PropChunk( iff, ID_GXUI, ID_GGUI );
   PropChunk( iff, ID_PREF, ID_PRHD ); // Probably will be deleted
   PropChunk( iff, ID_PRHD, ID_GTCO );
   PropChunk( iff, ID_PRHD, ID_GENC );
   PropChunk( iff, ID_PRHD, ID_GENA );
   
   CollectionChunk( iff, ID_GXWD, ID_WDDA );
   CollectionChunk( iff, ID_GXBX, ID_BBOX );
   CollectionChunk( iff, ID_GXTX, ID_ITXT );
   CollectionChunk( iff, ID_GXGA, ID_GADA );
   CollectionChunk( iff, ID_GXMN, ID_MEDA );

   StopOnExit( iff, ID_GXUI, ID_GGUI );
   StopOnExit( iff, ID_PREF, ID_PRHD );
   StopOnExit( iff, ID_PRHD, ID_GTCO );
   StopOnExit( iff, ID_PRHD, ID_GENC );
   StopOnExit( iff, ID_PRHD, ID_GENA );
   StopOnExit( iff, ID_GXWD, ID_WDDA );
   StopOnExit( iff, ID_GXBX, ID_BBOX );
   StopOnExit( iff, ID_GXTX, ID_ITXT );
   StopOnExit( iff, ID_GXGA, ID_GADA );
   StopOnExit( iff, ID_GXMN, ID_MEDA );
   
   return;
}

/****i* CMsg() [1.0] *************************************************
*
* NAME
*    CMsg()
*
* DESCRIPTION
*    Obtain a string from the locale catalog file, failing that,
*    return the default string.
**********************************************************************
*
*/

PRIVATE STRPTR CMsg( int strIndex, char *defaultString )
{
   if (scanCatalog && LocaleBase) // != NULL)
      return( (STRPTR) GetCatalogStr( scanCatalog, strIndex, defaultString ) );
   else
      return( (STRPTR) defaultString );
}

/****i* RewindFile() [1.0] *******************************************
*
* NAME
*    void RewindFile( FILE *filePtr );
*
* DESCRIPTION
*    Rewind the file to it's logical beginning.
**********************************************************************
*
*/

SUBFUNC void RewindFile( FILE *filePtr )
{
   int  location;

   if (!filePtr)
	   return;
		
   location = fseek( filePtr, 0, SEEK_CUR ); // Seek( filePtr, 0, OFFSET_CURRENT );     // Where are we?

   (void) fseek( filePtr, -location, SEEK_CUR ); // Seek( filePtr, -location, OFFSET_CURRENT ); // rewind this much.
   
   return;
}

/****i* WindFile() [1.0] *********************************************
*
* NAME
*    void WindFile( FILE *filePtr );
*
* DESCRIPTION
*    Wind the file to it's logical end.
**********************************************************************
*
*/

SUBFUNC void WindFile( FILE *filePtr )
{
	if (filePtr)
      (void) fseek( filePtr, 0, SEEK_END ); // wind this much.
   
   return;
}

// --------- .ini Translator section: -------------------------------------

/****i* fontName() [1.0] *************************************
* 
* NAME
*    fontName()
*
* DESCRIPTION
*    Filter out any .font extensions that might be present in
*    the font name supplied.
**************************************************************
*
*/

PRIVATE char fn[BUFF_SIZE], *FontName = &fn[0];

SUBFUNC char *fontName( char *fname )
{
   int i = 0, len = StringLength( fname );

   DBG( fprintf( stderr, "GTBScanner: Entering fontName( %s )...\n", fname ) );

   if (len > BUFF_SIZE)
	   {
		StringCopy( FontName, "topaz" );
      DBG( fprintf( stderr, "GTBScanner: fontName( %s ) BOUGS, using %s instead!\n", fname, FontName ) );
		}   
   else
	   {

      while (i < len && *(fname + i) != '.' && *(fname + i) != '\0')
         {
         *(FontName + i) = *(fname + i);
      
         i++;
         }
   
      *(FontName + i) = '\0';
	   }

   DBG( fprintf( stderr, "GTBScanner: Exiting fontName() = \"%s\".\n", FontName ) );
   
   return( FontName );
}

PRIVATE char const *tempName = "RAM:TempScan.ini";

PRIVATE BOOL printedCSI = FALSE;

SUBFUNC void PrintScreenInfo( struct projectChunk *pc )
{
   FILE *scrFile = MYNULL;

   DBG( fprintf( stderr, "GTBScanner: Entering PrintScreenInfo()...\n" ) );   

   if (printedCSI == FALSE)
      {
      if (!(scrFile = fopen( tempName, "w" )))
         {
         sprintf( ErrMsg, CMsg( MSG_FMT_NO_TEMPFILE, 
                                MSG_FMT_NO_TEMPFILE_STR ), 
                                IoErr() 
                );

         UserInfo( ErrMsg, CMsg( MSG_GTBP_SYSTEM_PROBLEM,
                                 MSG_GTBP_SYSTEM_PROBLEM_STR ) 
                 );

         return;
         }

      fprintf( scrFile, "%s\n", CMsg( MSG_GRP_SDATATAGS, MSG_GRP_SDATATAGS_STR ) );

      fprintf( scrFile, "SA_ScreenTitle  = %s\n",      pc->pc_ScreenTagsTitle );
      fprintf( scrFile, "SA_Width        = %d\n",      pc->pc_ScrWidth        );
      fprintf( scrFile, "SA_Height       = %d\n",      pc->pc_ScrHeight       );
      fprintf( scrFile, "SA_DisplayID    = 0x%08LX\n", pc->pc_ScreenModeID    );

      fprintf( scrFile, "ScreenFontName  = %s\n",      fontName( (char *) pc->pc_FontName ) );

      fprintf( scrFile, "ScreenFontSize  = %d\n",      pc->pc_FontSize        );

      fclose( scrFile );

      printedCSI = TRUE; // Execute the code once-only!
      }

   DBG( fprintf( stderr, "GTBScanner:  Exiting PrintScreenInfo().\n" ) );

   return;
}

SUBFUNC void PrintAuthorInfo( struct authorChunk *ac )
{
   DBG( fprintf( stderr, "GTBScanner:  Entering PrintAuthorInfo()...\n" ) );   

   fprintf( stderr, "Author (GTCO) Chunk contains:\n" );

   fprintf( stderr, "  Author  : %-64.64s\n", ac->ac_AuthorName );
   fprintf( stderr, "  IconPath: %-128.128s\n\n", ac->ac_IconPathName );

   DBG( fprintf( stderr, "GTBScanner:  Exiting PrintAuthorInfo().\n" ) );   

   return;
}

SUBFUNC void PrintCGenInfo( struct gencChunk *gc )
{
   DBG( fprintf( stderr, "GTBScanner:  Entering PrintCGenInfo()...\n" ) );   

   fprintf( stderr, "Generate C (GENC) Chunk contains:\n" );

   fprintf( stderr, "  Author    : %-64.64s\n", gc->gcc_AuthorName );
   fprintf( stderr, "  IconPath  : %-128.128s\n\n", gc->gcc_IconPathName );
   fprintf( stderr, "  CheckBoxes: 0x%04LX\n\n", gc->gcc_CheckBoxes );

   DBG( fprintf( stderr, "GTBScanner:  Exiting PrintCGenInfo().\n" ) );   

   return;
}

SUBFUNC void PrintAssyGenInfo( struct genaChunk *gac )
{
   DBG( fprintf( stderr, "GTBScanner:  Entering PrintAssyGenInfo()...\n" ) );   

   fprintf( stderr, "Generate Assy (GENA) Chunk contains:\n" );

   fprintf( stderr, "  Author    : %-64.64s\n", gac->gac_AuthorName );
   fprintf( stderr, "  IconPath  : %-128.128s\n\n", gac->gac_IconPathName );
   fprintf( stderr, "  CheckBoxes: 0x%04LX\n\n", gac->gac_CheckBoxes );

   DBG( fprintf( stderr, "GTBScanner:  Exiting PrintAssyGenInfo().\n" ) );   

   return;
}

/****i* appendScreenInfo() [] **************************************************************
*
* NAME
*    appendScreenInfo()
*
* DESCRIPTION
*    Read what the Scanner placed in the temp file for the Screen information and write it
*    to the output file 'out'.
********************************************************************************************
*
*/

SUBFUNC int appendScreenInfo( FILE *outFile, char const *tempFile )
{
   FILE *scrFile   = fopen( tempFile, "r" );
   char  buff[BUFF_SIZE] = { 0, };

   DBG( fprintf( stderr, "GTBScanner:  Entering appendScreenInfo()...\n" ) );   

   if (!scrFile)
      {
      sprintf( ErrMsg, CMsg( MSG_FMT_TEMPFILE_DEL, MSG_FMT_TEMPFILE_DEL_STR ), 
                       tempFile 
             );
      
      UserInfo( ErrMsg, CMsg( MSG_GTBP_SYSTEM_PROBLEM,
                              MSG_GTBP_SYSTEM_PROBLEM_STR )
              ); 

      return( IoErr() );
      }

   fgets( buff, BUFF_SIZE, scrFile ); // Get Screen Group Tag
   fputs( buff, outFile );
   
   fgets( buff, BUFF_SIZE, scrFile ); // Get first item
   fputs( buff, outFile );

   fgets( buff, BUFF_SIZE, scrFile ); // Get second item
   fputs( buff, outFile );

   fgets( buff, BUFF_SIZE, scrFile ); // Get third item
   fputs( buff, outFile );

   fgets( buff, BUFF_SIZE, scrFile ); // Get fourth item
   fputs( buff, outFile );

   fgets( buff, BUFF_SIZE, scrFile ); // Get fifth item
   fputs( buff, outFile );

   fgets( buff, BUFF_SIZE, scrFile ); // Get last item
   fputs( buff, outFile );

   fclose( scrFile );

   DBG( fprintf( stderr, "GTBScanner:  Exiting appendScreenInfo().\n" ) );   

   return( RETURN_OK );
}

PRIVATE char longFName[BUFF_SIZE] = { 0, };
PRIVATE int  pCount         = 0;

SUBFUNC char *MakeUniqueFileName( char *fileName, char *projectName )
{
   char  count[20] = { 0, };
   char *fname     = fileName;
   int   i         = 0;

   DBG( fprintf( stderr, "GTBScanner:  Entering MakeUniqueFileName( %s, %s )...\n", fileName, projectName ) );

   if (StringLength( fileName ) > BUFF_SIZE)
	   {
		fileName[BUFF_SIZE - 1] = '\0'; // Prevent a buffer overflow!
		}

   sprintf( &longFName[0], "%s", fileName );

   while (*fname != '.' && *fname != '\0')
      {
      fname++;
      i++;
      }
   
   longFName[i] = '\0'; // Clip off everything after the first '.'
   
   itoa( pCount++, count );
   
   strncat( longFName, projectName, BUFF_SIZE );
   strncat( longFName, count,       BUFF_SIZE );
   strncat( longFName, ".ini",      BUFF_SIZE );

   DBG( fprintf( stderr, "GTBScanner:  Exiting MakeUniqueFileName( %s ).\n", longFName ) );

   return( &longFName[0] );
}

// -------- Send out some data to the outFileName:

PRIVATE BOOL printedCWI     = FALSE;
PRIVATE char prevCPrj[64]   = { 0, };

SUBFUNC void PrintWindowInfo( struct winChunk *wc )
{
   IMPORT void MassageFileName( char *fname );
   IMPORT int  getProjectInfo( char *prjName, char *fileName );

   char  buff[BUFF_SIZE] = { 0, };   
   char *realFileName = NULL;
   
   DBG( fprintf( stderr, "GTBScanner:  Entering PrintWindowInfo()...\n" ) );   

   if (StringLength( prevCPrj ) > 1 && StringNComp( prevCPrj, (char *) wc->wc_ProjectName, 33 ) != 0)
      {
      // More than one project in the input .gui file, so we need to
      // kludge the project name onto the fileName:
      realFileName = MakeUniqueFileName( outFileName, (char *) wc->wc_ProjectName );
      }
   else
      realFileName = &outFileName[0];
            
   if (printedCWI == FALSE || StringNComp( prevCPrj, (char *) wc->wc_ProjectName, 33 ) != 0)
      {
      // First, create the Project Group & Items:

      if (getProjectInfo( (char *) wc->wc_ProjectName, realFileName ) != RETURN_OK)
         {
         return; // getProjectInfo() already showed an ERROR Requester!
         }

      MassageFileName( realFileName ); // Ensure a .ini extension

      // Open the file getProjectInfo() just created:

      if (!(outFile = fopen( realFileName, "a+" ))) // Open( realFileName, MODE_OLDFILE )))
         {
         sprintf( ErrMsg, CMsg( MSG_FMT_FILEUNOPENED, MSG_FMT_FILEUNOPENED_STR ),
                                realFileName
                );
         
         UserInfo( ErrMsg, CMsg( MSG_GTBP_SYSTEM_PROBLEM, 
                                 MSG_GTBP_SYSTEM_PROBLEM_STR ) );
         return;
         }

      WindFile( outFile ); // Move to the end of the file.

      // Add the Screen Group & Items from the temporary file:
                
      (void) appendScreenInfo( outFile, tempName );

      // Now add the Window Group & Items:

      sprintf( buff, "%s\n", CMsg( MSG_GRP_WDATATAGS, MSG_GRP_WDATATAGS_STR ));
      fputs( buff, outFile );

      sprintf( buff, "WA_CustomScreen = %sScr\n", wc->wc_ProjectName );
      fputs( buff, outFile );
      
      sprintf( buff, "WA_Title        = %s\n",    wc->wc_WindowTitle );
      fputs( buff, outFile );

      sprintf( buff, "WA_ScreenTitle  = %s\n",    wc->wc_ScreenTitle );
      fputs( buff, outFile );
      
      sprintf( buff, "WA_IDCMP        = 0x%08LX\n", wc->wc_IDCMPFlags );
      fputs( buff, outFile );

      sprintf( buff, "WA_Flags        = 0x%08LX\n", wc->wc_Flags );
      fputs( buff, outFile );
          
      if ((wc->wc_InnerFlags & 0x8) == 8)
         {
         sprintf( buff, "WA_MouseQueue   = %d\n", wc->wc_MouseQueue );
         fputs( buff, outFile );
         }

      if ((wc->wc_InnerFlags & 0x10) == 0x10)
         {
         sprintf( buff, "WA_RptQueue     = %d\n", wc->wc_ReportQueue );
         fputs( buff, outFile );
         }

      if ((wc->wc_InnerFlags & 1) == 1)
         {
         sprintf( buff, "WA_InnerWidth   = %d\n", wc->wc_InnerWidth );
         fputs( buff, outFile );
         }

      if ((wc->wc_InnerFlags & 2) == 2)
         {
         sprintf( buff, "WA_InnerHeight  = %d\n", wc->wc_InnerHeight );
         fputs( buff, outFile );
         }

      if ((wc->wc_InnerFlags & 0x80) == 0x80)
         {
         sprintf( buff, "WA_PubScreenFallBack = 1\n" );
         fputs( buff, outFile );
         }

      if ((wc->wc_InnerFlags & 0x20) == 0x20)
         {
         sprintf( buff, "WA_AutoAdjust   = 1\n" );
         fputs( buff, outFile );
         }

      sprintf( buff, "WA_Left         = %d\n", wc->wc_Tags[0].ti_Data );
      fputs( buff, outFile );

      sprintf( buff, "WA_Top          = %d\n", wc->wc_Tags[1].ti_Data );
      fputs( buff, outFile );

      sprintf( buff, "WA_Width        = %d\n", wc->wc_Tags[2].ti_Data );
      fputs( buff, outFile );

      sprintf( buff, "WA_Height       = %d\n", wc->wc_Tags[3].ti_Data );
      fputs( buff, outFile );

      sprintf( buff, "WA_MinWidth     = %d\n", wc->wc_Tags[8].ti_Data );
      fputs( buff, outFile );

      sprintf( buff, "WA_MinHeight    = %d\n", wc->wc_Tags[9].ti_Data );
      fputs( buff, outFile );

      sprintf( buff, "WA_MaxWidth     = %d\n", wc->wc_Tags[10].ti_Data );
      fputs( buff, outFile );
          
      sprintf( buff, "WA_MaxHeight    = %d\n", wc->wc_Tags[11].ti_Data );
      fputs( buff, outFile );
          
      sprintf( buff, "WA_NewLookMenus = %d\n", wc->wc_Tags[13].ti_Data );
      fputs( buff, outFile );

      // Insure one & only one pass for each Project window:
      printedCWI = TRUE;

      StringNCopy( prevCPrj, (char *) wc->wc_ProjectName, 33 );
      }

   DBG( fprintf( stderr, "GTBScanner:  Exiting PrintWindowInfo().\n" ) );   

   return;
}

SUBFUNC void PrintBevelBoxInfo( struct bevelChunk *bc )
{
   char buff[BUFF_SIZE] = { 0, };

   DBG( fprintf( stderr, "GTBScanner:  Entering PrintBevelBoxInfo()...\n" ) );   

   sprintf( buff, "%s\n", CMsg( MSG_GRP_BDATATAGS, MSG_GRP_BDATATAGS_STR ));      
   fputs( buff, outFile );

   sprintf( buff, "BBOX_LeftEdge = %d\n", bc->bc_LeftEdge );
   fputs( buff, outFile );

   sprintf( buff, "BBOX_TopEdge  = %d\n", bc->bc_TopEdge );
   fputs( buff, outFile );

   sprintf( buff, "BBOX_Width    = %d\n", bc->bc_Width   );
   fputs( buff, outFile );

   sprintf( buff, "BBOX_Height   = %d\n", bc->bc_Height );
   fputs( buff, outFile );

   sprintf( buff, "BBOX_Type     = %d\n", bc->bc_Flags  );
   fputs( buff, outFile );

   DBG( fprintf( stderr, "GTBScanner:  Exiting PrintBevelBoxInfo().\n" ) );   
      
   return;
}

SUBFUNC void PrintIntuiTextInfo( struct intuiChunk *tc )
{
   char buff[BUFF_SIZE] = { 0, };
   
   DBG( fprintf( stderr, "GTBScanner:  Entering PrintIntuiTextInfo()...\n" ) );   

   sprintf( buff, "%s\n", CMsg( MSG_GRP_IDATATAGS, MSG_GRP_IDATATAGS_STR ));      
   fputs( buff, outFile );

   sprintf( buff, "IT_FrontPen = %d\n", tc->ic_FrontPen );
   fputs( buff, outFile );

   sprintf( buff, "IT_BackPen  = %d\n", tc->ic_BackPen );
   fputs( buff, outFile );

   sprintf( buff, "IT_LeftEdge = %d\n", tc->ic_LeftEdge );
   fputs( buff, outFile );

   sprintf( buff, "IT_TopEdge  = %d\n", tc->ic_TopEdge );
   fputs( buff, outFile );

   sprintf( buff, "IT_DrawMode = %d\n", tc->ic_DrawMode );
   fputs( buff, outFile );

   sprintf( buff, "IT_Text     = %s\n", tc->ic_IText );
   fputs( buff, outFile );

   DBG( fprintf( stderr, "GTBScanner:  Exiting PrintIntuiTextInfo().\n" ) );   
      
   return;
}

   /* The number of Tags required by each Gadget Type is not the same.
   ** This is how many each Kind of GadTools Gadget uses in GadToolsBox:
   **
   **   GENERIC_KIND:    1
   **   BUTTON_KIND:     2
   **   CHECKBOX_KIND:   3
   **   INTEGER_KIND:    8
   **   LISTVIEW_KIND:   6
   **   MX_KIND:         4
   **   NUMBER_KIND:     3
   **   CYCLE_KIND:      4
   **   PALETTE_KIND:    8
   **   SCROLLER_KIND:   10
   **   SLIDER_KIND:     11
   **   STRING_KIND:     6
   **   TEXT_KIND:       3
   */


/* For ListView, Cycle & MX Gadgets, which have multiple
** initialization text strings in them:
*/

SUBFUNC void PrintMultipleBStrs( int numItems, char *buffer )
{
   char buff[BUFF_SIZE] = { 0, };
   char  temp[80] = { 0, };
   int   i        = 0, j;
   char bsize    = 0;   

   DBG( fprintf( stderr, "GTBScanner:  Entering PrintMultipleBStrs( %d, %s )...\n", numItems, buffer ) );   

   while (i < numItems)
      {
      j = 0;

      if ((bsize = *buffer) != 0) // bstrings can only be 255 bytes long
         {
         buffer++;
         
         while (*buffer != 0)
            {
            temp[j++] = *buffer;

            buffer++; 
            }
         
         temp[j] = '\0';

         sprintf( buff, "GA_ChoiceString = %s\n", &temp[0] );
         fputs( buff, outFile );
         
         while (*buffer == 0)
            buffer++;         // Skip over nil(s) at end of BSTR
         }
         
      i++; // Point to next item line.
      }

   DBG( fprintf( stderr, "GTBScanner:  Exiting PrintMultipleBStrs().\n" ) );   
      
   return;
}

// For String & Text Gadgets, which only have one default text string:

SUBFUNC void PrintDefaultString( char *buffer )
{
   char buff[ BUFF_SIZE ] = { 0, };
   int   len = 0;

   if ((len = StringLength( (char *) buffer )) > BUFF_SIZE)
	   {
		DBG( fprintf( stderr, "PrintDefaultString() received a buffer that was %d long (BOGUS!)\n", len ) );
		
	   StringCopy( (char *) buffer, "BAD defaultString" ); // Something wrong within the *.gui source file!
	   }

   DBG( fprintf( stderr, "GTBScanner:  Entering PrintDefaultString( %s )...\n", buffer ) );   

   StringCopy( (char *) buff, "GA_DefaultString = " );
   
   len = StringLength( (char *) buff );

   while (*buffer != '\0')
      {
      if (*buffer >= ' ' && *buffer <= '~')
		   buff[len++] = *buffer;
      else
		   buff[len++] = '_'; // Filter out illegal ASCII characters
			
      buffer++;
      }

   buff[len++] = '\n';
   buff[len  ] = '\0';

// sprintf( buff, "GA_DefaultString = %s\n", buffer );

   fputs( buff, outFile );

   DBG( fprintf( stderr, "GTBScanner:  Exiting PrintDefaultString().\n" ) );   
   
   return;
}

SUBFUNC void makeSliderFormat( char *buff, char *fmtString )
{
   int i = 0, len, formatSize = *fmtString & 0xFF;

   DBG( fprintf( stderr, "GTBScanner:  Entering makeSliderFormat( %s, %s )...\n", buff, fmtString ) );   

   strClear( buff ); // Reset buff to nils.
      
   // Put GTSL_LevelFormat tag into string first:   

   sprintf( buff, "0x%08LX  = ", GTSL_LevelFormat );

   len = StringLength( buff );
   i   = 0;

   fmtString++; // get past the BSTR length byte.
   
   while ((*(fmtString + i) != '\0') && (i < formatSize))
      {
      *(buff + i + len) = *(fmtString + i); // Copy format string into buff.

      i++;
      } 

   *(buff + i++ + len) = '\n';

   *(buff + i   + len) = '\0';

   DBG( fprintf( stderr, "GTBScanner:  Exiting makeSliderFormat().\n" ) );   
   
   return;
}
        
SUBFUNC void PrintGadgetInfo( struct gadgetChunk *gc )
{
   char   buff[BUFF_SIZE] = { 0, };
   char *txt       = NULL;
   UWORD  numItems  = 0;
   int    i;

   DBG( fprintf( stderr, "GTBScanner:  Entering PrintGadgetInfo()...\n" ) );   

   sprintf( buff, "%s\n", CMsg( MSG_GRP_GDATATAGS, MSG_GRP_GDATATAGS_STR ));      
   fputs( buff, outFile );

   sprintf( buff, "GA_Left     = %d\n",      gc->gc_LeftEdge   );
   fputs( buff, outFile );

   sprintf( buff, "GA_Top      = %d\n",      gc->gc_TopEdge    );
   fputs( buff, outFile );

   sprintf( buff, "GA_Width    = %d\n",      gc->gc_Width      );
   fputs( buff, outFile );

   sprintf( buff, "GA_Height   = %d\n",      gc->gc_Height     );
   fputs( buff, outFile );

   sprintf( buff, "GA_ID       = %d\n",      gc->gc_GadgetID   );
   fputs( buff, outFile );

   sprintf( buff, "GA_Flags    = 0x%08LX\n", gc->gc_Flags      );
   fputs( buff, outFile );

   sprintf( buff, "GA_Label    = %s\n",
            StringLength( (char *) gc->gc_GadgetText ) > 0 ? (char *) gc->gc_GadgetText : (char *) "" 
          );

   fputs( buff, outFile );

   sprintf( buff, "GA_SrcLabel = %s\n",
            StringLength( (char *) gc->gc_SrcLabel ) > 0 ? (char *) gc->gc_SrcLabel : (char *) "" 
          );

   fputs( buff, outFile );

   sprintf( buff, "GA_Type     = %d\n",      gc->gc_Type       );
   fputs( buff, outFile );
      
   // Output tag pairs (if any):

   switch (gc->gc_Type)
      {
      case GENERIC_KIND:
      case BUTTON_KIND:
      case CHECKBOX_KIND:
      case INTEGER_KIND:
      case NUMBER_KIND:
      case PALETTE_KIND:
      case SCROLLER_KIND:
         for (i = 0; i < gc->gc_NumberOfTags; i++)
            {
            if (gc->gc_Tags[i].ti_Tag == TAG_DONE)
               break;

            sprintf( buff, "0x%08LX  = 0x%08LX\n", 
                           gc->gc_Tags[i].ti_Tag, gc->gc_Tags[i].ti_Data
                   );
   
            fputs( buff, outFile );
            }

         break;

      case SLIDER_KIND:
         {
         for (i = 0; i < gc->gc_NumberOfTags; i++)
            {
            if (gc->gc_Tags[i].ti_Tag == TAG_DONE)
               break;

            if (gc->gc_Tags[i].ti_Tag != GTSL_LevelFormat)
               {
               sprintf( buff, "0x%08LX  = 0x%08LX\n", 
                              gc->gc_Tags[i].ti_Tag, gc->gc_Tags[i].ti_Data
                      );
               }
            else // Special case, GTSL_LevelFormat tag found: 
               {
               makeSliderFormat( buff, (char *) &gc->gc_FmtStr[0] );
               }

            fputs( buff, outFile );
            }
         }
         break;

      case LISTVIEW_KIND: 

         for (i = 0; i < gc->gc_NumberOfTags; i++)
            {
            if (gc->gc_Tags[i].ti_Tag == TAG_DONE)
               goto listViewContinue;

            sprintf( buff, "0x%08LX  = 0x%08LX\n", 
                           gc->gc_Tags[i].ti_Tag, gc->gc_Tags[i].ti_Data
                   );
   
            fputs( buff, outFile );
            }

listViewContinue:

         numItems = (gc->gc_Tags[6].ti_Tag & 0xFFFF0000) >> 16; 

         DBG( fprintf( stderr, "# of items for ListView: %d\n", numItems ) );

         if (numItems > 0)
            {
            txt = ((char *) &gc->gc_Tags[6].ti_Tag) + 3;
            
            sprintf( buff, "GA_NumberOfChoices = %d\n", numItems ); 
   
            fputs( buff, outFile );

            PrintMultipleBStrs( numItems, txt );
            }
         else
            fputs( buff, outFile );
	    
         break;

      case MX_KIND: 

         for (i = 0; i < gc->gc_NumberOfTags; i++)
            {
            if (gc->gc_Tags[i].ti_Tag == TAG_DONE)
               goto mxContinue;

            sprintf( buff, "0x%08LX  = 0x%08LX\n", 
                           gc->gc_Tags[i].ti_Tag, gc->gc_Tags[i].ti_Data
                   );
   
            fputs( buff, outFile );
            }

mxContinue:

         numItems = (gc->gc_Tags[4].ti_Tag & 0xFFFF0000) >> 16; 

         if (numItems > 0)
            {
            txt = ((char *) &gc->gc_Tags[4].ti_Tag) + 3;
               
            sprintf( buff, "GA_NumberOfChoices = %d\n", numItems ); 
   
            fputs( buff, outFile );

            PrintMultipleBStrs( numItems, txt );
            }
         else
            fputs( "GA_NumberOfChoices = 0\n", outFile ); // Should never happen!
	    
         break;

         
      case CYCLE_KIND:

         for (i = 0; i < gc->gc_NumberOfTags; i++)
            {
            if (gc->gc_Tags[i].ti_Tag == TAG_DONE)
               goto cycleContinue;

            sprintf( buff, "0x%08LX  = 0x%08LX\n", 
                           gc->gc_Tags[i].ti_Tag, gc->gc_Tags[i].ti_Data
                   );
   
            fputs( buff, outFile );
            }

cycleContinue:

         numItems = (gc->gc_Tags[4].ti_Tag & 0xFFFF0000) >> 16; 

         if (numItems > 0)
            {
            txt = ((char *) &gc->gc_Tags[4].ti_Tag) + 3;
            
            sprintf( buff, "GA_NumberOfChoices = %d\n", numItems ); 
   
            fputs( buff, outFile );

            PrintMultipleBStrs( numItems, txt );
            }
         else
            fputs( "GA_NumberOfChoices = 0\n", outFile ); // Should never happen!

         break;
         
      case STRING_KIND:
         {
         int bsize = 0;
         
         for (i = 0; i < gc->gc_NumberOfTags; i++)
            {
            if (gc->gc_Tags[i].ti_Tag == TAG_DONE)
               goto stringContinue; // break;

            sprintf( buff, "0x%08LX  = 0x%08LX\n", 
                           gc->gc_Tags[i].ti_Tag, gc->gc_Tags[i].ti_Data
                   );
   
            fputs( buff, outFile );
            }

stringContinue:

         bsize = (gc->gc_Tags[8].ti_Tag & 0xFFFF0000) >> 16; 

         if (bsize > 0)
            {
            fputs( "GA_NumberOfChoices = 1\n", outFile );

            txt = ((char *) &gc->gc_Tags[8].ti_Tag) + 2;

            PrintDefaultString( txt );
            }
         }

         break;
         
      case TEXT_KIND: 
         {
         int bsize = 0;
         
         for (i = 0; i < gc->gc_NumberOfTags; i++)
            {
            if (gc->gc_Tags[i].ti_Tag == TAG_DONE)
               goto textContinue; // break;

            sprintf( buff, "0x%08LX  = 0x%08LX\n", 
                           gc->gc_Tags[i].ti_Tag, gc->gc_Tags[i].ti_Data
                   );
   
            fputs( buff, outFile );
            }

textContinue:

         bsize = (gc->gc_Tags[3].ti_Tag & 0xFFFF0000) >> 16; 

         if (bsize > 0)
            {
            txt = ((char *) &gc->gc_Tags[3].ti_Tag) + 2;
            
            fputs( "GA_NumberOfChoices = 1\n", outFile );

            PrintDefaultString( txt );
            }
         }
      }

   DBG( fprintf( stderr, "GTBScanner:  Exiting PrintGadgetInfo().\n" ) );   

   return;
}

SUBFUNC void PrintMenuInfo( struct menuChunk *mc )
{
   char buff[BUFF_SIZE] = { 0, };
   
   DBG( fprintf( stderr, "GTBScanner:  Entering PrintMenuInfo()...\n" ) );   

   switch (mc->m_Type)
      {
      case 0x100: // Menu Title:
         sprintf( buff, "%s\n", CMsg( MSG_GRP_MDATATAGS, MSG_GRP_MDATATAGS_STR )); 
         fputs( buff, outFile );

         sprintf( buff, "NM_Title    = %s\n",      mc->m_MenuString );
         fputs( buff, outFile );

         sprintf( buff, "NM_Flags    = 0x%04LX\n", mc->m_Flags      );
         fputs( buff, outFile );
         
         break;
         
      case 0x200: // Menu Item:
         sprintf( buff, "%s\n", CMsg( MSG_GRP_MIDATATAGS, MSG_GRP_MIDATATAGS_STR )); 
         fputs( buff, outFile );

         if (mc->m_BarValue == (ULONG) NM_BARLABEL)
            {
            sprintf( buff, "NM_Label    = NM_BARLABEL\n" );
            fputs( buff, outFile );
  
            sprintf( buff, "NM_Flags    = 0\n"           );
            fputs( buff, outFile );

            sprintf( buff, "NM_CommKey  = 0\n"           );
            fputs( buff, outFile );

            sprintf( buff, "NM_SrcLabel = 0\n"           );
            fputs( buff, outFile );
            }
         else
            {
            sprintf( buff, "NM_Label    = %s\n",      mc->m_MenuString );
            fputs( buff, outFile );

            sprintf( buff, "NM_Flags    = 0x%04LX\n", mc->m_Flags      );
            fputs( buff, outFile );

            sprintf( buff, "NM_CommKey  = %s\n", mc->m_CommKey[0] == '\0' ? (char *) "0" : (char *) &mc->m_CommKey[0] );
            fputs( buff, outFile );

            sprintf( buff, "NM_SrcLabel = %s\n",      mc->m_SrcLabel   );
            fputs( buff, outFile );
            }
        
         break;

      case 0x300: // Menu SubItem:
         sprintf( buff, "%s\n", CMsg( MSG_GRP_MSDATATAGS, MSG_GRP_MSDATATAGS_STR )); 
         fputs( buff, outFile );

         if (mc->m_BarValue == (ULONG) NM_BARLABEL)
            {
            sprintf( buff, "NM_Label    = NM_BARLABEL\n" );
            fputs( buff, outFile );
  
            sprintf( buff, "NM_Flags    = 0\n"           );
            fputs( buff, outFile );

            sprintf( buff, "NM_CommKey  = 0\n"           );
            fputs( buff, outFile );

            sprintf( buff, "NM_SrcLabel = 0\n"           );
            fputs( buff, outFile );
            }
         else
            {
            sprintf( buff, "NM_Label    = %s\n",      mc->m_MenuString );
            fputs( buff, outFile );

            sprintf( buff, "NM_Flags    = 0x%04LX\n", mc->m_Flags      );
            fputs( buff, outFile );

            sprintf( buff, "NM_CommKey  = %s\n", mc->m_CommKey[0] == '\0' ? (char *) "0" : (char *) &mc->m_CommKey[0] );
            fputs( buff, outFile );

            sprintf( buff, "NM_SrcLabel = %s\n",      mc->m_SrcLabel   );
            fputs( buff, outFile );
            }
         break;
      }

   DBG( fprintf( stderr, "GTBScanner:  Exiting PrintMenuInfo().\n" ) );   

   return;
}

PRIVATE void PrintFileInfo( struct IFFHandle *iff )
{
   struct StoredProperty *sp = MYNULL;
   struct CollectionItem *ci = MYNULL;
   
   DBG( fprintf( stderr, "GTBScanner:  Entering PrintFileInfo()...\n" ) );   

   if ((sp = FindProp( iff, ID_GXUI, ID_GGUI )))
      PrintScreenInfo( (struct projectChunk *) sp->sp_Data );

   if ((sp = FindProp( iff, ID_PRHD, ID_GTCO )))
      PrintAuthorInfo( (struct authorChunk *) sp->sp_Data );

   if ((sp = FindProp( iff, ID_PRHD, ID_GENC )))
      PrintCGenInfo( (struct gencChunk *) sp->sp_Data );

   if ((sp = FindProp( iff, ID_PRHD, ID_GENA )))
      PrintAssyGenInfo( (struct genaChunk *) sp->sp_Data );

   if ((ci = FindCollection( iff, ID_GXWD, ID_WDDA )))
      PrintWindowInfo( (struct winChunk *) ci->ci_Data );

   if ((ci = FindCollection( iff, ID_GXBX, ID_BBOX )))
      PrintBevelBoxInfo( (struct bevelChunk *) ci->ci_Data );

   if ((ci = FindCollection( iff, ID_GXTX, ID_ITXT )))
      PrintIntuiTextInfo( (struct intuiChunk *) ci->ci_Data );

   if ((ci = FindCollection( iff, ID_GXGA, ID_GADA )))
      PrintGadgetInfo( (struct gadgetChunk *) ci->ci_Data );

   if ((ci = FindCollection( iff, ID_GXMN, ID_MEDA )))
      PrintMenuInfo( (struct menuChunk *) ci->ci_Data );

   DBG( fprintf( stderr, "GTBScanner:  Exiting PrintFileInfo().\n" ) );   

   return;
}

// --------- More general housekeeping functions: --------------

/****i* SetupScanCatalog() [1.0] *************************************
*
* NAME
*    SetupScanCatalog()
*
* DESCRIPTION
*    This is a test of the methods used to localize a program & is
*    not really necessary for the program since I never intend to
*    release this code for translations.
**********************************************************************
*
*/

PRIVATE int SetupScanCatalog( void )
{
   usage = CMsg( MSG_FMT_USAGE, MSG_FMT_USAGE_STR );

   DBG( fprintf( stderr, "GTBScanner:  Entering SetupScanCatalog()...\n" ) );   

   StringNCopy( &errIFF[ 0][0], CMsg( MSG_IFF_ERR_EOF,        MSG_IFF_ERR_EOF_STR ), 80 );
   StringNCopy( &errIFF[ 1][0], CMsg( MSG_IFF_ERR_EOC,        MSG_IFF_ERR_EOC_STR ), 80 );
   StringNCopy( &errIFF[ 2][0], CMsg( MSG_IFF_ERR_NO_SCOPE,   MSG_IFF_ERR_NO_SCOPE_STR ), 80 );
   StringNCopy( &errIFF[ 3][0], CMsg( MSG_IFF_ERR_NO_MEMORY,  MSG_IFF_ERR_NO_MEMORY_STR ), 80 );
   StringNCopy( &errIFF[ 4][0], CMsg( MSG_IFF_ERR_READ_ERR,   MSG_IFF_ERR_READ_ERR_STR ), 80 );
   StringNCopy( &errIFF[ 5][0], CMsg( MSG_IFF_ERR_WRITE_ERR,  MSG_IFF_ERR_WRITE_ERR_STR ), 80 );
   StringNCopy( &errIFF[ 6][0], CMsg( MSG_IFF_ERR_SEEK_ERR,   MSG_IFF_ERR_SEEK_ERR_STR ), 80 );
   StringNCopy( &errIFF[ 7][0], CMsg( MSG_IFF_ERR_BAD_FILE,   MSG_IFF_ERR_BAD_FILE_STR ), 80 );
   StringNCopy( &errIFF[ 8][0], CMsg( MSG_IFF_ERR_BAD_SYNTAX, MSG_IFF_ERR_BAD_SYNTAX_STR ), 80 );
   StringNCopy( &errIFF[ 9][0], CMsg( MSG_IFF_ERR_NOT_IFF,    MSG_IFF_ERR_NOT_IFF_STR ), 80 );
   StringNCopy( &errIFF[10][0], CMsg( MSG_IFF_ERR_NO_HOOK,    MSG_IFF_ERR_NO_HOOK_STR ), 80 );
   StringNCopy( &errIFF[11][0], CMsg( MSG_IFF_ERR_RETURN,     MSG_IFF_ERR_RETURN_STR ), 80 );

   DBG( fprintf( stderr, "GTBScanner:  Exiting SetupScanCatalog().\n" ) );   

   return( 0 );
}

PRIVATE BOOL openedLocale   = FALSE;
PRIVATE BOOL openedIFFParse = FALSE;
PRIVATE BOOL openedGadTools = FALSE;

PRIVATE void closeLibraries( void )
{
   DBG( fprintf( stderr, "GTBScanner:  Entering closeLibraries()...\n" ) );   

#  ifdef __amigaos4__

   if (openedLocale == TRUE)
      {
      if (ILocale)
		   {
         DropInterface( (struct Interface *) ILocale );
	      ILocale = NULL;
			}
			 
      if (LocaleBase)
		   {
         CloseLibrary( LocaleBase );
         LocaleBase = NULL;
		   }

      openedLocale = FALSE;
      }

   if (openedIFFParse == TRUE)
	   {
      if (IIFFParse)
		   {
         DropInterface( (struct Interface *) IIFFParse );
			IIFFParse = NULL;
		   }

		if (IFFParseBase)
		   {
		   CloseLibrary( IFFParseBase );
			IFFParseBase = NULL;
		   }

		openedIFFParse = FALSE;
		}

   if (openedGadTools == TRUE)
	   {
      if (IGadTools)
		   {
         DropInterface( (struct Interface *) IGadTools );
			IGadTools = NULL;
		   }

		if (GadToolsBase)
		   {
		   CloseLibrary( GadToolsBase );
			GadToolsBase = NULL;
		   }

		openedGadTools = FALSE;
		}
		
#  else
   if (LocaleBase)
      CloseLibrary( (struct Library *) LocaleBase );

   if (IFFParseBase)
      CloseLibrary( IFFParseBase );
#  endif

   DBG( fprintf( stderr, "GTBScanner:  Exiting closeLibraries().\n" ) );   

   return;
}

PRIVATE void ShutdownProgram( void )
{
   DBG( fprintf( stderr, "GTBScanner:  Entering ShutdownProgram()...\n" ) );   

   if (iff)
      {
      if (iff->iff_Stream) // != NULL)
         Close( iff->iff_Stream );

      FreeIFF( iff );
      }

   if (scanCatalog) // != NULL)
      CloseCatalog( scanCatalog );

   closeLibraries();      

   DBG( fprintf( stderr, "GTBScanner:  Exiting ShutdownProgram().\n" ) );   

   return;
}

PRIVATE int openLibraries( void )
{
   DBG( fprintf( stderr, "GTBScanner:  Entering openLibraries()...\n" ) );   

#  ifndef __amigaos4__   
   if (!(IFFParseBase = OpenLibrary( "iffparse.library", 37L ))) // == NULL)
      {
      fprintf( stderr, CMsg( MSG_FMT_LIB_UNOPENED, MSG_FMT_LIB_UNOPENED_STR ),
                       "iffparse.library", "37" 
             );
      
      return( ERROR_INVALID_RESIDENT_LIBRARY );
      }

   if (!(LocaleBase = OpenLibrary( "locale.library", 37L ))) // == NULL)
      {
      fprintf( stderr, CMsg( MSG_FMT_LIB_UNOPENED, MSG_FMT_LIB_UNOPENED_STR ),
                       "locale.library", "37" 
             );

      ShutdownProgram();
            
      return( ERROR_INVALID_RESIDENT_LIBRARY );
      }
#  else

   if (!IFFParseBase)
      {
      DBG( fprintf( stderr, "Opening iffparse.library...\n" ) );
   
	   if ((IFFParseBase = OpenLibrary( "iffparse.library", 50L ))) // != NULL)
         {
         if (!(IIFFParse = (struct IFFParseIFace *) GetInterface( IFFParseBase, "main", 1, NULL )))
            {
	         CloseLibrary( IFFParseBase );

            fprintf( stderr, CMsg( MSG_FMT_LIB_UNOPENED, MSG_FMT_LIB_UNOPENED_STR ),
                             "iffparse.IFace", "50" 
                   );
      
            return( ERROR_INVALID_RESIDENT_LIBRARY );
	         }
         else
			   openedIFFParse = TRUE; 
         }
      else
         {
         fprintf( stderr, CMsg( MSG_FMT_LIB_UNOPENED, MSG_FMT_LIB_UNOPENED_STR ),
                          "iffparse.library", "50" 
                );
      
         return( ERROR_INVALID_RESIDENT_LIBRARY );
         }
		}
   else
	   openedIFFParse = FALSE; // Library already open!
		
   if (!LocaleBase)
      {
      DBG( fprintf( stderr, "Opening locale.library...\n" ) );

      if ((LocaleBase = OpenLibrary( "locale.library", 50L ))) // == NULL)
         {
	      if (!(ILocale = (struct LocaleIFace *) GetInterface( LocaleBase, "main", 1, NULL )))
	         {
				closeLibraries();

            fprintf( stderr, CMsg( MSG_FMT_LIB_UNOPENED, MSG_FMT_LIB_UNOPENED_STR ),
                             "LocaleIFace", "50" 
                   );

            ShutdownProgram();
            
            return( ERROR_INVALID_RESIDENT_LIBRARY );
	         }
	      else
	         openedLocale = TRUE;
	      }
      else
         {
			closeLibraries();
			
         fprintf( stderr, CMsg( MSG_FMT_LIB_UNOPENED, MSG_FMT_LIB_UNOPENED_STR ),
                          "locale.library", "50" 
                );

         ShutdownProgram();
            
         return( ERROR_INVALID_RESIDENT_LIBRARY );
         }
      }
   else
	   openedLocale = FALSE; // Library already opened!
		
   if (!GadToolsBase)
      {
      DBG( fprintf( stderr, "Opening gadtools.library...\n" ) );
   
	   if ((GadToolsBase = OpenLibrary( "gadtools.library", 50L )))
         {
         if (!(IGadTools = (struct GadToolsIFace *) GetInterface( GadToolsBase, "main", 1, NULL )))
            {
	         closeLibraries();

            fprintf( stderr, CMsg( MSG_FMT_LIB_UNOPENED, MSG_FMT_LIB_UNOPENED_STR ),
                             "gadtools.IFace", "50" 
                   );
      
            return( ERROR_INVALID_RESIDENT_LIBRARY );
	         }
         else
			   openedGadTools = TRUE; 
         }
      else
         {
			closeLibraries();
			
         fprintf( stderr, CMsg( MSG_FMT_LIB_UNOPENED, MSG_FMT_LIB_UNOPENED_STR ),
                          "gadtools.library", "50" 
                );
      
         return( ERROR_INVALID_RESIDENT_LIBRARY );
         }
		}
   else
	   openedGadTools = FALSE; // Library already open!
		
#  endif

   DBG( fprintf( stderr, "All libraries open!\n" ) );

   return( RETURN_OK );
}

PRIVATE int SetupProgram( char *fileName )
{
   int rval = RETURN_OK, error = RETURN_OK;

//   DBG( fprintf( stderr, "Scanner: Calling openLibraries()...\n" ) );
   if (openLibraries() != RETURN_OK)
      return( ERROR_INVALID_RESIDENT_LIBRARY );
      
//   DBG( fprintf( stderr, "Scanner: Calling OpenCatalog()...\n" ) );
   scanCatalog = OpenCatalog( NULL, "gtbproject.catalog",
                              OC_BuiltInLanguage, MY_LANGUAGE,
                              TAG_DONE 
                            );

//   DBG( fprintf( stderr, "Scanner: Calling SetupScanCatalog()...\n" ) );
   (void) SetupScanCatalog();

   DBG( fprintf( stderr, "Scanner: Calling AllocIFF()...\n" ) );
   // Allocate IFF_File structure.
   if (!(iff = AllocIFF())) // == NULL)
      {
      fprintf( stderr, CMsg( MSG_FMT_FUNC_FAILED, MSG_FMT_FUNC_FAILED_STR ), 
                             "AllocIFF()" 
             );

      ShutdownProgram();

      rval = IoErr();
      }

   DBG( fprintf( stderr, "Scanner: Calling Open( %s )...\n", fileName ) );
   // Set up IFF_File for AmigaDOS I/O.
   if (!(iff->iff_Stream = Open( fileName, MODE_OLDFILE ))) // == NULL)
      {
      fprintf( stderr, CMsg( MSG_FMT_FILEUNOPENED, MSG_FMT_FILEUNOPENED_STR ),
                             fileName
             );

      ShutdownProgram();

      rval = IoErr();
      }

   DBG( fprintf( stderr, "Scanner: Calling InitIFFasDOS()...\n" ) );
   InitIFFasDOS( iff );

   DBG( fprintf( stderr, "Scanner: Calling OpenIFF()...\n" ) );
   // Start the IFF transaction.
   if ((error = OpenIFF( iff, IFFF_READ )) != RETURN_OK)
      {
      fprintf( stderr, CMsg( MSG_FMT_FUNC_FAILED, MSG_FMT_FUNC_FAILED_STR ),
                       "OpenIFF()"
             );

      ShutdownProgram();

      rval = RETURN_FAIL;

      fprintf( stderr, CMsg( MSG_FMT_SCAN_ABORT, MSG_FMT_SCAN_ABORT_STR ),
                       error, errIFF[ -error - 1 ]
             );
      }

   DBG( fprintf( stderr, "Scanner: Exiting SetupProgram()...\n" ) );

   return( rval );
}

PUBLIC int main( int argc, char **argv )
{
   long error = RETURN_OK;

   // usage[] = "Usage: %s IFFfilename.gui outputFileName.ini\n";

   if (argc != 3) // if not enough args or '?', print usage
      {
      fprintf( stderr, "USAGE: %s <inputFile.gui> <outputFile.ini>\n", argv[0] );
	 
      return( ERROR_REQUIRED_ARG_MISSING );
      }
   else if (argv[1][0] == '?')
      {
      fprintf( stderr, "USAGE: %s <inputFile.gui> <outputFile.ini>\n", argv[0] );

      return( RETURN_WARN );
      }

   StringNCopy( inFileName,    argv[1], BUFF_SIZE );
   StringNCopy( outFileName,   argv[2], BUFF_SIZE );

   if ((error = SetupProgram( inFileName )) != RETURN_OK)
      {
      return( error );
      }

   DBG( fprintf( stderr, "Scanner: Calling SetupChunks()...\n" ) );
   SetupChunks();
         
   // Do the scanning:

   while (1)
      {
#     ifdef DEBUG_SCAN
      struct ContextNode *cn = NULL;
#     endif
      
      error = ParseIFF( iff, IFFPARSE_SCAN );

      if (error == IFFERR_EOC)
         {
#        ifdef DEBUG_SCAN
         if ((cn = CurrentChunk( iff )) != NULL)
            {
            char b1[5], b2[5];
               
            fprintf( stderr, "End of Context for %s, %s\n", 
                              IDtoStr( cn->cn_Type, b1 ), 
                              IDtoStr( cn->cn_ID,   b2 ) 
                   );
   
            }
#        endif

         DBG( fprintf( stderr, "GTBScanner:  Calling PrintFileInfo() location 1...\n" ) );
         PrintFileInfo( iff ); // Generate the .ini file

         continue;
         }
      else if (error != 0) // Leave the loop if there is any other error.
         break;

      /* If we get here, error was zero Since we did IFFPARSE_SCAN, 
      ** zero error should mean we are at a Stop Chunk
      */

      DBG( fprintf( stderr, "GTBScanner:  Calling PrintFileInfo() location 2...\n" ) );
      PrintFileInfo( iff ); // Generate the .ini file
      }

   /* If error was IFFERR_EOF, then the parser encountered the end 
   ** of the file without problems.  Otherwise, we print a diagnostic. 
   */

   if (error != IFFERR_EOF)
      {
      fprintf( stderr, CMsg( MSG_FMT_SCAN_ABORT, MSG_FMT_SCAN_ABORT_STR ),
                       error, errIFF[ -error - 1 ]
             );
      }

#  ifdef DEBUG_SCAN
   else
      fprintf( stderr, "File scan complete.\n" );
#  endif

   UserInfo( CMsg( MSG_GTBP_EDIT_INI,     MSG_GTBP_EDIT_INI_STR ),
             CMsg( MSG_USER_INFO_RQTITLE, MSG_USER_INFO_RQTITLE_STR )
	   );
   
   if (outFile)
      fclose( outFile );

   ShutdownProgram();

   DBG( fprintf( stderr, "Exiting GTBScanner!\n" ) );

   return( RETURN_OK );
}

/* --------------- END of GTBScanner.c file! ------------------ */
