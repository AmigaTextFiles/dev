/****h* GTBTranslator/GTBGenMiscC.c [1.2] ******************************
*
* NAME
*    GTBGenMiscC.c 
*
* DESCRIPTION
*    Generate SMakeFile and/or Locale.h files for a GUIBuilder
*    project.
* 
* HISTORY
*    01-Nov-2004 - Added AmigaOS4 & gcc support.
*    13-Nov-2003 - Fixed some minor problems.
*
*    30-Sep-2003 - Created this file.
*
* NOTES
*    FUNCTIONAL INTERFACE:
*       PUBLIC int generateLocaleFile( aiPTR input, FILE *output );
*
*       PUBLIC int generateSMakeFile( FILE *output );
*
*    $VER: GTBGenMiscC.c 1.2 (01-Nov-2004) by J.T. Steichen
************************************************************************
*
*/

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include <exec/types.h>

#include <AmigaDOSErrs.h>

#include <libraries/gadtools.h>

#ifndef __amigaos4__

# include "StringFunctions.h"

# include <clib/exec_protos.h>

#else

# include <StringFunctions.h>

# define __USE_INLINE__

# include <proto/exec.h>
# include <proto/dos.h>

IMPORT struct Library  *DOSBase;

IMPORT struct DOSIFace *IDOS; // For FilePart(), etc.

#endif

#include "GadToolsBoxIFFs.h"

#include "CPGM:GlobalObjects/IniFuncs.h"
#include "CPGM:GlobalObjects/CommonFuncs.h"

#include "ScannerFuncProtos.h"

#define   LSIZE 80

#ifndef   BUFF_SIZE
# define  BUFF_SIZE 512
#endif

// ----------------------------------------------------

IMPORT BOOL useToolTypes;
IMPORT BOOL useASLReq;
IMPORT BOOL useBoopsiImage;

IMPORT char sourceFileName[BUFF_SIZE];
IMPORT char projectName[LSIZE];
IMPORT char projectFileName[LSIZE];
IMPORT char projectAuthorName[LSIZE];
IMPORT char projectAuthorEMail[LSIZE];
IMPORT char catalogName[LSIZE];

IMPORT struct myNewGadget *ngads;
IMPORT struct NewMenu     *nmenus;
IMPORT struct IntuiText   *itxt;

IMPORT int   gadgetCount;
IMPORT int   menuCount;
IMPORT int   itextCount;
IMPORT int   cycleGCount;
IMPORT int   listviewGCount;
IMPORT int   mxGCount;

IMPORT char *cycleStrings;
IMPORT char *mxStrings;
IMPORT char *listStrings;

// Called once only by each PUBLIC function:

PRIVATE UBYTE codeFileName[ BUFF_SIZE ];

SUBFUNC UBYTE *clipOffExtension( UBYTE *fileName )
{
   int len = StringLength( fileName );
   
   while (len > 0)
      {
      if (*(fileName + len) == '.')
         {
         *(fileName + len) = '\0';
      
         break;
	 }

      len--;
      }

   StringNCopy( &codeFileName[0], fileName, BUFF_SIZE );
   
   return( &codeFileName[0] );
}

// ----------------------------------------------------

// FilePart() [The DOS function] might NOT be working correctly:

PUBLIC UBYTE *FileNamePart( UBYTE *filePathString )
{
   int len = StringLength( filePathString );
   
   while (len > 0)
      {
      if (*(filePathString + len) == '/' || *(filePathString + len) == ':')
         {
	      len++;

	      break;
	      }
      
      len--;
      }
   
	DBG( fprintf( stderr, "FileNamePart() = '%s'\n", filePathString ) );

   return( &filePathString[ len ] );
}

PUBLIC void printOutLocaleHeader( FILE *fp, char *fileName )
{
   fprintf( fp, "#include \"%sLocale.h\"", FileNamePart( fileName ) );

   return;   
}

PRIVATE BOOL needLocale = FALSE;

PRIVATE void outputMakeHeader( FILE *fp )
{
   fputs( "####################################################################\n"
          "#\n", fp 
        );

   fprintf( fp, "#             MAKEFILE FOR %s program(s)\n#\n", codeFileName );

   fputs( "####################################################################\n"
          "#\n"
          "COPTS    = opt optsize strmer cpu=68040 ignore=100,225,304,147,315 nostkchk idir=Include:\n"
          "#\n", fp 
        );

   fputs( "LIBS     = LIB:scm.lib,LIB:sc.lib,LIB:Amiga.lib\n"
          "#\n"
          "DOPTS    = DEBUG=SYMBOL nostkchk ansi strmer cpu=68040 ignore=51,147,100,225 idir=INCLUDE:\n",
          fp 
        );

   fputs( "#\nGLO      = CPGM:GlobalObjects/\n#\n", fp );

   if (useBoopsiImage == TRUE)
      fputs( "GLOB     = $(GLO)CommonFuncs.o $(GLO)boopsi.o\n#\n", fp );
   else
      fputs( "GLOB     = $(GLO)CommonFuncs.o\n#\n", fp );

   fputs( "#\n"
          "MAKE     = SDK:c/make\n"
	  "#\n"  
          "CC       = GCC:Bin/gcc\n"
	  "#\n"
	  "CFLAGS   = -c -ILclInclude:\n"
	  "#\n"
	  "DBGFLAGS = -c -ggdb -gdwarf-2 -ILclInclude:\n"
	  "#\n", fp
        );

   fputs( "PPCLIBS  = -lm -lstringfuncs -lamiga -lauto\n"
          "#\n" 
	  "PPCGLOB  = GlobalObjects/CommonFuncsPPC.o\n#\n", fp
	);
   	
   return;
}

PRIVATE void outputMakeTargets( FILE *fp )
{
   fputs( "clean :\n"
          "\tDelete *.o QUIET\n"
          "#\n"
          "all   :\n", fp 
        );

   fprintf( fp, "\tSMake %s\n", codeFileName );
   fprintf( fp, "\t$(MAKE) %sPPC\n", codeFileName );

   fputs( "#\n"
          "help : \n"
	  "\t@echo \"Available target(s) for this MakeFile are...\"\n", fp );
   fprintf( fp, "\t@echo \"%s\"\n", codeFileName );
   fprintf( fp, "\t@echo \"%sPPC\"\n", codeFileName );
   fprintf( fp, "\t@echo \"%sDBG\"\n", codeFileName );
   fprintf( fp, "\t@echo \"%sPPCDBG\"\n", codeFileName );

   fputs( "#\n#\n", fp );
   fputs( "# -------------------- Final target(s): ----------------------------------\n"
          "#\n", fp 
        );

   fprintf( fp, "%s: %s.o $(GLOB)\n"
                "\tSLink LIB:c.o,%s.o,$(GLOB) TO %s LIB $(LIBS) STRIPDEBUG\n#\n",
                codeFileName, codeFileName,
                codeFileName, codeFileName
          );

   if (needLocale == TRUE)
      fprintf( fp, "%s.o : %s.c %sLocale.h\n"
                   "\tSC $(COPTS) %s.c\n#\n#\n", 
                   codeFileName, codeFileName, 
                   codeFileName, codeFileName
             );
   else
      fprintf( fp, "%s.o : %s.c\n"
                   "\tSC $(COPTS) %s.c\n#\n#\n", 
                   codeFileName, codeFileName, codeFileName
             );

   fprintf( fp, "%sPPC : %sPPC.o\n"
                "\t$(CC) $< CPGM:$(PPCGLOB) -o $@ $(PPCLIBS)\n#\n",
                codeFileName, codeFileName
          );

   if (needLocale == TRUE)
      fprintf( fp, "%sPPC.o : %s.c %sLocale.h\n"
                   "\tEnsureASCII $<     RAM:$<\n"
		   "\tCOPY        RAM:$< $<\n"
		   "\tDELETE      RAM:$<\n"
                   "\t$(CC) $(CFLAGS) -o $@ $<\n#\n#\n", 
                   codeFileName, codeFileName, codeFileName
             );
   else
      fprintf( fp, "%sPPC.o : %s.c\n"
                   "\tEnsureASCII $<     RAM:$<\n"
		   "\tCOPY        RAM:$< $<\n"
		   "\tDELETE      RAM:$<\n"
                   "\t$(CC) $(CFLAGS) -o $@ $<\n#\n#\n", 
                   codeFileName, codeFileName
             );
   
   fputs( "# -------------------- Debug target(s): ----------------------------------\n"
          "#\n", fp 
        );

   fprintf( fp, "%sDBG: %sDBG.o $(GLOB)\n"
                "\tSLink LIB:c.o,%sDBG.o,$(GLOB) TO %sDBG LIB $(LIBS) ADDSYM\n#\n",
                codeFileName, codeFileName,
                codeFileName, codeFileName
          );

   if (needLocale == TRUE)
      fprintf( fp, "%sDBG.o : %s.c %sLocale.h\n"
                   "\tSC $(DOPTS) objname=%sDBG.o %s.c\n#\n#\n", 
                   codeFileName, codeFileName, codeFileName, 
                   codeFileName, codeFileName
             );
   else
      fprintf( fp, "%sDBG.o : %s.c\n"
                   "\tSC $(DOPTS) -objname=%sDBG.o %s.c\n#\n#\n", 
                   codeFileName, codeFileName, codeFileName, codeFileName
             );

   fprintf( fp, "%sPPCDBG : %sPPCDBG.o\n"
                "\t$(CC) -ggdb -gdwarf-2 $< CPGM:$(PPCGLOB) -o $@ $(PPCLIBS) -lnet -lz\n#\n",
                codeFileName, codeFileName
          );

   if (needLocale == TRUE)
      fprintf( fp, "%sPPCDBG.o : %s.c %sLocale.h\n"
                   "\tEnsureASCII $<     RAM:$<\n"
		   "\tCOPY        RAM:$< $<\n"
		   "\tDELETE      RAM:$<\n"
                   "\t$(CC) $(DBGFLAGS) -o $@ $<\n#\n#\n", 
                   codeFileName, codeFileName, codeFileName
             );
   else
      fprintf( fp, "%sPPCDBG.o : %s.c\n"
                   "\tEnsureASCII $<     RAM:$<\n"
		   "\tCOPY        RAM:$< $<\n"
		   "\tDELETE      RAM:$<\n"
                   "\t$(CC) $(DBGFLAGS) -o $@ $<\n#\n#\n", 
                   codeFileName, codeFileName
             );
   
   return;
}

PRIVATE void outputMakeLocale( FILE *fp )
{
   if (needLocale == FALSE)
      return;

   fputs( "#\n"
          "# -------------------- Misc Targets: -------------------------------------\n"
          "#\n", fp 
        );
   
   fprintf( fp, "%sLocale.h : %s.cd\n"
                "\tCatComp $< CFILE  $@ NOCODE NOARRAY NOBLOCK\n"
                "\tCatComp $< CTFILE %s.ct\n#\n",
                codeFileName, codeFileName, codeFileName
          );

   return;
}

PUBLIC int generateSMakeFile( FILE *output, UBYTE *fileName )
{
   int error = RETURN_OK;

   (void) clipOffExtension( FileNamePart( fileName ) );
   (void) clipOffExtension( sourceFileName );
   
   if (StringLength( &catalogName[0] ) > 0)
      needLocale = TRUE;

   outputMakeHeader( output );

   outputMakeTargets( output );
        
   outputMakeLocale( output );

   return( error );
}

// ----------------------------------------------------

PRIVATE aiPTR aicopy = NULL;

// ---- Locale Generator functions: -------------------

PRIVATE void outputLocaleHeader( FILE *fp )
{
   fputs( "; ------------------------------------------------------------------\n"
          "; TRANSLATOR NOTES:\n"
          ";  \n"
          ";   1. Be sure to obey the limits (if any) associated with each\n"
          ";      string that you translate into your native language.\n"
          ";\n", 
          fp 
        );

   fputs( ";   2. In general, all strings should be less than 80 bytes in \n"
          ";      size, even after formatted numbers are taken into \n"
          ";      consideration because a lot of the strings in the program\n"
          ";      are sent via sprintf() into a buffer that is only 80 bytes\n"
          ";      in size before being displayed or written to a file.\n"
          ";\n",
          fp 
        );

   fputs( ";   3. MSGs with TITLE in the name are mostly used as Window/\n"
          ";      Requester titles, so limit them to 80 characters in length.\n"
          ";      Intuition will try to display longer ones, but they will be\n"
          ";      clipped by the end of the Window.\n"
          ";\n",
          fp 
        );

   fputs( ";   4. As a bare minimum, please translate the _GAD strings.  \n"
          ";      Currently, there is no way to change the HotKey\n"
          ";      equivalents for the Gadgets used in the program.  If anyone\n"
          ";      knows how to do this at run-time, please send me instructions\n"
          ";      or example code on how to correct this.\n"
          ";\n",
          fp 
        );

   fputs( ";   5. MSGs with _FMT in them are used by either fprintf() or\n"
          ";      sprintf() to create error messages (see note 2).\n",
          fp
        );
          
   fprintf( fp, ";\n;   6. This Locale file was automatically generated by %s\n"
                ";      written by %s -- EMail:  %s\n",
                        "GUIBuilder", &projectAuthorName[0], &projectAuthorEMail[0]
          );

   fputs( "; ------------------------------------------------------------------\n"
          ";\n", fp 
        );

   fprintf( fp, "#header %sLOCALE\n;\n", clipOffExtension( FileNamePart( projectFileName ) ) );
   
   return;
}

PRIVATE void outputTitles( aiPTR ai, FILE *fp )
{
   int i;
   
   i = iniFirstGroup( ai );
   i = iniNextGroup(  ai );
   i = iniFindItem(   ai,   "SA_ScreenTitle" );
   
   fprintf( fp, "MSG_%s_STITLE (//80)\n", projectName );
   fprintf( fp, "%s\n;\n", iniGetItemValue( aicopy, i ) );
    
   i = iniNextGroup( ai );
   i = iniFindItem(  ai,   "WA_Title" );
   
   fprintf( fp, "MSG_%s_WTITLE (//80)\n", projectName );
   fprintf( fp, "%s\n;\n", iniGetItemValue( aicopy, i ) );

   return;    
}

PRIVATE void outputToolTypeStrs( FILE *fp )
{
   fprintf( fp, ";\n; ------------- %s Icon ToolTypes: -------------------\n;\n",
                sourceFileName 
          );

   fprintf( fp, "MSG_%s_TT_SAVEPATH (//32)\nSAVEPATH\n;\n", projectName );

   return;
}

PRIVATE void outputASLStrs( FILE *fp )
{
   fprintf( fp, ";\n; -------------- %s ASL Requester: -------------------\n;\n",
                sourceFileName
          );

   fputs( "MSG_ASL_RTITLE (//80)\nEnter a File Name...\n;\n", fp );

   fputs( "MSG_ASL_OKAY_BT (//20)\n OKAY! \n;\n", fp );

   fputs( "MSG_ASL_CANCEL_BT (//20)\n CANCEL! \n;\n", fp ); 

   return;
}

PRIVATE char ml[80], *menuLabel = &ml[0];

PUBLIC char *filterMenuLabel( char *label )
{
   int i = 0, len = strlen( label );
   
   strClear( menuLabel ); // In CommonFuncsPPC.o
   
   while (i < len) // && isalnum( *(label + i) ))
      {
      switch (*(label + i))
         {
	      case ' ':
	         *(menuLabel + i) = '_';
	         break;

         // We only want C-identifier characters in the menuLabel:
	 	 
	      case 'a': case 'b': case 'c': case 'd': case 'e': case 'f': case 'g': case 'h':
	      case 'i': case 'j': case 'k': case 'l': case 'm': case 'n': case 'o': case 'p':
	      case 'q': case 'r': case 's': case 't': case 'u': case 'v': case 'w': case 'x':
	      case 'y': case 'z': case '0': case '1': case '2': case '3': case '4': case '5':
	      case '6': case '7': case '8': case '9':
	      case 'A': case 'B': case 'C': case 'D': case 'E': case 'F': case 'G': case 'H':
	      case 'I': case 'J': case 'K': case 'L': case 'M': case 'N': case 'O': case 'P':
	      case 'Q': case 'R': case 'S': case 'T': case 'U': case 'V': case 'W': case 'X':
	      case 'Y': case 'Z': case '_':
            *(menuLabel + i) = *(label + i);
	 
	      default:
	         break;   
         }
	 
      i++;
      }
      
   return( menuLabel );
}

PRIVATE void outputMenuStrings( FILE *fp )
{
   int i;

   if (menuCount < 1)
      return;
         
   fprintf( fp, ";\n; ---------- %s Menu Strings: ---------------------\n;\n",
                  sourceFileName 
          );

   for (i = 0; i < menuCount; i++)
      {
      if (nmenus[i].nm_Label != (STRPTR) NM_BARLABEL)
         {
         fprintf( fp, "MSG_MENU_%s (//32)\n", filterMenuLabel( nmenus[i].nm_Label ) );
         fprintf( fp, "%s\n;\n", nmenus[i].nm_Label );
         }
      }

   fprintf( fp, ";\n; ---------- %s Menu Key Strings: -----------------\n;\n",
                  sourceFileName 
          );

   for (i = 0; i < menuCount; i++)
      {
      if (nmenus[i].nm_CommKey)
         {
	      if (StringComp( nmenus[i].nm_CommKey, "0" ) != 0)
	         {
            fprintf( fp, "MSG_MENUKEY_%s (//4)\n", nmenus[i].nm_CommKey );
            fprintf( fp, "%s\n;\n", nmenus[i].nm_CommKey );
	         }
	      }
      }

   return;
}

PRIVATE void outputGadgetStrings( FILE *fp )
{
   int mxk = 0, cyk = 0, lvk = 0;
   int i, j;

   if (gadgetCount < 1)
      return;
         
   fprintf( fp, ";\n; ---------- %s Gadget Strings: -------------------\n;\n",
                sourceFileName 
          );

   for (i = 0; i < gadgetCount; i++)
      {
      if (ngads[i].ng_GadgetText != NULL && ngads[i].ng_GadgetText != (STRPTR) 0xDEADBEEF 
                                         && StringLength( ngads[i].ng_GadgetText ) > 0)
         {
	      if (ngads[i].ng_UserData != NULL && ngads[i].ng_UserData != (STRPTR) 0xDEADBEEF 
                                          && StringLength( ngads[i].ng_UserData ) > 0)
	         {
            fprintf( fp, "MSG_GAD_%s (//32)\n", (UBYTE *) ngads[i].ng_UserData );
	         }

	      fprintf( fp, "%s\n;\n", ngads[i].ng_GadgetText );
         }
      }

   if (cycleGCount > 0)
      {
      for (i = 0; i < gadgetCount; i++)
         {
         if (ngads[i].ng_Type == CYCLE_KIND)
            {
            fprintf( fp, ";\n; ---------- %d Cycle Gadget Strings: -------------\n;\n",
                          ngads[i].ng_GadgetID
                   );

            for (j = 0; j < ngads[i].ng_NumberOfChoices; j++)
               {
               fprintf( fp, "MSG_GAD_%d%d_CYLBL (//32)\n", ngads[i].ng_GadgetID, j );

               fprintf( fp, "%s\n;\n", &cycleStrings[ (j + cyk) * LSIZE ] );
                
               }

            cyk += ngads[i].ng_NumberOfChoices;
            }
         }
      }

   if (mxGCount > 0)
      {
      for (i = 0; i < gadgetCount; i++)
         {
         if (ngads[i].ng_Type == MX_KIND)
            {
            fprintf( fp, ";\n; ---------- %d MX Gadget Strings: ----------------\n;\n",
                          ngads[i].ng_GadgetID
                   );

            for (j = 0; j < ngads[i].ng_NumberOfChoices; j++)
               {
               fprintf( fp, "MSG_GAD_%d%d_MXLBL (//32)\n", ngads[i].ng_GadgetID, j );

               fprintf( fp, "%s\n;\n", &mxStrings[ (j + mxk) * LSIZE ] );
                
               }

            mxk += ngads[i].ng_NumberOfChoices;
            }
         }
      }

   if (listviewGCount > 0)
      {
      for (i = 0; i < gadgetCount; i++)
         {
         if (ngads[i].ng_Type == LISTVIEW_KIND)
            {
            if (ngads[i].ng_NumberOfChoices > 0)
               {
               fprintf( fp, ";\n; ---------- %d ListView Gadget Strings: ----------\n;\n",
                             ngads[i].ng_GadgetID
                      );

               for (j = 0; j < ngads[i].ng_NumberOfChoices; j++)
                  {
                  fprintf( fp, "MSG_GAD_%d%d_LVLBL (//32)\n", ngads[i].ng_GadgetID, j );

                  fprintf( fp, "%s\n;\n", &listStrings[ (j + lvk) * LSIZE ] );
                  }

               lvk += ngads[i].ng_NumberOfChoices;
               }
            }
         }
      }

   return;      
}

PRIVATE void outputITextStrings( FILE *fp )
{
   int i;

   if (itextCount < 1)
      return;
         
   fprintf( fp, ";\n; ------------- IntuiText Strings for %s: ---------------------\n;\n",
                sourceFileName
          ); 

   for (i = 0; i < itextCount; i++)
      {
      fprintf( fp, "MSG_ITXT_%s%d (//80)\n", projectName, i );
      fprintf( fp, "%s\n;\n", itxt[i].IText );
      }

   return;
}

PRIVATE void outputMiscErrs( FILE *fp )
{
   fprintf( fp, ";\n; ------------- Misc ERROR Strings for %s: --------------------\n;\n",
                sourceFileName
          ); 

   fputs( "MSG_SYSTEM_PROBLEM (//80)\nSystem PROBLEM:\n;\n", fp );

   fputs( "MSG_USER_ERROR (//80)\nUser ERROR:\n;\n", fp );

   fputs( "MSG_FMT_NO_FILEOPEN (//80)\nCould NOT open %s file!\n;\n", fp );

   fputs( "MSG_FMT_LIB_UNOPENED (//80)\nCould NOT open %s V%d library!\n;\n", fp );

   fputs( "MSG_FILE_WRITE_ERR (//80)\nThe file did NOT get written correctly!\n;\n", fp );

   fputs( "MSG_FMT_NOGUI_ERR (//80)\nCould NOT open a %s GUI (error # %d)!\\n\n;\n", fp );
   
   return;
}

// --------- The main calling points: ---------------------------

PUBLIC int generateLocaleFile( aiPTR input, FILE *output, UBYTE *fileName )
{
   int error = RETURN_OK;

   aicopy = input;

   (void) clipOffExtension( FileNamePart( fileName ) );

   outputLocaleHeader( output );

   outputTitles( aicopy, output );
   
   if (useToolTypes == TRUE)
      outputToolTypeStrs( output );

   if (useASLReq == TRUE)
      outputASLStrs( output );

   if (menuCount > 0)
      outputMenuStrings( output );
      
   if (gadgetCount > 0)
      outputGadgetStrings( output );

   if (itextCount > 0)
      outputITextStrings( output );
      
   outputMiscErrs( output );
   
   return( error );
}

/* -------------- END of GTBGenMiscC.c file! ----------------- */
