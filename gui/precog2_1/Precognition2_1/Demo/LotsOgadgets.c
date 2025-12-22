/* =====================================================
**   Created by the Precognition Interface Builder
** =====================================================
**
**  Link this file with 'Precognition.lib'
**
*/

#include "Precognition.h"
#include "Intuition_Utils.h"

#include <proto/exec.h>
#include <proto/intuition.h>
#include <proto/graphics.h>
#include <stdlib.h>
#include <stdio.h>


/*
** The event loop is terminated when 'Done' is true.
*/

BOOL Done = FALSE;

char *cyclegadget3_options[] = 
   {
      "this",
      "that",
      "the other",
      NULL
   };


struct LotsOgadgets
{
   pcgWindow		w;
   TitleBox			titlebox12;
   OutlineBox		outlinebox13;
   BoolGadget		boolgadget1;
   CheckBox			checkbox2;
   CycleGadget		cyclegadget3;
   StringGadget		stringgadget4;
   IntegerGadget	integergadget5;
   HSlider			hslider6;
   HScroller		hscroller7;
   VSlider			vslider8;
   VScroller		vscroller9;
   ScrollingList	scrollinglist10;
   ListEditor		listeditor11;
};


/*=============== Prototypes ====================*/

#ifdef ANSI_HEADERS

   void  LotsOgadgets_Init( 
              struct LotsOgadgets *window,
              struct Screen *screen );

   void  LotsOgadgets_CleanUp( struct LotsOgadgets *window );

   ULONG LotsOgadgets_Respond( 
              struct LotsOgadgets *window,
              struct IntuiMessage *event );

   void  LotsOgadgets_EventLoop( struct Screen *screen );

   void  GracefulExit( int ExitStatus );

#else

   void  LotsOgadgets_Init(); 
   void  LotsOgadgets_CleanUp();
   ULONG LotsOgadgets_Respond();
   void  LotsOgadgets_EventLoop();
   void  GracefulExit();

#endif



void LotsOgadgets_Init( window, screen )
   struct LotsOgadgets *window;
   struct Screen *screen;
{

   pcg_3DPens    pens;

   pens = StandardScreenPens( screen );

   /* Initialize the window */
   pcgWindow_Init( &window->w,
      0, 12, 640, 200, /* LeftEdge, TopEdge, Width, Height */
      100, 50, 65535, 65535, /* min width & height, max width & height */
      "application", /* title */
      REFRESHWINDOW | CLOSEWINDOW, /* IDCMPFlags */
      WINDOWSIZING | WINDOWDRAG | WINDOWDEPTH | WINDOWCLOSE | SIZEBBOTTOM | SIMPLE_REFRESH | ACTIVATE, /* Flags */
      screen );

   TitleBox_Init( &window->titlebox12,
      360, 20, 160, 20, /* LeftEdge, TopEdge, Width, Height */
      pens, "TitleBox" );
   AddWindowPObject( &window->w, (struct GraphicObject *)&window->titlebox12 );

   OutlineBox_Init( &window->outlinebox13,
      193, 128, 109, 28, /* LeftEdge, TopEdge, Width, Height */
      pens, " OutlineBox " );
   AddWindowPObject( &window->w, (struct GraphicObject *)&window->outlinebox13 );

   BoolGadget_Init( &window->boolgadget1,
      16, 16, 96, 14, /* LeftEdge, TopEdge, Width, Height */
      pens, "BOOL gadget" );
   AddWindowPObject( &window->w, (struct GraphicObject *)&window->boolgadget1 );

   CheckBox_Init( &window->checkbox2,
      20, 36, /* LeftEdge, TopEdge, */
      pens, "CheckMe",
      TRUE ); /* Initially checked? */
   AddWindowPObject( &window->w, (struct GraphicObject *)&window->checkbox2 );

   CycleGadget_Init( &window->cyclegadget3,
      68, 60, 96, /* LeftEdge, TopEdge, Width */
      pens, "cycle:", cyclegadget3_options );
   AddWindowPObject( &window->w, (struct GraphicObject *)&window->cyclegadget3 );

   StringGadget_Init( &window->stringgadget4,
      68, 88, 112, /* LeftEdge, TopEdge, Width */
      256, /* # of characters */
      pens, "string:" );
   SetStringValue( (Valuator *)&window->stringgadget4, "Hi Mom!" );
   AddWindowPObject( &window->w, (struct GraphicObject *)&window->stringgadget4 );

   IntegerGadget_Init( &window->integergadget5,
      72, 112, 48, /* LeftEdge, TopEdge, Width */
      10, /* # of characters */
      pens, "integer:" );
   SetValue( (Valuator *)&window->integergadget5, 42 );
   AddWindowPObject( &window->w, (struct GraphicObject *)&window->integergadget5 );

   HSlider_Init( &window->hslider6,
      80, 136, 100, 16, /* LeftEdge, TopEdge, Width, Height */
      pens, "Hslider:" );
   SetKnobSize( (Positioner *)&window->hslider6, 16384 ); /* Knob size */
   SetValue( (Valuator *)&window->hslider6, 32768 ); /* Knob position */
   AddWindowPObject( &window->w, (struct GraphicObject *)&window->hslider6 );

   HScroller_Init( &window->hscroller7,
      96, 168, 100, /* LeftEdge, TopEdge, Width */
      pens, "Hscroller:" );
   SetKnobSize( (Positioner *)&window->hscroller7, 16384 ); /* Knob size */
   SetValue( (Valuator *)&window->hscroller7, 32768 ); /* Knob position */
   AddWindowPObject( &window->w, (struct GraphicObject *)&window->hscroller7 );

   VSlider_Init( &window->vslider8,
      600, 24, 16, 100, /* LeftEdge, TopEdge, Width, Height */
      pens, "Vslider" );
   SetKnobSize( (Positioner *)&window->vslider8, 16384 ); /* Knob size */
   SetValue( (Valuator *)&window->vslider8, 32768 ); /* Knob position */
   AddWindowPObject( &window->w, (struct GraphicObject *)&window->vslider8 );

   VScroller_Init( &window->vscroller9,
      560, 68, 100, /* LeftEdge, TopEdge, Height */
      pens, "Vscroller" );
   SetKnobSize( (Positioner *)&window->vscroller9, 16384 ); /* Knob size */
   SetValue( (Valuator *)&window->vscroller9, 32768 ); /* Knob position */
   AddWindowPObject( &window->w, (struct GraphicObject *)&window->vscroller9 );

   ScrollingList_Init( &window->scrollinglist10,
      192, 16, 150, 96, /* LeftEdge, TopEdge, Width, Height */
      pens, FALSE );    /* Allow Selection of >1 item? */
   AddString( (StringLister *)&window->scrollinglist10, "January", 0 );
   AddString( (StringLister *)&window->scrollinglist10, "February", 0 );
   AddString( (StringLister *)&window->scrollinglist10, "March", 0 );
   AddString( (StringLister *)&window->scrollinglist10, "April", 0 );
   AddString( (StringLister *)&window->scrollinglist10, "May", 0 );
   AddString( (StringLister *)&window->scrollinglist10, "June", 0 );
   AddString( (StringLister *)&window->scrollinglist10, "July", 0 );
   AddString( (StringLister *)&window->scrollinglist10, "August", 0 );
   AddString( (StringLister *)&window->scrollinglist10, "September", 0 );
   AddString( (StringLister *)&window->scrollinglist10, "October", 0 );
   AddString( (StringLister *)&window->scrollinglist10, "November", 0 );
   AddString( (StringLister *)&window->scrollinglist10, "December", 0 );
   AddWindowPObject( &window->w, (struct GraphicObject *)&window->scrollinglist10 );

   ListEditor_Init( &window->listeditor11,
      380, 68, 150, 96, /* LeftEdge, TopEdge, Width, Height */
      pens, "EditList");
      /*
      ** Add string entries to listeditor11
      */
   AddString( (StringLister*) &window->listeditor11, "Sunday", 0 );
   AddString( (StringLister*) &window->listeditor11, "Monday", 0 );
   AddString( (StringLister*) &window->listeditor11, "Tuesday", 0 );
   AddString( (StringLister*) &window->listeditor11, "Wednesday", 0 );
   AddString( (StringLister*) &window->listeditor11, "Thursday", 0 );
   AddString( (StringLister*) &window->listeditor11, "Friday", 0 );
   AddString( (StringLister*) &window->listeditor11, "Saturday", 0 );
   AddWindowPObject( &window->w, (struct GraphicObject *)&window->listeditor11 );

}


void LotsOgadgets_CleanUp( window )
   struct LotsOgadgets *window;
{
   CleanUp( (struct PObject *)&window->w );
   CleanUp( (struct PObject *)&window->titlebox12 );
   CleanUp( (struct PObject *)&window->outlinebox13 );
   CleanUp( (struct PObject *)&window->boolgadget1 );
   CleanUp( (struct PObject *)&window->checkbox2 );
   CleanUp( (struct PObject *)&window->cyclegadget3 );
   CleanUp( (struct PObject *)&window->stringgadget4 );
   CleanUp( (struct PObject *)&window->integergadget5 );
   CleanUp( (struct PObject *)&window->hslider6 );
   CleanUp( (struct PObject *)&window->hscroller7 );
   CleanUp( (struct PObject *)&window->vslider8 );
   CleanUp( (struct PObject *)&window->vscroller9 );
   CleanUp( (struct PObject *)&window->scrollinglist10 );
   CleanUp( (struct PObject *)&window->listeditor11 );
}


ULONG LotsOgadgets_Respond( window, event )
     struct LotsOgadgets *window;
     struct IntuiMessage *event;
{

   ULONG response, r;
   struct Window *intuition_window;

   response = 0L;

   /* check to see if 'event' happenned in this window */
   intuition_window = iWindow( &window->w );
   if( event->IDCMPWindow == intuition_window )
   {
      switch( event->Class )
      {

         case CLOSEWINDOW:
            pcgCloseWindow( &window->w );
         
            Done =  TRUE; /* Trigger exit of the event loop */
            break;

         case REFRESHWINDOW:
            BeginRefresh( intuition_window );
            Refresh( (struct Interactor *)&window->w );
            EndRefresh( intuition_window, TRUE );
            break;

         default:
            r = Respond( (struct Interactor *)&window->boolgadget1, event );
            if( r & CHANGED_STATE )
            {  /* boolgadget1 was hit. */
               response |= r;
               ; /* YOUR CODE HERE */
            }

            r = Respond( (struct Interactor *)&window->checkbox2, event );
            if( r & CHANGED_STATE )
            { /* checkbox2 was hit. */
               response |= r;

               if( Value( (Valuator *)&window->checkbox2 ) ) /* checkbox2 is checked. */
               { 
                  ; /* YOUR CODE HERE */
               }
               else /* checkbox2 is NOT checked. */
               { 
                  ; /* YOUR CODE HERE */
               }
            }

            r = Respond( (struct Interactor *)&window->cyclegadget3, event );
            if( r & CHANGED_STATE )
            {  /* cyclegadget3 was cycled.  The current selection 
               ** can be determined by doing:
               **
               **       long v;
               **       v = Value( (Valuator *)&window->cyclegadget3 );
               */
               ; /* YOUR CODE HERE */
               response |= r;
            }

            r = Respond( (struct Interactor *)&window->stringgadget4, event );
            if( r & ( CHANGED_STATE | DEACTIVATED ) )
            {  /* User entered something into stringgadget4 
               ** To get the string value of the gadget, use:
               **       char *value;
               **       value = StringValue( (Valuator *)&window->stringgadget4 );
               **
               ** To set the value, use:
               **       SetStringValue( (Valuator *)&window->stringgadget4, value );
               */
               ; /* YOUR CODE HERE */
               /* Activate next string or integer gadget. */
               response |= r;
               ActivateNext( (struct Interactor *)&window->stringgadget4 );
            }

            r = Respond( (Interactor *)&window->integergadget5, event );
            if( r & ( CHANGED_STATE | DEACTIVATED ) )
            {  /* User entered something into integergadget5 
               ** To get the value of the gadget, use:
               **       LONG value;
               **       value = Value( (Valuator *)&window->integergadget5 );
               **
               ** To set the value, use:
               **       SetValue( (Valuator *)&window->integergadget5, value );
               */
               ; /* YOUR CODE HERE */
               /* Activate next string or integer gadget. */
               response |= r;
               ActivateNext( (struct Interactor *)&window->integergadget5 );
            }

            r = Respond( (Interactor *)&window->hslider6, event );
            if( r & CHANGED_STATE )
            {  /*
               ** HSlider hslider6 has been changed.
               ** 
               ** To read the current value of hslider6, do:
               ** 
               **    USHORT position, knob;
               **    position = (USHORT) Value( (Valuator *)&window->hslider6 );
               **    knob     = KnobSize( (Positioner *)&window->hslider6 );
               */
               ; /* YOUR CODE HERE */
               response |= r;
            }

            r = Respond( (Interactor *)&window->hscroller7, event );
            if( r & CHANGED_STATE )
            {  /*
               ** HScroller hscroller7 has been changed.
               ** 
               ** To read the current value of hscroller7, do:
               ** 
               **    USHORT position, knob;
               **    position = (USHORT) Value( (Valuator *)&window->hscroller7 );
               **    knob     = KnobSize( (Positioner *)&window->hscroller7 );
               */
               ; /* YOUR CODE HERE */
               response |= r;
            }

            r = Respond( (Interactor *)&window->vslider8, event );
            if( r & CHANGED_STATE )
            {  /*
               ** VSlider vslider8 has been changed.
               ** 
               ** To read the current value of vslider8, do:
               ** 
               **    USHORT position, knob;
               **    position = (USHORT) Value( (Valuator *)&window->vslider8 );
               **    knob     = KnobSize( (Positioner *)&window->vslider8 );
               */
               ; /* YOUR CODE HERE */
               response |= r;
            }

            r = Respond( (Interactor *)&window->vscroller9, event );
            if( r & CHANGED_STATE )
            {  /*
               ** VScroller vscroller9 has been changed.
               ** 
               ** To read the current value of vscroller9, do:
               ** 
               **    USHORT position, knob;
               **    position = (USHORT) Value( (Valuator *)&window->vscroller9 );
               **    knob     = KnobSize( (Positioner *)&window->vscroller9 );
               */
               ; /* YOUR CODE HERE */
               response |= r;
            }

            r = Respond( (struct Interactor *)&window->scrollinglist10, event );
            if( r & CHANGED_STATE )
            { /* An item was selected. */
               int i;
               char* selected_item;
               StringList  *stringlist;

               stringlist = StringList_of( (StringLister *)&window->scrollinglist10);
               for( i = 0; i < stringlist->nEntries; i++ )
               { /* Find selected item(s) */ 
                  if( stringlist->Qualifiers[i] & ENTRY_SELECTED ) 
                  {
                     selected_item = stringlist->Entries[i];
                     /* 'selected_item' is selected. */
                     ; /* YOUR CODE HERE */
                  } 
               }
              response |= r;
            }

            r = Respond( (struct Interactor *)&window->listeditor11, event );
            if( r & CHANGED_STATE )
            { /* An item was selected/added/deleted. */
               int i;
               char* selected_item;
               StringList  *stringlist;

               stringlist = StringList_of( (StringLister *)&window->listeditor11 );
               for( i = 0; i < stringlist->nEntries; i++ )
               { /* Find selected item(s) */ 
                  if( stringlist->Qualifiers[i] & ENTRY_SELECTED ) 
                  {
                     selected_item = stringlist->Entries[i];
                     /* 'selected_item' is selected. */
                     ; /* YOUR CODE HERE */
                  } 
               }
              response |= r;
            }

            break;

      } /* end switch */

   } /* end if */

   return response;
}


void LotsOgadgets_EventLoop ( screen )
   struct Screen *screen;
{
   struct LotsOgadgets LotsOgadgets;
   struct Window *iw;              /* Intuition window */
   struct IntuiMessage *imsg, event;
   struct MsgPort *userport;
   
   
   LotsOgadgets_Init( &LotsOgadgets, screen );
   
   if( ( iw = pcgOpenWindow( &LotsOgadgets.w ) ) != NULL )
   {
      userport = iw->UserPort;
      
      /*====== Event Loop ================*/
      while( ! Done )
      {
         imsg = WaitForMessage( userport );
         event = *imsg;
         ReplyMsg( (struct Message *) imsg );
         
         LotsOgadgets_Respond( &LotsOgadgets, &event );
         
      }

      pcgCloseWindow( &LotsOgadgets.w );
   }
   else /* Error : window couldn't be opened. */
   {
      ; /*** YOUR ERROR HANDLING HERE ***/
   }


   LotsOgadgets_CleanUp( &LotsOgadgets );
}


#include <stdio.h>
#include <intuition/screens.h>

/* declare lib structures */
struct IntuitionBase *IntuitionBase = NULL;
struct GfxBase       *GfxBase       = NULL;

#define HAS_CONSOLE ( argc > 0 )
/*
** If 'argc' is greater than 0, than the program was started from
** the command line, and therefore has a console that one can
** 'fprintf' to.
**
** If 'argc' == 0, this was started from Workbench.  It's not
** safe to assume there's a console attached to programs started
** from Workbench.
*/

struct Screen *screen;

void main ( argc, argv )
   int argc;
   char **argv;
{
  

   /* open intuition library */
   IntuitionBase = (struct IntuitionBase *)
      OpenLibrary( "intuition.library", 0 );
   if( IntuitionBase == NULL )
   {
      if( HAS_CONSOLE ) 
         fprintf( stderr, "Error: couldn't open intuition.library\n" );
      GracefulExit( 10 );
   }

   GfxBase = (struct GfxBase *)
      OpenLibrary( "graphics.library", 0 );
   if( GfxBase == NULL )
   {
      if( HAS_CONSOLE )
         fprintf( stderr, "Error: couldn't open graphics.library\n" );
      GracefulExit( 20 );
   }

   /* Open a screen, if desired. */


   /* Now do the window event loop. */
   LotsOgadgets_EventLoop( screen );

   GracefulExit( 0 );

}


void GracefulExit( int status )
{
   
   if( GfxBase )         
   {
      CloseLibrary( (struct Library*) GfxBase );
      GfxBase = NULL;
   }

   if( IntuitionBase )   
   {
      CloseLibrary( (struct Library*) IntuitionBase );
      IntuitionBase = NULL;
   }

   exit( status );
}

