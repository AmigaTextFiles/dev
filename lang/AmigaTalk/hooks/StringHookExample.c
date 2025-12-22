/* This source shows how to implement a screenhook. 
** It's based on the example in RKRM Libraries but fixed so
** it has the GadTools look.
*/

/* Note, be sure to turn off the stackcheck option in the compiler
** Stringhooks crashes when this option is used 
*/

#include <exec/types.h>
#include <intuition/intuition.h>
#include <intuition/sghooks.h>

#include <clib/intuition_protos.h>
#include <clib/gadtools_protos.h>
#include <clib/utility_protos.h>

#include <string.h>

#define REG(x)  register __ ## x
#define GAD_HEX 1

LONG __OSlibversion = 37L;

struct Screen   *Scr;
struct Window   *win;
struct Gadget   *glist, *strgad;
struct Hook     myhook;

APTR            vi;

UBYTE           *title = "StringHooks";

/* Convert the input to uppercase and check for hexadecimal chars */

BOOL IsHexDigit( UBYTE test_char )
{
   test_char = ToUpper( test_char );

   if (((test_char >= '0') && (test_char <= '9')) 
      || ((test_char >= 'A') && (test_char <= 'F')))
      return( TRUE );
   else
      return( FALSE );
}

/* This function is called whenever you press a key in the gadget.
   You can't run this function in the debugger.
   You're not allowed to call any dos function as printf() here.
   But you can do sprintf() and put a msg in the titlebar.
   This way you can check variables and what's wrong 
*/

ULONG __saveds str_hookRoutine( struct Hook   *hook, 
                                struct SGWork *sgw, 
                                ULONG         *msg
                              )
{
   ULONG return_code = ~0L;
   int   error       = 0;


   if (*msg == SGH_KEY)
      {
      if ((sgw->EditOp == EO_REPLACECHAR) 
          || (sgw->EditOp == EO_INSERTCHAR))
         {
         switch (sgw->Gadget->GadgetID)
            {
            case GAD_HEX:
               if (IsHexDigit( sgw->Code ) == FALSE)
                  error = TRUE;
               else
                  sgw->WorkBuffer[sgw->BufferPos - 1] = ToUpper( sgw->Code );
               
            default:
               break;
            }
   
         if (error != FALSE)
            {
            sgw->Actions |= SGA_BEEP;
            sgw->Actions &= ~SGA_USE;
            }
         }
      }
   else
      return_code = 0L; /* Unsupported command */

   return( return_code );
}


ULONG __saveds __asm hookEntry( REG(a0) struct Hook *hookptr,
                                REG(a2) void        *object,
                                REG(a1) void        *message
                              )
{
  return( ((ULONG (*)(struct Hook *,void *,void *))
          hookptr->h_SubEntry )( hookptr, object, message )
        );
}


/* Initialize the hook to use the hookEntry() routine above. */

void initHook( struct Hook *hook, ULONG (*ccode)() )
{
   hook->h_Entry    = (ULONG (*)()) hookEntry;
   hook->h_SubEntry = ccode;
   hook->h_Data     = 0;     /* this program does not use this */
   
   return;
}

// -------------------------------------------------------------

int OpenGui( void )
{
   struct NewGadget ng;
   struct Gadget    *gad;

   if (vi = GetVisualInfo( Scr, TAG_END ))
      {
      gad              = CreateContext( &glist );

      ng.ng_LeftEdge   = Scr->WBorLeft;
      ng.ng_TopEdge    = Scr->WBorTop + Scr->Font->ta_YSize + 1;
      ng.ng_Width      = 150;
      ng.ng_Height     = 15;
      ng.ng_GadgetText = NULL;
      ng.ng_TextAttr   = NULL;
      ng.ng_VisualInfo = vi;
      ng.ng_GadgetID   = GAD_HEX;
      ng.ng_Flags      = NULL;

      initHook( &myhook, str_hookRoutine );

      if (gad = CreateGadget( STRING_KIND, gad, &ng, 
                              GTST_EditHook, &myhook, 
                              TAG_END
                            ))
         {
         if ((win = OpenWindowTags( NULL,
             
                       WA_InnerWidth,  150,
                       WA_InnerHeight, 16,
                       WA_IDCMP,       STRINGIDCMP | IDCMP_CLOSEWINDOW 
                         | IDCMP_REFRESHWINDOW,
                       
                       WA_Flags,       WFLG_DRAGBAR | WFLG_CLOSEGADGET 
                         | WFLG_SMART_REFRESH | WFLG_ACTIVATE 
                         | WFLG_RMBTRAP,
                       
                       WA_Gadgets,     glist,
                       WA_Title,       title,
                       WA_PubScreen,   Scr,
             
                       TAG_DONE )) == NULL)
            return( -4L );

         UnlockPubScreen( NULL, Scr );
         GT_RefreshWindow( win, NULL );
         ActivateGadget( strgad, win, NULL );

         return( 0L );
         }
      }

   return( -5L );
}

void HandleIDCMP( void )
{
   struct IntuiMessage *msg;
   BOOL running = TRUE;
 
   while (running == TRUE)
      {
      WaitPort( win->UserPort );

      while ((msg = GT_GetIMsg( win->UserPort )) != NULL)
         {
         switch (msg->Class)
            {
            case  IDCMP_REFRESHWINDOW:
               GT_BeginRefresh( win );
               GT_EndRefresh( win, TRUE );
               break;

            case  IDCMP_CLOSEWINDOW:
               running = FALSE;
               break;
            }

         GT_ReplyIMsg( msg );
         }
      }

   return;
}

void Cleanup( void )
{
   if (win != NULL)
      CloseWindow( win );

   if (glist != NULL)
      FreeGadgets( glist );

   if (vi != NULL)
      FreeVisualInfo( vi );

   return;
}

void main( void )
{
   if ((Scr = LockPubScreen( NULL )) != NULL)
      {
      if (OpenGui() == 0)
         HandleIDCMP();
      }

   Cleanup();

   return;
}

