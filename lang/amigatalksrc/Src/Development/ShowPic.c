/****h* ShowPic/ShowPic.c [1.01] ************************************************
*
* NAME
*    ShowPic
*
* DESCRIPTION
*    Simple datatype picture viewer
*
* NOTES
*    Original source code was in Amiga-E by:
*    Jan Hagqvist,  V1.00  24-Feb-96
*********************************************************************************
*
*/

#include <stdio.h>
#include <exec/types.h>

#include <AmigaDOSErrs.h>

#include <datatypes/datatypesclass.h>

//#include <datatypes.h>

#include <datatypes/pictureclass.h>
#include <datatypes/datatypes.h>

#include <intuition/intuition.h>
#include <intuition/screens.h>
#include <intuition/gadgetclass.h>

#include <utility/tagitem.h>

#include <dos.h>
#include <dos/dos.h>


struct Screen *myscreen;
struct Window *mywin;

Object *mypic      = NULL;
ULONG   mypicflags = 0L;

struct IntuiMessage *imsg;

struct Library *DataTypesBase = NULL;

#define WINFLAGS 

void waitmsg( void )
{
   do { 
      imsg = WaitIMessage( mywin );

      if ((imsg == IDCMP_CHANGEWINDOW)
         RefreshDTObjectA( mypic, mywin, 0, 0 );
      
      }  while (imsg != IDCMP_CLOSEWINDOW);
}

int main( int argc, char **argv )
{
   fprintf( stderr, "ShowPic V1.00  24-Feb-96  by Jan Hagqvist\n" );

   if ((DataTypesBase = OpenLibrary( "datatypes.library", 39L )) == NULL)
      {
      fprintf( stderr, "\nUnable to open datatypes.library\n" );

      return( ERROR_INVALID_RESIDENT_LIBRARY );
      }

   if ((infile = Open( argv[1], MODE_OLDFILE )) == NULL)
      {
      fprintf( stderr, "\nCan't open file: %s\n", argv[1] );
      CloseLibrary( DataTypesBase );

      return( IoErr() );
      }
   else
      Close( infile ); // Just checking for file existence.

   if ((myscreen = LockPubScreen( NULL )) == NULL)
      {
      fprintf( stderr, "\nCannot open Screen!\n" );
      CloseLibrary( DataTypesBase );
      
      return( ERROR_ON_OPENING_SCREEN );
      }
       
   mypic = NewDTObject( argv[1], 
                        DTA_SOURCETYPE, DTST_FILE,
                        DTA_GROUPID,    GID_PICTURE,
                        PDTA_Screen,    myscreen,
                        PDTA_Remap,     TRUE,
                        PDTA_Precision, PRECISION_IMAGE,
                        
                        GA_LEFT,       4,  // win->BorderLeft,
                        GA_TOP,        11, // win->BorderTop,
                        GA_RELWIDTH,  -22,
                        GA_RELHEIGHT, -13,
                        TAG_DONE 
                      );

   if (mypic == NULL)
      {
      fprintf( stderr, "File System ERR: %s", PrintFault( IoErr() ) );

      CloseLibrary( DataTypesBase );

      return( IoErr() );
      }

   if ((mywin = OpenWindowTags( NULL,
                                WA_Width,  640, 
                                WA_Height, 256, 
                                WA_IDCMP,  IDCMP_CLOSEWINDOW | IDCMP_CHANGEWINDOW, 

                                WA_Flags,  WFLG_DRAGBAR | WFLG_CLOSEGADGET | WFLG_DEPTHGADGET
                                  | WFLG_SIMPLE_REFRESH | WFLG_NOCAREREFRESH 
                                  | WFLG_ACTIVATE | WFLG_SIZEGADGET,

                                WA_Title,     "Picture Window",
                                WA_PubScreen, myscreen,
                               TAG_DONE )) == NULL)
      {
      fprintf( stderr, "\nCannot open window!\n" );

      DisposeDTObject( mypic );

      UnlockPubScreen( NULL, myscreen );

      CloseLibrary( DataTypesBase );

      return( IoErr() );
      }

   AddDTObject( mywin, 0, mypic, -1 );

   do {
      mypicflags = mypic->specialinfo + 46;

      Delay( 25 );
      
      } while ((mypicflags & 1) == FALSE);
      
   RefreshDTObjectA( mypic, mywin, 0, 0 );

   waitmsg();

   RemoveDTObject( mywin, mypic );
   DisposeDTObject( mypic );

   CloseWindow( mywin );
   UnlockPubScreen( NULL, myscreen );

   CloseLibrary( DataTypesBase );

   return( RETURN_OK );
}

