/****h* MsgPortTester.c [1.0] **************************************
*
* NAME
*    MsgPortTester.c
*
* DESCRIPTION
*    This program actually receives the messages sent by the
*    TestMsgPort AmigaTalk script file.
********************************************************************
*
*/

#include <stdio.h>
#include <stdlib.h>
#include <strings.h>

#include <exec/types.h>
#include <exec/memory.h>

#include <AmigaDOSErrs.h>

#include <intuition/intuitionbase.h>
#include <intuition/intuition.h>
#include <intuition/screens.h>

#ifndef __amigaos4__

#include <clib/alib_protos.h>
#include <clib/exec_protos.h>
#include <clib/intuition_protos.h>

struct IntuitionBase *IntuitionBase;
struct Library       *GadToolsBase = NULL;

#else

# define __USE_INLINE__

# include <proto/exec.h>
# include <proto/intuition.h>
# include <proto/gadtools.h>

IMPORT struct ExecIFace *IExec;

struct Library *IntuitionBase;
struct Library *GadToolsBase = NULL;

struct IntuitionIFace *IIntuition;
struct GadToolsIFace  *IGadTools;

#endif

#include "CPGM:GlobalObjects/CommonFuncs.h"

/*
struct MsgPort {

    struct Node  mp_Node;
    UBYTE        mp_Flags;
    UBYTE        mp_SigBit;   // signal bit number
    void        *mp_SigTask;  // object to be signalled
    struct List  mp_MsgList;  // message linked list
};

#define MPORTNAME mp_Node.ln_Name
#define MPORT_PRI mp_Node.ln_Pri

struct Node {

   struct Node *ln_Succ; // Pointer to next (successor)
   struct Node *ln_Pred; // Pointer to previous (predecessor)
   UBYTE        ln_Type;
   BYTE         ln_Pri;	 // Priority, for sorting
   char        *ln_Name; // ID string, null terminated

};                       // Note:  word aligned struct

struct Message {

   struct Node     mn_Node;
   struct MsgPort *mn_ReplyPort;  // message reply port
   UWORD           mn_Length;     // total message length, in bytes
				  // (include the size of the Message
				  // structure in the length)
};
*/

#define MAXCHAR 80

struct MyMessage {

   struct Message mm_Message;
   char           mm_TheMsg[ MAXCHAR ];
};

PRIVATE struct MsgPort *myport = NULL;
PRIVATE struct Screen  *scr    = NULL;
PRIVATE struct Window  *win    = NULL;
PRIVATE APTR            vi     = NULL;

PRIVATE char v[] = "\0$VER: MsgPortTester 1.0 " __DATE__ " by J.T. Steichen\0";

PRIVATE char portName[80] = "MsgPort_Tester";

PRIVATE struct MyMessage *mess   = NULL;
PRIVATE struct MsgPort   *talkTo = NULL;

PRIVATE ULONG signals = 0, winsignal = 0, portsignal = 0;

PRIVATE BOOL dontCloseIntuition = FALSE;

/* Apparently, we cannot re-use Message space for sending &
** receiving, so we need: 
*/
PRIVATE struct MyMessage sendThis = { 0, };

// ----------------------------------------------------------------

PRIVATE void shutdownProgram( void )
{
   if (win) // != NULL)
      {
      CloseWindow( win );
      win = NULL;
      }

   if (vi) // != NULL)
      {
      FreeVisualInfo( vi );
      vi = NULL;
      }

   if (scr) // != NULL)
      {
//      UnlockPubScreen( scr->Title, scr );
      scr = NULL;
      }

   if (dontCloseIntuition != TRUE && IntuitionBase) // != NULL)
      {
#     ifdef __amigaos4__
      DropInterface( (struct Interface *) IIntuition );
#     endif
      CloseLibrary( (struct Library *) IntuitionBase );
      }
      
   if (GadToolsBase) // != NULL)
      {
#     ifdef __amigaos4__
      DropInterface( (struct Interface *) IGadTools );
#     endif
      CloseLibrary( GadToolsBase );
      } 
           
   if (myport) // != NULL)
      {
      DeletePort( myport );
      myport = NULL;
      }

   return;
}

PRIVATE int setupProgram( char *portName )
{
   if (IntuitionBase) // != NULL)
      {
      dontCloseIntuition = TRUE;

      goto skipOpening;
      } 

#  ifndef __amigaos4__
   if (!(IntuitionBase = (struct IntuitionBase *) 
                          OpenLibrary( "intuition.library", 39L ))) // == NULL)
      return( -1 );
#  else
   if ((IntuitionBase = OpenLibrary( "intuition.library", 50L ))) // != NULL)
      {
      if (!(IIntuition = (struct IntuitionIFace *) GetInterface( IntuitionBase, "main", 1, NULL )))
         {
	 CloseLibrary( IntuitionBase );
	 return( -1 );
	 }
      }
   else
      return( -1 );
#  endif


skipOpening:

#  ifndef __amigaos4__
   if (!(GadToolsBase = OpenLibrary( "gadtools.library", 39L ))) // == NULL)
      {
      shutdownProgram();

      return( -2 );
      }
#  else
   if ((GadToolsBase = OpenLibrary( "gadtools.library", 50L ))) // != NULL)
      {
      if (!(IGadTools = (struct GadToolsIFace *) GetInterface( GadToolsBase, "main", 1, NULL )))
         {
	 CloseLibrary( GadToolsBase );
	 
         shutdownProgram();

         return( -2 );
         }
      }
   else
      {
      shutdownProgram();

      return( -2 );
      }
#  endif

   if (!(myport = (struct MsgPort *) CreatePort( portName, 1 ))) // == NULL)
      {
      shutdownProgram();

      return( -2 );
      }

//   win = GetActiveWindow();
//   scr = win->WScreen;
   
   if (!(scr = GetActiveScreen())) // == NULL)
      {
      shutdownProgram();

      return( -3 );
      }       

//   scr = LockPubScreen( scr->Title );
   
   if (!(vi = GetVisualInfo( scr, TAG_DONE ))) // == NULL)
      {
      shutdownProgram();

      return( -4 );
      }

   if (!(win = OpenWindowTags( NULL,

               WA_Top,       36,
               WA_Left,      (scr->Width  - 600) / 2,
               WA_Width,     600,
               WA_Height,    200,

               WA_PubScreen,         scr,
               WA_PubScreenFallBack, TRUE,

               WA_Title,     "I am the tester of the MsgPort Class:",
               WA_IDCMP,     IDCMP_CLOSEWINDOW,
               WA_Flags,     WFLG_DRAGBAR | WFLG_RMBTRAP | WFLG_CLOSEGADGET,
               TAG_DONE ))) // == NULL)
      {
      shutdownProgram();

      return( -5 );
      }

  return( 0 );
}


PRIVATE void printIText( char *msg, int x, int y )
{
   struct IntuiText tp = { 0, };
   
   tp.DrawMode = JAM1;
   tp.FrontPen = 1;
   tp.BackPen  = 0; 
   tp.IText    = msg;
   
   PrintIText( win->RPort, &tp, x, y ); 
   
   return;
}

PRIVATE int handlemessage( struct MyMessage *mess )
{
  if (strncmp( mess->mm_TheMsg, "QUIT", 4 ) == 0)
     {
     ReplyMsg( (struct Message *) mess );

     printIText( "Wrapping this up now...", 20, 80 );
     
     Delay (150 );
     
     shutdownProgram(); 

     exit( RETURN_OK ); // Short-circuit everything here!
     }
  else
     {
     printIText( "The Message I received was:", 20, 20 );
     printIText( mess->mm_TheMsg, 20, 40 );
     Delay( 100 );
     }

  return( TRUE );
}


PRIVATE void SendMessage( struct MyMessage *mss, struct MsgPort *sendTo, char *msgString )
{
   char report[256];

   mss->mm_Message.mn_Node.ln_Type = NT_MESSAGE;
   mss->mm_Message.mn_Node.ln_Pri  = mss->mm_Message.mn_ReplyPort->mp_Node.ln_Pri;
   mss->mm_Message.mn_Length       = strlen( msgString );
      
   strcpy( mss->mm_TheMsg, msgString );
   
   sprintf( report, "Sending \"%s\" back to TestMsgPort script", msgString );

   printIText( report, 20, 60 );
              
   PutMsg( sendTo, (struct Message *) mss );

   signals = Wait( portsignal | winsignal );

   if ((signals & portsignal) == portsignal)
      (void) GetMsg( myport ); // Throw away any ReplyMsg() from other port.

   return;
}

PRIVATE int ReceiveMessage( void )
{
   int rval = TRUE;
   
   if ((mess = (struct MyMessage *) GetMsg( myport ))) // != NULL)
      {
      talkTo = mess->mm_Message.mn_ReplyPort;
      
      rval   = handlemessage( mess );

      ReplyMsg( (struct Message *) mess );
      }

   return( rval );
}

// -------------------------------------------------------------------

PUBLIC int main( int argc, char **argv )
{
  struct IntuiMessage *intmess = NULL;

  BOOL keepgoing = TRUE;

  if (argc == 2)
     strcpy( portName, argv[1] );
       
  if (setupProgram( portName ) < 0)
     {
     fprintf( stderr, "Could NOT setup %s!\n", argv[0] );

     return( RETURN_FAIL );
     }
  else
     {
     winsignal  = 1L << win->UserPort->mp_SigBit;
     portsignal = 1L << myport->mp_SigBit;

     while (keepgoing != FALSE)
        {
        signals = Wait( portsignal | winsignal );

        if ((signals & portsignal) == portsignal)
           {
           keepgoing = ReceiveMessage();
              
           if (strncmp( mess->mm_TheMsg, "QUIT", 4 ) != 0) 
              {
              sendThis.mm_Message.mn_ReplyPort = myport;

              SendMessage( &sendThis, talkTo, "Have at you!" );
              }
           }
        else if((signals & winsignal) == winsignal)
           {
           while (intmess = GT_GetIMsg( win->UserPort ))
              {
              if (intmess->Class == IDCMP_CLOSEWINDOW)
                 keepgoing = FALSE;

              GT_ReplyIMsg( intmess );
              }
           }
        }
     }
     
  shutdownProgram();

  return( RETURN_OK );
}
