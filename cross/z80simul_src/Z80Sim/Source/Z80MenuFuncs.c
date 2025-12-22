/****h* Z80Simulator/Z80MenuFuncs.c [2.5] *****************************
*
* NAME
*    Z80MenuFuncs.c
*
* DESCRIPTION
*    the Functions that get executed from the Z80Simulator MenuItems.
***********************************************************************
*
*/

#include <stdio.h>
#include <string.h>

#include <exec/types.h>

#include <MyFunctions.h>
#include <AmigaDOSErrs.h>

#define    ALLOCATE
# include <Author.h>
#undef     ALLOCATE

#include <intuition/intuitionbase.h>
#include <intuition/classes.h>
#include <intuition/classusr.h>
#include <intuition/imageclass.h>
#include <intuition/gadgetclass.h>

#include <libraries/gadtools.h>
#include <libraries/asl.h>

#include <graphics/gfxbase.h>

#include <clib/exec_protos.h>
#include <clib/intuition_protos.h>
#include <clib/gadtools_protos.h>
#include <clib/graphics_protos.h>
#include <clib/utility_protos.h>
#include <clib/asl_protos.h>

#include "CPGM:GlobalObjects/CommonFuncs.h"

#include "FileReqTags.h"

#include "Z80Sim.h"
#include "Z80SimGTGUI.h"

#include "Z80Vars.h"

#include "Z80FuncProtos.h"

#define SRC_LV       Z80SimGadgets[SrcCodeListView]
#define CURRENT_INST Z80SimGadgets[CurrentInst]

IMPORT struct  FileHandle *Open();

IMPORT BOOL PathValid( UBYTE *path ); // in Z80SimGTGUI.c

IMPORT struct Console *AttachConsole( struct Window *, char * );
IMPORT void           ShutDown( void );

/* GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG Located in Z80SimGTGUI.c file: */

IMPORT BOOL   sregchanged[], dregchanged[];
IMPORT UBYTE *mem;
IMPORT UWORD  temp_PC;

IMPORT UBYTE  PathName[], ProgramName[];

IMPORT unsigned short FromAddress;
IMPORT unsigned short ToAddress;

IMPORT char           InFileName[], OutFileName[];
IMPORT char           *PatternStr;

IMPORT struct Window  *Z80SimWnd;
IMPORT struct Gadget  *Z80SimGadgets[];

IMPORT struct Screen  *Scr;

IMPORT struct List    SCList;
IMPORT struct Node    SCListItems[];
IMPORT char           *SCItemBuffer;

IMPORT char           CurrentConfigFileName[];
IMPORT char           *Editor, *Translator, *ConfigFile;

/* GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG */

PRIVATE char cmdbuf[256];

/* -------------------------------------------------------------- */

/****i* Z80Simulator/ResetChangeFlags() *****************************
*
* NAME
*    ResetChangeFlags()
*
* DESCRIPTION
*    Set all highlighting flags to false.  The instruction decoders
*    will set them to true, when appropriate.
*********************************************************************
*
*/

PRIVATE void ResetChangeFlags( void )
{
   int i;
   
   for (i = A; i <= R; i++)
      sregchanged[i] = FALSE;
      
   for (i = PC; i <= IY; i++)
      dregchanged[i] = FALSE;
      
   return;
}

/****i* Problemo() **************************************************
*
* NAME
*    Problemo()
*
* DESCRIPTION
*    Inform the user of a problem, setting the buttons of the 
*    requester to a known state.
*********************************************************************
*
*/

PRIVATE void Problemo( char *msg, char *title, int *errnum )
{
   SetReqButtons( "Aaarrgghh!!" );

   (void) Handle_Problem( msg, title, errnum );

   SetReqButtons( "CONTINUE|ABORT" );
   
   return;
}

/****i* Z80MenuFuncs.c/Write_It() [1.0] ***************************** 
*
* NAME 
*   Write_It - write a string to the output file.
*
* SYNOPSIS
*   error = Write_It( FileHandle *file, char *output, int length )
*
* FUNCTION
*   Write the 'output' string of length 'length' to the 'file'.
*
* INPUTS
*   file   - Amiga Output file pointer.
*   output - output string to write to file.
*   length - length of outstr.
*
*********************************************************************
*
*/

PRIVATE int Write_It( struct FileHandle *file, char *outstr, int len )
{
   if (Write( file, outstr, len ) == -1)
      return( IoErr() );

   return( 0 );
}

#define  WRITEOUT(f,s,n,e)  {if ((e = Write_It( f,s,n )) != 0) return(e);}

/****i* Z80MenuFuncs.c/Save_File() [1.0] **************************** 
*
* NAME 
*   Save_File - write a configuration file.
*
* SYNOPSIS
*   error = Save_File( char *filename )
*
* FUNCTION
*   Write the register contents to the configuration file.
*   Then, write out all memory spaces specified by the user.
*
* INPUTS
*   filename - The Amiga Output filename.
*
* RETURNS
*   -1 if there is an error, 0 for success.
*
* SEE ALSO
*   HandleAddrRange()
*********************************************************************
*
*/

PRIVATE int Save_File( char *filename )
{
   static char    *srg[18] = {  "REG  A:  ", "REG  F:  ", "REG  AP: ",
                                "REG  FP: ", "REG  B:  ", "REG  C:  ",
                                "REG  BP: ", "REG  CP: ", "REG  D:  ",
                                "REG  E:  ", "REG  DP: ", "REG  EP: ",
                                "REG  H:  ", "REG  L:  ", "REG  HP: ",
                                "REG  LP: ", "REG  I:  ", "REG  R:  "
                             };

   static char    *drg[4] =  {  "REG  PC: ", "REG  SP: ",
                                "REG  IX: ", "REG  IY: "
                             };

   struct FileHandle *newfile;
   int               r, err;
   char              sf_nil1[ 11 ], *temp = &sf_nil1[0];

   if ((newfile = Open( filename, MODE_NEWFILE )) == NULL)
      return( -1 );

   for (r = 0; r < 18; r++)
      {
      WRITEOUT( newfile, srg[r], 9, err ) /* #define'd -> ';' */
      to_hexstr( reg[r], temp, 2 );
      WRITEOUT( newfile, temp, 2, err )
      WRITEOUT( newfile, "\n", 1, err )
      }

   for (r = 0; r < 4; r++)   
      {
      WRITEOUT( newfile, drg[r], 10, err )
      to_hexstr( dreg[r], temp, 4 );
      WRITEOUT( newfile, temp, 4, err )
      WRITEOUT( newfile, "\n", 1, err )
      }

More_Memory:

   if (HandleAddrRange() == 0)
      {
      WRITEOUT( newfile, "LOAD", 4, err )
      WRITEOUT( newfile, "\n", 1, err )
      to_hexstr( FromAddress, temp, 4 );

      WRITEOUT( newfile, temp, 4, err )
      WRITEOUT( newfile, "\n", 1, err )

      for (r = FromAddress; r <= ToAddress; r++)  
         {
         to_hexstr( mem[r], temp, 2 );
         WRITEOUT( newfile, temp, 2, err )
         WRITEOUT( newfile, " ",  1, err )

         if ((r % 4 == 0) && (r != 0))
            WRITEOUT( newfile, "\n", 1, err )
         }

      WRITEOUT( newfile, "\n@\n", 3, err )
      }
   else
      {
      /* This means that HandleAddrRange() couldn't open requester! */
      WRITEOUT( newfile, "END", 3, err )
      Close( newfile );

      return 0;
      }

   err = 0;

   if (Handle_Problem( "Press CONTINUE for another Address Range",
                       "Save File Request:", &err ) == 0)
      goto More_Memory;

   WRITEOUT( newfile, "END", 3, err )

   Close( newfile );

   return 0;
}

/* --------------------------------------------------------------- */

PRIVATE struct   NewWindow   d_window = {
   
   0, 0, 540, 400, 0, 1,
   ACTIVEWINDOW,
   SMART_REFRESH | ACTIVATE | WINDOWDRAG | RMBTRAP,
   NULL, NULL, (UBYTE *) NULL, NULL, NULL,
   540, 400, 540, 400, WBENCHSCREEN 
   };

/* --------------------------------------------------------------- */

/****i* Z80SimGTGUI.c/Open_Dump_Window() [1.0] ********************** 
*
* NAME 
*   Open_Dump_Window - Open a Console window to show memory contents.
*
* SYNOPSIS
*   DWindow = Open_Dump_Window( char *title, int x, int y )
*
* FUNCTION
*   Open a window & a Console to show the memory 'Dump' that the
*   user requested.
*
* INPUTS
*   title - title string to place on the new window.
*   x     - the LeftEdge to open the window at.
*   y     - the TopEdge to open the window at.
*
* RETURNS
*   DWindow - a pointer to the Dump Memory Window.
* 
* WARNINGS
*   there is an exit() point in this function.
*
*********************************************************************
*
*/

PRIVATE struct Window *Open_Dump_Window( char *title, int stx, int sty )
{
   struct   Window      *dwindow;

   d_window.LeftEdge = stx;       
   d_window.TopEdge  = sty;
   d_window.Screen   = Scr;
   d_window.Title    = title;

   if ((dwindow = (struct Window *) OpenWindow( &d_window )) == NULL)   
      {
      if (Handle_Problem( "Couldn't open Dump Window!",
                          "OUT OF MEMORY??", NULL ) == TRUE)
         {
         ShutDown();
         exit( 1 );
         }

      return( NULL );
      }

   return( dwindow );
}

/****i* Z80SimGTGUI.c/Form_String() [1.0] *************************** 
*
* NAME 
*   Form_String - Make the memory string for Dump Memory function. 
*
* SYNOPSIS
*   Form_String( struct Console *cons, UBYTE *memory, ULONG address,
*                int howmany );
*
* FUNCTION
*   Make a string of the memory contents in order to display them
*   in the console.
*
* INPUTS
*   cons    - The console to display the string on.
*   memory  - Z80 memory space pointer.
*   address - The starting Z80 address memory location.
*   howmany - How many bytes of memory to display. 
*
*********************************************************************
*
*/

PRIVATE void  Form_String( struct Console *console, UBYTE *memry, 
                           ULONG addr, int howmany 
                         )
{
   extern UWORD dreg[];

   auto           int  counter;
   register short int  i, byte, DoubleHowMany, OffsetHowMany;

   char       *taddr  = "      ";
   char       *tnum   = "                                    ";
   char       *tascii = "                    ", total[ MAXLINE ];

   DoubleHowMany = 2 * howmany;
   OffsetHowMany = 4 + howmany;

   for (i = 0; i < MAXLINE; i++)          /* nil out total[] array */
      total[i] = '\0';

   to_hexstr( (int) addr, taddr, 4 );
   (void) strcat( taddr, ": " );
   (void) strcpy( &total[0], taddr );     /* Address string is set up! */

   for ( counter = addr, i = 0; i < DoubleHowMany; counter++, i += 2)
      to_hexstr( (*(memry + counter) & 0x00FF), &tnum[i], 2 );

   (void) insert_string( tnum, " ", 8 );
   (void) insert_string( tnum, " ", 17 );
   (void) insert_string( tnum, " ", 26 );
   (void) strcat( total, tnum );
                                             /* set up ASCII string! */
   *(tascii + 1) = *(tascii + 2) = '-';
   *(tascii)     = *(tascii + 3) = ' ';

   for ( counter = addr, i = 4; i < OffsetHowMany; counter++, i++)
      {
      byte = (*(memry + counter ) & 0x00FF);
      if ( isprint( byte ) && (byte < 0x7F))
         *(tascii + i) = toascii( byte );
      else
         *(tascii + i) = '.';
      }

   (void) strcat( total, tascii );

   ConDumps( console, &total[0] );
   ConDumpc( console, ENDLINE );

   return;
}

/* --------------------------------------------------------------- */


/* 0=0=0=0=0=0=0=0=0= MenuItem selection functions: 0=0=0=0=0=0=0=0=0 */


/****i* Z80MenuFuncs.c/Z80SimLoadMI() [2.5] ************************* 
*
* NAME 
*   Z80SimLoadMI - load the configuration file specified by the user.
*
* SYNOPSIS
*   continue = Z80SimLoadMI( void )
*
* FUNCTION
*   Open the Load file ASL requester to get a filename from the
*   user, then call File_Loader() to load in a new configuartion
*   file if strlen( filename ) > 0.
*
* RETURNS
*   TRUE
*
*********************************************************************
*
*/

VISIBLE int Z80SimLoadMI( void )
{
   char NIL1[256], *permname = &NIL1[0], fname[256] = "";

   SetTagItem( LoadTags, ASLFR_TitleText, 
                         (ULONG) "Z80Simulator: Load a Config File..."
             );

   SetTagItem( LoadTags, ASLFR_Window, (ULONG) Z80SimWnd );
   
   if (FileReq( fname, LoadTags ) > 1)
      {
      (void) strcpy( permname, fname );
      (void) File_Loader( permname, NULL );
      (void) strncpy( &CurrentConfigFileName[0], permname, 255 );

      (void) GetPathName( &PathName[0], CurrentConfigFileName, 255 );

      if (PathValid( &PathName[0] ) == TRUE)
         SetTagItem( LoadTags, ASLFR_InitialDrawer, (ULONG) &PathName[0] );
      else
         SetTagItem( LoadTags, ASLFR_InitialDrawer, (ULONG) "RAM:" );
      }

   ResetChangeFlags();   

   return( (int) TRUE );
}

/****i* Z80MenuFuncs.c/Z80SimSaveMI() [2.5] ************************* 
*
* NAME 
*   Z80SimSaveMI - Save the configuration file.
*
* SYNOPSIS
*   continue = Z80SimSaveMI( void )
*
* FUNCTION
*   Use the current config filename if it's not empty, otherwise 
*   open the save file ASL requester to get a filename from the
*   user, then call Save_File() to save a new configuartion
*   file if strlen( filename ) > 0.
*
* RETURNS
*   TRUE
*
*********************************************************************
*
*/

VISIBLE int Z80SimSaveMI( void )
{
   char fname[256] = "";
   int  err        = 0;
   
   if (strlen( &CurrentConfigFileName[0] ) > 0)
      {
      if (Save_File( &CurrentConfigFileName[0] ) != 0)
         Problemo( "Unable to save file!",&CurrentConfigFileName[0],&err );
      else
         {
         (void) GetPathName( &PathName[0], CurrentConfigFileName, 255 );

         if (PathValid( &PathName[0] ) == FALSE)
            SetTagItem( SaveTags, ASLFR_InitialDrawer, (ULONG) "RAM:" );
         else
            SetTagItem( SaveTags, ASLFR_InitialDrawer,(ULONG)&PathName[0]);
         }
      }
   else
      {
      SetTagItem( SaveTags, ASLFR_TitleText, 
                            (ULONG) "Z80Simulator: Save a Config File..."
                );

      SetTagItem( SaveTags, ASLFR_Window, (ULONG) Z80SimWnd );
   
      if (FileReq( fname, SaveTags ) > 1)
         {
         if (Save_File( &CurrentConfigFileName[0] ) != 0)
            Problemo( "Unable to save file!", fname, &err );
         else 
            (void) strncpy( &CurrentConfigFileName[0], fname, 255 );

         (void) GetPathName( &PathName[0], fname, 255 );

         if (PathValid( &PathName[0] ) == FALSE)
            SetTagItem( SaveTags, ASLFR_InitialDrawer, (ULONG) "RAM:" );
         else
            SetTagItem( SaveTags, ASLFR_InitialDrawer,(ULONG)&PathName[0]);
         }
      }

   return( (int) TRUE );
}


/****i* Z80MenuFuncs.c/Z80SimSaveAsMI() [2.5] *********************** 
*
* NAME 
*   Z80SimSaveAsMI - Save the configuration file.
*
* SYNOPSIS
*   continue = Z80SimSaveAsMI( void )
*
* FUNCTION
*   Open the save file ASL requester to get a filename from the
*   user, then call Save_File() to save a new configuartion
*   file if strlen( filename ) > 0.
*
* RETURNS
*   TRUE
*
*********************************************************************
*
*/

VISIBLE int Z80SimSaveAsMI( void )
{
   char NIL1[256], *permname = &NIL1[0], fname[256] = "";
   int  err = 205;
   
   SetTagItem( SaveTags, ASLFR_TitleText, 
                         (ULONG) "Z80Simulator: Save a Config File..."
             );

   SetTagItem( SaveTags, ASLFR_Window, (ULONG) Z80SimWnd );
   
   if (FileReq( fname, SaveTags ) > 1)
      {
      (void) strcpy( permname, fname );

      if (Save_File( permname ) != 0)
         Problemo( "Unable to save", permname, &err );
      else
         {
         (void) strncpy( &CurrentConfigFileName[0], fname, 255 );

         (void) GetPathName( &PathName[0], CurrentConfigFileName, 255 );

         if (PathValid( &PathName[0] ) == FALSE)
            {
            SetTagItem( SaveTags, ASLFR_InitialDrawer, (ULONG) "RAM:" );
            SetTagItem( DefaultTags, ASLFR_InitialDrawer, (ULONG) "RAM:" );
            }
         else
            {
            SetTagItem( SaveTags,    ASLFR_InitialDrawer,
                        (ULONG) &PathName[0]
                      );

            SetTagItem( DefaultTags, ASLFR_InitialDrawer,
                        (ULONG) &PathName[0]
                      );
            }
         }
      }

   return( (int) TRUE );
}

/****i* Z80MenuFuncs.c/Z80SimAboutMI() [2.0] ************************ 
*
* NAME 
*   Z80SimAboutMI - Show some information about the program.
*
* SYNOPSIS
*   continue = Z80SimAboutMI( void )
*
* FUNCTION
*   Open the 'About' information requester.
*
* RETURNS
*   TRUE
*
*********************************************************************
*/

VISIBLE int Z80SimAboutMI( void )
{
   IMPORT UBYTE *version;

   char a[256];
   char t[80] = "";

   if (strlen( &ProgramName[0] ) < 2)
      strcpy( &ProgramName[0], "Z80Simulator" );
         
   sprintf( t, "About %s © 1998-2001:", &ProgramName[0] );
   
   sprintf( a, "%s ©1998-2001 V%s by %s\n"
               "   Create & Debug Z80 machine code!\n   My e-mail: %s", 
               &ProgramName[0], version, authorName, authorEMail );
   
   SetReqButtons( "OKAY!" ); 
 
   (void) Handle_Problem( a, t, NULL );

   SetReqButtons( "CONTINUE|ABORT" ); 

   return( (int) TRUE );
}

/****i* Z80MenuFuncs.c/Z80SimQuitMI() [2.0] ************************* 
*
* NAME 
*   Z80SimQuitMI - The only correct (besides the CloseWindow
*                  gadget) exit for the program.
*
* SYNOPSIS
*   continue = Z80SimQuitMI( void )
*
* FUNCTION
*   Make sure that the user really wants to quit, then ShutDown()
*   exit() the entire program.
*
* RETURNS
*   TRUE if the user was temporarily insane, otherwise, the 
*   program is exited here.
*
*********************************************************************
*/

VISIBLE int Z80SimQuitMI( void )
{
   if (SanityCheck( "Are you ready to exit the program?" ) == TRUE)
      {
      SetReqButtons( "Save Configuration first!|QUIT!" );   

      if (Handle_Problem( "Save the configuration?", 
                          "FINAL CHECK:", NULL ) == 0)
         {
         (void) Z80SimSaveMI();
         return( FALSE );
         }
      else
         return( FALSE );
      }
   else
      return( (int) TRUE );
}

/****i* Z80MenuFuncs.c/Z80SimTranslateMI() [2.5] ******************** 
*
* NAME 
*   Z80SimTranslateMI - Translate an Intel object file to a 
*                       configuration file.
*
* SYNOPSIS
*   continue = Z80SimTranslateMI( void )
*
* FUNCTION
*   Generate an 'Execute'able string of the form:
*   Z80Xlate <Intel_Input >Z80.cfg_OutputFile.
*
* RETURNS
*   TRUE
*
* NOTES
*   This function uses InFileName & OutFileName.
*
*********************************************************************
*
*/

VISIBLE int Z80SimTranslateMI( void )
{
   char *command = &cmdbuf[0];
   int  rval     = TRUE;


   if (HandleTranslateReq() > 0) 
      {
      if (strlen( &InFileName[0] ) > 0)
         {
         if (strlen( &OutFileName[0] ) > 0)
            {
            (void) strcpy( command, Translator );
            (void) strcat( command, " <" );
            (void) strcat( command, &InFileName[0] );
            (void) strcat( command, " >" );
            (void) strcat( command, &OutFileName[0] );

            rval = Execute( command, NULL, NULL );
            }

         if (rval == FALSE)
            Problemo( "Unable to Translate file!", &InFileName[0], NULL );
         }
      }

   return( (int) TRUE ); /* rval */
}

/****i* Z80MenuFuncs.c/EditFile() [1.0] ***************************** 
*
* NAME 
*   EditFile - Execute an Edit command string.
*
* SYNOPSIS
*   error = EditFIle( char *filename )
*
* FUNCTION
*   Generate an 'Execute'able string of the form:
*   Editor filename
*
* INPUTS
*   filename - the name of the file to edit.
*
* RETURNS
*   the result of 'Execute()'
*
* NOTES
*   called by Z80SimEditFileMI();
*
*********************************************************************
*
*/

PRIVATE int EditFile( char *filename )
{
   char *command = &cmdbuf[0];

   (void) strcpy( command, Editor );
   (void) strcat( command, " " );
   (void) strcat( command, filename );

   return( Execute( command, NULL, NULL ));
}

/****i* Z80MenuFuncs.c/Z80SimEditFileMI() [2.0] ********************* 
*
* NAME 
*   Z80SimEditFileMI - Execute an Edit menuitem command.
*
* SYNOPSIS
*   continue = Z80SimEditFIleMI( void )
*
* FUNCTION
*   Get a filename from the user that the user wants to edit,
*   then call EditFile( filename );
*
* RETURNS
*   TRUE
*
* SEE ALSO
*   EditFile()
*
*********************************************************************
*
*/

VISIBLE int Z80SimEditFileMI( void )
{
   char NIL1[256], *permname = &NIL1[0], fname[256] = "";
   int  err = 205;

   SetTagItem( DefaultTags, ASLFR_Window, (ULONG) Z80SimWnd );

   SetTagItem( DefaultTags, ASLFR_TitleText, 
                            (ULONG) "Editor: Edit a File..." 
             );

   if (FileReq( fname, DefaultTags ) > 1)
      {
      (void) strcpy( permname, fname );

      if (EditFile( permname ) == FALSE)
         Problemo( "Unable to Edit", permname, &err );
      else
         {
         (void) GetPathName( &PathName[0], permname, 255 );

         if (PathValid( &PathName[0] ) == FALSE)
            SetTagItem( DefaultTags, ASLFR_InitialDrawer, (ULONG) "RAM:" );
         else
            SetTagItem( DefaultTags, ASLFR_InitialDrawer,
                        (ULONG) &PathName[0]
                      );
         }
      }

   return( (int) TRUE );
}


/****i* Z80MenuFuncs.c/Z80SimMacroMI() [2.5] ************************ 
*
* NAME 
*   Z80SimMacroMI - Execute the Macro menuitem command.
*
* SYNOPSIS
*   continue = Z80SimMacroMI( void )
*
* FUNCTION
*   Get a command string from the user & Execute it.
*
* RETURNS
*   TRUE
*
* SEE ALSO
*   HandleCommandReq()
*
*********************************************************************
*
*/

VISIBLE int Z80SimMacroMI( void )
{
   char NIL1[256], *command = &NIL1[0];
   int  err = 205, rval = 0;

   rval = HandleCommandReq( command, "Macro" );

   if (rval < 0)
      {
      return( (int) TRUE );
      }
   else
      {
      rval = Execute( command, NULL, NULL );

      if (rval == FALSE)
         Problemo( command, "Unable to Execute Command:", &err );
      }

   return( (int) TRUE );
}

/****i* Z80MenuFuncs.c/Z80SimAssembleMI() [2.5] ********************* 
*
* NAME 
*   Z80SimAssembleMI - Execute the Assemble menuitem command.
*
* SYNOPSIS
*   continue = Z80SimAssembleMI( void )
*
* FUNCTION
*   Get a command string from the user & execute it.
*
* RETURNS
*   TRUE
*
* SEE ALSO
*   HandleCommandReq()
*
*********************************************************************
*/

VISIBLE int Z80SimAssembleMI( void )
{
   char NIL1[256], *command = &NIL1[0];
   int  err = 205, rval = 0;

   rval = HandleCommandReq( command, "Assemble" );

   if (rval < 0)
      {
      return( (int) TRUE );
      }
   else
      {
      rval = Execute( command, NULL, NULL );

      if (rval == FALSE)
         Problemo( command, "Unable to Execute Command:", &err );
      }

   return( (int) TRUE );
}

/****i* Z80MenuFuncs.c/PrintFile() [1.0] **************************** 
*
* NAME 
*   PrintFile - Output a source listing to a file.
*
* SYNOPSIS
*   error = PrintFile( char *filename )
*
* FUNCTION
*   Write the dis-assembly from 'FromAddress' to 'ToAddress'
*   to the 'filename'.
*
* RETURNS
*   0 if successful, -1 if there is a failure.
*
* SEE ALSO
*   Z80SimPrtListMI()
*********************************************************************
*
*/

PRIVATE int PrintFile( char *filename )
{
   IMPORT char *DisAssemble( UBYTE memcontents, int *addr );
   
   struct FileHandle *newfile;
   int               r, err;
   char              sf_nil1[ 21 ], *temp = &sf_nil1[0];

   if ((newfile = Open( filename, MODE_NEWFILE )) == NULL)
      return( -1 );

   WRITEOUT( newfile, "** Disassembly from ", 20, err )
   to_hexstr( FromAddress, temp, 4 );
   WRITEOUT( newfile, temp, 4, err )

   WRITEOUT( newfile, " to ", 4, err )
   to_hexstr( ToAddress, temp, 4 );
   WRITEOUT( newfile, temp, 4, err )

   WRITEOUT( newfile, "\n\n", 2, err )
   r = FromAddress;

   while (r <= ToAddress)
      {
      /* DisAssemble() has the side effect of incrementing 'r' to point to
      ** the next instruction to decode into an assembly instruction str.
      */
      temp = DisAssemble( mem[r], &r );
      WRITEOUT( newfile, temp, strlen( temp ), err )
      WRITEOUT( newfile, "\n", 1, err )
      }

   WRITEOUT( newfile, "\n\n", 2, err )
   WRITEOUT( newfile, "\t\tEND", 5, err )

   Close( newfile );

   return 0;
}

/****i* Z80MenuFuncs.c/Z80SimPrtListMI() [2.0] ********************** 
*
* NAME 
*   Z80SimPrtListMI - Execute the Print Listing menuitem command.
*
* SYNOPSIS
*   continue = Z80SimPrtListMI( void )
*
* FUNCTION
*   Get the output filename, the To & From addresses from the user,
*   then Write the dis-assembly from 'FromAddress' to 'ToAddress'
*   to the 'filename'.
*
* RETURNS
*   TRUE
*
* SEE ALSO
*   PrintFile()
*********************************************************************
*
*/

VISIBLE int Z80SimPrtListMI( void )
{
   int err = 205, rval = 0;

   rval = HandlePrintListing(); /* Setup OutFileName, FromAddress &
                                ** ToAddress.
                                */
   if (rval == -1)
      {
      Problemo( "Problem with Print List Requester",&OutFileName[0],&err );

      return( (int) TRUE );
      }
   else if (rval < -1)
      {
      Problemo( "Invalid data from Print List Requester", 
                "Print Listing Problem:", &err 
              );

      fprintf( stderr, "Invalid data from Print List Requester\n" );

      return( (int) TRUE );
      }
   else if (rval == 0) /* Valid Exit rval from HandlePrintListing(): */
      {
      /* DEBUG statement: */
      fprintf( stderr, "Printing listing to %s...\n", &OutFileName[0] );

      if (PrintFile( &OutFileName[0] ) != 0)
         Problemo( "Unable to print", &OutFileName[0], &err );
      }

   return( (int) TRUE );
}

/****i* Z80MenuFuncs.c/Z80SimFindCurrentMI() [2.5] ****************** 
*
* NAME 
*   Z80SimFindCurrentMI - Execute the Find Current Inst'
*                         menuitem command.
*
* SYNOPSIS
*   continue = Z80SimFindCurrentMI( void )
*
* FUNCTION
*   Find the current instruction (the last valid entry in the ListView)
*   & update the ListView & CurrentInst string gadgets accordingly.
*
* NOTES
*   This silly function is only necessary if the user played with
*   the ListView slider gadget & cannot find the current instruction
*   by looking at the ListView.
*
* RETURNS
*   TRUE
*********************************************************************
*
*/

VISIBLE int Z80SimFindCurrentMI( void )
{
   int  linenum;
      
   /* Disable the ListView momentarily: */
   GT_SetGadgetAttrs( SRC_LV, Z80SimWnd, NULL,
                      GTLV_Labels, ~0,
                      TAG_END
                    );
   linenum = 0;   

   while ((strlen( &SCItemBuffer[ linenum * SCITEMLENGTH ] ) > 0) 
          && (linenum < SCMAXITEM))
      {
      linenum++;
      }
   
   linenum--; // index now is at last valid ListView string.
       
   /* Copy the latest instruction to the Current Instruction String
   ** Gadget:
   */
   GT_SetGadgetAttrs( CURRENT_INST, Z80SimWnd, NULL,
                      GTTX_Text, &SCItemBuffer[ linenum * SCITEMLENGTH ],
                      TAG_END
                    );
        
   /* Re-enable the ListView gadget: */
   GT_SetGadgetAttrs( SRC_LV, Z80SimWnd, NULL,
                      GTLV_Labels,      &SCList,
                      GTLV_MakeVisible, linenum,
                      GTLV_Selected,    linenum,
                      TAG_END
                    );

   return( (int) TRUE );
}


/****i* Z80MenuFuncs.c/MakeDumpTitle() [2.0] ************************ 
*
* NAME 
*   MakeDumpTitle - Make a window title for DumpMem or DumpStack
*
* SYNOPSIS
*   void MakeDumpTitle( char *title, char *preamble, char *poststr )
*
*********************************************************************
*/

PRIVATE void MakeDumpTitle( char *title, char *preamble, char *poststr )
{
   char NNIL[6], *hexstr = &NNIL[0];

   hexstr[0] = '$';

   (void) strcpy( title, preamble );
   (void) stci_h( &hexstr[1], FromAddress );
   (void) strcat( title, hexstr );
   (void) strcat( title, "->" );
   (void) stci_h( &hexstr[1], ToAddress );
   (void) strcat( title, hexstr );
   (void) strcat( title, poststr );

   return;
}

/****i* Z80MenuFuncs.c/Z80SimDumpMI() [2.0] ************************* 
*
* NAME 
*   Z80SimDumpMI - Execute the Dump memory menuitem command.
*
* SYNOPSIS
*   continue = Z80SimDumpMI( void )
*
* FUNCTION
*   Get start & ending addresses from the user, then open a 
*   Dump Memory Console.
*
* RETURNS
*   TRUE
* 
* SEE ALSO
*   HandleDumpReq(), Open_Dump_Console()
*********************************************************************
*/

VISIBLE int Z80SimDumpMI( void )
{
   struct Console *dcon;
   struct Window  *DW;
   int            wlinectr, rval = 0;
   char           ch, dump_buffer[ MAXLINE ];
   char           TNIL[80], *title = &TNIL[0];
   ULONG          il;

   rval = HandleDumpReq();
   
   if (rval < 0)
      {
      Problemo( "Couldn't open Dump Memory Requester", 
                "OUT OF MEMORY??", NULL 
              );

      FromAddress = ToAddress = 0;

      return( (int) TRUE );
      }
   else if (rval == 0) /* User Aborted the Dump! */
      goto LeaveDump;
      

   /* HandleDumpReq() returned OPEN_DUMP_CONSOLE: */
   MakeDumpTitle( title, "Memory Dump: (", "):" );

   if ((DW = Open_Dump_Window( title, 0, 0 )) == NULL)
      goto LeaveDump;
   
   if ((dcon = AttachConsole( DW, dump_buffer )) == 0) 
      {
      if (Handle_Problem( "Couldn't get a console for dump window",
                          "OUT OF MEMORY??", NULL ) == TRUE)   
         {
         CloseWindow( DW );
         ShutDown();
         exit( 1 );
         }

      CloseWindow( DW );
      goto LeaveDump;
      }

   wlinectr = 0;
   il       = FromAddress;

   while (il <= ToAddress)  
      {
      Form_String( dcon, mem, il, 16 );

      if (wlinectr < 16)
         wlinectr++;
      else  
         {
         ConDumps( dcon, "Press any key to see more, <ESC> to exit" );

         ch = ConGetc( dcon );

         if (ch == ESC) 
            {
            DetachConsole( dcon );
            CloseWindow( DW );
            goto LeaveDump;
            }

         wlinectr = 0;
         ConDumps( dcon, "\n" );
         }

      if ((il + 16) <= ToAddress)
         il += 16;
      else
         break;
      }           /* end of address range reached! */

   ConDumps( dcon, "Press <ESC> to exit" );

   while ((ch = ConGetc( dcon )) != ESC)
      ;

   DetachConsole( dcon );
   CloseWindow( DW );

LeaveDump:
   return( (int) TRUE );
}

/****i* Z80MenuFuncs.c/Z80SimFillMI() [2.0] ************************* 
*
* NAME 
*   Z80SimFillMI - Execute the Fill memory menuitem command.
*
* SYNOPSIS
*   continue = Z80SimFillMI( void )
*
* FUNCTION
*   Get start, ending addresses & a pattern from the user, then
*   Fill the Z80 memory space specified with the pattern.
*
* RETURNS
*   TRUE
* 
* SEE ALSO
*   HandleFillMemReq()
*********************************************************************
*/

#define  HALFPATT    40  /* MAXLINE / 2 */

VISIBLE int Z80SimFillMI( void )
{
   int             flen = 0, fspace = 0;
   int             pbytes[ HALFPATT ];
   int             i, rval = 0, hxtoi();
   char            *tmpstr = "  ";
   ULONG           il;

   rval = HandleFillMemReq();
   
   if (rval < 0)
      {
      Problemo( "Couldn't open Fill Memory Requester", PatternStr, &flen );

      return( (int) TRUE );
      }
   else if (rval == 0)     /* User pressed ABORT! */
      goto LeaveFillMem;

   flen   = strlen( PatternStr );
   fspace = (int) (ToAddress - FromAddress + 1);

   for (i = 0; i < flen; i++)   
      {
      if (strlen( PatternStr ) > 2)  
         {
         tmpstr    = chop_high( PatternStr );
         pbytes[i] = hxtoi( tmpstr );
         (void) remove_substring( PatternStr, 0, 2 );
         }
      else
         pbytes[i] = hxtoi( PatternStr );
      }

   for ( il = FromAddress, i = 0; il <= ToAddress; il++, i++)
      mem[ il ] = pbytes[i];

LeaveFillMem:

   return( (int) TRUE );
}

/****i* Z80MenuFuncs.c/Z80SimStackMI() [2.0] ************************ 
*
* NAME 
*   Z80SimStackMI - Execute the Dump Stack menuitem command.
*
* SYNOPSIS
*   continue = Z80SimStackMI( void )
*
* FUNCTION
*   Get start & ending addresses from the user, then
*   open a Dump Console.
*
* RETURNS
*   TRUE
* 
* SEE ALSO
*   HandleStackReq(), Open_Dump_Window()
*********************************************************************
*/

VISIBLE int Z80SimStackMI( void )
{
   struct Console  *stcon;
   struct Window   *SW;
   int             wlinectr, rval = 0;
   char            ch, stack_buffer[ MAXLINE ];
   char            SNIL[80], *title = &SNIL[0];
   ULONG           il;

   rval = HandleStackReq();
   
   if (rval < 0)
      {
      Problemo( "Couldn't open Dump Stack Requester", 
                "OUT OF MEMORY??", NULL
              );

      return( (int) FALSE );
      }
   else if (rval == 0)
      goto LeaveStack;


   /* HandleStackReq() returned OPEN_STACK_CONSOLE: */

   MakeDumpTitle( title, "Stack Dump: (", "):" );

   if ((SW = Open_Dump_Window( title, 0, 0 )) == NULL)
      goto LeaveStack;

   if ((stcon = AttachConsole( SW, stack_buffer )) == 0) 
      {
      if (Handle_Problem( "Couldn't get console for Stack window",
                          "OUT OF MEMORY??", NULL ) == TRUE)  
         {
         CloseWindow( SW );
         ShutDown();
         exit( 1 );
         }

      CloseWindow( SW );
      goto LeaveStack;
      }

   wlinectr = 0;
   il       = FromAddress;

   while (il <= ToAddress)  
      {
      Form_String( stcon, mem, il, 16 );

      if (wlinectr < 16)
         wlinectr++;
      else  
         {
         ConDumps( stcon, "Press any key to see more, <ESC> to exit" );

         ch = ConGetc( stcon );

         if (ch == ESC) 
            {
            DetachConsole( stcon );
            CloseWindow( SW );
            goto LeaveStack;
            }

         wlinectr = 0;
         ConDumps( stcon, "\n" );
         }

      if ((il + 16) <= ToAddress)
         il += 16;
      else
         break;
      }

   ConDumps( stcon, "Press <ESC> to exit" );

   while ((ch = ConGetc( stcon )) != ESC)
      ;

   DetachConsole( stcon );
   CloseWindow( SW );

LeaveStack:
   return( (int) TRUE );
}

/****i* Z80MenuFuncs.c/Execute_Instruction() [1.0] ****************** 
*
* NAME 
*   Execute_Instruction - Process the next Z80 instruction byte.
*
* SYNOPSIS
*   status = Execute_Instruction( UBYTE instruction )
*
* FUNCTION
*   Decode the instruction, then process it as a Z80 would,
*   Update the display, CheckBkpt()'s & return status.
*   open a Dump Console.
*
* RETURNS
*   status - the Z80 Processor status integer value.
* 
* SEE ALSO
*   decode_mach(), Update_Regs(), CheckBkpt()
*********************************************************************
*/

PRIVATE int Execute_Instruction( UBYTE inst )
{
   ResetChangeFlags();   

   status = decode_mach( inst );

   if (status == RETURN_FOUND)    
      status = RUNNING;

   /* Update the SourceCode ListView, then */

   Update_Regs( dreg[ PC ] );

   (void) CheckBkpt();

   return( status );
}

/****i* Z80MenuFuncs.c/Z80SimStepMI() [2.0] ************************* 
*
* NAME 
*   Z80SimStepMI - Execute the Step menuitem command.
*
* SYNOPSIS
*   continue = Z80SimStepMI( void )
*
* FUNCTION
*   Process the Z80 memory byte at the current PC location.
*
* RETURNS
*   TRUE
* 
* SEE ALSO
*   Execute_Instruction()
*********************************************************************
*/

VISIBLE int Z80SimStepMI( void )
{
   status = RUNNING;

   ResetChangeFlags();   

   (void) Execute_Instruction( mem[ dreg[ PC ] ] );

   return( (int) TRUE );
}

/****i* Z80MenuFuncs.c/Z80SimRestartMI() [2.0] ********************** 
*
* NAME 
*   Z80SimRestartMI - Execute the Restart menuitem command.
*
* SYNOPSIS
*   continue = Z80SimRestartMI( void )
*
* FUNCTION
*   Reset the Z80 program counter, then process the Z80 memory 
*   byte at the current PC location.
*
* RETURNS
*   TRUE
* 
* SEE ALSO
*   Execute_Instruction()
*********************************************************************
*/

VISIBLE int Z80SimRestartMI( void )
{
   dreg[ PC ] = 0; 
   status     = RUNNING;

   ResetChangeFlags();   

   (void) Execute_Instruction( mem[ dreg[ PC ] ] );

   return( (int) TRUE );
}

/****i* Z80MenuFuncs.c/Z80SimNMI_MI() [2.0] ************************* 
*
* NAME 
*   Z80SimNMI_MI - Execute the NMI menuitem command.
*
* SYNOPSIS
*   continue = Z80SimNMI_MI( void )
*
* FUNCTION
*   Clear the IFF1 register, set the Z80 program counter to 0x0066,
*   then Execute_Instruction()'s forever.
*
* RETURNS
*   TRUE
* 
* SEE ALSO
*   Execute_Instruction()
*********************************************************************
*/

VISIBLE int Z80SimNMI_MI( void )
{
   int rstatus = RUNNING;

   if ((IFF1_2 & IFF1) == IFF1)
      SETIFF2();
   else
      RESETIFF2();
      
   RESETIFF1();
   Push( ((dreg[PC] & 0xFF00) >> 8), (dreg[PC] & 0x00FF) );
   dreg[PC] = 0x0066;

   status   = NMI;
   Display_Status();

   status   = RUNNING;

   for (;;)  /* FOREVER!! */
      {
      ResetChangeFlags();   
   
      rstatus = Execute_Instruction( mem[ dreg[ PC ] ] );

      if (rstatus == ILLGL || rstatus == HALT)
         break;
      }

   if ((IFF1_2 & IFF2) == IFF2)
      {
      SETIFF1();
      RESETIFF2();
      }

   return( (int) TRUE );
}

/****i* Z80MenuFuncs.c/Z80SimInt_MI() [2.0] ************************* 
*
* NAME 
*   Z80SimInt_MI - Execute the INT menuitem command.
*
* SYNOPSIS
*   continue = Z80SimInt_MI( void )
*
* FUNCTION
*   Determine which interrupt mode is currently set, (0 -> 2):
*   For imode == 0:
*     Get the RST address (for PC) from the user, then
*     Execute_Instruction()'s forever.
*
*   For imode == 1:
*     Set the program counter to 0x0038, then
*     Execute_Instruction()'s forever.
*
*   For imode == 2:
*     Get an interrupt vector value from the user, form
*     the program counter from this value & the contents of the
*     'I' register, then
*     Execute_Instruction()'s forever.
*
* RETURNS
*   TRUE
* 
* SEE ALSO
*   HandleIM0Req(), HandleIM2Req(), Execute_Instruction()
*********************************************************************
*/

VISIBLE int Z80SimInt_MI( void )
{
   int taddr = 0, rstatus = RUNNING;
   
   if ((IFF1_2 & IFF1) != IFF1)
      return( (int) TRUE );        // NMI' running, Interrupts disabled! 
   else
      {
      status = INT;
      Display_Status();
      }   
      
   status = RUNNING;

   ResetChangeFlags();   

   switch (imode)
      {
      default:
      case 0:
         {
         short int rst_address = 0;

         taddr = HandleIM0Req();

         if (taddr > 7)          /* User pressed HALT button. */
            break;
         else if (taddr < 0)
            {
            /* No memory for requester????? */
            }
         else
            {
            Push( ((dreg[ PC ] & 0xFF00) >> 8), (dreg[ PC ] & 0x00FF) );
            switch (taddr)
               {
               case 0:
                  rst_address = 0;
                  break;
               case 1:
                  rst_address = 0x0008;
                  break;
               case 2:
                  rst_address = 0x0010;
                  break;
               case 3:
                  rst_address = 0x0018;
                  break;
               case 4:
                  rst_address = 0x0020;
                  break;
               case 5:
                  rst_address = 0x0028;
                  break;
               case 6:
                  rst_address = 0x0030;
                  break;
               case 7:
                  rst_address = 0x0038;
                  break;
               }
            dreg[ PC ] = rst_address;
            }

         status = RUNNING; 

         for (;;)  /* FOREVER!! */
            {
            ResetChangeFlags();   

            rstatus = Execute_Instruction( mem[ dreg[ PC ] ] );

            if (rstatus == ILLGL || rstatus == HALT)
               break;
            }
         }
         break;

      case 1:  
         Push( ((dreg[ PC ] & 0xFF00) >> 8), (dreg[ PC ] & 0x00FF));
         dreg[ PC ] = 0x0038;
         status     = RUNNING;

         for (;;)  /* FOREVER!! */
            {
            ResetChangeFlags();   
         
            rstatus = Execute_Instruction( mem[ dreg[ PC ] ] );

            if (rstatus == ILLGL || rstatus == HALT)
               break;
            }

         break;

      case 2:  
         taddr = (HandleIM2Req( reg[ I ] ) & 0x000000FF );

         if (taddr >= 0)
            {
            /* Valid IVector value range: */
            int Iptr = 0;

            Push(((dreg[ PC ] & 0xFF00) >> 8),(dreg[ PC ] & 0x00FF));
            Iptr     = (reg[ I ] << 8) + taddr;
            dreg[PC] = (mem[ Iptr + 1 ] << 8) + mem[ Iptr ];
            }
         else if (taddr < 0) // Problem or user Aborted!
            break;

         status = RUNNING;

         for (;;)  /* FOREVER!! */
            {
            ResetChangeFlags();   
         
            rstatus = Execute_Instruction( mem[ dreg[ PC ] ] );

            if (rstatus == ILLGL || rstatus == HALT)
               break;
            }
         
         break;
      }

   return( (int) TRUE );
}

/****i* Z80MenuFuncs.c/Z80SimGoMI() [2.0] *************************** 
*
* NAME 
*   Z80SimGoMI - Execute the GO! menuitem command.
*
* SYNOPSIS
*   continue = Z80SimGoMI( void )
*
* FUNCTION
*   Get a starting address from the user, then set the
*   Z80 program counter to this value, then
*   Execute_Instruction()'s forever.
*
* RETURNS
*   TRUE
* 
* SEE ALSO
*   decode_mach(), Update_Regs(), checkBkpt(), Execute_Instruction()
*********************************************************************
*/

VISIBLE int Z80SimGoMI( void )
{
   if (HandleStartAddr() < 0)   
      {
      Problemo( "Couldn't open Go Requester", "OUT OF MEMORY??", NULL );

      return( (int) FALSE );
      }
   else
      {
      dreg[ PC ] = ToAddress;
      status     = RUNNING;

      for (;;)    /* FOREVER!! */
         {
         ResetChangeFlags();   
      
         status  = decode_mach( mem[ dreg[ PC ] ] );

         if (status == ILLGL || status == HALT)
            {
            /* Update the SourceCode ListView, then */
            Update_Regs( dreg[ PC ] );
            (void) CheckBkpt();

            return( (int) TRUE );
            }
         else if (status == RETURN_FOUND)    
            {
            Update_Regs( dreg[ PC ] );
            (void) CheckBkpt();
            status = RUNNING;

            return( (int) TRUE );
            }

         (void) CheckBkpt();
         }
      }

   return( (int) TRUE );
}

/****i* Z80MenuFuncs.c/Z80SimSetPC_MI() [2.0] *********************** 
*
* NAME 
*   Z80SimSetPC_MI - Execute the Set PC menuitem command.
*
* SYNOPSIS
*   continue = Z80SimSetPC_MI( void )
*
* FUNCTION
*   Get a starting address from the user, then set
*   Z80 program counter to this value, then
*   Update the display.
*
* RETURNS
*   TRUE
* 
* SEE ALSO
*   HandleStartAddr(), Update_Regs()
*********************************************************************
*/

VISIBLE int Z80SimSetPC_MI( void )
{
   if (HandleStartAddr() < 0)   
      {
      Problemo( "Couldn't open Set PC Requester", "OUT OF MEMORY??", NULL);

      return( (int) FALSE );
      }
   else
      {  
      dreg[ PC ]      = ToAddress;
      dregchanged[PC] = TRUE;

      Update_Regs( dreg[ PC ] );
      }

   return( (int) TRUE );
}

/****i* Z80MenuFuncs.c/Z80SimSetBreakMI() [2.0] ********************* 
*
* NAME 
*   Z80SimSetBreakMI - Execute the SetBreakPt menuitem command.
*
* SYNOPSIS
*   continue = Z80SimSetBreakMI( void )
*
* FUNCTION
*   Add a breakpoint to the list via requester.
*
* RETURNS
*   TRUE
* 
* SEE ALSO
*   HandleSetBreakPt()
*********************************************************************
*/

VISIBLE int Z80SimSetBreakMI( void )
{
   IMPORT unsigned short BkptNum;
   
   if (HandleSetBreakPt() < 0)
      {
      Problemo( "Couldn't open Set BreakPoint Requester!", 
                "OUT OF MEMORY??", (int *) &BkptNum 
              );
      }

   return( (int) TRUE );
}

/****i* Z80MenuFuncs.c/Z80SimSetRegisterMI() [2.0] ****************** 
*
* NAME 
*   Z80SimSetRegisterMI - Execute the SetRegister menuitem command.
*
* SYNOPSIS
*   continue = Z80SimSetRegisterMI( void )
*
* FUNCTION
*   Change Z80 register values.
*
* RETURNS
*   TRUE
* 
* SEE ALSO
*   Update_Regs()
*********************************************************************
*/

VISIBLE int Z80SimSetRegisterMI( void )
{
   int rval = 0;
   
   ResetChangeFlags();   

   rval = HandleSetRegister();
   
   if (rval < 0)
      {
      Problemo( "Couldn't open Set Register Requester!", 
                "OUT OF MEMORY??", NULL
              );
      }
   else if (rval > 1)
      Update_Regs( dreg[ PC ] );
   
   return( (int) TRUE );
}

/****i* Z80MenuFuncs.c/Z80SimClearBreakMI() [2.0] ******************* 
*
* NAME 
*   Z80SimClearBreakMI - Execute the ClearBreakPt menuitem command.
*
* SYNOPSIS
*   continue = Z80SimClearBreakMI( void )
*
* FUNCTION
*   Delete a breakpoint from the list via requester.
*
* RETURNS
*   TRUE
* 
* SEE ALSO
*   HandleClearBreakPt()
*********************************************************************
*/

VISIBLE int Z80SimClearBreakMI( void )
{
   if (HandleClearBreakPt() < 0)
      {
      Problemo( "Couldn't open Clear BreakPoint Requester!", 
                "OUT OF MEMORY??", NULL
              );
      }

   return( (int) TRUE );
}

/****i* Z80MenuFuncs.c/Z80SimShowBreaksMI() [2.0] ******************* 
*
* NAME 
*   Z80SimShowBreaksMI - Execute the ShowBreakPts menuitem command.
*
* SYNOPSIS
*   continue = Z80SimShowBreaksMI( void )
*
* FUNCTION
*   Display the Breakpoints.
*
* RETURNS
*   TRUE
* 
* SEE ALSO
*   HandleShowBreakPt()
*********************************************************************
*/

VISIBLE int Z80SimShowBreaksMI( void )
{
   if (HandleShowBreakPt() < 0)
      {
      Problemo( "Couldn't open Show BreakPoint Requester!",
                "OUT OF MEMORY??", NULL
              );
      }

   return( (int) TRUE );
}

/* ------------------ END of Z80MenuFuncs.c file ---------------- */
