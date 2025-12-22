/****h* GTBGenATalk/GTBATLex.flex [1.0] ****************************
*
* NAME
*    GTBATLex.flex
*
* DESCRIPTION
*    Scan through the template file given & return tokens to the 
*    generator program that called us.
*
* HISTORY
*    05-Oct-2003 - Created this file.
********************************************************************
*
*/

/* ----------------------- Definitions Section: -------------------- */

%option noyywrap
%START  NORM

WHT           ([ \t]*)

SEMI          ";"

COMMA         ","

DOLLAR        "$"

AMP           "&"

NL            \n

IDENT         ([a-z_A-Z][0-9a-z_A-Z]*)

DOLLAR_ID     ({DOLLAR}{IDENT})
    
%{

#include <stdio.h>
#include <ctype.h>
#include <string.h>

#include <exec/types.h>
#include <exec/memory.h>

#include <AmigaDOSErrs.h>

#include <libraries/gadtools.h>

#include "CPGM:GlobalObjects/IniFuncs.h"
#include "CPGM:GlobalObjects/CommonFuncs.h"

#include "ScannerFuncProtos.h"

IMPORT int __far fputs( const char *, FILE * );

// --------------------------------------------------------------------

IMPORT FILE *myFOpen(  char *fileName, char *mode, char *func ); // Not used.
IMPORT void  myFClose( FILE *fp, char *func );

IMPORT BOOL  useBoopsiImage;
IMPORT BOOL  useASLReq;

IMPORT char  projectName[80];
IMPORT char  projectFileName[80];
IMPORT char  projectVersion[80];
IMPORT char  projectAuthorName[80];
IMPORT char  screenFontName[80];
IMPORT char  screenTitle[80];

IMPORT int   screenFontSize;
IMPORT ULONG screenModeID;

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

PRIVATE FILE *oFP = stdout;

PRIVATE void outputStr( char * );

PRIVATE int  lineNum = 0;

PRIVATE void decodeDollarIdent( char *idString );

%}

/* -------------------------- Rules Section: ------------------------ */

%%

{NL}                        { lineNum++; fputs( "\n", oFP ); }

{DOLLAR_ID}                 { decodeDollarIdent( yytext );   }

.                           { outputStr( yytext );        }

%%


/* -------------------------- User Code Section: -------------------- */

PRIVATE void outputStr( char *string )
{
   char *cp = string;
   
   while (*cp != '\0')
      {
      fprintf( oFP, "%c", *cp );

      cp++;
      }
      
   return;
}

SUBFUNC void outputProjectName( char *txt )
{
   int len = strlen( txt ), chk = strlen( "$ProjectName" );

   if (len > chk)
      {
      outputStr( &projectName[0] );
      outputStr( &txt[ chk ] );
      }
   else
      outputStr( &projectName[0] );

   return;   
}

SUBFUNC void outputDollarStr( char *txt )
{
   int len = strlen( txt ), chk = strlen( "$ProjectName" );

   if (strncmp( "$ProjectName", txt, len ) == 0)
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

   return;   
}

PRIVATE char timeStr[32] = "";

PRIVATE void outputTheDate( void )
{
   IMPORT long  time(  long int * );
   IMPORT char *ctime( long int * );
   
   long int clock;

   (void) time( &clock );
   
   myStrnCpy( timeStr, ctime( &clock ), 32 );

   timeStr[7]  = timeStr[10] = '-';
   timeStr[11] = timeStr[20];
   timeStr[12] = timeStr[21];
   timeStr[13] = timeStr[22];
   timeStr[14] = timeStr[23];
   timeStr[15] = '\0';
   
   fprintf( oFP, "%s", &timeStr[4] );

   return;
}

SUBFUNC int countGadgetTags( char *tagStr )
{
   int i = 0, rval = 0, len = strlen( tagStr );
   
   while (i < len && *tagStr != '\0')
      {
      if (*(tagStr + i) == ',')
         rval++;
         
      i++;
      }
      
   return( rval + 1 ); // There is a TAG_DONE at the end of the string.
} 

SUBFUNC int getGadgetIntTag( char *tagStr, int whichOne )
{
   char tb[32] = "";
   int  i = 0, j = 0, rval = 0, len = strlen( tagStr );
   
   if (whichOne == 0)
      {
      while (*(tagStr + j) != ',')
         j++;
         
      myStrnCpy( &tb[0], tagStr, j - 1 );
      
      goto findTheTag;   
      }
      
   while (i < whichOne && j < len)
      {
      if (*(tagStr + j) == ',')
         i++;
     
      j++;
      }
   
   while (*(tagStr + j) == ' ')
      j++;
   
   i = 0;   

   while (*(tagStr + j) != ',' && *(tagStr + j) != '\0')
      {
      tb[i] = *(tagStr + j);
      i++;
      j++;
      }

findTheTag:

   rval = gadgetStrToInt( &tb[0] );
         
   return( rval );
}

// $SetupGadgets expansion:

SUBFUNC void outputSetupGadgets( void )
{
   int i, ch, j, numTags = 0;

   if (gadgetCount < 1) // No Gadgets!
      return;
         
   fprintf( oFP, "      gadgetList <- GadgetList new: %d.\n", gadgetCount );
   fputs(        "      gadget     <- Gadget     new.\n", oFP );
   fputs(        "      gadget     <- gadgetList firstGadget.\n\n", oFP );

   for (i = 0; i < gadgetCount; i++)
      {      
      fprintf( oFP, "      ngad%d      <- NewGadget new.\n", i );
      fprintf( oFP, "      gad%dAction <- Array     new: 3.\n", i );

      fprintf( oFP, "      gad%dAction at: 1 put: #%s.\n", i, ngads[i].ng_UserData );
      fprintf( oFP, "      gad%dAction at: 2 put: %d.\n",  i, ngads[i].ng_Type     );

      if ((ch = findHotKey( ngads[i] )) != 0)
         fprintf( oFP, "      gad%dAction at: 3 put: $%c.\n\n", i, ch );
      else
         fprintf( oFP, "      gad%dAction at: 3 put: nil.\n\n", i );
         
      fprintf( oFP, "      ngad% new: #( %d %d %d %d\n",
                             i,
                             ngads[i].ng_LeftEdge,  ngads[i].ng_TopEdge,
                             ngads[i].ng_Width,     ngads[i].ng_Height,
             );

      if (strlen( ngads[i].ng_GadgetText ) > 0) 
         fprintf( oFP, "                    '%s' fontAttr %d %d viObj\n",
                                             ngads[i].ng_GadgetText,
                                             ngads[i].ng_GadgetID,
                                             ngads[i].ng_Flags
                );
      else
         fprintf( oFP, "                    nil fontAttr %d %d viObj\n",
                                             ngads[i].ng_GadgetID,
                                             ngads[i].ng_Flags
                );
      
      if ((ch = findHotKey( ngads[i] )) != 0)
         fprintf( oFP, "                    gad%dAction %d $%c ).\n\n", 
                                             i, ngads[i].ng_Type, ch
                );
      else
         fprintf( oFP, "                    gad%dAction %d nil ).\n\n", 
                                             i, ngads[i].ng_Type
                );
      
      j = countGadgetTags( gtags[i] );
      
      fprintf( oFP, "      ngad%dTags <- Array new: %d.\n", j ); 

      for (j = 0; j < countGadgetTags( gtags[i] ); j++)
         {
         fprintf( oFP, "      ngad%dTags at: %d put: %d.\n", 
                               i, j + 1, getGadgetIntTag( gtags[i], j )
                );
         }
      
      fprintf( oFP, "      gadget <- gadgetList addGadgetToList: ngad%d at: gadget "
                                                "type: %d tags: ngad%dTags\n",
                                                        i, ngads[i].ng_Type, i
             );
      }

   return;
}

PRIVATE char correctCommKey[4] = "";

SUBFUNC char *decodeCommKey( STRPTR commKey )
{
   myStrnCpy( &correctCommKey[0], "\0\0\0", 4 ); // Reset the storage space.
    
   if (!commKey) // == NULL)
      {
      correctCommKey[0] = '0';
      correctCommKey[1] = '\0';
      }
   else if (strcmp( commKey, "NULL" ) == 0)
      {
      correctCommKey[0] = '0';
      correctCommKey[1] = '\0';
      }
   else if (strcmp( commKey, "0" ) == 0)
      {
      correctCommKey[0] = '0';
      correctCommKey[1] = '\0';
      }
   else
      {
      correctCommKey[0] = '\"';
      correctCommKey[1] = *commKey;
      correctCommKey[2] = '\"';
      }   
   
   correctCommKey[3] = '\0';
      
   return( correctCommKey );
}

// $SetupMenus

PRIVATE void outputSetupMenus( void )
{
   int i;
   
   fprintf( oFP, "PRIVATE struct NewMenu %sNMenu[ %d ] = {\n\n",
                       projectName, (menuCount + 1) // for the NM_END item
          );
    
   for (i = 0; i < menuCount; i++)
      {
      switch (nmenus[i].nm_Type)
         {
         case NM_TITLE:
            fprintf( oFP, "   NM_TITLE, \"%s\", NULL, 0, 0L, NULL,\n\n",
                              nmenus[i].nm_Label
                   );
            break;

         case NM_ITEM:
            if (nmenus[i].nm_Label == (STRPTR) NM_BARLABEL)
               {
               fputs( "    NM_ITEM, (STRPTR) NM_BARLABEL, NULL, 0, 0L, NULL,\n", oFP );
               fputs( "    // ---------------------------------------------\n\n", oFP );
               }
            else
               {
               fprintf( oFP, "    NM_ITEM, \"%s\", %s, 0x%04LX, 0L, (APTR) %s,\n\n", 
                             nmenus[i].nm_Label,
                             decodeCommKey( nmenus[i].nm_CommKey ),
                             nmenus[i].nm_Flags,
                             nmenus[i].nm_UserData != NULL ? nmenus[i].nm_UserData : "NULL"
                   );
               }
            break;

         case NM_SUB:
            if (nmenus[i].nm_Label == (STRPTR) NM_BARLABEL)
               {
               fputs( "     NM_SUB, (STRPTR) NM_BARLABEL, NULL, 0, 0L, NULL,\n", oFP );
               fputs( "     // ---------------------------------------------\n\n", oFP );
               }
            else
               {
               fprintf( oFP, "     NM_SUB, \"%s\", %s, 0x%04LX, 0L, (APTR) %s,\n\n", 
                             nmenus[i].nm_Label,
                             decodeCommKey( nmenus[i].nm_CommKey ),
                             nmenus[i].nm_Flags,
                             nmenus[i].nm_UserData != NULL ? nmenus[i].nm_UserData : "NULL"
                   );
               }
            break;

         default: // case NM_BARLABEL:
            fputs( "    NM_ITEM, (STRPTR) NM_BARLABEL, NULL, 0, 0L, NULL,\n", oFP );
            fputs( "    // ---------------------------------------------\n\n", oFP );
            break;

         case IM_ITEM:
            if (nmenus[i].nm_Label == (STRPTR) NM_BARLABEL)
               {
               fputs( "    IM_ITEM, (STRPTR) NM_BARLABEL, NULL, 0, 0L, NULL,\n", oFP );
               fputs( "    // ---------------------------------------------\n\n", oFP );
               }
            else
               {
               fprintf( oFP, "    IM_ITEM, 0x%08LX, %s, 0x%04LX, 0L, (APTR) %s,\n\n", 
                             (APTR) nmenus[i].nm_Label,
                             decodeCommKey( nmenus[i].nm_CommKey ),
                             nmenus[i].nm_Flags,
                             nmenus[i].nm_UserData != NULL ? nmenus[i].nm_UserData : "NULL"
                      );
               }
            break;

         case IM_SUB:
            if (nmenus[i].nm_Label == (STRPTR) NM_BARLABEL)
               {
               fputs( "     IM_SUB, (STRPTR) NM_BARLABEL, NULL, 0, 0L, NULL,\n", oFP );
               fputs( "     // ---------------------------------------------\n\n", oFP );
               }
            else
               {
               fprintf( oFP, "     IM_SUB, 0x%08LX, %s, 0x%04LX, 0L, (APTR) %s,\n\n", 
                             (APTR) nmenus[i].nm_Label,
                             decodeCommKey( nmenus[i].nm_CommKey ),
                             nmenus[i].nm_Flags,
                             nmenus[i].nm_UserData != NULL ? nmenus[i].nm_UserData : "NULL"
                      );
               }
            break;

         case NM_IGNORE:
            fprintf( oFP, "    NM_IGNORE, \"%s\", %s, 0x%04LX, 0L, (APTR) %s,\n\n", 
                               nmenus[i].nm_Label,
                               decodeCommKey( nmenus[i].nm_CommKey ),
                               nmenus[i].nm_Flags,
                               nmenus[i].nm_UserData != NULL ? nmenus[i].nm_UserData : "NULL"
                   );
            break;

         case NM_END:
            break;
         } 
      }

   fputs( "   NM_END, NULL, NULL, 0, 0L, NULL\n\n", oFP );
   fputs( "};\n", oFP );

   return;
}

// $SetupScreenCode

SUBFUNC void outputSetupScreenCode( void )
{
   fputs( "      screen  <- Screen new.\n", oFP );
   fputs( "      scrFont <- Font   new.\n", oFP );

   fputs( "      guiWindow <- Window new.\n", oFP );
   
   fprintf( oFP, "      scrFont openFont: '%s' size: %d style: 0.\n", 
                         screenFontName, screenFontSize
          );

   fputs( "      fontAttr <- scrFont fontAttributes.\n", oFP );

   fputs( "      screen setFont: fontAttr.\n", oFP );

   fprintf( oFP, "      screen openScreen: 16r%08LX title: '%s'.\n", 
                         screenModeID, screenTitle 
          );

   fputs( "      viObj <- screen getVisualInfo: nil.\n", oFP );

   return;
}

// $CloseScreenCode

SUBFUNC void outputCloseScreen( void )
{
   fputs( "      screen  disposeVisualInfo: viObj.\n"
          "      screen  close.\n"
          "      scrFont close.\n", oFP 
        );

   return;
}

// $CloseWindowCode

SUBFUNC void outputCloseWindow( void )
{
   fputs( "      guiWindow close.\n\n", oFP );

   return;
}

// $RenderBevelBoxes

PRIVATE void outputBBoxes( void )
{
   int i;
   
   if (bboxCount < 1)
      {
      fputs( "   renderBevelBoxes\n      ^ nil", oFP );
      
      return;
      }

   fputs( "   renderBevelBoxes ! box ! \n", oFP );
       
   for (i = 0; i < bboxCount; i++)
      {
      switch (bbox[i].bb_Flags)
         {
         default:
         case 0:  // Normal
            fprintf( oFP, "      box <- bboxes at: %d.\n", i );
            fputs(        "      box drawNormalBox: guiWindow with: viObj.\n\n", oFP );
            
            break;
            
         case 1: // Recessed 
            fprintf( oFP, "      box <- bboxes at: %d.\n", i );
            fputs(        "      box drawRecessedBox: guiWindow with: viObj.\n\n", oFP );

            break;
            
         case 2: // DropBox   
            fprintf( oFP, "      box <- bboxes at: %d.\n", i );
            fputs(        "      box drawDropBox: guiWindow with: viObj.\n\n", oFP );
            break;
         
         case 3: // Recessed DropBox:
            fprintf( oFP, "      box <- bboxes at: %d.\n", i );
            fputs(        "      box drawRecessedDropBox: guiWindow with: viObj.\n\n", oFP );

            break;
         }
      }

   fputs( "   ^ nil", oFP );

   return;
}

// $RenderIntuiTexts

PRIVATE void outputRenderITexts( void )
{
   int i;
   
   if (itextCount < 1)
      {
      fputs( "   renderIntuiTexts\n      ^ nil", oFP );
      
      return;
      }
      
   fputs( "   renderIntuiTexts ! itext ! \n", oFP );

   for (i = 0; i < itextCount; i++)
      {
      fprintf( oFP, "     itext <- itexts at: %d.\n", i );
      fputs(        "     guiWindow printIText: itext at: itext getITextOrigin.\n\n", oFP );
      }

   fputs( "   ^ nil", oFP );

   return;
}

// $SetupMenus

SUBFUNC void outputSetupMenus( void )
{
}
   
// $DisposeMenus

SUBFUNC void outputDisposeMenus( void )
{
}
   
// $DisposeGadgets

SUBFUNC void outputDisposeGadgets( void )
{
}
   
// $DisposeITexts

SUBFUNC void outputDisposeITexts( void )
{
}
   
// $DisposeBBoxes

SUBFUNC void outputDisposeBBoxes( void )
{
}

PRIVATE void outputW_IDCMPFlags( FILE *fp )
{
   IMPORT void genWIDCMPFlags( FILE *fp );
   
   // Transfer back to GenC & output code to output Window IDCMP strings

   genWIDCMPFlags( fp );
   
   return;
}

PRIVATE void outputW_Flags( FILE *fp )
{
   IMPORT void genWindowFlags( FILE *fp );

   // Transfer back to GenC & output code to output Window Flag strings

   genWindowFlags( fp );
   
   return;
}

PRIVATE void outputWindowTags( FILE *fp )
{
   IMPORT void genWindowTags( FILE *fp );

   // Transfer back to GenC & output code to output Window Tag strings

   genWindowTags( fp );
   
   return;
}

// $OpenWindowCode generator:

PRIVATE void outputOpenWindowCode( void )
{
   IMPORT void generateOpenWindowCode( void );
   
   generateOpenWindowCode();
   
   return;
/*
   IMPORT UWORD winLeft, winTop, winWidth, winHeight;

      guiWindow setWindowOrigin: $WA_Left  @ $WA_Top.
      guiWindow setWindowSize:   $WA_Width @ $WA_Height.
      guiWindow setIDCMPFlags:   $WA_IDCMP.
      guiWindow setFlags:        $WA_Flags.
      guiWindow setMinSize:      $WA_MinWidth @ $WA_MinHeight.
      guiWindow setMaxSize:      $WA_MaxWidth @ $WA_MaxHeight.
   
      wTags       <- Array new: 11.
   
      wTags at: 1  put: intuition getWindowTag: #WA_CustomScreen.
      wTags at: 2  put: screen.
      wTags at: 3  put: intuition getWindowTag: #WA_Title.
      wTags at: 4  put: $WindowTitle.
      wTags at: 5  put: intuition getWindowTag: #WA_AutoAdjust.
      wTags at: 6  put: $WA_AutoAdjust.
      wTags at: 7  put: intuition getWindowTag: #WA_NewLookMenus.
      wTags at: 8  put: $WA_NewLookMenus.
      wTags at: 9  put: intuition getWindowTag: #WA_Gadgets.
      wTags at: 10 put: firstGadget.
      wTags at: 11 put: intuition getWindowTag: #TAG_DONE.

      self setupMenuStrip.
         
      guiWindow openWindowWithTags: wTags.
*/
}

PRIVATE void decodeDollarIdent( char *idString )
{
   if (strcmp( "$DateToday", idString ) == 0)
      outputTheDate();

   else if (strncmp( "$ProjectName", idString, strlen( "$ProjectName" ) ) == 0)
      outputProjectName( &projectName[0] );

   else if (strncmp( "$ProjectFileName", idString, strlen( "$ProjectFileName" ) ) == 0)
      outputStr( &projectFileName[0] );

   else if (strcmp( "$ProjectVersion", idString ) == 0)
      outputStr( &projectVersion[0] );
   
   else if (strcmp( "$ProjectAuthorName", idString ) == 0)
      outputStr( &projectAuthorName[0] );
   
   else if (strcmp( "$MXStrings", idString ) == 0)
      outputMultStrings( MX_KIND );

   else if (strcmp( "$CycleStrings", idString ) == 0)
      outputMultStrings( CYCLE_KIND );

   else if (strcmp( "$ListViewStrings", idString ) == 0)
      outputMultStrings( LISTVIEW_KIND );

   else if (strcmp( "$ScreenFontName", idString ) == 0)
      outputStr( &screenFontName[0] );

   else if (strcmp( "$WindowIDCMPFlags", idString ) == 0)
      outputW_IDCMPFlags( oFP );
   
   else if (strcmp( "$WindowFlags", idString ) == 0)
      outputW_Flags( oFP );
   
   else if (strcmp( "$ScreenFontSize", idString ) == 0)
      outputFontSize();
   
   else if (strcmp( "$SetupBevelBoxes", idString ) == 0)
      outputBBoxDefn();
   
   else if (strcmp( "$RenderBevelBoxes", idString ) == 0)
      outputRenderBBoxes();
   
   else if (strcmp( "$RenderIntuiTexts", idString ) == 0)
      outputRenderITexts();
   
   else if (strcmp( "$SetupMenus", idString ) == 0)
      outputSetupMenus();
   
   else if (strcmp( "$SetupGadgets", idString ) == 0)
      outputSetupGadgets();
   
   else if (strcmp( "$SetupIntuiTexts", idString ) == 0)
      outputITextDefn();

   else if (strcmp( "$SetupScreenCode", idString ) == 0)
      outputSetupScreenCode();

   else if (strcmp( "$CloseScreenCode", idString ) == 0)
      outputCloseScreen();

   else if (strcmp( "$CloseWindowCode", idString ) == 0)
      outputCloseWindow();

   else if (strcmp( "$DisposeMenus", idString ) == 0)
      outputDisposeMenus();
   
   else if (strcmp( "$DisposeGadgets", idString ) == 0)
      outputDisposeGadgets();
   
   else if (strcmp( "$DisposeITexts", idString ) == 0)
      outputDisposeITexts();
   
   else if (strcmp( "$DisposeBBoxes", idString ) == 0)
      outputDisposeBBoxes();
   
   else if (strcmp( "$OpenWindowCode", idString ) == 0)
      outputOpenWindowCode();
   
   else if (strcmp( "$IDCMPHandlers", idString ) == 0)
      outputIDCMPHandlers();
   
   else if (strcmp( "$IDCMPCode", idString ) == 0)
      outputIDCMPCode();

   else                    // Could be '$VER:' or something!! 
      outputDollarStr( yytext );
      
   return;
}


/****h* GTBGenC/processTemplate() [1.0] *******************************
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
   IMPORT FILE *yyin;

   int rval = RETURN_OK;
   
   // -----------------------------------------------------------------

   if (oFP != NULL)
      oFP = out;
   else
      oFP = stdout;
      
   if (tempFP == NULL)
      tempFP = stdin;

   yyin = tempFP;

   BEGIN NORM;
   
   rval = yylex();      // Translate template file to output code.

   if (tempFP != stdin)
      {
      myFClose( tempFP, "processTemplate" );

      tempFP = NULL;
      }

   return( rval );
}    

/* ------------------- END of GTBLex.flex file! ------------------- */
