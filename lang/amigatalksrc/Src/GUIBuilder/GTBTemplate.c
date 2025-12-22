/****h* GTBTranslator/GTBTemplate.c [3.0] **************************
*
* NAME
*    GTBTemplate.c
*
* DESCRIPTION
*    Scan through the template file given & output a source code
*    file for the GTBTranslator program.
*
* HISTORY
*    22-Dec-2004 - Rewrote GTBLex.flex into this file.
*
*    11-Dec-2004 - Added the replaceSpaces() function.
*
*    30-Sep-2003 - Added tags for Gadget choice strings.
*
*    25-Sep-2003 - Created this file.
********************************************************************
*
*/

#include <stdio.h>
#include <ctype.h>
#include <string.h>

#include <exec/types.h>
#include <exec/memory.h>

#include <AmigaDOSErrs.h>

#include <libraries/gadtools.h>

#include <StringFunctions.h>

#include "CPGM:GlobalObjects/IniFuncs.h"
#include "CPGM:GlobalObjects/CommonFuncs.h"

#include "ScannerFuncProtos.h"

#ifndef __amigaos4__

IMPORT int __far fputs( const char *, FILE * );

#else

IMPORT int fputs( const char *, FILE * );

#endif

#ifndef  BUFF_SIZE
# define BUFF_SIZE 512
#endif

#ifndef  LSIZE
# define LSIZE 80
#endif

// --------------------------------------------------------------------

IMPORT UBYTE *stripOffBadChars(      UBYTE *instring ); // In GTBGenC.c
IMPORT UBYTE *stripOffLabelBadChars( UBYTE *instring ); // In GTBGenC.c

IMPORT FILE *myFOpen( char *fileName, char *mode, char *func ); // Not used.
IMPORT void myFClose( FILE *fp, char *func );

IMPORT void printOutLocaleHeader( FILE *out, char *projectFileName ); // In GTBGenMiscC.c

IMPORT BOOL useActiveScreen;
IMPORT BOOL useToolTypes;
IMPORT BOOL useBoopsiImage;
IMPORT BOOL useASLReq;
IMPORT BOOL usePragmas;
IMPORT BOOL unrollGadgetLoop;

IMPORT char sourceFileName[ BUFF_SIZE ];
IMPORT char projectName[LSIZE];
IMPORT char projectFileName[LSIZE];
IMPORT char projectVersion[LSIZE];
IMPORT char projectAuthorName[LSIZE];
IMPORT char screenFontName[LSIZE];
IMPORT char catalogName[LSIZE];

IMPORT int  screenFontSize;

IMPORT char              **gtags; // One line per gadget.

IMPORT struct myNewGadget *ngads;
IMPORT struct NewMenu     *nmenus;
IMPORT struct BBox        *bbox;
IMPORT struct IntuiText   *itxt;

IMPORT int  gadgetCount;
IMPORT int  menuCount;
IMPORT int  itextCount;
IMPORT int  bboxCount;

IMPORT ULONG windowIDCMP;
IMPORT ULONG windowFlags;

IMPORT  FILE *InputFP; 

PRIVATE FILE *oFP = (FILE *) NULL; // stdout;

PRIVATE int  lineNum = 0; // Delete later!!

//#ifndef  INVALID_PTR
//# define INVALID_PTR 0xDEADBEEF
//#endif

/****h* replaceSpaces() [2.0] ***********************************
*
* NAME
*    replaceSpaces()
*
* DESCRIPTION
*    We need to ensure that the passed in string has ALL
*    spaces converted to legal identifier characters, namely
*    the underscore.
*************************************************************************
*
*/

PRIVATE UBYTE rsBuff[1024] = { 0, };

PUBLIC UBYTE *replaceSpaces( UBYTE *str )
{
   int i, len = StringLength( str );

   rsBuff[0] = '\0';
   
   StringNCopy( (char *) &rsBuff[0], (char *) str, 1024 );
      
   i = 0;

   while (i < len)
      {
      if (rsBuff[ i ] == ' ')
         rsBuff[ i ] = '_';

      i++;
      }

   rsBuff[i] = '\0';
   
   return( &rsBuff[0] );
}

PRIVATE void outputStr( char *string )
{
   char *cp = string;
   
   while (*cp != '\0')
      {
      fputc( *cp, oFP ); // fprintf( oFP, "%c", *cp );

      cp++;
      }

   fflush( oFP );

   return;
}

// $SourceFileName

SUBFUNC void outputSourceFileName( char *sourceName )
{
   int len = StringLength( sourceName );

   if (len > 0)
      outputStr( sourceName );

   return;   
}

SUBFUNC void outputProjectName( char *txt )
{
   int len = StringLength( txt ), chk = StringLength( "$ProjectName" );

   if (len > chk)
      {
      outputStr( &projectName[0] );
      outputStr( &txt[ chk ] );
      }
   else
      outputStr( &projectName[0] );

   return;   
}

// $LocaleHeader expansion:

SUBFUNC void outputLocaleHeader( void )
{
   printOutLocaleHeader( oFP, projectFileName ); // In GTBGenMiscC.c
   
   fflush( oFP );
   
   return;   
}

// $GUIVariables expansion:

SUBFUNC void outputGUIVars( void )
{
   IMPORT UWORD winLeft, winTop, winWidth, winHeight;
   
   fprintf( oFP, "PRIVATE struct Screen *%sScr        = NULL;\n", projectName );
   fprintf( oFP, "PRIVATE STRPTR         PubScreenName = \"Workbench\";\n" );
   fprintf( oFP, "PRIVATE APTR           VisualInfo    = NULL;\n\n" );

   fprintf( oFP, "PRIVATE struct TextFont     *%sFont = NULL;\n", projectName );
   fprintf( oFP, "PRIVATE struct TextAttr     *Font, Attr;\n" );
   fprintf( oFP, "PRIVATE struct CompFont      CFont = { 0, };\n\n" );
    
   fprintf( oFP, "PRIVATE struct Window       *%sWnd   = NULL;\n", projectName );

   if (menuCount > 0)
      {
      fprintf( oFP, "PRIVATE struct Menu         *%sMenus = NULL;\n", projectName );
      }
           
   if (gadgetCount > 0)
      {
      fprintf( oFP, "PRIVATE struct Gadget       *%sGList = NULL;\n", projectName );
      fprintf( oFP, "PRIVATE struct Gadget       *%sGadgets[ %s_CNT ] = { 0, };\n\n",
                        projectName, projectName 
             );
      }

   fprintf( oFP, "PRIVATE struct IntuiMessage  %sMsg = { 0, };\n\n", projectName );

   fprintf( oFP, "PRIVATE UWORD  %sLeft   = %d;\n", projectName, winLeft   );
   fprintf( oFP, "PRIVATE UWORD  %sTop    = %d;\n", projectName, winTop    );
   fprintf( oFP, "PRIVATE UWORD  %sWidth  = %d;\n", projectName, winWidth  );
   fprintf( oFP, "PRIVATE UWORD  %sHeight = %d;\n", projectName, winHeight );
   fprintf( oFP, "PRIVATE STRPTR %sWdt    = NULL;   // WA_Title\n", projectName );
   fprintf( oFP, "PRIVATE STRPTR ScrTitle = NULL;   // WA_ScreenTitle\n" );
   
   fflush( oFP );
   
   return;  
}

SUBFUNC void outputDollarStr( char *txt )
{
   int len = 0;
   int chk = StringLength( "$ProjectName" );

   if (!txt)
      return;
   else
      len = StringLength( txt );
         
   if (StringNComp( "$ProjectName", txt, len ) == 0)
      {
      if (len > chk)
         {
         outputStr( &projectName[0] );
         outputStr( &txt[ chk ] );
         }
      else
         outputStr( &projectName[0] );
      }
   else
      outputStr( txt );
      
   return;   
}

SUBFUNC void outputFontSize( void )
{
   fprintf( oFP, "%d", screenFontSize );

   fflush( oFP );
   
   return;   
}

PRIVATE char timeStr[32] = { 0, };

PRIVATE void outputTheDate( void )
{
//   IMPORT long  time(  long int * );
//   IMPORT char *ctime( long int * );
   
   long int clock;

   (void) time( &clock );
   
   StringNCopy( timeStr, (char *) ctime( &clock ), 32 );

   timeStr[7]  = timeStr[10] = '-';
   timeStr[11] = timeStr[20];
   timeStr[12] = timeStr[21];
   timeStr[13] = timeStr[22];
   timeStr[14] = timeStr[23];
   timeStr[15] = '\0';
   
   fprintf( oFP, "%s", &timeStr[4] );

   fflush( oFP );

   return;
}

PRIVATE void outputPgmOptions( void )
{
   if (useActiveScreen == TRUE)
      fputs( "#define USE_ACTIVE_SCREEN  1\n", oFP );
      
   if (useToolTypes == TRUE)
      fputs( "#define USE_TOOLTYPES      1\n", oFP );

   if (useBoopsiImage == TRUE)
      fputs( "#define USE_BOOPSI_IMAGE   1\n", oFP );

   if (useASLReq == TRUE)
      fputs( "#define USE_ASL_REQ        1\n", oFP );

   if (usePragmas == TRUE)
      fputs( "#define USE_PRAGMA_HEADERS 1\n", oFP );

   if (unrollGadgetLoop == TRUE)
      fputs( "#define UNROLL_GADGET_LOOP 1\n", oFP );

   fflush( oFP );

   return;
}

PRIVATE void outputPragmaHeaders( void )
{
   if (usePragmas == TRUE)
      {
      fputs( "#include <pragmas/exec_pragmas.h>\n",      oFP );
      fputs( "#include <pragmas/intuition_pragmas.h>\n", oFP );
      fputs( "#include <pragmas/gadtools_pragmas.h>\n",  oFP );
      fputs( "#include <pragmas/graphics_pragmas.h>\n",  oFP );
      fputs( "#include <pragmas/utility_pragmas.h>\n",   oFP );

      fflush( oFP );
      }

   return;
}

PRIVATE void outputGadgetIDs( void )
{
   int i;

   if (gadgetCount == 0)
      return;

   fflush( oFP );
            
   for (i = 0; i < gadgetCount; i++)
      {
      if (!ngads[i].ng_UserData ) // || ngads[i].ng_UserData == (APTR) INVALID_PTR)
         fprintf( oFP, "#define ID_%d \t%d\n", ngads[i].ng_GadgetID, i );
      else
         fprintf( oFP, "#define ID_%s \t%d\n", stripOffBadChars( (UBYTE *) ngads[i].ng_UserData ), i );
      }
      
   fprintf( oFP, "\n#define %s_CNT \t\t%d\n", projectName, gadgetCount );

   fflush( oFP );

   return;
}

SUBFUNC char *drawModeToStr( int mode )
{
   switch (mode)
      {
      default:
      case JAM1:
         return( "JAM1" );

      case JAM2:
         return( "JAM2" );

      case COMPLEMENT:
         return( "COMPLEMENT" );

      case INVERSVID:
         return( "INVERSVID" );

      case JAM2 | COMPLEMENT:
         return( "JAM2 | COMPLEMENT" );

      case JAM2 | INVERSVID:
         return( "JAM2 | INVERSVID" );
      }
}

PRIVATE void outputITextArray( void )
{
   int i = 0;

   if (itextCount == 0)
      return;
      
   if (itextCount > 1)
      {
      fprintf( oFP, "#define %s_TNUM %d\n\n", projectName, itextCount );   

      fprintf( oFP, "PRIVATE struct IntuiText %sIT[ %s_TNUM ] = {\n\n", projectName, projectName );   

      for (i = 0; i < itextCount; i++)
         {
         fprintf( oFP, "   %d, %d, %s, %3d, %3d, NULL, \"%s\", NULL,\n",
                            itxt[i].FrontPen, itxt[i].BackPen, 
                            drawModeToStr( itxt[i].DrawMode ),
                            
                            itxt[i].LeftEdge, itxt[i].TopEdge,
                            itxt[i].IText
                );   
         }
      }
   else
      {
      fprintf( oFP, "PRIVATE struct IntuiText %sIT = {\n\n", projectName );   

      fprintf( oFP, "   %d, %d, %s, %3d, %3d, NULL, \"%s\", NULL",
                          itxt[i].FrontPen, itxt[i].BackPen, 
                          drawModeToStr( itxt[i].DrawMode ),
                            
                          itxt[i].LeftEdge, itxt[i].TopEdge,
                          itxt[i].IText
             );   
      }
      
   fputs( "\n};\n", oFP );   

   fflush( oFP );

   return;
}

PRIVATE void outputMenuFuncDecls( void )
{
   int    i;
   UBYTE *menuLabel = NULL;
   
   if (menuCount == 0)
      return;
         
   for (i = 0; i < menuCount; i++)
      {
      switch (nmenus[i].nm_Type)
         {
         case NM_TITLE:
         case NM_END:
         case NM_IGNORE:
         default:           // case NM_BARLABEL:
            break;
                     
         case NM_ITEM:
         case NM_SUB:
         case IM_ITEM:
         case IM_SUB:
            if (nmenus[i].nm_UserData) // && (nmenus[i].nm_UserData != (APTR) INVALID_PTR))
               {
	            menuLabel = stripOffBadChars( (UBYTE *) nmenus[i].nm_UserData );
	       
	            if (StringLength( menuLabel ) > 0)
                  fprintf( oFP, "PRIVATE int %s( void );\n", menuLabel );
	            }
            else
               fprintf( oFP, "// Menu item %d has NO User-Defined Action (BAR_LABEL??)! ------------ \n", i );

            break;
         }
      }
      
   return;
}

PRIVATE char correctCommKey[8] = { 0, };

SUBFUNC char *decodeCommKey( STRPTR commKey )
{
   StringNCopy( &correctCommKey[0], "\0\0\0", 4 ); // Reset the storage space.

   if (!commKey ) // || commKey == (STRPTR) INVALID_PTR)
      {
      correctCommKey[0] = '0';
      correctCommKey[1] = '\0';
      }
   else if (StringComp( commKey, "NULL" ) == 0)
      {
      correctCommKey[0] = '0';
      correctCommKey[1] = '\0';
      }
   else if (StringComp( commKey, "0" ) == 0)
      {
      correctCommKey[0] = '0';
      correctCommKey[1] = '\0';
      }
   else
      {
      correctCommKey[0] = '\"';     // format string has NO quotes for this, so add some.
      correctCommKey[1] = *commKey;
      correctCommKey[2] = '\"';
      }   

   correctCommKey[3] = '\0'; // strncpy() needs help (But StringNCopy() does not).
      
   return( correctCommKey );
}

PRIVATE void outputMenuArray( void )
{
   int    i;
   UBYTE *menuUData = NULL;

   if (menuCount == 0)
      return;
   
   // Need space for the NM_END item, so use menuCount + 1:      
   fprintf( oFP, "PRIVATE struct NewMenu %sNMenu[ %d ] = {\n\n", projectName, (menuCount + 1) );
    
   for (i = 0; i < menuCount; i++)
      {
      switch (nmenus[i].nm_Type)
         {
         case NM_TITLE:
            fprintf( oFP, "   NM_TITLE, \"%s\", NULL, 0, 0L, (APTR) NULL,\n\n", 
	                   stripOffLabelBadChars( nmenus[i].nm_Label )
	           );
            break;

         case NM_ITEM:
            if (nmenus[i].nm_Label == (STRPTR) NM_BARLABEL)
               {
               fputs( "    NM_ITEM, (STRPTR) NM_BARLABEL, NULL, 0, 0L, (APTR) NULL,\n" , oFP );
               fputs( "    // ---------------------------------------------\n\n", oFP );

               fflush( oFP );
               }
            else
               {
               if (nmenus[i].nm_UserData) // && (nmenus[i].nm_UserData != (APTR) INVALID_PTR))
	          {
                  menuUData = stripOffBadChars( (UBYTE *) nmenus[i].nm_UserData );
		  
		  if (StringLength( menuUData ) > 1)
   		     fprintf( oFP, "    NM_ITEM, \"%s\", %s, 0x%04LX, 0L, (APTR) %s,\n\n", 
                                   nmenus[i].nm_Label ? nmenus[i].nm_Label : (UBYTE *) "GARBAGE",
                                   decodeCommKey( nmenus[i].nm_CommKey ),
                                   nmenus[i].nm_Flags,
                                   menuUData
                            );
		  else // UserData was gibberish!!
   		     fprintf( oFP, "    NM_ITEM, \"%s\", %s, 0x%04LX, 0L, (APTR) NULL,\n\n",
                                   nmenus[i].nm_Label ? nmenus[i].nm_Label : (UBYTE *) "GARBAGE",
                                   decodeCommKey( nmenus[i].nm_CommKey ),
                                   nmenus[i].nm_Flags
                            );
		  }
               else
                  fprintf( oFP, "    NM_ITEM, \"%s\", %s, 0x%04LX, 0L, (APTR) NULL,\n\n", 
                                nmenus[i].nm_Label ? nmenus[i].nm_Label : (UBYTE *) "GARBAGE",
                                decodeCommKey( nmenus[i].nm_CommKey ),
                                nmenus[i].nm_Flags
                         );
               }
            break;

         case NM_SUB:
            if (nmenus[i].nm_Label == (STRPTR) NM_BARLABEL)
               {
               fputs( "     NM_SUB, (STRPTR) NM_BARLABEL, NULL, 0, 0L, (APTR) NULL,\n"  , oFP );
               fputs( "     // ---------------------------------------------\n\n", oFP );
               }
            else
               {
               if (nmenus[i].nm_UserData) // && (nmenus[i].nm_UserData != (APTR) INVALID_PTR))
	               {
                  menuUData = stripOffBadChars( (UBYTE *) nmenus[i].nm_UserData );
		  
		            if (StringLength( menuUData ) > 1)
   		            fprintf( oFP, "     NM_SUB, \"%s\", %s, 0x%04LX, 0L, (APTR) %s,\n\n", 
                                   nmenus[i].nm_Label ? nmenus[i].nm_Label : (UBYTE *) "GARBAGE",
                                   decodeCommKey( nmenus[i].nm_CommKey ),
                                   nmenus[i].nm_Flags,
                                   menuUData
                            );
		            else // UserData was gibberish!!
   		            fprintf( oFP, "     NM_SUB, \"%s\", %s, 0x%04LX, 0L, (APTR) NULL,\n\n", 
                                   nmenus[i].nm_Label ? nmenus[i].nm_Label : (UBYTE *) "GARBAGE",
                                   decodeCommKey( nmenus[i].nm_CommKey ),
                                   nmenus[i].nm_Flags
                            );
		  
		            }
               else
                  fprintf( oFP, "     NM_SUB, \"%s\", %s, 0x%04LX, 0L, (APTR) NULL,\n\n", 
                                nmenus[i].nm_Label ? nmenus[i].nm_Label : (UBYTE *) "GARBAGE",
                                decodeCommKey( nmenus[i].nm_CommKey ),
                                nmenus[i].nm_Flags
                         );
               }
            break;

         default: // case NM_BARLABEL:
            fputs( "    NM_ITEM, (STRPTR) NM_BARLABEL, NULL, 0, 0L, (APTR) NULL,\n" , oFP );
            fputs( "    // ---------------------------------------------\n\n", oFP );
         
	         fflush( oFP );
            break;

         case IM_ITEM:
            if (nmenus[i].nm_Label == (STRPTR) NM_BARLABEL)
               {
               fputs( "    IM_ITEM, (STRPTR) NM_BARLABEL, NULL, 0, 0L, (APTR) NULL,\n" , oFP );
               fputs( "    // ---------------------------------------------\n\n", oFP );
               }
            else
               {
               if (nmenus[i].nm_UserData) // && (nmenus[i].nm_UserData != (APTR) INVALID_PTR))
	               {
                  menuUData = stripOffBadChars( (UBYTE *) nmenus[i].nm_UserData );
		  
		            if (StringLength( menuUData ) > 1)
   		            fprintf( oFP, "    IM_ITEM, 0x%08LX, %s, 0x%04LX, 0L, (APTR) %s,\n\n", 
                                   (APTR) nmenus[i].nm_Label,
                                   decodeCommKey( nmenus[i].nm_CommKey ),
                                   nmenus[i].nm_Flags,
                                   menuUData
                            );
		            else // UserData was gibberish!!
   		            fprintf( oFP, "    IM_ITEM, 0x%08LX, %s, 0x%04LX, 0L, (APTR) NULL,\n\n", 
                                   (APTR) nmenus[i].nm_Label,
                                   decodeCommKey( nmenus[i].nm_CommKey ),
                                   nmenus[i].nm_Flags
                            );
		            }
               else
                  fprintf( oFP, "    IM_ITEM, 0x%08LX, %s, 0x%04LX, 0L, (APTR) NULL,\n\n", 
                                (APTR) nmenus[i].nm_Label,
                                decodeCommKey( nmenus[i].nm_CommKey ),
                                nmenus[i].nm_Flags
                         );
               }
            break;

         case IM_SUB:
            if (nmenus[i].nm_Label == (STRPTR) NM_BARLABEL)
               {
               fputs( "     IM_SUB, (STRPTR) NM_BARLABEL, NULL, 0, 0L, (APTR) NULL,\n"  , oFP );
               fputs( "     // ---------------------------------------------\n\n", oFP );
            
	            fflush( oFP );
               }
            else
               {
               if (nmenus[i].nm_UserData) // && (nmenus[i].nm_UserData != (APTR) INVALID_PTR))
	               {
                  menuUData = stripOffBadChars( (UBYTE *) nmenus[i].nm_UserData );
		  
		            if (StringLength( menuUData ) > 1)
   		            fprintf( oFP, "     IM_SUB, 0x%08LX, %s, 0x%04LX, 0L, (APTR) %s,\n\n", 
                                   (APTR) nmenus[i].nm_Label,
                                   decodeCommKey( nmenus[i].nm_CommKey ),
                                   nmenus[i].nm_Flags,
                                   menuUData
                            );
		            else // UserData was gibberish!!
   		            fprintf( oFP, "     IM_SUB, 0x%08LX, %s, 0x%04LX, 0L, (APTR) NULL,\n\n", 
                                   (APTR) nmenus[i].nm_Label,
                                   decodeCommKey( nmenus[i].nm_CommKey ),
                                   nmenus[i].nm_Flags
                            );
		  
		            }
               else
                  fprintf( oFP, "     IM_SUB, 0x%08LX, %s, 0x%04LX, 0L, (APTR) NULL,\n\n", 
                                (APTR) nmenus[i].nm_Label,
                                decodeCommKey( nmenus[i].nm_CommKey ),
                                nmenus[i].nm_Flags
                         );
               }
            break;

         case NM_IGNORE:
            if (nmenus[i].nm_UserData) // && (nmenus[i].nm_UserData != (APTR) INVALID_PTR))
               {
               menuUData = stripOffBadChars( (UBYTE *) nmenus[i].nm_UserData );
		  
 	            if (StringLength( menuUData ) > 1)
   		         fprintf( oFP, "    NM_IGNORE, \"%s\", %s, 0x%04LX, 0L, (APTR) %s,\n\n", 
                                nmenus[i].nm_Label ? nmenus[i].nm_Label : (UBYTE *) "GARBAGE",
                                decodeCommKey( nmenus[i].nm_CommKey ),
                                nmenus[i].nm_Flags,
                                menuUData
                         );
	            else // UserData was gibberish!!
   		         fprintf( oFP, "    NM_IGNORE, \"%s\", %s, 0x%04LX, 0L, (APTR) NULL,\n\n", 
                                nmenus[i].nm_Label ? nmenus[i].nm_Label : (UBYTE *) "GARBAGE",
                                decodeCommKey( nmenus[i].nm_CommKey ),
                                nmenus[i].nm_Flags
                         );
	            }
            else
               fprintf( oFP, "    NM_IGNORE, \"%s\", %s, 0x%04LX, 0L, (APTR) NULL,\n\n", 
                                  nmenus[i].nm_Label ? nmenus[i].nm_Label : (UBYTE *) "GARBAGE",
                                  decodeCommKey( nmenus[i].nm_CommKey ),
                                  nmenus[i].nm_Flags
                      );
            break;

         case NM_END:
            break;
         } 
      }

   fputs( "   NM_END, NULL, NULL, 0, 0L, (APTR) NULL\n", oFP );
   fputs( "};\n", oFP );

   fflush( oFP );

   return;
}

PRIVATE void outputGadgetTypesArray( void )
{
   int i, j;

   if (gadgetCount == 0)
      return;
         
   fprintf( oFP, "PRIVATE UWORD %sGTypes[ %s_CNT ] = {\n\n", projectName, projectName );
   
   for (i = 0, j = 1; i < gadgetCount; i++, j++)
      {
      fprintf( oFP, "   %14.14s,", getGadgetType( ngads[i].ng_Type ) );
      
      if (j % 3 == 0)
         fprintf( oFP, "\n" );
      }

   fputs( "\n};\n\n", oFP );

   fflush( oFP );

   return;
}

PRIVATE void outputGadgetFuncDecls( void )
{
   int    i;
   UBYTE *gadgetLabel = NULL;
      
   if (gadgetCount == 0)
      return;
         
   for (i = 0; i < gadgetCount; i++)
      {
      if (ngads[i].ng_UserData) // && (ngads[i].ng_UserData != (APTR) INVALID_PTR))
         {
	      gadgetLabel = stripOffBadChars( (UBYTE *) ngads[i].ng_UserData );
         
	      if (StringLength( gadgetLabel ) > 0)
	         {
   	      if (ngads[i].ng_Type == NUMBER_KIND)
	            fputs( "// --- READ_ONLY: --- ", oFP );
	         else if (ngads[i].ng_Type == TEXT_KIND)
	            fputs( "// --- READ_ONLY: --- ", oFP );
	 
            fprintf( oFP, "PRIVATE int %sClicked( void );\n", gadgetLabel );
	         }
	      }
      else
         fprintf( oFP, "// Gadget %d has NO User-defined Action! ----------------- \n", i );
      }

   return;
}

PRIVATE char gf[ BUFF_SIZE ], *gStr = &gf[0];

SUBFUNC char *decodeGadgetFlags( ULONG gflags )
{
   BOOL highlighted = FALSE;

   *gStr = '\0'; // Reset the buffer.
      
   if (gflags == 0)
      {
      StringCopy( gStr, "0" );
      
      goto exitDecodeGFlags;
      }
   
   if (gflags & NG_HIGHLABEL)
      {
      StringCopy( gStr, getGadgetTextLoc( gflags & NG_HIGHLABEL ) );
      
      gflags      &= ~NG_HIGHLABEL; // Strip off this bit.

      highlighted  = TRUE;
      }
   
   if (gflags > 0)
      {
      if (highlighted == TRUE)
         {
         StringCat( gStr, " | " );
         StringCat( gStr, getGadgetTextLoc( gflags ) );
         }
      else
         StringCopy( gStr, getGadgetTextLoc( gflags ) );
      }
         
exitDecodeGFlags:

   return( gStr );
}

PRIVATE void outputGadgetArray( void )
{
   int i;
   
   if (gadgetCount == 0)
      return;
         
   fprintf( oFP, "PRIVATE struct NewGadget %sNGad[ %s_CNT ] = {\n\n", projectName, projectName );
    
   for (i = 0; i < gadgetCount; i++)
      {
      if (ngads[i].ng_GadgetText && StringLength( ngads[i].ng_GadgetText ) > 0)
         {
         if (ngads[i].ng_UserData) // && (ngads[i].ng_UserData != (APTR) INVALID_PTR))
	         {
	         if (ngads[i].ng_Type != NUMBER_KIND && ngads[i].ng_Type != TEXT_KIND)
	            {
               fprintf( oFP, "   %3d, %3d, %3d, %3d, \"%s\", NULL,\n"
                             "   ID_%s, %s, 0L, (APTR) %sClicked,\n\n",
                               ngads[i].ng_LeftEdge,   ngads[i].ng_TopEdge,
                               ngads[i].ng_Width,      ngads[i].ng_Height,
                               stripOffLabelBadChars( ngads[i].ng_GadgetText ), 
		   	                   stripOffBadChars( (UBYTE *) ngads[i].ng_UserData ),
                               decodeGadgetFlags( ngads[i].ng_Flags ), 
			                      stripOffBadChars( (UBYTE *) ngads[i].ng_UserData )
                       );
		         }
            else // Read-only type of Gadget
	            {
               fprintf( oFP, "   %3d, %3d, %3d, %3d, \"%s\", NULL,\n"
                              "   ID_%s, %s, 0L, (APTR) NULL,\n\n",
                                ngads[i].ng_LeftEdge,   ngads[i].ng_TopEdge,
                                ngads[i].ng_Width,      ngads[i].ng_Height,
                                stripOffLabelBadChars( ngads[i].ng_GadgetText ), 
		   	                    stripOffBadChars( (UBYTE *) ngads[i].ng_UserData ),
                                decodeGadgetFlags( ngads[i].ng_Flags ) 
                      );
		         }
	        }
   	  else // No ng_UserData:
	        {
           fprintf( oFP, "   %3d, %3d, %3d, %3d, \"%s\", NULL,\n"
                           "   ID_%s, %s, 0L, (APTR) NULL,\n\n",
                            ngads[i].ng_LeftEdge,   ngads[i].ng_TopEdge,
                            ngads[i].ng_Width,      ngads[i].ng_Height,
                            stripOffLabelBadChars( ngads[i].ng_GadgetText ), 
			                   stripOffLabelBadChars( ngads[i].ng_GadgetText ),
			                   decodeGadgetFlags( ngads[i].ng_Flags )
                    );
	        }
        }
     else // NO ng_GadgetText!
        {
        if (ngads[i].ng_UserData) // && (ngads[i].ng_UserData != (APTR) INVALID_PTR))
	        {
	        if (ngads[i].ng_Type != NUMBER_KIND && ngads[i].ng_Type != TEXT_KIND)
	           {
              fprintf( oFP, "   %3d, %3d, %3d, %3d, NULL, NULL,\n"
                             "   ID_%s, %s, 0L, (APTR) %sClicked,\n\n",
                                 ngads[i].ng_LeftEdge, ngads[i].ng_TopEdge,
                                 ngads[i].ng_Width,    ngads[i].ng_Height,
			                        // NO ng_GadgetText!!
                                 stripOffBadChars( (UBYTE *) ngads[i].ng_UserData ), 
			                        decodeGadgetFlags( ngads[i].ng_Flags ),
                                 stripOffBadChars( (UBYTE *) ngads[i].ng_UserData )
                       );
	           }
           else // Read-only type of Gadget
	           {
              fprintf( oFP, "   %3d, %3d, %3d, %3d, NULL, NULL,\n"
                             "   ID_%s, %s, 0L, (APTR) NULL,\n\n",
                                 ngads[i].ng_LeftEdge, ngads[i].ng_TopEdge,
                                 ngads[i].ng_Width,    ngads[i].ng_Height,
			                        // NO ng_GadgetText!!
                                 stripOffBadChars( (UBYTE *) ngads[i].ng_UserData ), 
			                        decodeGadgetFlags( ngads[i].ng_Flags )
                       );
  	           }
	        }
  	     else // No ng_UserData:
	        { 
           fprintf( oFP, "   %3d, %3d, %3d, %3d, NULL, NULL,\n"
                          "   ID_%d, %s, 0L, (APTR) NULL,\n\n",
                              ngads[i].ng_LeftEdge, ngads[i].ng_TopEdge,
                              ngads[i].ng_Width,    ngads[i].ng_Height,
			                     // NO ng_GadgetText!!
                              ngads[i].ng_GadgetID, 
			                     decodeGadgetFlags( ngads[i].ng_Flags )
                   );
	        }
	     }
     }

   fprintf( oFP, "};\n" );

   fflush( oFP );
   
   return;
}

PRIVATE void outputGadgetTagsArray( void )
{
   int i;
   
   if (gadgetCount == 0)
      return;
         
   fprintf( oFP, "PRIVATE ULONG %sGTags[] = {\n\n", projectName );
   
   for (i = 0; i < gadgetCount; i++)
      {
      if (StringLength( (char *) gtags[i] ) > 0)
         fprintf( oFP, "   %s\n", gtags[i] );
      else
         fprintf( oFP, "   TAG_DONE,\n" );
      }

   fputs( "\n};\n", oFP );

   fflush( oFP );

   return;
}

// $LocaleStrings
PRIVATE void outputLocaleStrs( void )
{
   IMPORT void LocaleStrings( FILE *fp );
   
   // Transfer back to GenC & output all Locale strings as CMsg() calls:
   
   LocaleStrings( oFP );
   
   fflush( oFP );

   return;
}

// $GadgetFunctions expansion:

PRIVATE void outputGadgetFuncDefs( void )
{
   int i;
   
   if (gadgetCount == 0)
      return;
         
   for (i = 0; i < gadgetCount; i++)
      {
      if (ngads[i].ng_UserData) // && (ngads[i].ng_UserData != (APTR) INVALID_PTR))
         {
	      UBYTE *gadgetUData = stripOffBadChars( (UBYTE *) ngads[i].ng_UserData );

         if (StringLength( (char *) gadgetUData ) > 1)
	         {
	         if (ngads[i].ng_Type != NUMBER_KIND && ngads[i].ng_Type != TEXT_KIND)
	            {
               fprintf( oFP, "PRIVATE int %sClicked( void )\n", gadgetUData );
   
               fprintf( oFP, "{\n   // Action for %s:\n\n   return( TRUE );\n}\n\n", gadgetUData );
	            }
	         }
	      }
      }

   return;
}

// $MenuFunctions expansion:
PRIVATE void outputMenuFuncDefs( void )
{
   int i;

   if (menuCount == 0)
      return;
   
   for (i = 0; i < menuCount; i++)
      {
      if (nmenus[i].nm_UserData) // && (nmenus[i].nm_UserData != (APTR) INVALID_PTR))
         {
	      UBYTE *menuUData = stripOffBadChars( (UBYTE *) nmenus[i].nm_UserData );
         
	      if (StringLength( (char *) menuUData ) > 0)
	         {
            fprintf( oFP, "PRIVATE int %s( void )\n", menuUData );
 
            fprintf( oFP, "{\n   // Action for %s:\n\n   return( TRUE );\n}\n\n", menuUData );
	         }
         }
      }

   return;
}

// $SetupScreenCode

SUBFUNC void outputSetupScreenCode( void )
{
   fputs( "#ifdef USE_ACTIVE_SCREEN\n\n", oFP );

   fputs( "PRIVATE BOOL UnlockFlag = FALSE;\n\n#endif\n\n", oFP );

   fprintf( oFP, "PRIVATE int Open%sScreen( void )\n{\n", projectName );

   fputs( "#  ifdef USE_ACTIVE_SCREEN\n\n", oFP );

   fputs( "   struct Screen *chk = GetActiveScreen();\n\n#  endif\n\n", oFP );
   
   fprintf( oFP, "   if (!(%sFont = OpenDiskFont( &%s%d )))\n"
                 "      return( -5 );\n\n", 
                     projectName, replaceSpaces( screenFontName ), screenFontSize
          );

   fputs( "   Font = &Attr;\n\n", oFP );
   
   fprintf( oFP, "   if (!(%sScr = LockPubScreen( PubScreenName )))\n"
                 "      return( -1 );\n\n", projectName
          );

   fputs( "#   ifdef USE_ACTIVE_SCREEN\n", oFP );

   fprintf( oFP, "   if (chk != %sScr)\n"
                 "      {\n"
                 "      UnlockPubScreen( NULL, %sScr );\n"
                 "      %sScr = chk;\n"
                 "      UnlockFlag = FALSE;\n"
                 "      }\n"
                 "   else\n"
                 "      UnlockFlag = TRUE;\n"
                 "#  endif\n\n", projectName, projectName, projectName
          ); 

   fflush( oFP );

   fprintf( oFP, "   ComputeFont( %sScr, Font, &CFont, 0, 0 );\n\n", projectName );

   fprintf( oFP, "   if (!(VisualInfo = GetVisualInfo( %sScr, TAG_DONE )))\n"
                 "      return( -2 );\n\n", projectName
          );

   fputs( "#  ifdef USE_BOOPSI_IMAGE\n", oFP );
   fputs( "   if (!(getClass = initGet()))\n", oFP );
   fputs( "      return( -3 );\n\n", oFP );

   fputs( "   if (!(getImage = NewObject( getClass, NULL,\n" 
          "                               GT_VisualInfo, VisualInfo,\n"
          "                               TAG_DONE )))\n"
          "      return( -4 );\n"
          "#  endif\n\n", oFP 
        );

   fputs( "   return( RETURN_OK );\n}\n", oFP );

   fflush( oFP );

   return;
}

// $CloseScreenCode

SUBFUNC void outputCloseScreen( void )
{
   fprintf( oFP, "PRIVATE void Close%sScreen( void )\n{\n", projectName );

   fputs( "#  ifdef USE_BOOPSI_IMAGE\n", oFP );
   fputs( "   if (getImage)\n"
          "      {\n"
          "      DisposeObject( getImage );\n\n"
          "      getImage = NULL;\n"
          "      }\n\n", oFP 
        );

   fputs( "   if (getClass)\n"
          "      {\n"
          "      FreeClass( getClass );\n\n"
          "      getClass = NULL;\n"
          "      }\n"
          "#  endif\n\n", oFP 
        );

   fputs( "   if (VisualInfo)\n"
          "      {\n"
          "      FreeVisualInfo( VisualInfo );\n\n"
          "      VisualInfo = NULL;\n"
          "      }\n\n", oFP 
        );

   fputs( "#  ifdef USE_ACTIVE_SCREEN\n", oFP );

   fprintf( oFP, "   if ((UnlockFlag == TRUE) && %sScr)\n"
                 "      {\n"
                 "      UnlockPubScreen( NULL, %sScr );\n\n"
                 "      %sScr = NULL;\n"
                 "      }\n"
                 "#  else\n"
                 "   if (%sScr)\n"
                 "      {\n"
                 "      UnlockPubScreen( NULL, %sScr );\n\n"
                 "      %sScr = NULL;\n"
                 "      }\n"
                 "#  endif\n\n", 
                 projectName, projectName, projectName,
                 projectName, projectName, projectName
          );

   fprintf( oFP, "   if (%sFont)\n"
                 "      {\n"
                 "      CloseFont( %sFont );\n\n"
                 "      %sFont = NULL;\n"
                 "      }\n\n", projectName, projectName, projectName
          );

   fputs(        "   return;\n}\n", oFP );

   fflush( oFP );

   return;
}

// $CloseWindowCode

SUBFUNC void outputCloseWindow( void )
{
   fprintf( oFP, "PRIVATE void Close%sWindow( void )\n{\n", projectName );

   if ((windowIDCMP & IDCMP_MENUPICK) && ((windowFlags & WFLG_RMBTRAP) == 0))
      {
      fprintf( oFP, "   if (%sMenus)\n", projectName );

      fprintf( oFP, "      {\n"
                    "      ClearMenuStrip( %sWnd );\n"
                    "      FreeMenus( %sMenus );\n"
                    "      %sMenus = NULL;\n"
                    "      }\n\n", 
                           projectName, projectName, projectName
             );
      }

   fprintf( oFP, "   if (%sWnd)\n" 
                 "      {\n"
                 "      CloseWindow( %sWnd );\n\n"

                 "      %sWnd = NULL;\n"
                 "      }\n\n", projectName, projectName, projectName
          );

   fprintf( oFP, "   if (%sGList)\n"
                 "      {\n"
                 "      FreeGadgets( %sGList );\n\n"
                 "      %sGList = NULL;\n"
                 "      }\n\n", projectName, projectName, projectName
          );

   fputs(        "   return;\n}\n", oFP );

   fflush( oFP );

   return;
}

PRIVATE void outputBBoxDefn( void )
{
   int i;

   if (bboxCount == 0)
      return;
   
   fputs(        "PRIVATE void BBoxRender( void )\n{\n", oFP );

   fprintf( oFP, "   ComputeFont( %sScr, Font, &CFont, %sWidth, %sHeight );\n\n",
                     projectName, projectName, projectName
          );

   for (i = 0; i < bboxCount; i++)
      {
      switch (bbox[i].bb_Flags)
         {
         default:
         case 0:  // Normal
            fprintf( oFP, "   DrawBevelBox( %sWnd->RPort,\n" 
                          "                 CFont.OffX + ComputeX( CFont.FontX, %3d ),\n"
                          "                 CFont.OffY + ComputeY( CFont.FontY, %3d ),\n"
                          "                 ComputeX( CFont.FontX, %3d ),\n"
                          "                 ComputeY( CFont.FontY, %3d ),\n"
                          "                 GT_VisualInfo, VisualInfo,\n" 
                          "                 TAG_DONE\n" 
                          "               );\n\n", 
                   
                            projectName, bbox[i].bb_Left, bbox[i].bb_Top,
                            bbox[i].bb_Width, bbox[i].bb_Height
                   );
            break;
            
         case 1: // Recessed 
            fprintf( oFP, "   DrawBevelBox( %sWnd->RPort,\n" 
                          "                 CFont.OffX + ComputeX( CFont.FontX, %3d ),\n"
                          "                 CFont.OffY + ComputeY( CFont.FontY, %3d ),\n"
                          "                 ComputeX( CFont.FontX, %3d ),\n"
                          "                 ComputeY( CFont.FontY, %3d ),\n"
                          "                 GT_VisualInfo, VisualInfo,\n"
                          "                 GTBB_Recessed, TRUE,\n" 
                          "                 TAG_DONE\n" 
                          "               );\n\n", 
                   
                            projectName, bbox[i].bb_Left, bbox[i].bb_Top,
                            bbox[i].bb_Width, bbox[i].bb_Height
                   );
            break;
            
         case 2: // DropBox   
            fprintf( oFP, "   DrawBevelBox( %sWnd->RPort,\n" 
                          "                 CFont.OffX + ComputeX( CFont.FontX, %3d ),\n"
                          "                 CFont.OffY + ComputeY( CFont.FontY, %3d ),\n"
                          "                 ComputeX( CFont.FontX, %3d ),\n"
                          "                 ComputeY( CFont.FontY, %3d ),\n"
                          "                 GT_VisualInfo,  VisualInfo,\n" 
                          "                 GTBB_FrameType, BBFT_ICONDROPBOX,\n"
                          "                 TAG_DONE\n" 
                          "               );\n\n", 
                   
                            projectName, bbox[i].bb_Left, bbox[i].bb_Top,
                            bbox[i].bb_Width, bbox[i].bb_Height
                   );
            break;
         
         case 3: // Recessed DropBox:
            fprintf( oFP, "   DrawBevelBox( %sWnd->RPort,\n" 
                          "                 CFont.OffX + ComputeX( CFont.FontX, %3d ),\n"
                          "                 CFont.OffY + ComputeY( CFont.FontY, %3d ),\n"
                          "                 ComputeX( CFont.FontX, %3d ),\n"
                          "                 ComputeY( CFont.FontY, %3d ),\n"
                          "                 GT_VisualInfo,  VisualInfo,\n" 
                          "                 GTBB_FrameType, BBFT_ICONDROPBOX,\n"
                          "                 GTBB_Recessed,  TRUE,\n"
                          "                 TAG_DONE\n" 
                          "               );\n\n", 
                   
                            projectName, bbox[i].bb_Left, bbox[i].bb_Top,
                            bbox[i].bb_Width, bbox[i].bb_Height
                   );
            break;
         }
      }
      
   fputs( "   return;\n}\n\n", oFP );

   fflush( oFP );

   return;
}

PRIVATE void outputITextDefn( void )
{
   if (itextCount == 0)
      return;

   fputs(           "PRIVATE void IntuiTextRender( void )\n{\n", oFP );

   if (itextCount > 1)
      {
      fprintf( oFP, "  struct IntuiText it;\n"
                    "  UWORD            cnt;\n\n" 
             );

      fprintf( oFP, "  ComputeFont( %sScr, Font, &CFont, %sWidth, %sHeight );\n\n",
                                    projectName, projectName, projectName 
             );

      fprintf( oFP, "  for (cnt = 0; cnt < %s_TNUM; cnt++)\n"
                    "     {\n", projectName
             );
                        
      fprintf( oFP, "     CopyMem( (char *) &%sIT[ cnt ], (char *) &it,\n"
                    "              (long) sizeof( struct IntuiText )\n"
                    "            );\n\n", projectName
             );
                       
      fprintf( oFP, "     it.ITextFont = &%s%d;\n", replaceSpaces( screenFontName ), screenFontSize );
/*
      fprintf( oFP, "     it.LeftEdge  = CFont.OffX + ComputeX( CFont.FontX, it.LeftEdge )\n"
                    "                    - (IntuiTextLength( &it ) >> 1);\n\n"
             );
*/
      fprintf( oFP, "     it.TopEdge   = CFont.OffY + ComputeY( CFont.FontY, it.TopEdge )\n" 
                    "                    - (Font->ta_YSize >> 1);\n\n"
             );

      fprintf( oFP, "     PrintIText( %sWnd->RPort, &it, 0, 0 );\n", projectName );
      fprintf( oFP, "     }\n\n" );
      }
   else
      {
      fprintf( oFP, "  struct IntuiText it;\n\n" );

      fprintf( oFP, "  ComputeFont( %sScr, Font, &CFont, %sWidth, %sHeight );\n\n",
                            projectName, projectName, projectName 
             );

      fprintf( oFP, "  CopyMem( (char *) &%sIT, (char *) &it,\n"
                    "           (long) sizeof( struct IntuiText )\n"
                    "         );\n\n", projectName
             );

      fprintf( oFP, "  it.ITextFont = &%s%d;\n", replaceSpaces( screenFontName ), screenFontSize );
/*
      fprintf( oFP, "  it.LeftEdge  = CFont.OffX + ComputeX( CFont.FontX, it.LeftEdge )\n"
                    "                 - (IntuiTextLength( &it ) >> 1);\n\n"
             );
*/
      fprintf( oFP, "  it.TopEdge   = CFont.OffY + ComputeY( CFont.FontY, it.TopEdge )\n" 
                    "                 - (Font->ta_YSize >> 1);\n\n"
             );

      fprintf( oFP, "  PrintIText( %sWnd->RPort, &it, 0, 0 );\n\n", projectName );
      }

   fputs(           "  return;\n}\n\n", oFP );

   fflush( oFP );

   return;
}

SUBFUNC void outputUnrolledGadgets( void )
{
   if (gadgetCount == 0)
      return;
         
   fprintf( oFP, "/****i* SetupGadget() [%s] *******************************************\n"
                 "*\n"
                 "* NAME\n"
                 "*    SetupGadget()\n"
                 "*\n"
                 "* DESCRIPTION\n"
                 "*    Unrolled the setup gadgets loop that GadToolsBox generated in\n" 
                 "*    Open%sWindow() so that each gadget can be sized differently.\n"
                 "************************************************************************\n"
                 "*\n"
                 "*/\n\n", projectVersion, projectName
          );

   fprintf( oFP, "PRIVATE int tagcount = 0;\n\n" );

   fputs(        "SUBFUNC struct Gadget *SetupGadget( struct Gadget *g, int idx, int w, int h )\n{\n", oFP );

   fprintf( oFP, "   IMPORT UWORD     %sTypes[];\n"
                 "   IMPORT ULONG     %sGTags[];\n\n", projectName, projectName 
          ); 

   fputs(        "   struct NewGadget ng = { 0, };\n\n", oFP );

   fprintf( oFP, "   CopyMem( (char *) &%sNGad[ idx ], (char *) &ng,\n" 
                 "            (long) sizeof( struct NewGadget )\n"
                 "          );\n\n", projectName
          );

   fflush( oFP );

   fputs(        "   ng.ng_VisualInfo = VisualInfo;\n", oFP );
   fprintf( oFP, "   ng.ng_TextAttr   = &%s%d;\n\n", replaceSpaces( screenFontName ), screenFontSize );

   fputs(        "   ng.ng_LeftEdge   = CFont.OffX + ComputeX( CFont.FontX,\n", oFP );
   fputs(        "                                             ng.ng_LeftEdge\n", oFP );
   fputs(        "                                           );\n\n", oFP );

   fputs(        "   ng.ng_TopEdge    = CFont.OffY + ComputeY( CFont.FontY,\n", oFP );
   fputs(        "                                             ng.ng_TopEdge\n", oFP );
   fputs(        "                                           );\n\n", oFP );

   fputs(        "   ng.ng_Width      = ComputeX( CFont.FontX, w );\n", oFP );
   fputs(        "   ng.ng_Height     = ComputeY( CFont.FontY, h );\n\n", oFP );

   fprintf( oFP, "   %sGadgets[ idx ] = g\n", projectName ); 

   fprintf( oFP, "                    = CreateGadgetA( (ULONG) %sGTypes[ idx ],\n", projectName ); 
   fputs(        "                                     g, \n", oFP );
   fputs(        "                                     &ng, \n", oFP );
   fprintf( oFP, "                                     (struct TagItem *) &%sGTags[ tagcount ]\n", projectName );
   fputs(        "                                   );\n\n", oFP );

   fputs(        "   if (!g)\n", oFP );
   fputs(        "      {\n", oFP );
   fputs(        "      return( NULL );\n", oFP );
   fputs(        "      }\n\n", oFP );

   fprintf( oFP, "   while (%sGTags[ tagcount ] != TAG_DONE)\n"
                 "      tagcount += 2;\n\n", projectName
          );

   fputs(        "   tagcount++; // Go past the TAG_DONE tag.\n\n", oFP );

   fputs(        "   return( g );\n", oFP );
   fputs(        "}\n", oFP );

   fflush( oFP );
   
   return;
}

SUBFUNC void genSetupGadgetCalls( void )
{
   int idx = 0;
   
   if (gadgetCount == 0)
      return;
         
   while (idx < gadgetCount)
      {
      fputs(        "         // Customize the width & height here:\n", oFP );  

      fprintf( oFP, "      if (!(g = SetupGadget( g, ID_%s, %d, %d )))\n",
                                         stripOffBadChars( (UBYTE *) ngads[idx].ng_UserData ), 
                                         ngads[idx].ng_Width, ngads[idx].ng_Height 
             );

      fputs(        "         {\n", oFP );
      fputs(        "         return( -2 );\n", oFP );
      fputs(        "         }\n\n", oFP );

      idx++;
      }

   return;
}

PRIVATE void outputW_IDCMPFlags( FILE *fp )
{
   IMPORT void genWIDCMPFlags( FILE *fp );
   
   // Transfer back to GenC & output code to output Window IDCMP strings

   genWIDCMPFlags( fp );

   fflush( fp );
      
   return;
}

PRIVATE void outputW_Flags( FILE *fp )
{
   IMPORT void genWindowFlags( FILE *fp );

   // Transfer back to GenC & output code to output Window Flag strings

   genWindowFlags( fp );

   fflush( fp );   

   return;
}

PRIVATE void outputWindowTags( FILE *fp )
{
   IMPORT void genWindowTags( FILE *fp );

   // Transfer back to GenC & output code to output Window Tag strings

   genWindowTags( fp );

   fflush( fp );
      
   return;
}

// $OpenWindowDefn generator:

PRIVATE void outputOpenWindowCode( void )
{
   if (unrollGadgetLoop == TRUE)
      {
      outputUnrolledGadgets();
      }
      
   fprintf( oFP, "PRIVATE int Open%sWindow( void )\n{\n", projectName );

   fputs(        "   struct NewGadget  ng;\n"
                 "   struct Gadget    *g;\n", oFP );

   if (unrollGadgetLoop == FALSE)
      fputs(     "   UWORD             lc, tc;\n", oFP );
   else
      fputs(     "   UWORD             tc;\n", oFP );

   fputs(        "//    WORD             zCoords[] = { 100, 0, 300, 25 };\n", oFP );

   fprintf( oFP, "   UWORD             wleft, wtop, ww, wh;\n\n"

                 "   ComputeFont( %sScr, Font, &CFont, %sWidth, %sHeight );\n\n",
                      projectName, projectName, projectName 
          );
   
   fprintf( oFP, "   ww = ComputeX( CFont.FontX, %sWidth  );\n"
                 "   wh = ComputeY( CFont.FontY, %sHeight );\n\n", projectName, projectName 
          );

   fprintf( oFP, "   wleft = (%sScr->Width  - %sWidth ) / 2;\n"
                 "   wtop  = (%sScr->Height - %sHeight) / 2;\n\n",
                      projectName, projectName, projectName, projectName 
          );

   fprintf( oFP, "   if (!(g = CreateContext( &%sGList )))\n"
                 "      return( -1 );\n\n", projectName 
          );

   fflush( oFP );

   if (unrollGadgetLoop == TRUE)
      genSetupGadgetCalls();      // Unrolled code.
   else
      {      
      // Rolled code:
      fprintf( oFP, "   for (lc = 0, tc = 0; lc < %s_CNT; lc++)\n", projectName ); 
      fputs(        "      {\n", oFP );
      fprintf( oFP, "      CopyMem( (char *) &%sNGad[ lc ], (char *) &ng,\n" 
                    "               (long) sizeof( struct NewGadget )\n"
                    "             );\n\n", projectName
             );

      fputs(        "      ng.ng_VisualInfo = VisualInfo;\n", oFP );
      fprintf( oFP, "      ng.ng_TextAttr   = &%s%d;\n", replaceSpaces( screenFontName ), screenFontSize );
      
      fputs(        "      ng.ng_LeftEdge   = CFont.OffX + ComputeX( CFont.FontX, ng.ng_LeftEdge );\n", oFP );
      fputs(        "      ng.ng_TopEdge    = CFont.OffY + ComputeY( CFont.FontY, ng.ng_TopEdge );\n\n", oFP );

      if (useBoopsiImage == TRUE)
         {
         fprintf( oFP, "      if (%sGTypes[ lc ] != GENERIC_KIND)\n", projectName );
         fputs(     "         {\n", oFP );
         fputs(     "         ng.ng_Width   = ComputeX( CFont.FontX, ng.ng_Width );\n", oFP );
         fputs(     "         ng.ng_Height  = ComputeY( CFont.FontY, ng.ng_Height);\n", oFP );
         fputs(     "         }\n\n", oFP );
         }

      fprintf( oFP, "      %sGadgets[ lc ] = g\n", projectName ); 
      fprintf( oFP, "                      = CreateGadgetA( (ULONG) %sGTypes[ lc ],\n", projectName ); 
      fputs(        "                                       g,\n", oFP );
      fputs(        "                                       &ng,\n", oFP );
      fprintf( oFP, "                                       (struct TagItem *) &%sGTags[ tc ]\n", projectName );
      fputs(        "                                     );\n\n", oFP );

      if (useBoopsiImage == TRUE)
         {
         fprintf( oFP, "      if (%sGTypes[ lc ] == GENERIC_KIND)\n", projectName ); 
         fputs(        "         {\n", oFP );
         fputs(        "         g->Flags        |= GFLG_GADGIMAGE | GFLG_GADGHIMAGE;\n", oFP );
         fputs(        "         g->Activation   |= GACT_RELVERIFY;\n", oFP );
         fputs(        "         g->GadgetRender  = (APTR) getImage;\n", oFP );
         fputs(        "         g->SelectRender  = (APTR) getImage;\n", oFP );
         fputs(        "         }\n\n", oFP );
         }

      fprintf( oFP, "      while (%sGTags[ tc ] != TAG_DONE)\n"  
                    "         tc += 2;\n\n", projectName
             );
      fputs(        "      tc++;\n\n", oFP );

      fputs(        "      if (!g)\n", oFP );
      fputs(        "         return( -2 );\n", oFP );
      fputs(        "      }\n\n", oFP );

      if ((windowIDCMP & IDCMP_MENUPICK) && ((windowFlags & WFLG_RMBTRAP) == 0))
         {
         fprintf( oFP, "   if (!(%sMenus = CreateMenus( %sNMenu, GTMN_FrontPen, 0L,\n"
                       "                                TAG_DONE )))\n"
							  "      {\n"
                       "      return( -3 );\n"
							  "      }\n\n",
                            projectName, projectName
                ); 

         fprintf( oFP, "   LayoutMenus( %sMenus, VisualInfo, TAG_DONE );\n\n", projectName );
         }

      fprintf( oFP, "   if (!(%sWnd = OpenWindowTags( NULL,\n\n", projectName );

      fputs(        "         WA_Left,          wleft,\n", oFP );
      fputs(        "         WA_Top,           wtop,\n", oFP );

      fprintf( oFP, "         WA_Width,         ww + CFont.OffX + %sScr->WBorRight,\n"
                    "         WA_Height,        wh + CFont.OffY + %sScr->WBorBottom,\n\n",
                         projectName, projectName
             ); 

      outputW_IDCMPFlags( oFP );

      outputW_Flags( oFP );

      outputWindowTags( oFP );

      fputs(        "//         WA_Zoom,          (ULONG) &zCoords[0],\n", oFP );      
      fprintf( oFP, "         WA_Gadgets,       %sGList,\n"
                    "         WA_Title,         %sWdt,\n"
                    "         WA_ScreenTitle,   ScrTitle,\n"
                    "         WA_CustomScreen,  %sScr,\n"
                    "         TAG_DONE )))\n",
                         projectName, projectName, projectName
             );
             
      fputs(        "      {\n", oFP );
      fputs(        "      return( -4 );\n", oFP );
      fputs(        "      }\n\n", oFP );

      if (bboxCount > 0)
         fputs( "   BBoxRender();\n\n", oFP );

      if (itextCount > 0)
         fputs( "   IntuiTextRender();\n\n", oFP );

      if ((windowIDCMP & IDCMP_MENUPICK) && ((windowFlags & WFLG_RMBTRAP) == 0))
         {
         fprintf( oFP, "   SetMenuStrip( %sWnd, %sMenus );\n\n",
                           projectName, projectName 
                );
         }

      fprintf( oFP, "   GT_RefreshWindow( %sWnd, NULL );\n\n", projectName );

      fputs(        "   return( RETURN_OK );\n}\n\n", oFP );
      }

   fflush( oFP );

   return;
}

SUBFUNC ULONG genVerifyHandler( ULONG idcmp )
{
   ULONG saved = idcmp;
   ULONG mask  = IDCMP_MENUVERIFY | IDCMP_SIZEVERIFY | IDCMP_REQVERIFY;
   
   idcmp &= mask;
   
   if (idcmp)
      {
      fprintf( oFP, "PRIVATE int %sMenuVerify( void )\n"
                         "{\n"
                         "   int rval = TRUE;\n\n"
                            
                         "   return( rval );\n}\n\n", projectName
             );

      fprintf( oFP, "PRIVATE int %sReqVerify( void )\n"
                         "{\n"
                         "   int rval = TRUE;\n\n"
                            
                         "   return( rval );\n}\n\n", projectName
             );

      fprintf( oFP, "PRIVATE int %sSizeVerify( void )\n"
                         "{\n"
                         "   int rval = TRUE;\n\n"
                            
                         "   return( rval );\n}\n\n", projectName
             );
        
      fprintf( oFP, "PRIVATE int Handle%sVerify( void )\n{\n", projectName );
      fprintf( oFP, "   int rc = FALSE;\n\n" );

      fprintf( oFP, "   switch (%sMsg.Class)\n", projectName ); 
      fprintf( oFP, "      {\n" );
        
      fprintf( oFP, "      case IDCMP_MENUVERIFY:\n"
                         "         %sMenuVerify();\n"
                         "         rc = TRUE;\n"
                         "         break;\n\n"

                         "      case IDCMP_REQVERIFY:\n"
                         "         %sReqVerify();\n"
                         "         rc = TRUE;\n"
                         "         break;\n\n"
 
                         "      case IDCMP_SIZEVERIFY:\n"
                         "         %sSizeVerify();\n"
                         "         rc = TRUE;\n"
                         "         break;\n"
                         "      }\n\n"

                         "   return( rc );\n}\n\n",
                         projectName, projectName, projectName
             );
                     
      idcmp &= ~mask; // Kill the Verify bits.
      }

   idcmp = saved & ~mask;
         
   return( idcmp );
}

// $IDCMPHandlers code:

PRIVATE void outputIDCMPHandlers( void )
{
   ULONG idcmp = windowIDCMP;

   // First take care of the special cases, then spit out what we can:
   idcmp = genVerifyHandler( idcmp );
      
   if (idcmp & IDCMP_CLOSEWINDOW)
      {
      fprintf( oFP, "PRIVATE int %sCloseWindow( void )\n"
                         "{\n"
                         "   Close%sWindow();\n\n"
                            
                         "   return( FALSE );\n}\n\n", 
                         projectName, projectName
             );
      } 

   if (idcmp & IDCMP_VANILLAKEY)
      {
      fprintf( oFP, "PRIVATE int %sVanillaKey( int whichKey )\n"
                         "{\n"
                         "   int rval = TRUE;\n\n"
                            
                         "   switch (whichKey)\n"
                         "      {\n"
                         "      case 'q':\n"
			                "      case 'Q':\n"
			                "         rval = ExitTheProgram();\n"
			                "         break;\n\n"
                         "      default:\n"
                         "         break;\n"

                         "      }\n\n"
                            
                         "   return( rval );\n}\n\n", projectName
             );
      }

   if (idcmp & IDCMP_RAWKEY)
      {
      fprintf( oFP, "PRIVATE int %sRawKey( struct IntuiMessage *m )\n"
                         "{\n"
                         "   int rval = TRUE;\n\n"
                            
                         "   switch (m->Code)\n"
                         "      {\n"
			                "      case HELP: // 0x5F == 95\n"
			                "         rval = DisplaySomeHelp();\n"
			                "         break;\n\n"

                         "      default:\n"
                         "         break;\n"
                         "      }\n\n"
                            
                         "   return( rval );\n}\n\n", projectName
             );
      }

   if (idcmp & IDCMP_NEWSIZE)
      {
      fprintf( oFP, "PRIVATE int %sNewSize( void )\n"
                         "{\n"
                         "   int rval = TRUE;\n\n"
                            
                         "   return( rval );\n}\n\n", projectName
             );
      }

   if (idcmp & IDCMP_MOUSEBUTTONS)
      {
      fprintf( oFP, "PRIVATE int %sMouseButtons( void )\n"
                         "{\n"
                         "   int rval = TRUE;\n\n"
                            
                         "   return( rval );\n}\n\n", projectName
             );
      }

   if (idcmp & IDCMP_MOUSEMOVE)
      {
      fprintf( oFP, "PRIVATE int %sMouseMove( void )\n"
                         "{\n"
                         "   int rval = TRUE;\n\n"
                            
                         "   return( rval );\n}\n\n", projectName
             );
      }

   if (idcmp & IDCMP_REQSET)
      {
      fprintf( oFP, "PRIVATE int %sReqSet( void )\n"
                         "{\n"
                         "   int rval = TRUE;\n\n"
                            
                         "   return( rval );\n}\n\n", projectName
             );
      }

   if (idcmp & IDCMP_REQCLEAR)
      {
      fprintf( oFP, "PRIVATE int %sReqClear( void )\n"
                         "{\n"
                         "   int rval = TRUE;\n\n"
                            
                         "   return( rval );\n}\n\n", projectName
             );
      }

   if (idcmp & IDCMP_NEWPREFS)
      {
      fprintf( oFP, "PRIVATE int %sNewPrefs( void )\n"
                         "{\n"
                         "   int rval = TRUE;\n\n"
                            
                         "   return( rval );\n}\n\n", projectName
             );
      }

   if (idcmp & IDCMP_DISKINSERTED)
      {
      fprintf( oFP, "PRIVATE int %sDiskInserted( void )\n"
                         "{\n"
                         "   int rval = TRUE;\n\n"
                            
                         "   return( rval );\n}\n\n", projectName
             );
      }

   if (idcmp & IDCMP_DISKREMOVED)
      {
      fprintf( oFP, "PRIVATE int %sDiskRemoved( void )\n"
                         "{\n"
                         "   int rval = TRUE;\n\n"
                            
                         "   return( rval );\n}\n\n", projectName
             );
      }

   if (idcmp & IDCMP_ACTIVEWINDOW)
      {
      fprintf( oFP, "PRIVATE int %sActiveWindow( void )\n"
                         "{\n"
                         "   int rval = TRUE;\n\n"
                            
                         "   return( rval );\n}\n\n", projectName
             );
      }

   if (idcmp & IDCMP_INACTIVEWINDOW)
      {
      fprintf( oFP, "PRIVATE int %sInActiveWindow( void )\n"
                         "{\n"
                         "   int rval = TRUE;\n\n"
                            
                         "   return( rval );\n}\n\n", projectName
             );
      }

   if (idcmp & IDCMP_DELTAMOVE)
      {
      fprintf( oFP, "PRIVATE int %sDeltaMove( void )\n"
                         "{\n"
                         "   int rval = TRUE;\n\n"
                            
                         "   return( rval );\n}\n\n", projectName
             );
      }

   if (idcmp & IDCMP_INTUITICKS)
      {
      fprintf( oFP, "PRIVATE int %sIntuiTicks( void )\n"
                         "{\n"
                         "   int rval = TRUE;\n\n"
                            
                         "   return( rval );\n}\n\n", projectName
             );
      }

   if (idcmp & IDCMP_IDCMPUPDATE)
      {
      fprintf( oFP, "PRIVATE int %sIDCMPUpdate( void )\n"
                         "{\n"
                         "   int rval = TRUE;\n\n"
                            
                         "   return( rval );\n}\n\n", projectName
             );
      }

   if (idcmp & IDCMP_MENUHELP)
      {
      fprintf( oFP, "PRIVATE int %sMenuHelp( void )\n"
                         "{\n"
                         "   int rval = TRUE;\n\n"
                            
                         "   return( rval );\n}\n\n", projectName
             );
      }

   if (idcmp & IDCMP_CHANGEWINDOW)
      {
      fprintf( oFP, "PRIVATE int %sChangeWindow( void )\n"
                         "{\n"
                         "   int rval = TRUE;\n\n"
                            
                         "   return( rval );\n}\n\n", projectName
             );
      }

   if (idcmp & IDCMP_GADGETHELP)
      {
      fprintf( oFP, "PRIVATE int %sGadgetHelp( void )\n"
                         "{\n"
                         "   int rval = TRUE;\n\n"
                            
                         "   return( rval );\n}\n\n", projectName
             );
      }

   fflush( oFP );

   return;
}

SUBFUNC void outputTheIDCMPs( ULONG idcmp )
{
   if (idcmp & IDCMP_CLOSEWINDOW)
      {
      fprintf( oFP, "            case IDCMP_CLOSEWINDOW:\n"
                    "               running = %sCloseWindow();\n"
                    "               break;\n\n",
                                    projectName
             );
      } 

   if (idcmp & IDCMP_GADGETDOWN)
      {
      fprintf( oFP, "            case IDCMP_GADGETDOWN:\n"
                    "               if ((func = (int (*)( void )) ((struct Gadget *) %sMsg.IAddress)->UserData))\n"
                    "                  running = func();\n\n"
                    "               break;\n\n", projectName
             );
      }

   if (idcmp & IDCMP_GADGETUP)
      {
      fprintf( oFP, "            case IDCMP_GADGETUP:\n"
                    "               if ((func = (int (*)( void )) ((struct Gadget *) %sMsg.IAddress)->UserData))\n"
                    "                  running = func();\n\n"
                    "               break;\n\n", projectName
             );
      }

   if (idcmp & IDCMP_MENUPICK)
      {
      fprintf( oFP, "            case IDCMP_MENUPICK:\n"
                    "               if (%sMsg.Code != MENUNULL)\n"
                    "                  {\n"
                    "                  int (*mfunc)( void );\n\n"
                            
                    "                  struct MenuItem *n = ItemAddress( %sMenus, %sMsg.Code );\n\n"

                    "                  if (n)\n"
                    "                     if ((mfunc = (int (*)( void )) (GTMENUITEM_USERDATA( n ))))\n"
                    "                        running = mfunc();\n"
                    "                  }\n\n"
                            
                    "               break;\n\n", 
                         projectName, projectName, projectName
              );
      }

   if (idcmp & IDCMP_VANILLAKEY)
      {
      fprintf( oFP, "            case IDCMP_VANILLAKEY:\n"
                    "               running = %sVanillaKey( %sMsg.Code );\n"
                    "               break;\n\n", projectName, projectName
             );
      }

   if (idcmp & IDCMP_RAWKEY)
      {
      fprintf( oFP, "            case IDCMP_RAWKEY:\n"
                    "               running = %sRawKey( &%sMsg );\n"
                    "               break;\n\n", projectName, projectName
             );
      }

   if (idcmp & IDCMP_NEWSIZE)
      {
      fprintf( oFP, "            case IDCMP_NEWSIZE:\n"
                    "               running = %sNewSize();\n"
                    "               break;\n\n", projectName
             );
      }

   if (idcmp & IDCMP_REFRESHWINDOW)
      {
      fprintf( oFP, "            case IDCMP_REFRESHWINDOW:\n"
                    "               GT_BeginRefresh( %sWnd );\n\n", projectName 
             );
             
      if (bboxCount > 0)
         fputs( "                  BBoxRender();\n", oFP );
      
      if (itextCount > 0)   
         fputs( "                  IntuiTextRender();\n\n", oFP );

      fprintf( oFP, "               GT_EndRefresh( %sWnd, TRUE );\n\n"
                    "               break;\n\n",   projectName
             );
      }

   if (idcmp & IDCMP_MOUSEBUTTONS)
      {
      fprintf( oFP, "            case IDCMP_MOUSEBUTTONS:\n"
                    "               running = %sMouseButtons();\n"
                    "               break;\n\n", projectName
             );
      }

   if (idcmp & IDCMP_MOUSEMOVE)
      {
      fprintf( oFP, "            case IDCMP_MOUSEMOVE:\n"
                    "               running = %sMouseMove();\n"
                    "               break;\n\n", projectName
             );
      }

   if (idcmp & IDCMP_REQSET)
      {
      fprintf( oFP, "            case IDCMP_REQSET:\n"
                    "               running = %sReqSet();\n"
                    "               break;\n\n", projectName
             );
      }

   if (idcmp & IDCMP_REQCLEAR)
      {
      fprintf( oFP, "            case IDCMP_REQCLEAR:\n"
                    "               running = %sReqClear();\n"
                    "               break;\n\n", projectName
             );
      }

   if (idcmp & IDCMP_NEWPREFS)
      {
      fprintf( oFP, "            case IDCMP_NEWPREFS:\n"
                    "               running = %sNewPrefs();\n"
                    "               break;\n\n", projectName
             );
      }

   if (idcmp & IDCMP_DISKINSERTED)
      {
      fprintf( oFP, "            case IDCMP_DISKINSERTED:\n"
                    "               running = %sDiskInserted();\n"
                    "               break;\n\n", projectName
             );
      }

   if (idcmp & IDCMP_DISKREMOVED)
      {
      fprintf( oFP, "            case IDCMP_DISKREMOVED:\n"
                    "               running = %sDiskRemoved();\n"
                    "               break;\n\n", projectName
             );
      }

   if (idcmp & IDCMP_ACTIVEWINDOW)
      {
      fprintf( oFP, "            case IDCMP_ACTIVEWINDOW:\n"
                    "               running = %sActiveWindow();\n"
                    "               break;\n\n", projectName
             );
      }

   if (idcmp & IDCMP_INACTIVEWINDOW)
      {
      fprintf( oFP, "            case IDCMP_INACTIVEWINDOW:\n"
                    "               running = %sInActiveWindow();\n"
                    "               break;\n\n", projectName
             );
      }

   if (idcmp & IDCMP_DELTAMOVE)
      {
      fprintf( oFP, "            case IDCMP_DELTAMOVE:\n"
                    "               running = %sDeltaMove();\n"
                    "               break;\n\n", projectName
             );
      }

   if (idcmp & IDCMP_INTUITICKS)
      {
      fprintf( oFP, "            case IDCMP_INTUITICKS:\n"
                    "               running = %sIntuiTicks();\n"
                    "               break;\n\n", projectName
             );
      }

   if (idcmp & IDCMP_IDCMPUPDATE)
      {
      fprintf( oFP, "            case IDCMP_IDCMPUPDATE:\n"
                    "               running = %sIDCMPUpdate();\n"
                    "               break;\n\n", projectName
             );
      }

   if (idcmp & IDCMP_MENUHELP)
      {
      fprintf( oFP, "            case IDCMP_MENUHELP:\n"
                    "               running = %sMenuHelp();\n"
                    "               break;\n\n", projectName
             );
      }

   if (idcmp & IDCMP_CHANGEWINDOW)
      {
      fprintf( oFP, "            case IDCMP_CHANGEWINDOW:\n"
                    "               running = %sChangeWindow();\n"
                    "               break;\n\n", projectName
             );
      }

   if (idcmp & IDCMP_GADGETHELP)
      {
      fprintf( oFP, "            case IDCMP_GADGETHELP:\n"
                    "               running = %sGadgetHelp();\n"
                    "               break;\n\n", projectName
             );
      }

   fflush( oFP );

   return;
}

// $IDCMPCode generator:

PRIVATE void outputIDCMPCode( void )
{
   ULONG idcmp = windowIDCMP;
   ULONG mask  = IDCMP_MENUVERIFY | IDCMP_SIZEVERIFY | IDCMP_REQVERIFY;

   fprintf( oFP, "PRIVATE int Handle%sIDCMP( void )\n{\n", projectName );

   fputs( "   struct IntuiMessage *m;\n", oFP );
	// Later this should be part of an if (useVoidFunction == TRUE) ... else ... construct.
   fputs( "   int                (*func)( void );\n", oFP );

   fputs( "   BOOL                 running = TRUE;\n\n", oFP );

   fputs( "   while (running == TRUE)\n"
          "      {\n", oFP 
        );

   fprintf( oFP, "      if (!(m = GT_GetIMsg( %sWnd->UserPort )))\n"
                 "         {\n"
                 "         (void) Wait( 1L << %sWnd->UserPort->mp_SigBit );\n\n"

                 "         continue;\n"
                 "         }\n\n", projectName, projectName
          );

   fprintf( oFP, "      CopyMem( (char *) m, (char *) &%sMsg, \n"
                 "               (long) sizeof( struct IntuiMessage )\n"
                 "             );\n\n", projectName
          );

   idcmp &= mask;
   
   if (idcmp)
      {
      // Need to generate the Handle??Verify() if statement:
      
      fprintf( oFP, "      if (Handle%sVerify() == 0)\n"
                    "         {\n\n", projectName
             );

      fprintf( oFP, "         GT_ReplyIMsg( m );\n\n" );
      
      fprintf( oFP, "         switch (%sMsg.Class)\n", projectName );
      fprintf( oFP, "            {\n" );

      outputTheIDCMPs( windowIDCMP );

      fprintf( oFP, "            }\n" );
             
      fprintf( oFP, "         }\n" );
      }
   else
      {
      fprintf( oFP, "      GT_ReplyIMsg( m );\n\n" );
      
      fprintf( oFP, "      switch (%sMsg.Class)\n", projectName );
      fprintf( oFP, "         {\n" );

      outputTheIDCMPs( windowIDCMP );

      fprintf( oFP, "         }\n" );
      }

   fputs( "      }\n\n", oFP );
   fputs( "   return( running );\n}\n", oFP );

   fflush( oFP );

   return;
}

// $OpenGUI expansion:

SUBFUNC void outputOpenGUIs( void )
{
   IMPORT int listviewGCount;

   int        i;
   
   fprintf( oFP, "   if (Open%sScreen() != RETURN_OK)\n", projectName );

   fputs(        "      {\n"
                 "      rval = ERROR_ON_OPENING_SCREEN;\n\n"
      
                 "      ShutdownProgram();\n\n"

                 "      goto exitSetup;\n"
                 "      }\n\n", oFP 
        );

   fprintf( oFP, "   if (Open%sWindow() != RETURN_OK)\n", projectName );

   fputs(        "      {\n"
                 "      rval = ERROR_ON_OPENING_WINDOW;\n\n"
      
                 "      ShutdownProgram();\n\n"

                 "      goto exitSetup;\n"
                 "      }\n", oFP 
        );

   if (listviewGCount > 0)
      {
      for (i = 0; i < gadgetCount; i++)
         {
         if (ngads[i].ng_Type == LISTVIEW_KIND && (ngads[i].ng_NumberOfChoices > 0))
            {
            fputs( "\n", oFP );
            
            fprintf( oFP, "   %s%d_lvm = Guarded_AllocLV( LV%d_NUM_ELEMENTS, ELEMENT_SIZE );\n\n",
                               stripOffBadChars( (UBYTE *) ngads[i].ng_UserData ), 
			       ngads[i].ng_GadgetID,
                               ngads[i].ng_GadgetID
                   );

            fprintf( oFP, "   if ( !%s%d_lvm )\n",
                           stripOffBadChars( (UBYTE *) ngads[i].ng_UserData ), 
			   ngads[i].ng_GadgetID
                   );
                   
            fputs(        "      {\n"
                          "      rval = ERROR_NO_FREE_STORE;\n\n"
                          "      ShutdownProgram();\n\n"
                          "      goto exitSetup;\n"
                          "      }\n"
                          "   else\n"
                          "      {\n"
                          "      int k = 0;\n\n", oFP 
                );

            fprintf( oFP, "      SetupList( &%sList, %s%d_lvm );\n\n",
                                    stripOffBadChars( (UBYTE *) ngads[i].ng_UserData ),
                                    stripOffBadChars( (UBYTE *) ngads[i].ng_UserData ),
                                    ngads[i].ng_GadgetID
                   );

            fprintf( oFP, "      for (k = 0; k < LV%d_NUM_ELEMENTS; k++)\n"
                          "         {\n", ngads[i].ng_GadgetID
                   );
            
            fprintf( oFP, "         StringNCopy( &%s%d_lvm->lvm_NodeStrs[ k * ELEMENT_SIZE ],\n"
                          "                      LV_%dLbls[ k ], ELEMENT_SIZE\n"
                          "                    );\n",
                                           stripOffBadChars( (UBYTE *) ngads[i].ng_UserData ), 
					   ngads[i].ng_GadgetID,
					   ngads[i].ng_GadgetID
                   );            
            fputs(        "         }\n\n", oFP );
            
            fprintf( oFP, "      ModifyListView( %sGadgets[ ID_%s ], %sWnd, &%sList, NULL );\n",
                                  projectName, 
				  stripOffBadChars( (UBYTE *) ngads[i].ng_UserData ), 
                                  projectName, 
				  stripOffBadChars( (UBYTE *) ngads[i].ng_UserData )
                   );
            
            fputs(        "      }\n\n", oFP );
            }
         }
      }
         
   fflush( oFP );

   return;
}

// $CloseGUI expansion:

SUBFUNC void outputCloseGUIs( void )
{
   IMPORT int listviewGCount;
   
   int i;

   fprintf( oFP, "   Close%sWindow();\n\n", projectName );

   fprintf( oFP, "   Close%sScreen();\n\n", projectName ); 

   if (listviewGCount > 0)
      {
      for (i = 0; i < gadgetCount; i++)
         {
         if (ngads[i].ng_Type == LISTVIEW_KIND && (ngads[i].ng_NumberOfChoices > 0))
            {
            fprintf( oFP, "   Guarded_FreeLV( %s%d_lvm );\n",
                              stripOffBadChars( (UBYTE *) ngads[i].ng_UserData ), ngads[i].ng_GadgetID
                   );
            }
         }
      }
         
   fflush( oFP );

   return;
}

// $MainSettings expansion:

SUBFUNC void outputMainSettings( void )
{
   fprintf( oFP, "   SetNotifyWindow( %sWnd );\n\n"

                 "   (void) Handle%sIDCMP();\n", projectName, projectName
          );

   fflush( oFP );

   return;
}

SUBFUNC void outputMultStrings( int gtype )
{
   IMPORT void genMultStrings( int ); // Located in GTBGenC.c file
   
   genMultStrings( gtype );
   
   return;
}

PRIVATE void decodeDollarIdent( char *idString )
{
   if (!idString)
      return; // Should never happen!
      
   if (StringComp( "$DateToday", idString ) == 0)
      outputTheDate();

   else if (StringNComp( "$ProjectName", idString, StringLength( "$ProjectName" ) ) == 0)
      outputProjectName( &projectName[0] );

   else if (StringNComp( "$SourceFileName", idString, StringLength( "$SourceFileName" ) ) == 0)
      outputSourceFileName( &sourceFileName[0] );

   else if (StringNComp( "$ProjectFileName", idString, StringLength( "$ProjectFileName" ) ) == 0)
      outputStr( &projectFileName[0] );

   else if (StringComp( "$ProjectVersion", idString ) == 0)
      outputStr( &projectVersion[0] );
   
   else if (StringComp( "$ProjectAuthorName", idString ) == 0)
      outputStr( &projectAuthorName[0] );
   
   else if (StringComp( "$MXStrings", idString ) == 0)
      outputMultStrings( MX_KIND );

   else if (StringComp( "$CycleStrings", idString ) == 0)
      outputMultStrings( CYCLE_KIND );

   else if (StringComp( "$ListViewStrings", idString ) == 0)
      outputMultStrings( LISTVIEW_KIND );

   else if (StringComp( "$ScreenFontName", idString ) == 0)
      outputStr( &screenFontName[0] );

   // Had to add this since AmigaOS4 fonts can have spaces in their names:
   else if (StringComp( "$MassagedScreenFontName", idString ) == 0)
      {
      outputStr( replaceSpaces( &screenFontName[0] ) );
      }

   else if (StringComp( "$LocaleHeader", idString ) == 0)
      outputLocaleHeader();
   
   else if (StringComp( "$CatalogName", idString ) == 0)
      outputStr( &catalogName[0] );

   else if (StringComp( "$IncludeCommonFuncs", idString ) == 0)
      outputStr( "#include \"CPGM:GlobalObjects/CommonFuncs.h\"" );
   
   else if (StringComp( "$GUIVariables", idString ) == 0)
      outputGUIVars();
   
   else if (StringComp( "$WindowIDCMPFlags", idString ) == 0)
      outputW_IDCMPFlags( oFP );
   
   else if (StringComp( "$WindowFlags", idString ) == 0)
      outputW_Flags( oFP );
   
   else if (StringComp( "$ActiveScreenSupport", idString ) == 0)
      outputStr( "USE_ACTIVE_SCREEN" );
   
   else if (StringComp( "$IconSupport", idString ) == 0)
      outputStr( "USE_TOOLTYPES" );
   
   else if (StringComp( "$ImageSupport", idString ) == 0)
      outputStr( "USE_BOOPSI_IMAGE" );
   
   else if (StringComp( "$ASLSupport", idString ) == 0)
      outputStr( "USE_ASL_REQ" );

   else if (StringComp( "$ScreenFontSize", idString ) == 0)
      outputFontSize();
   
   else if (StringComp( "$ProgramOptionDefines", idString ) == 0)     
      outputPgmOptions();
   
   else if (StringComp( "$IncludePragmas", idString ) == 0)
      outputPragmaHeaders();

   else if (StringComp( "$GadgetIDs", idString ) == 0)
      outputGadgetIDs();
   
   else if (StringComp( "$IntuiTextArray", idString ) == 0)
      outputITextArray();
   
   else if (StringComp( "$MenuFunctionNames", idString ) == 0)
      outputMenuFuncDecls();
   
   else if (StringComp( "$MenuArray", idString ) == 0)
      outputMenuArray();
   
   else if (StringComp( "$GadgetTypesArray", idString ) == 0)
      outputGadgetTypesArray();
   
   else if (StringComp( "$GadgetFunctionNames", idString ) == 0)
      outputGadgetFuncDecls();
   
   else if (StringComp( "$GadgetsArray", idString ) == 0)
      outputGadgetArray();
   
   else if (StringComp( "$GadgetTagsArray", idString ) == 0)
      outputGadgetTagsArray();
   
   else if (StringComp( "$LocaleStrings", idString ) == 0)
      outputLocaleStrs();
   
   else if (StringComp( "$GadgetFunctions", idString ) == 0)
      outputGadgetFuncDefs();
   
   else if (StringComp( "$MenuFunctions", idString ) == 0)
      outputMenuFuncDefs();
   
   else if (StringComp( "$BevelBoxRenderFunction", idString ) == 0)
      outputBBoxDefn();
   
   else if (StringComp( "$IntuiTextRenderFunction", idString ) == 0)
      outputITextDefn();

   else if (StringComp( "$SetupScreenCode", idString ) == 0)
      outputSetupScreenCode();

   else if (StringComp( "$CloseScreenCode", idString ) == 0)
      outputCloseScreen();

   else if (StringComp( "$CloseWindowCode", idString ) == 0)
      outputCloseWindow();
   
   else if (StringComp( "$OpenWindowDefn", idString ) == 0)
      outputOpenWindowCode();
   
   else if (StringComp( "$IDCMPHandlers", idString ) == 0)
      outputIDCMPHandlers();
   
   else if (StringComp( "$IDCMPCode", idString ) == 0)
      outputIDCMPCode();

   else if (StringComp( "$CloseGUI", idString ) == 0)
      outputCloseGUIs();

   else if (StringComp( "$OpenGUI", idString ) == 0)
      outputOpenGUIs();

   else if (StringComp( "$MainSettings", idString ) == 0)
      outputMainSettings();

   else                    // Could be '$VER' or something!! 
      outputDollarStr( idString );
      
   return;
}

#ifndef  SMALL_BUFF_SIZE
# define SMALL_BUFF_SIZE 256
#endif

PRIVATE char idString[ SMALL_BUFF_SIZE ] = "$";
PRIVATE char outbuff[ SMALL_BUFF_SIZE  ] = { 0, };

SUBFUNC UBYTE *getDollarString( FILE *fp )
{
   int idx, ch;
   
   idx = 0;
   ch  = fgetc( fp );
   
   while (((isalnum( ch )) || (ch == '_')) && (idx < SMALL_BUFF_SIZE))
      {
      outbuff[ idx++ ] = ch;
      
      ch = fgetc( fp );
      }

   outbuff[idx] = '\0';
         
   ungetc( ch, fp );
   
   return( &outbuff[0] );
}

SUBFUNC void TranslateFile( FILE *input, FILE *output )
{
   int ch;

   idString[0] = '$';
   ch          = fgetc( input );
   
   while (ch != EOF) // Inner loop will find EOF first, this is just for safety.
      {
      while ((ch != EOF) && (ch != '$') && (ch != '\n'))
         {
	      fputc( ch, output );

	      ch = fgetc( input );
	      }
	 
      if (ch == EOF)
         return;
      else if (ch == '\n')
      	{
	      lineNum++;
	 
	      fputc( ch, output );
	      }
      else if (ch == '$')
         {
	      StringNCopy( (char *) &idString[1], getDollarString( input ), SMALL_BUFF_SIZE );
	 
	      decodeDollarIdent( &idString[0] );
         }	 
      
      ch = fgetc( input );
      }
      
   return;
}

/****h* GTBTranslator/processTemplate() [1.0] ************************
*
* NAME
*    processTemplate()
*
* DESCRIPTION
*    Translate template file to output code.  out is opened & closed
*    by the calling function.  tempFP is only opened by the calling
*    function.
***********************************************************************
*
*/

PUBLIC int processTemplate( FILE *tempFP, FILE *out )
{
   int rval = RETURN_OK;

   // -----------------------------------------------------
      
   if (out)
      oFP = out;
   else
      oFP = stdout;
      
   if (!tempFP)
      tempFP = stdin;

   TranslateFile( tempFP, oFP );

   if (tempFP != stdin)
      {
      myFClose( tempFP, "processTemplate" );

      tempFP = (FILE *) NULL;
      }

   return( rval );
}    

/* ------------------- END of GTBTemplate.c file! ------------------- */
