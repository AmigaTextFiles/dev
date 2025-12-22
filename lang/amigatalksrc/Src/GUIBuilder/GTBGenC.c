/****h* GTBTranslator/GTBGenC.c [2.5] **********************************
*
* NAME
*    GTBGenC.c 
*
* DESCRIPTION
*    Parse through a .template file & send the output data to
*    the specified output fileName for C-source.
* 
* SYNOPSIS 
*    GTBGenC <.ini file> <.template File> [-mS] [-mL]
*
*       -mS asks the program to generate an SMakeFile also.
*       -mL asks the program to generate a Locale header file also.
*
* HISTORY
*    25-Jan-2005 - Added missing generating functions for the 
*                  Mx, Cycle & ListView Gadget contents.
*
*    01-Nov-2004 - Added AmigaOS4 & gcc support.
*    13-Nov-2003 - Since ListView Gadgets do not always have choice
*                  strings, I had to add conditional code to only
*                  generate choice stuff if numberOfChoices > 0.
*
* NOTES
*    $VER: GTBGenC.c 2.5 (25-Jan-2005) by J.T. Steichen
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

#include <intuition/gadgetclass.h>
#include <graphics/rastport.h> // for JAM1, JAM2, etc

#ifndef __amigaos4__

# include "StringFunctions.h" // For StringNComp(), etc.

# include <clib/exec_protos.h>
# include <clib/dos_protos.h>
# include <clib/iffparse_protos.h>
# include <proto/locale.h>

IMPORT struct LocaleBase *LocaleBase;

#else

# include <StringFunctions.h> // For StringNComp(), etc.

# define __USE_INLINE__

# include <proto/exec.h>
# include <proto/dos.h>
# include <proto/iffparse.h>
# include <proto/intuition.h>
# include <proto/graphics.h>
# include <proto/gadtools.h>
# include <proto/locale.h>

IMPORT struct Library *LocaleBase;
IMPORT struct Library *DOSBase;
IMPORT struct Library *SysBase;
IMPORT struct Library *IntuitionBase;
IMPORT struct Library *GfxBase;

PUBLIC struct Library *GadToolsBase;       // Has to be visible to CommonFuncsPPC.o

IMPORT struct DOSIFace       *IDOS;
IMPORT struct ExecIFace      *IExec;
IMPORT struct LocaleIFace    *ILocale;
IMPORT struct IntuitionIFace *IIntuition;
IMPORT struct GraphicsIFace  *IGraphics;

PUBLIC struct GadToolsIFace  *IGadTools;

#endif
 
struct Catalog *scanCatalog = NULL;

#define   CATCOMP_ARRAY    1
#include "GTBProjectLocale.h"

#define  MY_LANGUAGE "english"

#include "GadToolsBoxIFFs.h"

#include "CPGM:GlobalObjects/IniFuncs.h"
#include "CPGM:GlobalObjects/CommonFuncs.h"

#include "ScannerFuncProtos.h"

/* Now found in AmigaDOSErrs.h file...
#ifdef   DEBUG
# define DBG(p) p
#else
# define DBG(p)
#endif
#define BUFF_SIZE     512
*/

#ifndef  MYNULL
# define MYNULL 0
#endif

#define LSIZE          80
#define DELIMITERS    "= &|"

IMPORT UBYTE *ErrMsg;

IMPORT int processTemplate( FILE *tempFP, FILE *out ); // In GTBLex file

IMPORT ULONG getCurrentLineNumber( void ); // in IniFuncs.o

#define MAX_MENUS       3000
#define MAX_GADGETS     3000
#define MAX_ITEXTS      1000
#define MAX_BEVELBOXES  200

// ----------------------------------------------------

PUBLIC void LocaleStrings(  FILE * );
PUBLIC void genWIDCMPFlags( FILE * ); // Used in GTBLex code.
PUBLIC void genWindowFlags( FILE * );
PUBLIC void genWindowTags(  FILE * );

// --- Globals used in GTBLex code: -------------------

PUBLIC BOOL useActiveScreen  = TRUE;
PUBLIC BOOL useToolTypes     = FALSE;
PUBLIC BOOL useBoopsiImage   = FALSE;
PUBLIC BOOL useASLReq        = FALSE;
PUBLIC BOOL usePragmas       = FALSE;
PUBLIC BOOL unrollGadgetLoop = FALSE;

PUBLIC UWORD winLeft         = 0;
PUBLIC UWORD winTop          = 0;
PUBLIC UWORD winWidth        = 0;
PUBLIC UWORD winHeight       = 0;

PUBLIC char sourceFileName[BUFF_SIZE] = { 0, };
PUBLIC char projectName[LSIZE]        = { 0, };
PUBLIC char projectFileName[LSIZE]    = { 0, };
PUBLIC char projectVersion[LSIZE]     = "1.0";
PUBLIC char projectAuthorName[LSIZE]  = "J.T. Steichen";
PUBLIC char projectAuthorEMail[LSIZE] = "jimbot@frontiernet.net";
PUBLIC char screenFontName[LSIZE]     = "helvetica";
PUBLIC char catalogName[LSIZE]        = { 0, };

PUBLIC int  screenFontSize        = 13;

PUBLIC char              **gtags  = NULL; // One line (very long line!) per gadget.

PUBLIC struct myNewGadget *ngads  = NULL;
PUBLIC struct NewMenu     *nmenus = NULL;
PUBLIC struct BBox        *bbox   = NULL;
PUBLIC struct IntuiText   *itxt   = NULL;

PUBLIC int   gadgetCount    = 0;
PUBLIC int   menuCount      = 0;
PUBLIC int   itextCount     = 0;
PUBLIC int   bboxCount      = 0;
PUBLIC int   cycleGCount    = 0; // Also used in GTBTemplate.c & GTBGenMiscC.c
PUBLIC int   listviewGCount = 0; // Also used in GTBTemplate.c & GTBGenMiscC.c
PUBLIC int   mxGCount       = 0; // Also used in GTBTemplate.c & GTBGenMiscC.c

PUBLIC char *cycleStrings   = NULL;
PUBLIC char *mxStrings      = NULL;
PUBLIC char *listStrings    = NULL;

PUBLIC int   numListStrings  = 0;
PUBLIC int   numCycleStrings = 0;
PUBLIC int   numMxStrings    = 0;

PUBLIC ULONG windowIDCMP = 0L;
PUBLIC ULONG windowFlags = 0L;

PUBLIC FILE  *InputFP    = NULL; 

// ----------------------------------------------------

PUBLIC FILE *myFOpen( char *fileName, char *mode, char *func )
{
   FILE *fp = NULL;
	
	if (!fileName || !mode)
	   return( fp ); // Short-circuit from bad input!!
	else
	   fp = fopen( fileName, mode );
   
   DBG( fprintf( stderr, "fopen( \"%s\", \"%s\" ) => 0x%08LX; called from %s\n", fileName, mode, fp, func ));
   
   return( fp );
}

PUBLIC void myFClose( FILE *fp, char *func )
{
   DBG( fprintf( stderr, "fclose( 0x%08LX ); called from %s\n", fp, func ) );

   if (fp && fp != stdin && fp != stdout)
      fclose( fp );
   
   return;
}

// ----------------------------------------------------

PRIVATE void *MyAllocVec( ULONG size, ULONG flags, char *location )
{
   void *rval = NULL;
   
   if (size > 0)
      rval = AllocVec( size, flags );

#  if DEBUG_ALLOC         
   DBG( fprintf( stderr, "%s Alloc = 0x%08LX\n", location, rval ) );
#  endif
   
   return( rval );
}

PRIVATE void MyFreeVec( void *memBlock, char *location )
{
   if ((memBlock != MYNULL) && (memBlock != (void *) NM_BARLABEL))
      {
#     if DEBUG_ALLOC         
      DBG( fprintf( stderr, "%s Free = 0x%08LX\n", location, memBlock ) );
#     endif
      
      FreeVec( memBlock );
      
      memBlock = NULL;
      }

   return;
}

PRIVATE char *cgn = &currentGroupName[0];

PRIVATE BOOL openedLocale = FALSE;

PRIVATE char usage[] = "USAGE:  %s File.ini File.template [-mL] [-mS]\n";

PRIVATE FILE *outFile = MYNULL;

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
   if (scanCatalog)
      return( (STRPTR) GetCatalogStr( scanCatalog, strIndex, defaultString ) );
   else
      return( (STRPTR) defaultString );
}

// ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

PRIVATE int IRaised( int base, int power )
{
   int  rval = 1;
   int  i;

   if (power == 0)
      return( rval );

   for ( i = 0; i < power; i++)   
      rval = rval * base;

   return( rval );
}

PRIVATE int Iconv_digit( int chr )
{
   int   temp = 0;

   if (isdigit( chr ))
      temp = (chr - '0');
   else if ((chr >= 'a' && chr <= 'f') || (chr >= 'A' && chr <= 'F'))
      temp = (chr - 'A' + 10);

   return( temp );
}

PUBLIC int hxtoi( char *hxstr )
{
   int     IRaised( int, int );
   int     Iconv_digit( int );

   int     rval    = 0, lngth = 0, index = 0;
   char    nxt[12] = { 0, }, ch; // *nx = &nxt[0], ch;

   (void) StringCopy( nxt, hxstr );

   lngth = StringLength( nxt );

   if (lngth > 8 || lngth < 1) 
      {
      return( 0 );
      }

   lngth --;

   while (lngth >= 0)   
      {
      ch   = toupper( nxt[ lngth ] );
      rval = rval + Iconv_digit( ch ) * IRaised( 16, index );

      lngth--;
      index++;
      }

   return( rval );
}

PRIVATE int hexToI( char *str )
{
#  ifdef __amigaos4__
   char dummy[32] = { 0, }, *dumb = &dummy[0];
#  endif

   int  rval = 0;

   if (!str)
      return( rval );

#  ifdef __amigaos4__
		
   if (*str == '0' && str[1] == 'x')
      rval = strtoul( &str[2], &dumb, 16 );
	else
      rval = strtoul( &str[0], &dumb, 16 );

#  elif (__SASC_650)
   if (*str == '0' && str[1] == 'x')
      stch_i( &str[2], &rval );
   else
      stch_i( &str[0], &rval );

#  else // Use our own code...
      
   if (*str == '0' && str[1] == 'x')
      rval = (int) hxtoi( &str[2] );
   else
      rval = (int) hxtoi( &str[0] );
#  endif
      
   return( rval );
}

// :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

// --- Used in GTBLex code: ------------------------------------

PRIVATE aiPTR aicopy = NULL;

PUBLIC void genMultStrings( int gtype )
{
   int mxk = 0;
   int cyk = 0;
   int lvk = 0;
   int i;
   
   switch (gtype)
      {
      case MX_KIND:
         for (i = 0; i < gadgetCount; i++)
            {
            if (ngads[i].ng_Type == MX_KIND)
               {
               if (ngads[i].ng_NumberOfChoices > 0) // Should NOT be necessary!
                  {
                  int j;
               
                  fprintf( outFile, "#define MX_%d_CNT   %d\n\n",
                                     ngads[i].ng_GadgetID, ngads[i].ng_NumberOfChoices + 1 
                         );

                  fprintf( outFile, "PRIVATE UBYTE *MX_%dLbls[ MX_%d_CNT ] = {\n\n", 
		                     ngads[i].ng_GadgetID, ngads[i].ng_GadgetID 
			                );

                  for (j = 0; j < ngads[i].ng_NumberOfChoices; j++)
                     {
                     fprintf( outFile, "   \"%s\",\n", &mxStrings[ (j + mxk) * LSIZE ] ); 
                     }
                  
                  fputs(               "   NULL\n", outFile ); // Terminate strings   
                  
                  mxk += ngads[i].ng_NumberOfChoices;
    
                  fputs( "};\n", outFile );
                  }
	            }
            }

         break;

      case LISTVIEW_KIND:
         for (i = 0; i < gadgetCount; i++)
            {
            if (ngads[i].ng_Type == LISTVIEW_KIND)
               {
               if (ngads[i].ng_NumberOfChoices > 0) // This is Necessary!
                  {
                  int j;

                  fprintf( outFile, "#define LV%d_NUM_ELEMENTS  %d\n"
                                    "#define ELEMENT_SIZE       %d\n\n",
                                     ngads[i].ng_GadgetID, ngads[i].ng_NumberOfChoices + 1,
                                     LSIZE
                         );               

                  fprintf( outFile, "PRIVATE struct List         %sList   = { 0, };\n",
                                     ngads[i].ng_UserData
                         );
  
                  fprintf( outFile, "PRIVATE struct ListViewMem *%s%d_lvm = NULL;\n\n",
                                     ngads[i].ng_UserData, ngads[i].ng_GadgetID
                         );

                  fprintf( outFile, "#define LV_%d_CNT %d\n\n",
                                     ngads[i].ng_GadgetID, ngads[i].ng_NumberOfChoices + 1
                         );

                  fprintf( outFile, "PRIVATE UBYTE *LV_%dLbls[ LV_%d_CNT ] = {\n\n", 
		                    ngads[i].ng_GadgetID, ngads[i].ng_GadgetID
		                   );

                  for (j = 0; j < ngads[i].ng_NumberOfChoices; j++)
                     {
                     fprintf( outFile, "   \"%s\",\n", &listStrings[ (j + lvk) * LSIZE ] ); 
                     }
                  
                  fputs(               "   NULL\n", outFile ); // Terminate strings   

                  lvk += ngads[i].ng_NumberOfChoices;
    
                  fputs( "};\n", outFile );
                  }
               }
            }

         break;

      case CYCLE_KIND:
         for (i = 0; i < gadgetCount; i++)
            {
            if (ngads[i].ng_Type == CYCLE_KIND)
               {
               if (ngads[i].ng_NumberOfChoices > 0) // Should NOT be necessary!
                  {
                  int j;
               
                  fprintf( outFile, "#define CY_%d_CNT   %d\n\n",
                                     ngads[i].ng_GadgetID, ngads[i].ng_NumberOfChoices + 1
                         );

                  fprintf( outFile, "PRIVATE UBYTE *CY_%dLbls[ CY_%d_CNT ] = {\n\n", 
		                     ngads[i].ng_GadgetID, ngads[i].ng_GadgetID 
		                   );

                  for (j = 0; j < ngads[i].ng_NumberOfChoices; j++)
                     {
                     fprintf( outFile, "   \"%s\",\n", &cycleStrings[ (j + cyk) * LSIZE ] ); 
                     }
                  
                  fputs(               "   NULL\n", outFile ); // Terminate strings   

                  cyk += ngads[i].ng_NumberOfChoices;
    
                  fputs( "};\n", outFile );
                  }
	            }
            }

         break;
      }
      
   return;
}

SUBFUNC void outputChoiceLocaleStrings( struct myNewGadget *gad )
{
   int idx = 0;
   
   if (gad->ng_Type == MX_KIND)
      {
      if (gad->ng_NumberOfChoices > 0)
         {
         int j;
               
         for (j = 0; j < gad->ng_NumberOfChoices; j++)
	         {
            fprintf( outFile, "   MX_%dLbls[%d] = CMsg( MSG_GAD_%d%d_MXLBL, MSG_GAD_%d%d_MXLBL_STR );\n", 
                                  gad->ng_GadgetID, j,
				                      gad->ng_GadgetID, idx,
				                      gad->ng_GadgetID, idx
                   );

            idx++;
            }

         fprintf( outFile, "   // MX_%dLbls[%d] = NULL;\n\n", gad->ng_GadgetID, j );
	      }
      }
   else if (gad->ng_Type == LISTVIEW_KIND)
      {
      if (gad->ng_NumberOfChoices > 0)
         {
         int j;
               
         for (j = 0; j < gad->ng_NumberOfChoices; j++)
            {   
            fprintf( outFile, "   LV_%dLbls[%d] = CMsg( MSG_GAD_%d%d_LVLBL, MSG_GAD_%d%d_LVLBL_STR );\n",
                                  gad->ng_GadgetID, j,
	  		            	          gad->ng_GadgetID, idx,
				                      gad->ng_GadgetID, idx
                   );

            idx++;
            }

         fprintf( outFile, "   // LV_%dLbls[%d] = NULL;\n\n", gad->ng_GadgetID, j );
	      }
      }
   else if (gad->ng_Type == CYCLE_KIND)
      {
      if (gad->ng_NumberOfChoices > 0)
         {
         int j;

         for (j = 0; j < gad->ng_NumberOfChoices; j++)
            {   
            fprintf( outFile, "   CY_%dLbls[%d] = CMsg( MSG_GAD_%d%d_CYLBL, MSG_GAD_%d%d_CYLBL_STR );\n",
                                  gad->ng_GadgetID, j,
				                      gad->ng_GadgetID, idx,
				                      gad->ng_GadgetID, idx
                   );

            idx++;
            }

         fprintf( outFile, "   // CY_%dLbls[%d] = NULL;\n\n", gad->ng_GadgetID, j );
         }
      }

   return;
}

SUBFUNC void outputITextLocaleStrings( FILE *fp )
{
   if (itextCount < 1)
      return;

   else if (itextCount == 1)
      {
      fprintf( fp, "   %sIT.IText = (UBYTE *) CMsg( MSG_ITXT_%s0, MSG_ITXT_%s0_STR );\n\n",
                       projectName, projectName, projectName
             );
      }
   else 
      {     
      int i;
      
      for (i = 0; i < itextCount; i++)
         {
         fprintf( fp, "   %sIT[%d].IText = (UBYTE *) CMsg( MSG_ITXT_%s%d, MSG_ITXT_%s%d_STR );\n",
                          projectName, i, 
		                    projectName, i, 
		                    projectName, i 
	             );
         }

      fputc( '\n', fp );
      }

   return;
}

PUBLIC void LocaleStrings( FILE *fp )
{
   IMPORT char *filterMenuLabel( char *label );
   
   int i;

   fprintf( fp, "   ScrTitle = CMsg( MSG_%s_STITLE, MSG_%s_STITLE_STR ); // WA_ScreenTitle\n", 
                    projectName, projectName
          );
      
   fprintf( fp, "   %sWdt  = CMsg( MSG_%s_WTITLE, MSG_%s_WTITLE_STR ); // WA_Title\n\n",
                    projectName, projectName, projectName 
          );

   fputs( "   // Place StringNCopy( ToolName, CMsg( , _STR ), 32 ); calls here!!\n\n", fp );
   
   fflush( fp );
      
   outputITextLocaleStrings( fp );
   
   if (gadgetCount < 1)
      goto checkMenus; // Nothing to do for Gadget strings.

   fflush( fp );

   for (i = 0; i < gadgetCount; i++)
      {
      outputChoiceLocaleStrings( &ngads[i] );

      if ((STRPTR) ngads[i].ng_GadgetText && (STRPTR) ngads[i].ng_GadgetText < (STRPTR) 1024)
         fputs( "   // Generic (or Unlabeled) Gadget?? ---------------- \n", fp ); // Indicate missing Texts.
      else if (ngads[i].ng_GadgetText && StringLength( (char *) ngads[i].ng_GadgetText ) > 0)
         {
         fprintf( fp, "   %sNGad[ %d ].ng_GadgetText = CMsg( MSG_GAD_%s, MSG_GAD_%s_STR );\n",
                          projectName, i, 
                          (UBYTE *) ngads[i].ng_UserData,
                          (UBYTE *) ngads[i].ng_UserData
                );
         }
      else // ngads[i].ng_GadgetText == NULL
         fputs( "   // Generic (or Unlabeled) Gadget?? ---------------- \n", fp ); // Indicate missing Texts.
      }

checkMenus:

   fputs( "\n   // ---- Menu Strings (if any): -------------------------------- \n", fp );

   fflush( fp );

   if (menuCount < 1)
      goto genASLStrings; // Nothing to do for menu strings
   
   for (i = 0; i < menuCount; i++)
      {
      if (nmenus[i].nm_Label && nmenus[i].nm_Label < (STRPTR) 1024)
         fputs( "   // BAR_LABEL?? ------------------------------------- \n", fp ); // Indicate missing Texts.
      else if (nmenus[i].nm_Label && nmenus[i].nm_Label == (STRPTR) NM_BARLABEL)
         fputs( "   // BAR_LABEL?? ------------------------------------- \n", fp ); // Indicate missing Texts.
      else if (nmenus[i].nm_Label && StringLength( (char *) nmenus[i].nm_Label ) > 0)
         {
         fprintf( fp, "   %sNMenu[ %d ].nm_Label = CMsg( MSG_MENU_%s, MSG_MENU_%s_STR );\n",
                          projectName, i,
                          filterMenuLabel( (char *) nmenus[i].nm_Label ),
                          filterMenuLabel( (char *) nmenus[i].nm_Label )
                );
         }
      else
         fputs( "   // BAR_LABEL?? ------------------------------------- \n", fp ); // Inidicate missing Texts.
      }

   fputs( "\n   // ----- Menu Key strings (if any): ---------------------------- \n", fp );

   for (i = 0; i < menuCount; i++)
      {
      if (nmenus[i].nm_CommKey && nmenus[i].nm_CommKey < (STRPTR) 1024)
         {
	      ; // Do Nothing here
	      }
      else if (nmenus[i].nm_CommKey && StringLength( nmenus[i].nm_CommKey ) > 0)
         {
	      if (StringComp( nmenus[i].nm_CommKey, "0" ) != 0)
	         {
            fprintf( fp, "   %sNMenu[ %d ].nm_CommKey = CMsg( MSG_MENUKEY_%s, MSG_MENUKEY_%s_STR );\n",
                             projectName, i,
                             nmenus[i].nm_CommKey,
                             nmenus[i].nm_CommKey
                   );
	         }
         }
      }

   fflush( fp );

genASLStrings:
   
   fputs( "\n#  ifdef USE_ASL_REQ\n"
          "   SetTagItem( FileTags, ASLFR_TitleText,    (ULONG) CMsg( MSG_ASL_RTITLE,    MSG_ASL_RTITLE_STR    ));\n"
          "   SetTagItem( FileTags, ASLFR_PositiveText, (ULONG) CMsg( MSG_ASL_OKAY_BT,   MSG_ASL_OKAY_BT_STR   ));\n"
          "   SetTagItem( FileTags, ASLFR_NegativeText, (ULONG) CMsg( MSG_ASL_CANCEL_BT, MSG_ASL_CANCEL_BT_STR ));\n"
          "#  endif\n", fp 
        );

   return;      
}

SUBFUNC ULONG genGadgetIDCMPs( FILE *fp, ULONG idcmp )
{
   ULONG rval = idcmp;
   int   i    = 0;
   
   if (gadgetCount < 1)
      return( idcmp );  // Nothing to do.
   else
      {
      BOOL but, chk, intg, lv, mx, num, cy, pa, sc, sl, st, tx;

      but = chk = intg = lv = mx = num = cy = pa = sc = sl = st = tx = FALSE;
      
      while (i < gadgetCount)
         {
         if (ngads[i].ng_Type == BUTTON_KIND && but == FALSE)
            {
            fputs( "BUTTONIDCMP | ", fp );
            but   = TRUE;
            rval &= ~BUTTONIDCMP;
            }

         if (ngads[i].ng_Type == CHECKBOX_KIND && chk == FALSE)
            {
            fputs( "CHECKBOXIDCMP | ", fp );
            chk   = TRUE;
            rval &= ~CHECKBOXIDCMP;
            }

         if (ngads[i].ng_Type == INTEGER_KIND && intg == FALSE)
            {
            fputs( "INTEGERIDCMP | ", fp );
            intg  = TRUE;
            rval &= ~INTEGERIDCMP;
            }

         if (ngads[i].ng_Type == LISTVIEW_KIND && lv == FALSE)
            {
            fputs( "LISTVIEWIDCMP |\n           ", fp );
            lv    = TRUE;
            rval &= ~LISTVIEWIDCMP;
            }

         if (ngads[i].ng_Type == MX_KIND && mx == FALSE)
            {
            fputs( "MXIDCMP | ", fp );
            mx    = TRUE;
            rval &= ~MXIDCMP;
            }

         if (ngads[i].ng_Type == NUMBER_KIND && num == FALSE)
            {
            fputs( "NUMBERIDCMP | ", fp );
            num   = TRUE;
            rval &= ~NUMBERIDCMP;
            }

         if (ngads[i].ng_Type == CYCLE_KIND && cy == FALSE)
            {
            fputs( "CYCLEIDCMP | ", fp );
            cy    = TRUE;
            rval &= ~CYCLEIDCMP;
            }

         if (ngads[i].ng_Type == PALETTE_KIND && pa == FALSE)
            {
            fputs( "PALETTEIDCMP | ", fp );
            pa    = TRUE;
            rval &= ~PALETTEIDCMP;
            }

         if (ngads[i].ng_Type == SCROLLER_KIND && sc == FALSE)
            {
            fputs( "SCROLLERIDCMP | ", fp );
            sc    = TRUE;
            rval &= ~SCROLLERIDCMP;
            }

         if (ngads[i].ng_Type == SLIDER_KIND && sl == FALSE)
            {
            fputs( "SLIDERIDCMP | ", fp );
            sl    = TRUE;
            rval &= ~SLIDERIDCMP;
            }

         if (ngads[i].ng_Type == STRING_KIND && st == FALSE)
            {
            fputs( "STRINGIDCMP | ", fp );
            st    = TRUE;
            rval &= ~STRINGIDCMP;
            }

         if (ngads[i].ng_Type == TEXT_KIND && tx == FALSE)
            {
            fputs( "TEXTIDCMP | ", fp );
            tx    = TRUE;
            rval &= ~TEXTIDCMP;
            }

         i++;
         }
      }

   fputs( "\n           ", fp ); // terminate this mess.

   return( rval );      
}

PUBLIC void genWIDCMPFlags( FILE *fp )
{
   BOOL   firstFlag = TRUE;
   ULONG  idcmp     = windowIDCMP & 0x07FDFFFF; // Mask off unwanted flags.
   
   fputs( "         WA_IDCMP,        ", fp );

   if (idcmp == 0)
      {
      fputs( "0L,\n\n", fp ); // Highly unlikely.

      return;
      }
      
   idcmp = genGadgetIDCMPs( fp, idcmp );
   
   if (idcmp & IDCMP_CLOSEWINDOW)
      {
      if (firstFlag == TRUE)
         {
         firstFlag = FALSE;
         fputs( "IDCMP_CLOSEWINDOW", fp );
         }
      else 
         fputs( " | IDCMP_CLOSEWINDOW", fp );
      }

   if (idcmp & IDCMP_GADGETDOWN)
      {
      if (firstFlag == TRUE)
         {
         firstFlag = FALSE;
         fputs( "IDCMP_GADGETDOWN", fp );
         }
      else 
         fputs( " | IDCMP_GADGETDOWN", fp );
      }

   if (idcmp & IDCMP_GADGETUP)
      {
      if (firstFlag == TRUE)
         {
         firstFlag = FALSE;
         fputs( "IDCMP_GADGETUP", fp );
         }
      else 
         fputs( " | IDCMP_GADGETUP", fp );
      }

   if (idcmp & IDCMP_MENUPICK)
      {
      if (firstFlag == TRUE)
         {
         firstFlag = FALSE;
         fputs( "IDCMP_MENUPICK", fp );
         }
      else 
         fputs( " | IDCMP_MENUPICK", fp );
      }

   if (idcmp & IDCMP_VANILLAKEY)
      {
      if (firstFlag == TRUE)
         {
         firstFlag = FALSE;
         fputs( "IDCMP_VANILLAKEY", fp );
         }
      else 
         fputs( " | IDCMP_VANILLAKEY", fp );
      }

   if (idcmp & IDCMP_RAWKEY)
      {
      if (firstFlag == TRUE)
         {
         firstFlag = FALSE;
         fputs( "IDCMP_RAWKEY", fp );
         }
      else 
         fputs( " | IDCMP_RAWKEY", fp );
      }

   if (idcmp & IDCMP_NEWSIZE)
      {
      if (firstFlag == TRUE)
         {
         firstFlag = FALSE;
         fputs( "IDCMP_NEWSIZE", fp );
         }
      else 
         fputs( " | IDCMP_NEWSIZE", fp );
      }

   if (idcmp & IDCMP_REFRESHWINDOW)
      {
      if (firstFlag == TRUE)
         {
         firstFlag = FALSE;
         fputs( "IDCMP_REFRESHWINDOW", fp );
         }
      else 
         fputs( " | IDCMP_REFRESHWINDOW", fp );
      }

   if (idcmp & IDCMP_MOUSEBUTTONS)
      {
      if (firstFlag == TRUE)
         {
         firstFlag = FALSE;
         fputs( "IDCMP_MOUSEBUTTONS", fp );
         }
      else 
         fputs( " | IDCMP_MOUSEBUTTONS", fp );
      }

   if (idcmp & IDCMP_MOUSEMOVE)
      {
      if (firstFlag == TRUE)
         {
         firstFlag = FALSE;
         fputs( "IDCMP_MOUSEMOVE", fp );
         }
      else 
         fputs( " | IDCMP_MOUSEMOVE", fp );
      }

   if (idcmp & IDCMP_REQSET)
      {
      if (firstFlag == TRUE)
         {
         firstFlag = FALSE;
         fputs( "IDCMP_REQSET", fp );
         }
      else 
         fputs( " | IDCMP_REQSET", fp );
      }

   if (idcmp & IDCMP_REQCLEAR)
      {
      if (firstFlag == TRUE)
         {
         firstFlag = FALSE;
         fputs( "IDCMP_REQCLEAR", fp );
         }
      else 
         fputs( " | IDCMP_REQCLEAR", fp );
      }

   if (idcmp & IDCMP_NEWPREFS)
      {
      if (firstFlag == TRUE)
         {
         firstFlag = FALSE;
         fputs( "IDCMP_NEWPREFS", fp );
         }
      else 
         fputs( " | IDCMP_NEWPREFS", fp );
      }

   if (idcmp & IDCMP_DISKINSERTED)
      {
      if (firstFlag == TRUE)
         {
         firstFlag = FALSE;
         fputs( "IDCMP_DISKINSERTED", fp );
         }
      else 
         fputs( " | IDCMP_DISKINSERTED", fp );
      }

   if (idcmp & IDCMP_DISKREMOVED)
      {
      if (firstFlag == TRUE)
         {
         firstFlag = FALSE;
         fputs( "IDCMP_DISKREMOVED", fp );
         }
      else 
         fputs( " | IDCMP_DISKREMOVED", fp );
      }

   if (idcmp & IDCMP_ACTIVEWINDOW)
      {
      if (firstFlag == TRUE)
         {
         firstFlag = FALSE;
         fputs( "IDCMP_ACTIVEWINDOW", fp );
         }
      else 
         fputs( " | IDCMP_ACTIVEWINDOW", fp );
      }

   if (idcmp & IDCMP_INACTIVEWINDOW)
      {
      if (firstFlag == TRUE)
         {
         firstFlag = FALSE;
         fputs( "IDCMP_INACTIVEWINDOW", fp );
         }
      else 
         fputs( " | IDCMP_INACTIVEWINDOW", fp );
      }

   if (idcmp & IDCMP_DELTAMOVE)
      {
      if (firstFlag == TRUE)
         {
         firstFlag = FALSE;
         fputs( "IDCMP_DELTAMOVE", fp );
         }
      else 
         fputs( " | IDCMP_DELTAMOVE", fp );
      }

   if (idcmp & IDCMP_INTUITICKS)
      {
      if (firstFlag == TRUE)
         {
         firstFlag = FALSE;
         fputs( "IDCMP_INTUITICKS", fp );
         }
      else 
         fputs( " | IDCMP_INTUITICKS", fp );
      }

   if (idcmp & IDCMP_IDCMPUPDATE)
      {
      if (firstFlag == TRUE)
         {
         firstFlag = FALSE;
         fputs( "IDCMP_IDCMPUPDATE", fp );
         }
      else 
         fputs( " | IDCMP_IDCMPUPDATE", fp );
      }

   if (idcmp & IDCMP_MENUHELP)
      {
      if (firstFlag == TRUE)
         {
         firstFlag = FALSE;
         fputs( "IDCMP_MENUHELP", fp );
         }
      else 
         fputs( " | IDCMP_MENUHELP", fp );
      }

   if (idcmp & IDCMP_CHANGEWINDOW)
      {
      if (firstFlag == TRUE)
         {
         firstFlag = FALSE;
         fputs( "IDCMP_CHANGEWINDOW", fp );
         }
      else 
         fputs( " | IDCMP_CHANGEWINDOW", fp );
      }

   if (idcmp & IDCMP_GADGETHELP)
      {
      if (firstFlag == TRUE)
         {
         firstFlag = FALSE;
         fputs( "IDCMP_GADGETHELP", fp );
         }
      else 
         fputs( " | IDCMP_GADGETHELP", fp );
      }

   if (idcmp & IDCMP_MENUVERIFY)
      {
      if (firstFlag == TRUE)
         {
         firstFlag = FALSE;
         fputs( "IDCMP_MENUVERIFY", fp );
         }
      else 
         fputs( " | IDCMP_MENUVERIFY", fp );
      }

   if (idcmp & IDCMP_SIZEVERIFY)
      {
      if (firstFlag == TRUE)
         {
         firstFlag = FALSE;
         fputs( "IDCMP_SIZEVERIFY", fp );
         }
      else 
         fputs( " | IDCMP_SIZEVERIFY", fp );
      }

   if (idcmp & IDCMP_REQVERIFY)
      {
      if (firstFlag == TRUE)
         {
         firstFlag = FALSE;
         fputs( "IDCMP_REQVERIFY", fp );
         }
      else 
         fputs( " | IDCMP_REQVERIFY", fp );
      }

   fputs( ",\n\n", fp ); // Terminate the IDCMPFlags line.

   return;
}

PUBLIC void genWindowFlags( FILE *fp )
{
   BOOL  firstFlag = TRUE;
   ULONG flags     = windowFlags & 0x00271FFF; // Mask off unwanted flags.

   fputs( "         WA_Flags,         ", fp );

   if (flags == 0)
      {
      fputs( "0L,\n\n", fp ); // Highly unlikely.

      return;
      }

   if (flags & WFLG_ACTIVATE)
      {
      if (firstFlag == TRUE)
         {
         firstFlag = FALSE;
         fputs( "WFLG_ACTIVATE", fp );
         }
      else 
         fputs( " | WFLG_ACTIVATE", fp );
      }
         
   if (flags & WFLG_SIZEGADGET)
      {
      if (firstFlag == TRUE)
         {
         firstFlag = FALSE;
         fputs( "WFLG_SIZEGADGET", fp );
         }
      else 
         fputs( " | WFLG_SIZEGADGET", fp );
      }   

   if (flags & WFLG_DRAGBAR)
      {
      if (firstFlag == TRUE)
         {
         firstFlag = FALSE;
         fputs( "WFLG_DRAGBAR", fp );
         }
      else 
         fputs( " | WFLG_DRAGBAR", fp );
      }   

   if (flags & WFLG_DEPTHGADGET)
      {
      if (firstFlag == TRUE)
         {
         firstFlag = FALSE;
         fputs( "WFLG_DEPTHGADGET", fp );
         }
      else 
         fputs( " | WFLG_DEPTHGADGET\n          ", fp );
      }   

   if (flags & WFLG_CLOSEGADGET)
      {
      if (firstFlag == TRUE)
         {
         firstFlag = FALSE;
         fputs( "WFLG_CLOSEGADGET", fp );
         }
      else 
         fputs( " | WFLG_CLOSEGADGET", fp );
      }   

   if (flags & WFLG_SIZEBRIGHT)
      {
      if (firstFlag == TRUE)
         {
         firstFlag = FALSE;
         fputs( "WFLG_SIZEBRIGHT", fp );
         }
      else 
         fputs( " | WFLG_SIZEBRIGHT", fp );
      }   

   if (flags & WFLG_SIZEBBOTTOM)
      {
      if (firstFlag == TRUE)
         {
         firstFlag = FALSE;
         fputs( "WFLG_SIZEBBOTTOM", fp );
         }
      else 
         fputs( " | WFLG_SIZEBBOTTOM", fp );
      }   

   if (flags & WFLG_SMART_REFRESH)
      {
      if (firstFlag == TRUE)
         {
         firstFlag = FALSE;
         fputs( "WFLG_SMART_REFRESH", fp );
         }
      else 
         fputs( " | WFLG_SMART_REFRESH\n          ", fp );
      }   

   if (flags & WFLG_SIMPLE_REFRESH)
      {
      if (firstFlag == TRUE)
         {
         firstFlag = FALSE;
         fputs( "WFLG_SIMPLE_REFRESH", fp );
         }
      else 
         fputs( " | WFLG_SIMPLE_REFRESH\n          ", fp );
      }   

   if (flags & WFLG_SUPER_BITMAP)
      {
      if (firstFlag == TRUE)
         {
         firstFlag = FALSE;
         fputs( "WFLG_SUPER_BITMAP", fp );
         }
      else 
         fputs( " | WFLG_SUPER_BITMAP\n          ", fp );
      }   

   if (flags & WFLG_OTHER_REFRESH)
      {
      if (firstFlag == TRUE)
         {
         firstFlag = FALSE;
         fputs( "WFLG_OTHER_REFRESH", fp );
         }
      else 
         fputs( " | WFLG_OTHER_REFRESH\n          ", fp );
      }   

   if (flags & WFLG_BACKDROP)
      {
      if (firstFlag == TRUE)
         {
         firstFlag = FALSE;
         fputs( "WFLG_BACKDROP", fp );
         }
      else 
         fputs( " | WFLG_BACKDROP", fp );
      }   

   if (flags & WFLG_REPORTMOUSE)
      {
      if (firstFlag == TRUE)
         {
         firstFlag = FALSE;
         fputs( "WFLG_REPORTMOUSE", fp );
         }
      else 
         fputs( " | WFLG_REPORTMOUSE", fp );
      }   

   if (flags & WFLG_GIMMEZEROZERO)
      {
      if (firstFlag == TRUE)
         {
         firstFlag = FALSE;
         fputs( "WFLG_GIMMEZEROZERO", fp );
         }
      else 
         fputs( " | WFLG_GIMMEZEROZERO\n          ", fp );
      }   

   if (flags & WFLG_BORDERLESS)
      {
      if (firstFlag == TRUE)
         {
         firstFlag = FALSE;
         fputs( "WFLG_BORDERLESS", fp );
         }
      else 
         fputs( " | WFLG_BORDERLESS", fp );
      }   

   if (flags & WFLG_RMBTRAP)
      {
      if (firstFlag == TRUE)
         {
         firstFlag = FALSE;
         fputs( "WFLG_RMBTRAP", fp );
         }
      else 
         fputs( " | WFLG_RMBTRAP", fp );
      }   

   if (flags & WFLG_NOCAREREFRESH)
      {
      if (firstFlag == TRUE)
         {
         firstFlag = FALSE;
         fputs( "WFLG_NOCAREREFRESH", fp );
         }
      else 
         fputs( " | WFLG_NOCAREREFRESH\n          ", fp );
      }   

   if (flags & WFLG_NW_EXTENDED)
      {
      if (firstFlag == TRUE)
         {
         firstFlag = FALSE;
         fputs( "WFLG_NW_EXTENDED", fp );
         }
      else 
         fputs( " | WFLG_NW_EXTENDED", fp );
      }   

   if (flags & WFLG_NEWLOOKMENUS)
      {
      if (firstFlag == TRUE)
         {
         firstFlag = FALSE;
         fputs( "WFLG_NEWLOOKMENUS", fp );
         }
      else 
         fputs( " | WFLG_NEWLOOKMENUS", fp );
      }   

   if (flags & WFLG_VISITOR)
      {
      if (firstFlag == TRUE)
         {
         firstFlag = FALSE;
         fputs( "WFLG_VISITOR", fp );
         }
      else 
         fputs( " | WFLG_VISITOR", fp );
      }   

   if (flags & WFLG_ZOOMED)
      {
      if (firstFlag == TRUE)
         {
         firstFlag = FALSE;
         fputs( "WFLG_ZOOMED", fp );
         }
      else 
         fputs( " | WFLG_ZOOMED", fp );
      }   

   if (flags & WFLG_HASZOOM)
      {
      if (firstFlag == TRUE)
         {
         firstFlag = FALSE;
         fputs( "WFLG_HASZOOM", fp );
         }
      else 
         fputs( " | WFLG_HASZOOM", fp );
      }   
   else
      fputs( "// | WFLG_HASZOOM", fp );
      
   fputs( ",\n\n", fp ); // Terminate the Flags line.

   return;
}

PUBLIC int myAtoi( char *str )
{
   if (!str)
      return( 0 );
   else
      return( atoi( str ) );
}

PUBLIC void genWindowTags( FILE *fp )
{
   int li = 0, value = 0;
   
   (void) iniFirstGroup( aicopy );

   li = iniFindGroup( aicopy, CMsg( MSG_GRP_WDATATAGS, MSG_GRP_WDATATAGS_STR ) ) + 1;
   
   if ((li = iniFindItem( aicopy, "WA_AutoAdjust" )) > 0)
      fprintf( fp, "         WA_AutoAdjust,    %s,\n", 
               StringNComp( iniGetItemValue( aicopy, li ), "0", 1 ) == 0 ? "FALSE" : "TRUE" 
             );
   
   if ((li = iniFindItem( aicopy, "WA_NewLookMenus" )) > 0)
      fprintf( fp, "         WA_NewLookMenus,  %s,\n",
               StringNComp( iniGetItemValue( aicopy, li ), "0", 1 ) == 0  ? "FALSE" : "TRUE"
             );
   
   if ((li = iniFindItem( aicopy, "WA_MinWidth" )) > 0)
      {
      value = myAtoi( iniGetItemValue( aicopy, li ) );
      fprintf( fp, "         WA_MinWidth,      %d,\n", value );
      }
   
   if ((li = iniFindItem( aicopy, "WA_MinHeight" )) > 0)
      {
      value = myAtoi( iniGetItemValue( aicopy, li ) );
      fprintf( fp, "         WA_MinHeight,     %d,\n", value );
      }
   
   if ((li = iniFindItem( aicopy, "WA_MaxWidth" )) > 0)
      {
      value = myAtoi( iniGetItemValue( aicopy, li ) );
      fprintf( fp, "         WA_MaxWidth,      %d,\n", value );
      }
   
   if ((li = iniFindItem( aicopy, "WA_MaxHeight" )) > 0)
      {
      value = myAtoi( iniGetItemValue( aicopy, li ) );
      fprintf( fp, "         WA_MaxHeight,     %d,\n", value );
      }
      
   return;
}

// --------- More general housekeeping functions: --------------

IMPORT UBYTE *FileNamePart( UBYTE *filePathString ); // Located in GTBGenMiscC.c

PRIVATE char tempSFN[ BUFF_SIZE ], *tSFN = &tempSFN[0];

SUBFUNC char *makeSourceName( char *iniFileName )
{
   int  length;

   if (!iniFileName || StringLength( iniFileName ) < 1)
	   StringCopy( tSFN, "BOGUS_iniFileName" );
	else   
      StringNCopy( tSFN, (char *) FileNamePart( (UBYTE *) iniFileName ), BUFF_SIZE ); // Remove Path information first.

   DBG( fprintf( stderr, "makeSourceName(): source = '%s'\n", tSFN ) );   

   length = StringLength( tSFN );
   
   while (length > 0)
      {
      if (*(tSFN + length) == '.')
         break;
      
      length--;
      }
   
   *(tSFN + length) = '\0'; //Clip off the *.ini extension.
   
   StringCat( tSFN, ".c" );
   DBG( fprintf( stderr, "makeSourceName(): source = '%s'\n", tSFN ) );   
   
   return( tSFN );   
}

SUBFUNC int setupProgramFlags( aiPTR ai )
{
   int li = 0, value = FALSE, rval = RETURN_OK;

   (void) iniFirstGroup( ai );

   (void) iniFindGroup( ai, CMsg( MSG_GRP_PDATATAGS, MSG_GRP_PDATATAGS_STR ) );
      
   if ((li = iniFindItem( ai, CMsg( MSG_ITEM_PRJ_ICONFLAG, MSG_ITEM_PRJ_ICONFLAG_STR ))) == 0)
      {
      rval = RETURN_FAIL;

      goto exitSetup;
      }
   else
      {
      value = myAtoi( iniGetItemValue( ai, li ) );
      
      if (value == 1)
         useToolTypes = TRUE;
      else
         useToolTypes = FALSE;
      }

   if ((li = iniFindItem( ai, CMsg( MSG_ITEM_PRJ_ASLFLAG, MSG_ITEM_PRJ_ASLFLAG_STR ) )) == 0)
      {
      rval = RETURN_FAIL;

      goto exitSetup;
      }
   else
      {
      value = myAtoi( iniGetItemValue( ai, li ) );
      
      if (value == 1)
         useASLReq = TRUE;
      else
         useASLReq = FALSE;
      }

   if ((li = iniFindItem( ai, CMsg( MSG_ITEM_PRJ_SCRNFLAG, MSG_ITEM_PRJ_SCRNFLAG_STR ) )) == 0)
      {
      rval = RETURN_FAIL;

      goto exitSetup;
      }
   else
      {
      value = myAtoi( iniGetItemValue( ai, li ) );
      
      if (value == 1)
         useActiveScreen = TRUE;
      else
         useActiveScreen = FALSE;
      }

   if ((li = iniFindItem( ai, CMsg( MSG_ITEM_PRJ_UNROLLFLAG, MSG_ITEM_PRJ_UNROLLFLAG_STR ) )) == 0)
      {
      rval = RETURN_FAIL;

      goto exitSetup;
      }
   else
      {
      value = myAtoi( iniGetItemValue( ai, li ) );
      
      if (value == 1)
         unrollGadgetLoop = TRUE;
      else
         unrollGadgetLoop = FALSE;
      }

   if ((li = iniFindItem( ai, CMsg( MSG_ITEM_PRJ_PRAGMAFLAG, MSG_ITEM_PRJ_PRAGMAFLAG_STR ) )) == 0)
      {
      rval = RETURN_FAIL;

      goto exitSetup;
      }
   else
      {
      value = myAtoi( iniGetItemValue( ai, li ) );
      
      if (value == 1)
         usePragmas = TRUE;
      else
         usePragmas = FALSE;
      }

   if ((li = iniFindItem( ai, CMsg( MSG_ITEM_PRJ_GENIMAGE, MSG_ITEM_PRJ_GENIMAGE_STR ) )) == 0)
      {
      rval = RETURN_FAIL;

      goto exitSetup;
      }
   else
      {
      value = myAtoi( iniGetItemValue( ai, li ) );
      
      if (value == 1)
         useBoopsiImage = TRUE;
      else
         useBoopsiImage = FALSE;
      }

exitSetup:

   return( rval );
}

SUBFUNC void makeCatalogName( char *fileName )
{
   char *cp = NULL;
   int   i  = 0;
   
	if (!fileName || StringLength( fileName ) < 1)
	   cp = "BOGUS_CatalogFileName";
	else
	   cp = (char *) FileNamePart( (UBYTE *) fileName );

   while (i < LSIZE && *cp != '\0')
      {
      if (*cp == '.')
         break;
         
      catalogName[i++] = *cp;
      cp++;
      }

   catalogName[i] = '\0';
   
   StringCat( catalogName, ".catalog" ); // strncat( catalogName, ".catalog", LSIZE );

   return;
}

SUBFUNC int countMenus( aiPTR ai )
{
   int rval = 0;

   rval = (int) countItemsThatMatch( ai, (char *) CMsg( MSG_ITEM_NM_FLAGS, MSG_ITEM_NM_FLAGS_STR ) );

   DBG( fprintf( stderr, "countMenus(): result = %d\n", rval ) );

   return( rval );
}

SUBFUNC int countChoiceStrings( aiPTR ai, int Type, int idx )
{
   char *temp    = NULL;
   int   saveidx = idx;

   switch (Type)
      {
      case MX_KIND:
	      {
         DBG( fprintf( stderr, "countChoiceStrings() found a Mx Gadget!\n" ) );

         mxGCount++;

         idx = iniFindItem( ai, "GA_NumberOfChoices" );
	
         if ((temp = iniGetItemValue( ai, idx )))         // temp != 0??
	         {
            numMxStrings += myAtoi( temp );
	         }

         DBG( fprintf( stderr, "numMxStrings = %d!\n", numMxStrings ) );
         idx = saveidx; // restore index to GA_Type line.
         }
	      break;

      case CYCLE_KIND:
         {
         DBG( fprintf( stderr, "countChoiceStrings() found a Cycler Gadget!\n" ) );

         cycleGCount++;

         idx = iniFindItem( ai, "GA_NumberOfChoices" );
	
         if ((temp = iniGetItemValue( ai, idx )))         // temp != 0??
	         {
            numCycleStrings += myAtoi( temp );
	         }

         DBG( fprintf( stderr, "numCycleStrings = %d!\n", numCycleStrings ) );
         idx = saveidx; // restore index to GA_Type line.
         }
	      break;

      case LISTVIEW_KIND:
	      {
         DBG( fprintf( stderr, "countChoiceStrings() found a ListView Gadget!\n" ) );

         listviewGCount++; // GTBTemplate.c uses this.

         idx = iniFindItem( ai, "GA_NumberOfChoices" );
	
         if ((temp = iniGetItemValue( ai, idx )))         // temp != 0??
            {
	         numListStrings += myAtoi( temp );
	         }
            
         DBG( fprintf( stderr, "numListStrings = %d!\n", numListStrings ) );
         idx = saveidx; // restore index to GA_Type line.
	      }
         break;
	       
      default:
	      break;
      }
      
   return( idx );
}

SUBFUNC int countGadgetsAndChoices( aiPTR ai )
{
   int numberOfGadgets = 0;
	int  idx = -1, type;
	int count = 0;
	int maxGadgets = 0; // To prevent infinite looping!

   DBG( fprintf( stderr, "Entering countGadgetsAndChoices()...\n" ) );

   numberOfGadgets = count = (int) countItemsThatMatch( ai, (char *) CMsg( MSG_ITEM_GA_LEFT, MSG_ITEM_GA_LEFT_STR ) );

   if (count < 1)
	   return( numberOfGadgets ); // No Gadgets in the file!
   else
	   {
      (void) iniFirstGroup( ai );

      // Since count was > 0 this CANNOT fail...
      idx = iniFindGroup( ai, CMsg( MSG_GRP_GDATATAGS, MSG_GRP_GDATATAGS_STR ) ) + 1;
	   DBG( fprintf( stderr, "countGadgetsAndChoices():  idx = %d after iniFindGroup()\n", idx ) );

      while (count > 0)
		   {
         idx = iniFindItem( ai, "GA_Type" );
//         DBG( fprintf( stderr, "countGadgetsAndChoices():  idx = %d after iniFindItem( GA_Type )\n", idx ) );
   
         type = myAtoi( iniGetItemValue( ai, idx ) );
      
         DBG( fprintf( stderr, "countGadgetsAndChoices():  Calling countChoiceStrings( type = %d )...\n", type ) );
         idx  = countChoiceStrings( ai, type, idx );
			
			count--;

         // Since Gadgets are contiguous in a file, just go to the next group...
         idx = iniNextGroup( ai ); // iniNextGroup() will wrap to the start of the file (idx = 0)
			}
		}

//   DBG( fprintf( stderr, "at Line #%d\n", getCurrentLineNumber() ) );
   DBG( fprintf( stderr, "   Number of Gadgets = %d\n", numberOfGadgets ) );
   DBG( fprintf( stderr, "Exiting countGadgetsAndChoices().\n" ) );

   return( numberOfGadgets );
}

SUBFUNC int countBevelBoxes( aiPTR ai )
{
   int rval = 0;

   rval = (int) countItemsThatMatch( ai, (char *) CMsg( MSG_ITEM_BBOX_LEFTEDGE, MSG_ITEM_BBOX_LEFTEDGE_STR ) );
	DBG( fprintf( stderr, "countBevelBoxes() found %d bevelBoxes\n", rval ) );

   return( rval );
}

SUBFUNC int countITexts( aiPTR ai )
{
   int rval = 0;

   rval = (int) countItemsThatMatch( ai, (char *) CMsg( MSG_ITEM_IT_FRONTPEN, MSG_ITEM_IT_FRONTPEN_STR ) );
	DBG( fprintf( stderr, "countITexts() found %d IntuiTexts\n", rval ) );
   return( rval );
}

SUBFUNC void freeMultChoiceStrings( void )
{
   if (cycleStrings) 
      {
      MyFreeVec( (void *) cycleStrings, "freeMultChoiceStrings( cycleStrings )" );

      cycleStrings = NULL;
      }
               
   if (mxStrings) 
      {
      MyFreeVec( (void *) mxStrings, "freeMultChoiceStrings( mxStrings )" );

      mxStrings = NULL;
      }
               
   if (listStrings) 
      {
      MyFreeVec( (void *) listStrings, "freeMultChoiceStrings( listStrings )" );

      listStrings = NULL;
      }

   return;
}

PRIVATE char *gadgetTagSpace = NULL;

SUBFUNC void freeMemorySpace( void )
{
   if (nmenus) 
      {
      int i;
      
      for (i = 0; i < menuCount; i++)
         {
         MyFreeVec( (void *) nmenus[i].nm_CommKey, "freeMemorySpace( nmenus.CommKey )" );
            
         MyFreeVec( (void *) nmenus[i].nm_Label, "freeMemorySpace( nmenus.Label )" ); 
            
         MyFreeVec( (void *) nmenus[i].nm_UserData, "freeMemorySpace( nmenus.UserData )" ); 
         }
         
      MyFreeVec( (void *) nmenus, "freeMemorySpace( nmenus )" );
      
      nmenus = NULL;
      }

//   DBG( fprintf( stderr, "Freed the NewMenus, next the BevelBoxes (if any)...\n" ) );

   if (bbox) 
      {
      MyFreeVec( (void *) bbox, "freeMemorySpace( bbox )" );
      
      bbox = NULL;
      }
            
//   DBG( fprintf( stderr, "Freed the BevelBoxes, next the NewGadgets...\n" ) );

   if (ngads) 
      {
      int i;
      
      for (i = 0; i < gadgetCount; i++)
         {
	      if (ngads[i].ng_GadgetText)
            MyFreeVec( (void *) ngads[i].ng_GadgetText, "freeMemorySpace( ngads.GadgetText )" );
            
         MyFreeVec( (void *) ngads[i].ng_UserData, "freeMemorySpace( ngads.UserData )" );
         }

      MyFreeVec( (void *) ngads, "freeMemorySpace( ngads )" );
      
      ngads = NULL;
      }
            
//   DBG( fprintf( stderr, "Freed the NewGadgets, next the Gadget tags...\n" ) );

   if (gtags) 
      {
      MyFreeVec( (void *) gadgetTagSpace, "freeMemorySpace( gadgetTagSpace )" );

      MyFreeVec( (void *) gtags, "freeMemorySpace( gtags )" );

      gtags = NULL;
      }
         
//   DBG( fprintf( stderr, "Freed the Gadget Tags, next the IntuiTexts (if any)...\n" ) );

   if (itxt) 
      {
      int i;
      
      for (i = 0; i < itextCount; i++)
         {
         MyFreeVec( (void *) itxt[i].IText, "freeMemorySpace( itxt.IText )" );
         }

      MyFreeVec( (void *) itxt, "freeMemorySpace( itxt )" );

      itxt = NULL;
      }

//   DBG( fprintf( stderr, "Exiting freeMemorySpace()!\n" ) );

   return;
}

#ifndef __amigaos4__
# define MEM_FLAGS MEMF_CLEAR | MEMF_ANY
#else
# define MEM_FLAGS MEMF_CLEAR | MEMF_SHARED
#endif

SUBFUNC char *allocMultStrings( int gtype ) // aiPTR ai, int count, int gtype )
{
   char *rval = NULL;

   switch (gtype)
      {
      case CYCLE_KIND:
         if (numCycleStrings > 0)
	         rval = (char *) MyAllocVec( (numCycleStrings + 1) * LSIZE * sizeof( char ), 
	                                     MEM_FLAGS, "allocMultStrings( CYCLE_KIND )" );
  	      break;
	   
      case MX_KIND:
         if (numMxStrings > 0)
	         rval = (char *) MyAllocVec( (numMxStrings + 1) * LSIZE * sizeof( char ), 
	                                     MEM_FLAGS, "allocMultStrings( MX_KIND )" );
	      break;
	   
      case LISTVIEW_KIND:
         if (numListStrings > 0)
	         rval = (char *) MyAllocVec( (numListStrings + 1) * LSIZE * sizeof( char ), 
	                                     MEM_FLAGS, "allocMultStrings( LISTVIEW_KIND )" );
	      break;
	   
      default:
         break;   
      }

   return( rval );
}

SUBFUNC void findMultStrings( aiPTR ai , int startLine, int howManyGadgets )
{
   int idx, type = -1, numchoices = 0;
   int imx, icy, ilv;                   // string space indices
   int gcount = 0;
//   int safety = 0;
	
//   idx = startLine;
   imx = 0;
   icy = 0;
   ilv = 0;

   (void) iniFirstGroup( ai );
   idx = iniFindGroup( ai, CMsg( MSG_GRP_GDATATAGS, MSG_GRP_GDATATAGS_STR ) ); //  [GadgetDataTags]
   
   while (gcount < howManyGadgets) // idx < numberOfElements && safety < 3000)
      {
      char *temp = NULL;
      int   n    = 0;

                     // cgn == currentGroupName
      if (StringNComp( cgn, (char *) CMsg( MSG_GRP_GDATATAGS, MSG_GRP_GDATATAGS_STR), LSIZE ) != 0)
         break; // Not in a Gadget group, get out of here!
      
      if ((idx = iniFindItem( ai, "GA_Type" )) > 0)
		   {
         type = myAtoi( iniGetItemValue( ai, idx ) );
         DBG( fprintf( stderr, "findMultStrings(): Gadget type = %d\n", type ) ); 
		   }

//      idx = startLine;

      switch (type)
         {
	      case MX_KIND:
            if ((idx = iniFindItem( ai, "GA_NumberOfChoices" )) < 1)
	            break; // Impossible condition;

  	         if ((temp = iniGetItemValue( ai, idx )))
               numchoices = myAtoi( temp );
            
	         if (numchoices < 1)
	            break;
	       
            idx = iniFindItem( ai, "GA_ChoiceString" );
            n   = 0;
            imx = 0;
				
            DBG( fprintf( stderr, "findMultStrings( MX ): # of choices = %d\n", numchoices ) );
            while (n < numchoices && idx < numberOfElements)
               {
	            temp = iniGetItemValue( ai, idx );

               if (StringLength( temp ) > 0)
					   {
                  StringNCopy( (char *) &mxStrings[ imx * LSIZE ], temp, LSIZE );
						DBG( fprintf( stderr, "findMultStrings(MX):  choice = '%s'\n", &mxStrings[ imx * LSIZE ] ) );
					   }

               n++;
               imx++;
               idx++;
               }
            break;
	    	  
	      case LISTVIEW_KIND:
            if ((idx = iniFindItem( ai, "GA_NumberOfChoices" )) < 1)
	            break;

   	      if ((temp = iniGetItemValue( ai, idx )))
               numchoices = myAtoi( temp );

            if (numchoices > 0) 
               {
               idx = iniFindItem( ai, "GA_ChoiceString" );
               n   = 0;
               ilv = 0;

               DBG( fprintf( stderr, "findMultStrings( LV ): # of choices = %d\n", numchoices ) );
               while (n < numchoices && idx < numberOfElements)
                  {
                  temp = iniGetItemValue( ai, idx );

                  if (StringLength( temp ) > 0)
                     StringNCopy( (char *) &listStrings[ ilv * LSIZE ], temp, LSIZE );
            
                  n++;
                  ilv++;
                  idx++;
                  }
               }
	         break;
	    
	      case CYCLE_KIND:
            if ((idx = iniFindItem( ai, "GA_NumberOfChoices" )) < 1)
	            break; // A CYCLE_KIND with no GA_NumberOfChoices tag is impossible:

	         if ((temp = iniGetItemValue( ai, idx )))
               numchoices = myAtoi( temp );

            if (numchoices < 1)
	            break;
	                
            idx = iniFindItem( ai, "GA_ChoiceString" );
            n   = 0;
	         icy = 0;

            DBG( fprintf( stderr, "findMultStrings( CYC ): # of choices = %d\n", numchoices ) );
            while (n < numchoices && idx < numberOfElements)
               {
	            temp = iniGetItemValue( ai, idx );

               if (StringLength( temp ) > 0)
                  StringNCopy( (char *) &cycleStrings[ icy * LSIZE ], temp, LSIZE );
            
               n++;
               icy++;
               idx++;
               }
	         break;
	      }

      idx = iniNextGroup( ai ); // if ((idx = iniFindGroup( ai, CMsg( MSG_GRP_GDATATAGS, MSG_GRP_GDATATAGS_STR ) )) < 1)
                                //    idx = 0xFFFFFFF0; // break the loop!!

//      startLine = idx;
		gcount++; // safety++;
      }

   return;
}

SUBFUNC UBYTE *allocGField( char *fieldStr )
{
   UBYTE *rval = NULL;
   int    len  = StringLength( (char *) fieldStr ) + 1; // Need Space for the nil as well.

   // This can be done since all calls to FreeVec() check for NULL:
   if (len < 1)
      return( rval );
         
   if ((rval = (UBYTE *) MyAllocVec( len * sizeof( UBYTE ), MEM_FLAGS, "allocGField( fieldStr )" )))
      StringNCopy( (char *) rval, (char *) fieldStr, len );
      
   return( rval );
}

SUBFUNC void setupBBoxes( aiPTR ai )
{
   int idx = 0, i;
   int maxBevelBoxes = 0;
	   
   if (bboxCount > 0)
      {
      (void) iniFirstGroup( ai );

      i   = 0;
      idx = iniFindGroup( ai, CMsg( MSG_GRP_BDATATAGS, MSG_GRP_BDATATAGS_STR ) );

      while (idx < numberOfElements && maxBevelBoxes < MAX_BEVELBOXES)
         {
         if (StringNComp( cgn, (char *) CMsg( MSG_GRP_BDATATAGS, MSG_GRP_BDATATAGS_STR ), LSIZE ) != 0)
            break;
      
         idx = iniFindItem( ai, CMsg( MSG_ITEM_BBOX_LEFTEDGE, MSG_ITEM_BBOX_LEFTEDGE_STR ) );
            
         bbox[i].bb_Left   = myAtoi( iniGetItemValue( ai, idx++ ) );
         bbox[i].bb_Top    = myAtoi( iniGetItemValue( ai, idx++ ) );
         bbox[i].bb_Width  = myAtoi( iniGetItemValue( ai, idx++ ) );
         bbox[i].bb_Height = myAtoi( iniGetItemValue( ai, idx++ ) );
         bbox[i].bb_Flags  = myAtoi( iniGetItemValue( ai, idx++ ) );
            
         idx = iniNextGroup( ai );
         i++;
			maxBevelBoxes++;
         }
      }
 
   return;
}

SUBFUNC void setupITexts( aiPTR ai )
{
   int idx = 0, i;

   if (itextCount > 0)
      {
      (void) iniFirstGroup( ai );

      i   = 0;
      idx = iniFindGroup( ai, CMsg( MSG_GRP_IDATATAGS, MSG_GRP_IDATATAGS_STR ) );

      while (idx < numberOfElements)
         {
         if (StringNComp( cgn, (char *) CMsg( MSG_GRP_IDATATAGS, MSG_GRP_IDATATAGS_STR ), LSIZE ) != 0)
            break;
      
         idx = iniFindItem( ai, "IT_FrontPen" );
            
         itxt[i].FrontPen = myAtoi( iniGetItemValue( ai, idx++ ) );
         itxt[i].BackPen  = myAtoi( iniGetItemValue( ai, idx++ ) );
         itxt[i].LeftEdge = myAtoi( iniGetItemValue( ai, idx++ ) );
         itxt[i].TopEdge  = myAtoi( iniGetItemValue( ai, idx++ ) );
         itxt[i].DrawMode = myAtoi( iniGetItemValue( ai, idx++ ) );

         itxt[i].IText    = (STRPTR) allocGField( iniGetItemValue( ai, idx ) );

         idx = iniNextGroup( ai );
         i++;
         }
      }

   return;
}

SUBFUNC void setupMenus( aiPTR ai )
{
   int i, idx = 0;

   (void) iniFirstGroup( ai );

   if ((idx = iniFindGroup( ai, CMsg( MSG_GRP_MDATATAGS, MSG_GRP_MDATATAGS_STR ))) == 0) // NewMenus
      return;

   i = 0;
      
   while (idx < numberOfElements && idx != 0)
      {
      if (StringNComp( cgn, (char *) CMsg( MSG_GRP_MDATATAGS, MSG_GRP_MDATATAGS_STR ), LSIZE ) != 0)
         if (StringNComp( cgn, (char *) CMsg( MSG_GRP_MIDATATAGS, MSG_GRP_MIDATATAGS_STR ), LSIZE ) != 0)
            if (StringNComp( cgn, (char *) CMsg( MSG_GRP_MSDATATAGS, MSG_GRP_MSDATATAGS_STR ), LSIZE ) != 0)
               break; // Where the f&*@%#$! are we??
      
      if (StringNComp( cgn, (char *) CMsg( MSG_GRP_MDATATAGS, MSG_GRP_MDATATAGS_STR ), LSIZE) == 0)
         {
         // NM_TITLE:
         idx = iniFindItem( ai, "NM_Title" );
            
         nmenus[i].nm_Type     = NM_TITLE;
         nmenus[i].nm_Label    = (STRPTR) allocGField( iniGetItemValue( ai, idx++ ) );
         nmenus[i].nm_Flags    = (UWORD) hexToI( iniGetItemValue( ai, idx ) );
	      nmenus[i].nm_CommKey  = MYNULL;
         nmenus[i].nm_UserData = MYNULL;
         }   
      else if (StringNComp( cgn, (char *) CMsg( MSG_GRP_MIDATATAGS, MSG_GRP_MIDATATAGS_STR ), LSIZE ) == 0)
         {
         // NM_ITEM:
         idx = iniFindItem( ai, "NM_Label" );

         nmenus[i].nm_Type     = NM_ITEM;
            
         if (StringNComp( "NM_BARLABEL", iniGetItemValue( ai, idx ), 12 ) == 0)
            {
            nmenus[i].nm_Label    = (STRPTR) NM_BARLABEL;
            nmenus[i].nm_Flags    = 0;
            nmenus[i].nm_CommKey  = MYNULL;
            nmenus[i].nm_UserData = MYNULL;
            idx++;
            }
         else
            {
            nmenus[i].nm_Label    = (STRPTR) allocGField( iniGetItemValue( ai, idx++ ) );
            nmenus[i].nm_Flags    = (UWORD) hexToI( iniGetItemValue( ai, idx++ ) );
            nmenus[i].nm_CommKey  = (STRPTR) allocGField( iniGetItemValue( ai, idx++ ) );
            nmenus[i].nm_UserData = (APTR)  allocGField( iniGetItemValue( ai, idx ) );
            }
         }
      else if (StringNComp( cgn, CMsg( MSG_GRP_MSDATATAGS, MSG_GRP_MSDATATAGS_STR ), LSIZE ) == 0)
         {
         // NM_SUB:
         idx = iniFindItem( ai, "NM_Label" );

         nmenus[i].nm_Type = NM_SUB;

         if (StringNComp( "NM_BARLABEL", (char *) iniGetItemValue( ai, idx ), 12 ) == 0)
            {
            nmenus[i].nm_Label    = (STRPTR) NM_BARLABEL;
            nmenus[i].nm_Flags    = 0;
            nmenus[i].nm_CommKey  = MYNULL;
            nmenus[i].nm_UserData = MYNULL;
            idx++;
            }
         else
            {
            nmenus[i].nm_Label    = (STRPTR) allocGField( iniGetItemValue( ai, idx++ ) );
            nmenus[i].nm_Flags    = (UWORD) hexToI( iniGetItemValue( ai, idx++ ) );
            nmenus[i].nm_CommKey  = (STRPTR) allocGField( iniGetItemValue( ai, idx++ ) );
            nmenus[i].nm_UserData = (APTR)  allocGField( iniGetItemValue( ai, idx ) );
            }
         }
            
      idx = iniNextGroup( ai );
      i++;
      }

   return;
}

PRIVATE int gtagIdx = 0;

SUBFUNC int setupNGadTags( aiPTR ai, int idx, int whichGad )
{
   int   index = idx;
   ULONG tag, data;

   DBG( fprintf( stderr, "Entering setupNGadTags( ai, idx = %d, gad = %d )...\n", idx, whichGad ) );
   index = idx;
	
   while (StringNComp( (char *) iniGetItemName( ai, index ), "0x", 2 ) == 0) // Raw tags start with '0x'
      {
      char pair[LSIZE] = { 0, }; // Maximum # of gadget tag pairs found in *.ini Gadget Group.
 
      DBG( fprintf( stderr, "setupNGadTags():  Calling iniGetItemName( ai, idx = %d )...\n", index ) );
      tag  = (ULONG) hexToI( iniGetItemName( ai, index ) );
      data = (ULONG) hexToI( iniGetItemValue( ai, index ) );

      switch (tag)
         {
         case STRINGA_Justification: // 0x80032010
            sprintf( pair, "%s, %s, ", getGadgetTag( (int) tag ), getTextJustifyType( data ) );
	         break;
	      
	      case GT_Underscore: // 0x80080040
	      case GA_Underscore: // 0x80030040
            sprintf( pair, "%s, '%c', ", getGadgetTag( (int) tag ), (char ) data );
            
            break;

         case GTST_String: // 0x8008002D
	      case GTTX_Text:   // 0x8008000B
	         {
            int saveidx = index; // before we move in the *.ini file, save our location
                  
            index = iniFindItem( ai, "GA_DefaultString" ); // go forward in the file...
                  
	         if (index > 1) // Is there a GA_DefaultString present??
               sprintf( pair, "%s, (ULONG) \"%s\", ", getGadgetTag( (int) tag ),
                               iniGetItemValue( ai, index )
                      );

            index = saveidx; // Restore *.ini line indicator value.
	         }
	         break;
		  
	      case GTLV_Labels: // 0x80080006
            if (ngads[whichGad].ng_NumberOfChoices >  0)
               {
               sprintf( pair, "%s, (ULONG) &LV_%s%dLbls, ", getGadgetTag( (int) tag ), 
                               (char *) ngads[whichGad].ng_UserData, ngads[whichGad].ng_GadgetID 
                      );
               }
	        break;
		  
	     case GTCY_Labels:  // 0x8008000E 
            sprintf( pair, "%s, (ULONG) &CY_%dLbls, ", getGadgetTag( (int) tag ), 
                            ngads[whichGad].ng_GadgetID
                   );

	         break;
		  
	      case GTMX_Labels: // 0x80080009 
            sprintf( pair, "%s, (ULONG) &MX_%dLbls, ", getGadgetTag( (int) tag ), 
                            ngads[whichGad].ng_GadgetID
                   );

	         break;
		  
	      case GTSL_LevelFormat: // 0x8008002A
            sprintf( pair, "%s, (ULONG) \"%s\", ", getGadgetTag( (int) tag ), 
                            iniGetItemValue( ai, index ) 
                   );

            break;
               
	      default:
            sprintf( pair, "%s, %d, ", getGadgetTag( (int) tag ), data );
               
	         break;
         }

      StringCat( (char *) gtags[ gtagIdx ], (char *) pair );
      ngads[ gtagIdx ].ng_NumberOfTags++;

      index++;
      }
         
   StringCat( (char *) gtags[ gtagIdx++ ], "TAG_DONE,\n" ); // Terminate the tags.
   
   return( index );
}

SUBFUNC void setupNewGadgets( aiPTR ai, int howManyGadgets )
{
   int   idx, i;
//   int   safety = 0;
   int   gcount = 0;
		
   DBG( fprintf( stderr, "Calling findMultStrings( line = %d )...\n", idx ) );

   findMultStrings( ai, idx, howManyGadgets ); // Setup already allocated space for choice strings.

   (void) iniFirstGroup( ai );  // Back to top of .ini file

   idx = iniFindGroup( ai, CMsg( MSG_GRP_GDATATAGS, MSG_GRP_GDATATAGS_STR ) );
   i   = 0;

   while (gcount < howManyGadgets) // idx < numberOfElements && safety < 3000) // i < gadgetCount)
      {
      char *gadLabel = NULL, *gadSrcLabel = NULL;
      
      if (StringNComp( cgn, (char *) CMsg( MSG_GRP_GDATATAGS, MSG_GRP_GDATATAGS_STR ), LSIZE ) != 0)
         break; // No more Gadgets, so get out of here.
      
      idx = iniFindItem( ai, "GA_Left" );
            
      ngads[i].ng_LeftEdge   = (UWORD) myAtoi( iniGetItemValue( ai, idx++ ) );
      ngads[i].ng_TopEdge    = (UWORD) myAtoi( iniGetItemValue( ai, idx++ ) );
      ngads[i].ng_Width      = (UWORD) myAtoi( iniGetItemValue( ai, idx++ ) );
      ngads[i].ng_Height     = (UWORD) myAtoi( iniGetItemValue( ai, idx++ ) );
      ngads[i].ng_GadgetID   = (UWORD) myAtoi( iniGetItemValue( ai, idx++ ) );

      ngads[i].ng_Flags      = (ULONG) hexToI( iniGetItemValue( ai, idx ) ); // ++ ) );

      idx      = iniFindItem( ai, "GA_Label" );
      gadLabel = iniGetItemValue( ai, idx );
      
      if (StringLength( gadLabel ) > 1)
         ngads[i].ng_GadgetText = allocGField( gadLabel );
      else
         ngads[i].ng_GadgetText = NULL; // allocGField( "NO_LABEL" );
         
      idx         = iniFindItem( ai, "GA_SrcLabel" ); // Should NOT need this.
      gadSrcLabel = iniGetItemValue( ai, idx );
      
      if (StringLength( gadSrcLabel ) > 1)
         ngads[i].ng_UserData = (APTR) allocGField( gadSrcLabel );
      else
         ngads[i].ng_UserData = (APTR) NULL;
	 
	   idx++;
      ngads[i].ng_Type = (UWORD) myAtoi( iniGetItemValue( ai, idx ) );

      // Now process any Gadget Tags into gtags[][]:
      idx++; // Point to first tag (if any)
         
      if (iniIsGroup( ai, idx ) == TRUE)
         goto nextGroupThen; // No Gadget Tags in this group.
      else
         idx = setupNGadTags( ai, idx, i );

      if (StringNComp( (char *) iniGetItemName( ai, idx ), "GA_NumberOfChoices", 18 ) == 0)
         ngads[i].ng_NumberOfChoices = (UWORD) myAtoi( iniGetItemValue( ai, idx++ ) );
      else
         ngads[i].ng_NumberOfChoices = 0;
		   	 
nextGroupThen:

      idx = iniNextGroup( ai );
      i++;
		gcount++; // safety++; // Kill infinite loops!!!
      }

   gtagIdx = 0; // Reset this in case we need it elsewhere.
   
   return;
}

SUBFUNC void setupGUIMemorySpaces( aiPTR ai )
{
//	DBG( fprintf( stderr, "setupGUIMemorySpaces():  Calling setupBBoxes()...\n" ) );
   setupBBoxes( ai );

//	DBG( fprintf( stderr, "setupGUIMemorySpaces():  Calling setupITexts()...\n" ) );
   setupITexts( ai );
   
   if (gadgetCount > 0)
	   {
   	DBG( fprintf( stderr, "setupGUIMemorySpaces():  Calling setupNewGadgets()...\n" ) );
      setupNewGadgets( ai, gadgetCount );
      }

   if (menuCount > 0)
	   {
	   DBG( fprintf( stderr, "setupGUIMemorySpaces():  Calling setupMenus()...\n" ) );
      setupMenus( ai );
      }

   DBG( fprintf( stderr, "exiting setupGUIMemorySpaces().\n" ) );

   return;
}

SUBFUNC void massageSrcFileName( char *fname ) // make sure extension is clipped off
{
   char *cp  = NULL;
   int   len = 0;

   if (!fname || StringLength( fname ) < 1)
	   {
		fprintf( stderr, "gtbGenC(): massageSrcFileName() received a bogus filename to massage!\n" );

		return;
		}
   else
	   {
		cp = fname;
		len = StringLength( fname );
		}			   

   while (len > 0)
      {
      if (*(cp + len) == '.')
         {
         *(cp + len) = '\0';
      
         break;
	      }
      
      len--;
      }  

   return;
}

PRIVATE char pFName[BUFF_SIZE] = { 0, };

SUBFUNC int setupProjectStuff( aiPTR ai )
{
   int li, rval = RETURN_OK;

   (void) iniFirstGroup( ai );
      
   li = iniFindGroup( ai, CMsg( MSG_GRP_PDATATAGS, MSG_GRP_PDATATAGS_STR ) );
   
   if (StringNComp( &currentGroupName[0], (char *) CMsg( MSG_GRP_PDATATAGS, MSG_GRP_PDATATAGS_STR ), 
                                                INI_MAX_LINE_SIZE ) != 0)
      {
      rval = INI_NOHEADER;
      
      fprintf( stderr, "Failed to find %s!\n", CMsg( MSG_GRP_PDATATAGS, MSG_GRP_PDATATAGS_STR ) );

      goto exitSetupProject;
      }

   if ((li = iniFindItem( ai, CMsg( MSG_ITEM_PRJ_NAME, MSG_ITEM_PRJ_NAME_STR ) )) == 0)
      {
      rval = INI_NOITEM;

      fprintf( stderr, "Failed to find %s!\n", CMsg( MSG_ITEM_PRJ_NAME, MSG_ITEM_PRJ_NAME_STR ) );

      goto exitSetupProject;
      }
   else
      {
      StringNCopy( (char *) &projectName[0], (char *) iniGetItemValue( ai, li ) , LSIZE );
      }           

   // Now determine the name of the source Code file:
   if ((li = iniFindItem( ai, CMsg( MSG_ITEM_PRJ_FILENAME, MSG_ITEM_PRJ_FILENAME_STR ) )) == 0)
      {
      rval = INI_NOITEM;

      fprintf( stderr, "Failed to find %s!\n", CMsg( MSG_ITEM_PRJ_FILENAME, MSG_ITEM_PRJ_FILENAME_STR ) );

      goto exitSetupProject;
      }
   else
      {
      StringNCopy( &pFName[0],          (char *) iniGetItemValue( ai, li ) , LSIZE );
      StringNCopy( &projectFileName[0], (char *) iniGetItemValue( ai, li ) , LSIZE );

      massageSrcFileName( &projectFileName[0] ); // Clip off extensions
      }           

   massageSrcFileName( &pFName[0] ); // make sure there's NO extension
   StringCat( (char *) &pFName[0], ".c" );
      
   if ((li = iniFindItem( ai, CMsg( MSG_ITEM_PRJ_AUTHORNAME, MSG_ITEM_PRJ_AUTHORNAME_STR ))) == 0)
      {
      rval = INI_NOITEM;

      fprintf( stderr, "Failed to find %s!\n", CMsg( MSG_ITEM_PRJ_AUTHORNAME, MSG_ITEM_PRJ_AUTHORNAME_STR ) );

      goto exitSetupProject;
      }
   else
      {
      StringNCopy( &projectAuthorName[0], (char *) iniGetItemValue( ai, li ) , LSIZE );
      }           

   if ((li = iniFindItem( ai, CMsg( MSG_ITEM_PRJ_AUTHOREMAIL, MSG_ITEM_PRJ_AUTHOREMAIL_STR ))) == 0)
      {
      rval = INI_NOITEM;

      fprintf( stderr, "Failed to find %s!\n", CMsg( MSG_ITEM_PRJ_AUTHOREMAIL, MSG_ITEM_PRJ_AUTHOREMAIL_STR ) );

      goto exitSetupProject;
      }
   else
      {
      StringNCopy( &projectAuthorEMail[0], (char *) iniGetItemValue( ai, li ) , LSIZE );
      }           

   if ((li = iniFindItem( ai, CMsg( MSG_ITEM_PRJ_VERSION, MSG_ITEM_PRJ_VERSION_STR ) )) == 0)
      {
      rval = INI_NOITEM;

      fprintf( stderr, "Failed to find %s!\n", CMsg( MSG_ITEM_PRJ_VERSION, MSG_ITEM_PRJ_VERSION_STR ) );

      goto exitSetupProject;
      }
   else
      {
      StringNCopy( &projectVersion[0], (char *) iniGetItemValue( ai, li ) , LSIZE );
      }           

   (void) iniFirstGroup( ai ); // Go back to top of file.
   li = iniFindItemInGroup( ai, CMsg( MSG_GRP_SDATATAGS, MSG_GRP_SDATATAGS_STR ), "ScreenFontName" );
   DBG( fprintf( stderr, "Line %d has \"%s\"\n", li, iniGetItemName( ai, li ) ) );
//   li = iniNextGroup( ai ) + 5; // iniFindItem() is NOT working correclty...
   if (StringComp( iniGetItemName( ai, li ), "ScreenFontName" ) != 0) // (li = iniFindItem( ai, "ScreenFontName" )) == 0)
      {
      rval = INI_NOITEM;

      fprintf( stderr, "Failed to find ScreenFontName!\n" );

      goto exitSetupProject;
      }
   else
      {
      StringNCopy( &screenFontName[0], (char *) iniGetItemValue( ai, li ) , LSIZE );
      }

   (void) iniFirstGroup( ai ); // Go back to top of file.
   (void) iniFindGroup( ai, CMsg( MSG_GRP_PDATATAGS, MSG_GRP_PDATATAGS_STR ) );

//   DBG( fprintf( stderr, "Calling setupProgramFlags()...\n" ) );   

   if (setupProgramFlags( ai ) != RETURN_OK)
      {
      rval = INI_NOITEM;

      goto exitSetupProject;
      }

   makeCatalogName( &pFName[0] );

   (void) iniFirstGroup( ai );

   li = iniNextGroup( ai ) + 6; // iniFindItem() is NOT working correclty...   
   if ((li = iniFindItem( ai, "ScreenFontSize" )) == 0) // StringComp( iniGetItemName( ai, li ), "ScreenFontSize" ) != 0
      {
      rval = INI_NOITEM;

      fprintf( stderr, "Failed to find ScreenFontSize!\n" );

      goto exitSetupProject;
      }
   else
      {
      screenFontSize = myAtoi( iniGetItemValue( ai, li ) );
      }

exitSetupProject:

   return( rval );
}

SUBFUNC int openLibraries( void )
{
   int rval = RETURN_OK;
   
#  ifndef __amigaos4__
   if (!LocaleBase) // == NULL)
      {
      if ((LocaleBase = (struct LocaleBase *) OpenLibrary( "locale.library", 39L )))
         openedLocale = TRUE;
      else
         rval = ERROR_INVALID_RESIDENT_LIBRARY;
      }
#  else
   if (!GadToolsBase) // == NULL)
      {
      if ((GadToolsBase = OpenLibrary( "gadtools.library", 50L )))
         {
	      if (!(IGadTools = (struct GadToolsIFace *) GetInterface( GadToolsBase, "main", 1, NULL )))
	         {
	         CloseLibrary( GadToolsBase );
	         GadToolsBase = NULL;
	    
	         rval = ERROR_INVALID_RESIDENT_LIBRARY;
	         }
	      }
      else
         rval = ERROR_INVALID_RESIDENT_LIBRARY;
      }
#  endif

   return( rval );
}

SUBFUNC int getWindowTags( aiPTR ai )
{
   int   li, rval = RETURN_OK;

   (void) iniFirstGroup( ai );
   (void) iniFindGroup( ai, CMsg( MSG_GRP_WDATATAGS, MSG_GRP_WDATATAGS_STR ) ); // "[WindowDataTags]" );

   if ((li = iniFindItem( ai, "WA_Left" )) == 0)
      {
      fprintf( stderr, "Did NOT find \"WA_Left\" item!\n" );

      rval = INI_NOITEM;

      goto exitGetWindowTags;
      }
   else
      {
      winLeft   = (UWORD) myAtoi( iniGetItemValue( ai, li++ ) );
      winTop    = (UWORD) myAtoi( iniGetItemValue( ai, li++ ) );
      winWidth  = (UWORD) myAtoi( iniGetItemValue( ai, li++ ) );
      winHeight = (UWORD) myAtoi( iniGetItemValue( ai, li   ) );
      }

   (void) iniFirstGroup( ai );
   (void) iniFindGroup( ai, CMsg( MSG_GRP_WDATATAGS, MSG_GRP_WDATATAGS_STR ) ); // "[WindowDataTags]" );
   
   if ((li = iniFindItem( ai, "WA_IDCMP" )) == 0)
      {
      fprintf( stderr, "Did NOT find \"WA_IDCMP\" item!\n" );

      rval = INI_NOITEM;

      goto exitGetWindowTags;
      }
   else
      {
      windowIDCMP = (ULONG) hexToI( iniGetItemValue( ai, li ) );
      }

   if ((li = iniFindItem( ai, "WA_Flags" )) == 0)
      {
      fprintf( stderr, "Did NOT find \"WA_Flags\" item!\n" );

      rval = INI_NOITEM;
//      goto exitGetWindowTags;
      }
   else
      {
      windowFlags = (ULONG) hexToI( iniGetItemValue( ai, li ) );
      }

exitGetWindowTags:

   return( rval );
}

SUBFUNC int checkForBevelBoxes( aiPTR ai )
{
   int rval = RETURN_OK;
   
   if ((bboxCount = countBevelBoxes( ai )) > 0)
      {
      // struct BBox { UWORD bb_Left, bb_Top, bb_Width, bb_Height, bb_Flags; };
      if (!(bbox = (struct BBox *) MyAllocVec( (bboxCount  + 1) * sizeof( struct BBox ),
                                               MEM_FLAGS, "checkForBevelBoxes( bbox )" ))) // == NULL) 
         {
         rval = ERROR_NO_FREE_STORE;

         fprintf( stderr, "NO Memory for BevelBoxes!\n" );
         } 
      } 

   return( rval );
}

SUBFUNC int checkForIntuiTexts( aiPTR ai )
{
   int rval = RETURN_OK;
   
   if ((itextCount = countITexts( ai )) > 0)
      {
      if (!(itxt = (struct IntuiText *) MyAllocVec( (itextCount + 1) * sizeof( struct IntuiText ),
                                                    MEM_FLAGS, "checkForIntuiTexts( itxt )" ))) // == NULL) 
         {
         rval = ERROR_NO_FREE_STORE;

         fprintf( stderr, "NO Memory for IntuiTexts!\n" );
         } 
      } 

   return( rval );
}

SUBFUNC int checkForMenus( aiPTR ai )
{
   int rval = RETURN_OK;
   
   if ((menuCount = countMenus( ai )) > 0)
      {
      if (!(nmenus = (struct NewMenu *) MyAllocVec( (menuCount + 1) * sizeof( struct NewMenu ),
                                                    MEM_FLAGS, "checkForMenus( nmenus )" )))
         {
         rval = ERROR_NO_FREE_STORE;

         fprintf( stderr, "NO Memory for NewMenus!\n" );
         } 
      } 

   return( rval );
}

SUBFUNC int allocCycleChoices( void )
{
   int rval = RETURN_OK;
   
   if (numCycleStrings == 0)
      return( rval );

   if (!(cycleStrings = allocMultStrings( CYCLE_KIND )))
      {
      rval = ERROR_NO_FREE_STORE;
      }

   return( rval );
}

SUBFUNC int allocListViewChoices( void )
{
   int rval = RETURN_OK;

   if (numListStrings == 0)
      return( rval );
   
   if (!(listStrings = allocMultStrings( LISTVIEW_KIND )))
      {
      rval = ERROR_NO_FREE_STORE;
      }

   return( rval );
}

SUBFUNC int allocMxChoices( void )
{
   int rval = RETURN_OK;
   
   if (numMxStrings == 0)
      return( rval );

   if (!(mxStrings = allocMultStrings( MX_KIND )))
      {
      rval = ERROR_NO_FREE_STORE;
      }

   return( rval );
}

SUBFUNC int checkForGadgets( aiPTR ai )
{
   int rval = RETURN_OK;

   DBG( fprintf( stderr, "checkForGadgets(): Calling countGadgetsAndChoices()...\n" ) );   
   if ((gadgetCount = countGadgetsAndChoices( ai )) < 1)
      {
      return( rval );
      }

   if (!(gtags = (char **) MyAllocVec( (gadgetCount + 1) * sizeof( char * ), MEM_FLAGS, "checkForGadgets( gtags )" )))
      {
      rval = ERROR_NO_FREE_STORE;

      fprintf( stderr, "NO Memory for Gadgets!\n" );

      goto exitCheckForGadgets;
      } 
   else
      {
      DBG( fprintf( stderr, "checkForGadgets(): Calling MyAllocVec( gadgetTagSpace )...\n" ) );   
      // There are only 11 Tags/Gadget (NUM_GADGET_TAGS):
      gadgetTagSpace = (char *) MyAllocVec( LSIZE * NUM_GADGET_TAGS * (gadgetCount + 1), 
                                            MEM_FLAGS, "checkForGadgets( gadgetTagSpace )" );
         
      if (!gadgetTagSpace) // == NULL)
         {
         rval = ERROR_NO_FREE_STORE;

         fprintf( stderr, "NO Memory for Gadget Tags!\n" );

         goto exitCheckForGadgets;
         }
      else
         {
         int i;
            
         DBG( fprintf( stderr, "checkForGadgets(): setting gtags[] for %d gadgets...\n", gadgetCount ) );   

         for (i = 0; i < gadgetCount; i++)
            gtags[i] = &gadgetTagSpace[ i * (LSIZE * NUM_GADGET_TAGS) ]; 
         }
      }

   DBG( fprintf( stderr, "checkForGadgets(): Calling MyAllocVec( for ngads )...\n" ) );   
   if (!(ngads = (struct myNewGadget *) MyAllocVec( (gadgetCount + 1) * sizeof( struct myNewGadget ),
                                                    MEM_FLAGS, "checkForGadgets( ngads )" )))
      {
      rval = ERROR_NO_FREE_STORE;

      fprintf( stderr, "NO Memory for NewGadgets!\n" );

      goto exitCheckForGadgets;
      } 

   DBG( fprintf( stderr, "checkForGadgets(): Calling allocCycleChoices()...\n" ) );   
   if ((rval = allocCycleChoices()) != RETURN_OK)
      {
      rval = ERROR_NO_FREE_STORE;

      fprintf( stderr, "NO Memory for Cycle Gadget Strings!\n" );

      goto exitCheckForGadgets;
      }

   DBG( fprintf( stderr, "checkForGadgets(): Calling allocListViewChoices()...\n" ) );   
   if ((rval = allocListViewChoices()) != RETURN_OK)
      {
      rval = ERROR_NO_FREE_STORE;

      fprintf( stderr, "NO Memory for ListView Gadget Strings!\n" );

      goto exitCheckForGadgets;
      }

   DBG( fprintf( stderr, "checkForGadgets(): Calling allocMxChoices()...\n" ) );   
   if ((rval = allocMxChoices()) != RETURN_OK)
      {
      rval = ERROR_NO_FREE_STORE;

      fprintf( stderr, "NO Memory for Mx Gadget Strings!\n" );

      goto exitCheckForGadgets;
      }
      
exitCheckForGadgets:

   DBG( fprintf( stderr, "Exiting checkForGadgets().\n" ) );   
   return( rval );
}

#ifdef __amigaos4__

PRIVATE UBYTE sobcBuff[BUFF_SIZE] = { 0, };

PUBLIC UBYTE *stripOffBadChars( UBYTE *instring )
{
   int i, j, len = 0;

   sobcBuff[0] = '\0';

   if (instring && (STRPTR) instring > (STRPTR) 1024 && (STRPTR) instring != (STRPTR) 0xFFFFFFFF)
      len = StringLength( (char *) instring );
   else
      return( &sobcBuff[0] );

   i = j = 0;
   
   while (i < len)
      {
      if (isalnum( *(instring + i) ) || (*(instring + i) == '_'))
         sobcBuff[j++] = *(instring + i);
      else
         break; // Found one bad character, get out of loop to ignore others that follow.
	       
      i++;
      }

   sobcBuff[j] = '\0';

//   DBG( fprintf( stderr, "sobcBuff[] = '%s'\n", &sobcBuff[0] ) );

   StringNCopy( (char *) instring, (char *) &sobcBuff[0], BUFF_SIZE );
   	
   return( instring ); 
}

PUBLIC UBYTE *stripOffLabelBadChars( UBYTE *instring )
{
   int i, j, len = 0;

   sobcBuff[0] = '\0';

   if (instring && (STRPTR) instring > (STRPTR) 1024 && (STRPTR) instring != (STRPTR) 0xFFFFFFFF)
      len = StringLength( (char *) instring );
   else
      return( &sobcBuff[0] );
      
   i = j = 0;
   
   while (i < len)
      {
      if (isprint( *(instring + i) ))
         sobcBuff[j++] = *(instring + i);
      else
         break; // Found one bad character, get out of loop to ignore others that follow.
	       
      i++;
      }

   sobcBuff[j] = '\0';

//   DBG( fprintf( stderr, "sobcBuff[] = '%s'\n", &sobcBuff[0] ) );

   StringNCopy( (char *) instring, (char *) &sobcBuff[0], BUFF_SIZE );
   	
   return( instring ); 
}

#else // Do NOT need these for SAS-C:

PUBLIC UBYTE *stripOffBadChars( UBYTE *instring )
{
   return( instring );
}

PUBLIC UBYTE *stripOffLabelBadChars( UBYTE *instring )
{
   return( instring );
}

#endif // __amigaos4__

SUBFUNC void massageGadgetStrings( void )
{
   int i = 0;
   
   for (i = 0; i < gadgetCount; i++)
      {
      if (ngads[i].ng_GadgetText)
         ngads[i].ng_GadgetText = stripOffLabelBadChars( ngads[i].ng_GadgetText );

      if (ngads[i].ng_UserData)
         ngads[i].ng_UserData = stripOffBadChars( ngads[i].ng_UserData );
      }
   
   return;
}

SUBFUNC void massageMenuStrings( void )
{
   int i = 0;
   
   for (i = 0; i < menuCount; i++)
      {
      if (nmenus[i].nm_Label && nmenus[i].nm_Label != (STRPTR) NM_BARLABEL)
         nmenus[i].nm_Label = (STRPTR) stripOffLabelBadChars( (UBYTE *) nmenus[i].nm_Label );
    
      if (nmenus[i].nm_UserData)
         nmenus[i].nm_UserData = stripOffBadChars( (UBYTE *) nmenus[i].nm_UserData );
      }
   
   return;
}

/****i* filterBadStrings() [3.0] *********************************
* 
* NAME
*    filterBadStrings()
*
* DESCRIPTION
*    Since gdb does not work on my AmigaOne, I have to filter 
*    out garbage in the ng_UserData, ng_GadgetText,
*    nm_Label, & nm_UserData strings.
******************************************************************
*
*/

PRIVATE void filterBadStrings( void )
{
   if (menuCount > 0)
      {
      massageMenuStrings();
      } 
      
   if (gadgetCount > 0)
      {
      massageGadgetStrings();
      }
   
   return;  
}

// Read the .ini file & setup globals here:

PRIVATE int SetupProgram( char *fileName )
{
   aiPTR ai   = (aiPTR) NULL; 
   int   rval = RETURN_OK;

   if (!fileName || StringLength( fileName ) < 1)
	   {
		rval = ERROR_REQUIRED_ARG_MISSING;
		goto exitSetup;
		}
	else
	   ai = iniOpenFile( fileName, TRUE, DELIMITERS ); 

   if (openLibraries() != RETURN_OK)
      goto exitSetup;
      
   if (LocaleBase)
      scanCatalog = OpenCatalog( NULL, "gtbproject.catalog",
                                 OC_BuiltInLanguage, MY_LANGUAGE,
                                 TAG_DONE 
                               );
   if (!ai)
      {
      fprintf( stderr, "iniOpenFile() returned a NULL!\n" );

      rval = INI_UNKERROR;
      
      goto exitSetup;
      }
   else
      {
      aicopy = ai;
      DBG( fprintf( stderr, "gtbGenC():  opened %s in SetupProgram(), ai = 0x%08LX\n", fileName, ai ) );
      }
      
   if ((rval = setupProjectStuff( aicopy )) != RETURN_OK)
      {
      fprintf( stderr, "setupProjectStuff() failed with %d\n", rval );

      goto exitSetup;
      }
         
   if (!(outFile = myFOpen( &pFName[0], "w", "SetupProgram()" )))
      {
      fprintf( stderr, "Could NOT open %s for output!\n", pFName );

      rval = IoErr();

      goto exitSetup;
      }

   DBG( fprintf( stderr, "Calling getWindowTags()...\n" ) );

   if ((rval = getWindowTags( aicopy )) != RETURN_OK)
      goto exitSetup;

   // Allocate memory here: --------------------------------------------------------------
   DBG( fprintf( stderr, "Calling checkForBevelBoxes()...\n" ) );
   if ((rval = checkForBevelBoxes( aicopy )) != RETURN_OK)
      goto exitSetup;

   DBG( fprintf( stderr, "Calling checkForIntuiTexts()...\n" ) );
   if ((rval = checkForIntuiTexts( aicopy )) != RETURN_OK)
      goto exitSetup;

   DBG( fprintf( stderr, "Calling checkForGadgets()...\n" ) );
   if ((rval = checkForGadgets( aicopy )) != RETURN_OK)
      goto exitSetup;

   DBG( fprintf( stderr, "Calling checkForMenus()...\n" ) );
   if ((rval = checkForMenus( aicopy )) != RETURN_OK)
      goto exitSetup;
   // ------------------------------------------------------------------------------------
         
   // If we made it to here, we have the memory space to initialize 
   // Gadgets, BevelBoxes, Menus & IntuiTexts:
   DBG( fprintf( stderr, "Calling setupGUIMemorySpaces()...\n" ) );

   setupGUIMemorySpaces( aicopy );

   DBG( fprintf( stderr, "gtbGenC(): SetupProgram() -- Calling filterBadStrings()...\n" ) );
   // There's a bug in the PPC version of GTBTranslator that requires this:
   filterBadStrings();
      
exitSetup:

   DBG( fprintf( stderr, "Exiting SetupProgram().\n" ) );
   return( rval );
}

SUBFUNC void closeLibraries( void )
{
#  ifndef __amigaos4__
   if (LocaleBase && openedLocale == TRUE) 
      {
      CloseLibrary( (struct Library *) LocaleBase );
      
      openedLocale = FALSE;
      }
#  else
   if (IGadTools)
      DropInterface( (struct Interface *) IGadTools );
	 
   if (GadToolsBase)
      CloseLibrary( GadToolsBase );	 
#  endif

   return;
}

PRIVATE void ShutdownProgram( void )
{
   // Deallocate memory here:
//   DBG( fprintf( stderr, "Calling freeMultChoiceStrings() in ShutdownProgram()...\n" ) );
   freeMultChoiceStrings();

//   DBG( fprintf( stderr, "Calling freeMemorySpace() in ShutdownProgram()...\n" ) );
   freeMemorySpace();

   // Close libraries:
   if (openedLocale == TRUE)
      {
      if (scanCatalog) 
         CloseCatalog( scanCatalog );
      }

   if (aicopy) 
      {
      iniExit( aicopy );

      aicopy = NULL;
      }

   closeLibraries();
   
//   DBG( fprintf( stderr, "Exiting ShutdownProgram()...\n" ) );
   
   return;
}

PRIVATE BOOL generateMakeFileFlg   = FALSE;
PRIVATE BOOL generateLocaleFileFlg = FALSE;

PUBLIC int gtbGenC( char *iniFile, 
                    char *templateFile, 
                    BOOL  makeFlag, 
                    BOOL  loclFlag 
                  )
{
   IMPORT int generateLocaleFile( aiPTR, FILE *, UBYTE *fileName ); // In GTBGenMiscC.c file
   IMPORT int generateSMakeFile( FILE *, UBYTE *fileName );

   int error = RETURN_OK;
   
   generateMakeFileFlg   = makeFlag;
   generateLocaleFileFlg = loclFlag;

   StringNCopy( (char *) &sourceFileName[0], (char *) makeSourceName( iniFile ), BUFF_SIZE );

   DBG( fprintf( stderr, "gtbGenc():  sourceFileName = %s\n", sourceFileName ) );

   // Read the .ini file & setup globals here:

   if ((error = SetupProgram( iniFile )) != RETURN_OK)
      {
      ShutdownProgram();

      if (outFile != stdout && outFile) 
         myFClose( outFile, "gtbGenC()" );
      
      fprintf( stderr, "SetupProgram() Failed with %d!\n", error );

      return( error );
      }

   // InputFile (template file) will be closed in GTBLex code:
   if (!(InputFP = myFOpen( templateFile, "r", "gtbGenC()" ))) // == NULL)
      {
      fprintf( stderr, "gtbGenC() Could NOT open %s for input!\n", templateFile );

      return( IoErr() );
      }

   DBG( fprintf( stderr, "Calling processTemplate()...\n" ) );

   if (processTemplate( InputFP, outFile ) != RETURN_OK)
      {
      fprintf( stderr, "gtbGenC() Could NOT process %s!\n", templateFile );
      }

#  ifdef DEBUG
   else
      fprintf( stderr, "processTemplate() File scan complete.\n" );
#  endif

   if (outFile && outFile != stdout)
      myFClose( outFile, "gtbGenC()" );

   // Is there more to do??

   if (generateMakeFileFlg == TRUE)
      {
      FILE *mkFile         = NULL;
      char  makeFName[BUFF_SIZE] = { 0, };

//      DBG( fprintf( stderr, "Generating MakeFile...\n" ) );

      sprintf( &makeFName[0], "%s.smake", projectFileName );
      
      if (!(mkFile = myFOpen( &makeFName[0], "w", "gtbGenC()" ))) // == NULL)       
         {
         error = IoErr();

         goto exitMain;
         }
         
      (void) generateSMakeFile( mkFile, (UBYTE *) projectFileName );
      
      myFClose( mkFile, "gtbGenC()" );
      }
      
   if (generateLocaleFileFlg == TRUE)
      {
      aiPTR aiLc           = NULL;
      FILE *lcFile         = NULL;
      char  loclFName[BUFF_SIZE] = { 0, };

//      DBG( fprintf( stderr, "Generating Locale Header File...\n" ) );
      
      if (!(aiLc = iniOpenFile( iniFile, TRUE, DELIMITERS ))) // == NULL) 
         {
         error = IoErr();
      
         goto exitMain;
         }
     
      sprintf( &loclFName[0], "%s.cd", projectFileName );
      
      if (!(lcFile = myFOpen( &loclFName[0], "w", "gtbGenC()" ))) // == NULL)
         {
         error = IoErr();

         iniExit( aiLc );
            
         goto exitMain;
         }
         
      (void) generateLocaleFile( aiLc, lcFile, (UBYTE *) projectFileName );

      iniExit( aiLc );
            
      myFClose( lcFile, "gtbGenC()" );
      }

exitMain:

//   DBG( fprintf( stderr, "Calling ShutdownProgram() in GTBGenC...\n" ) );
   ShutdownProgram();

//   DBG( fprintf( stderr, "Exiting GTBGenC with %d...\n", error ) );

   return( error );
}

#ifdef DEBUGGEN // Make a separate executable:

PUBLIC int main( int argc, char **argv )
{
   IMPORT int generateLocaleFile( aiPTR, FILE *, UBYTE *fileName ); // In GTBGenMiscC.c file
   IMPORT int generateSMakeFile( FILE *, UBYTE *fileName );

   int error = RETURN_OK;
   
   if (argc < 3) // if not enough args or '?', print usage
      {
      fprintf( stderr, (char *) usage, argv[0] );

      return( ERROR_REQUIRED_ARG_MISSING );
      }
   else if (argv[1][0] == '?')
      {
      fprintf( stderr, (char *) usage, argv[0] );

      return( RETURN_WARN );
      }
   else if (argc == 4)
      {
      if (argv[3][0] == '-' && argv[3][1] == 'm')
         {
         if (argv[3][2] == 'S')
            generateMakeFileFlg = TRUE;
         else if (argv[3][2] == 'L')
            generateLocaleFileFlg = TRUE;
         }
      }
   else if (argc == 5)
      {
      if (argv[3][0] == '-' && argv[3][1] == 'm')
         {
         if (argv[3][2] == 'S')
            generateMakeFileFlg = TRUE;
         else if (argv[3][2] == 'L')
            generateLocaleFileFlg = TRUE;
         }

      if (argv[4][0] == '-' && argv[4][1] == 'm')
         {
         if (argv[4][2] == 'S')
            generateMakeFileFlg = TRUE;
         else if (argv[4][2] == 'L')
            generateLocaleFileFlg = TRUE;
         }
      }
      
   // Read the .ini file & setup globals here:

   DBG( fprintf( stderr, "gtbGenC():  Calling SetupProgram()...\n" ) );
   if ((error = SetupProgram( argv[1] )) != RETURN_OK)
      {
      if (error == INI_NOMEMORY)
         error = ERROR_NO_FREE_STORE;
         
      ShutdownProgram();

      if (outFile != stdout && outFile) 
         myFClose( outFile, "main()" );

      return( error );
      }

   // InputFile (template file) will be closed in GTBLex code:
   if (!(InputFP = myFOpen( argv[2], "r", "main()" )))
      {
      fprintf( stderr, "%s Could NOT open %s for input!\n", argv[0], argv[2] );

      return( IoErr() );
      }

   DBG( fprintf( stderr, "gtbGenC():  Calling processTemplate()...\n" ) );
   if (processTemplate( InputFP, outFile ) != RETURN_OK)
      {
      fprintf( stderr, "%s Could NOT process %s!\n", argv[0], argv[2] );
      }

#  ifdef DEBUG
   else
      fprintf( stderr, "// File scan complete.\n" );
#  endif

   if (outFile && outFile != stdout)
      myFClose( outFile, "main()" );

   DBG( fprintf( stderr, "gtbGenC():  Checking for makeFile & Locale file flags...\n" ) );
   // Is there more to do??

   if (generateMakeFileFlg == TRUE)
      {
      FILE *mkFile         = NULL;
      char  makeFName[BUFF_SIZE] = { 0, };
      char  mkPath[BUFF_SIZE]    = { 0, };
      
      sprintf( &makeFName[0], "%s%s.smake", 
                              GetPathName( &mkPath[0], projectFileName, 256 ), 
                              sourceFileName 
             );
      
      if (!(mkFile = myFOpen( &makeFName[0], "w", "main()" ))) // == NULL)       
         {
         error = IoErr();

         goto exitMain;
         }
         
      (void) generateSMakeFile( mkFile, (UBYTE *) projectFileName );
      
      myFClose( mkFile, "main()" );
      }
      
   if (generateLocaleFileFlg == TRUE)
      {
      aiPTR aiLc           = NULL;
      FILE *lcFile         = NULL;
      char  loclFName[BUFF_SIZE] = { 0, };
      char  lcPath[BUFF_SIZE]    = { 0, };
      
      if (!(aiLc = iniOpenFile( argv[1], TRUE, DELIMITERS ))) // == NULL) 
         {
         error = IoErr();
      
         goto exitMain;
         }
     
      sprintf( &loclFName[0], "%s%s.cd", 
                               GetPathName( &lcPath[0], projectFileName, BUFF_SIZE ), 
                               sourceFileName 
             );
      
      if (!(lcFile = myFOpen( &loclFName[0], "w", "main()" ))) // == NULL)
         {
         error = IoErr();

         iniExit( aiLc );
            
         goto exitMain;
         }
         
      (void) generateLocaleFile( aiLc, lcFile, (UBYTE *) projectFileName );

      iniExit( aiLc );
            
      myFClose( lcFile, "main()" );
      }

exitMain:
      
   ShutdownProgram();

   return( error );
}

#endif // DEBUGGEN

/* --------------- END of GTBGenC.c file! ------------------ */
