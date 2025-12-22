/****h *AmigaTalk/WindowInfo.c ****************************************
**
** NAME
**    SysInfoWindow.c
**
** FUNCTIONAL INTERFACE:
**
**    PUBLIC void WriteText( char *string, int xpos, int ypos, int color );
**
**    PUBLIC BOOL CheckBit( int flags, int bit );
**
**    PUBLIC int HandleWindowInfo( void *structptr, int whichdisplay );
**
***********************************************************************
*/


PRIVATE struct Window *IWnd = NULL;

PRIVATE UWORD ILeft   = 0;
PRIVATE UWORD ITop    = 32;
PRIVATE UWORD IWidth  = 640;
PRIVATE UWORD IHeight = MAX_HEIGHT;

PRIVATE UBYTE *IWTitle = "System Screens & Windows Full Info:";


// -----------------------------------------------------------------

PUBLIC void WriteText( char *string, int xpos, int ypos, int color ) 
{
   struct RastPort  *rp = IWnd->RPort;
   struct IntuiText  outtxt;

   outtxt.FrontPen  = color;
   outtxt.BackPen   = 0;
   outtxt.DrawMode  = JAM1;
   outtxt.LeftEdge  = 0;
   outtxt.TopEdge   = 0;
   outtxt.ITextFont = Font;
   outtxt.NextText  = NULL;
   outtxt.IText     = (UBYTE *) string;

   PrintIText( rp, &outtxt, xpos, ypos );

   return;
}

PUBLIC BOOL CheckBit( int flags, int bit )
{
   if ((flags & bit) == bit)
      return( TRUE );
   else
      return( FALSE );
}


#define XPOS  6

PUBLIC UWORD StrYPos[32] = { 0, };

PRIVATE char bf[82], *itxt  = &bf[0];
PRIVATE char tx[82], *title = &tx[0];

PRIVATE void DisplayStructure( void *ptr, int struct_type )
{
   IMPORT void WriteTask( void *ptr );
   
   struct Screen *s = NULL;
   struct Window *w = NULL;
   struct Task   *t = NULL;
  
   int            bgad, sgad, pgad, m, mi;
  
   bgad = sgad = pgad = m = mi = 0;
   
   switch (struct_type)
      {
      case 0: // Screen data:
         s = (struct Screen *) ptr;

         sprintf( title, "SCREEN: (%08LX) %s", s, s->Title );
         SetWindowTitles( IWnd, title, (UBYTE *) -1 );

         sprintf( itxt, "DefaultTitle: %s", s->DefaultTitle );
         WriteText( itxt, XPOS, StrYPos[0], 2 ); 

         sprintf( itxt, "Left     : %3u Top       : %3u Width: %4u Height: %4u", 
                  s->LeftEdge, s->TopEdge, s->Width, s->Height 
                );
         WriteText( itxt, XPOS, StrYPos[1], 1 ); 

         sprintf( itxt, "WBorLeft : %3u WBorTop   : %3u", 
                  s->WBorLeft, s->WBorTop
                );
         WriteText( itxt, XPOS, StrYPos[2], 1 ); 

         sprintf( itxt, "WBorRight: %3u WBorBottom: %3u", 
                  s->WBorRight, s->WBorBottom
                );
         WriteText( itxt, XPOS, StrYPos[3], 1 ); 

         sprintf( itxt, "DetailPen: %3u BlockPen  : %3u", 
                  s->DetailPen, s->BlockPen
                );
         WriteText( itxt, XPOS, StrYPos[4], 1 ); 

         sprintf( itxt, "ViewPort  : %08LX RastPort   : %08LX", 
                  s->ViewPort, s->RastPort
                );
         WriteText( itxt, XPOS, StrYPos[5], 1 ); 

         sprintf( itxt, "BitMap    : %08LX LayerInfo  : %08LX", 
                  s->BitMap, s->LayerInfo
                );
         WriteText( itxt, XPOS, StrYPos[6], 1 ); 

         sprintf( itxt, "ExtData   : %08LX UserData   : %08LX", 
                  s->ExtData, s->UserData
                );
         WriteText( itxt, XPOS, StrYPos[7], 1 ); 

         sprintf( itxt, "NextScreen: %08LX FirstWindow: %08LX", 
                  s->NextScreen, s->FirstWindow
                );
         WriteText( itxt, XPOS, StrYPos[8], 2 ); 

         sprintf( itxt, "BarHeight  : %3u BarVBorder : %3u BarHBorder: %3u", 
                  s->BarHeight, s->BarVBorder, s->BarHBorder
                );
         WriteText( itxt, XPOS, StrYPos[9], 1 ); 

         sprintf( itxt, "MenuVBorder: %3u MenuHBorder: %3u", 
                  s->MenuVBorder, s->MenuHBorder
                );
         WriteText( itxt, XPOS, StrYPos[10], 1 ); 

         WriteText( "Flags:", XPOS, StrYPos[11], 3 );
         
         SetScreenFlagString( itxt, s );
         WriteText( itxt, XPOS, StrYPos[12], 1 );

         WriteText( "ViewModes:", XPOS, StrYPos[13], 3 );

         SetScreenViewMode1( itxt, s );
         WriteText( itxt, XPOS, StrYPos[14], 1 );

         SetScreenViewMode2( itxt, s );
         WriteText( itxt, XPOS, StrYPos[15], 1 );

         WriteText( "Press Close Gadget when you're done!", 
                    150, StrYPos[16], 2 
                  ); 
         break;

      case 1: // Window data:
         w = (struct Window *) ptr;

         sprintf( title, "WINDOW: (%08LX) %s", w, w->Title );
         SetWindowTitles( IWnd, title, (UBYTE *) -1 );

         sprintf( itxt, "WScreen: %08LX -> %s", 
                  w->WScreen, w->WScreen->Title 
                );
         WriteText( itxt, XPOS, StrYPos[0], 2 ); 

         sprintf( itxt, "Left    : %3u Top      : %3u Width    : %5u Height   : %5u",
                  w->LeftEdge, w->TopEdge, w->Width, w->Height 
                );
         WriteText( itxt, XPOS, StrYPos[1], 1 ); 

         sprintf( itxt, "MinWidth: %3u MinHeight: %3u MaxWidth : %5u MaxHeight: %5u",
                  w->MinWidth, w->MinHeight, w->MaxWidth, w->MaxHeight 
                );
         WriteText( itxt, XPOS, StrYPos[2], 1 ); 

         sprintf( itxt, "BdrLeft : %3u BdrTop   : %3u BdrRight : %5u BdrBottom: %5u",
                  w->BorderLeft, w->BorderTop, 
                  w->BorderRight, w->BorderBottom
                );
         WriteText( itxt, XPOS, StrYPos[3], 1 ); 

         sprintf( itxt, "XOffset : %3u YOffset  : %3u DetailPen: %5u BlockPen : %5u",
                  w->XOffset, w->YOffset, w->DetailPen, w->BlockPen
                );
         WriteText( itxt, XPOS, StrYPos[4], 1 ); 

         sprintf( itxt, "CheckMark: %08LX ExtData: %08LX UserData: %08LX",
                  w->CheckMark, w->ExtData, w->UserData
                );
         WriteText( itxt, XPOS, StrYPos[5], 2 ); 

         CountGadgets( w, &bgad, &sgad, &pgad );

         sprintf( itxt, "BoolGadgets: %2u StrGadgets: %4u PropGadgets: %2u",
                  bgad, sgad, pgad
                );
         WriteText( itxt, XPOS, StrYPos[6], 1 ); 

         CountMenus( w, &m, &mi );

         sprintf( itxt, "Menus      : %2u MenuItems : %4u", m, mi );
         WriteText( itxt, XPOS, StrYPos[7], 1 ); 

         t = (struct Task *) w->UserPort->mp_SigTask;

         sprintf( itxt, "UserPort  : %08LX -> mp_SigTask: %08LX, %-30.30s",
                  w->UserPort, w->UserPort->mp_SigTask,
                  (t == NULL ? " " : t->tc_Node.ln_Name)
                );
         WriteText( itxt, XPOS, StrYPos[8], 2 ); 

         t = (struct Task *) w->WindowPort->mp_SigTask;
         
         sprintf( itxt, "WindowPort: %08LX -> mp_SigTask: %08LX, %-30.30s",
                  w->WindowPort, w->WindowPort->mp_SigTask,
                  (t == NULL ? " " : t->tc_Node.ln_Name) 
                );
         WriteText( itxt, XPOS, StrYPos[9], 2 ); 

         sprintf( itxt, "PtrHeight: %3u PtrWidth: %2u Pointer: %08LX",
                  w->PtrHeight, w->PtrWidth, w->Pointer
                );
         WriteText( itxt, XPOS, StrYPos[10], 1 ); 

         sprintf( itxt, "ReqCount : %3u NextWindow: %08LX",
                  w->ReqCount, w->NextWindow
                );
         WriteText( itxt, XPOS, StrYPos[11], 1 ); 

         WriteText( "Flags:", XPOS, StrYPos[12], 3 );

         SetWindowFlags1( w, itxt );
         WriteText( itxt, XPOS, StrYPos[13], 1 ); 

         SetWindowFlags2( w, itxt );
         WriteText( itxt, XPOS, StrYPos[14], 1 ); 

         SetWindowFlags3( w, itxt );
         WriteText( itxt, XPOS, StrYPos[15], 1 ); 

         SetWindowFlags4( w, itxt );
         WriteText( itxt, XPOS, StrYPos[16], 1 ); 

         WriteText( "IDCMPFlags:", XPOS, StrYPos[17], 3 );

         SetIDCMPFlags1( w, itxt );
         WriteText( itxt, XPOS, StrYPos[18], 1 ); 

         SetIDCMPFlags2( w, itxt );
         WriteText( itxt, XPOS, StrYPos[19], 1 ); 

         SetIDCMPFlags3( w, itxt );
         WriteText( itxt, XPOS, StrYPos[20], 1 ); 

         SetIDCMPFlags4( w, itxt );
         WriteText( itxt, XPOS, StrYPos[21], 1 ); 

         SetIDCMPFlags5( w, itxt );
         WriteText( itxt, XPOS, StrYPos[22], 1 ); 

         SetIDCMPFlags6( w, itxt );
         WriteText( itxt, XPOS, StrYPos[23], 1 ); 

         SetIDCMPFlags7( w, itxt );
         WriteText( itxt, XPOS, StrYPos[24], 1 ); 

         WriteText( "Press Close Gadget when you're done!", 
                    150, StrYPos[25], 2 
                  ); 
         break;
      
      case 2: // Task structure:
         WriteTask( ptr );
         break;

      case 3: // Process structure:
         WriteTask( ptr );
         break;
      }

   return;
}

PRIVATE int OpenIWindow( int numlines )
{
   UWORD wleft = ILeft, wtop = ITop, ww, wh;
   int   i;
   
   ComputeFont( Scr, Font, &CFont, IWidth, IHeight );

   IHeight = (numlines + 1) * (CFont.FontY + 3) + 2;

   if (IHeight > MAX_HEIGHT)
      IHeight = MAX_HEIGHT;

   for (i = 0; i < 32; i++)
      StrYPos[i] = 16 + i * (CFont.FontY + 3);
         
   ww = ComputeX( CFont.FontX, IWidth  );
   wh = ComputeY( CFont.FontY, IHeight );

   if ((wleft + ww + CFont.OffX + Scr->WBorRight) > Scr->Width) 
      wleft = Scr->Width - ww;

   if ((wtop + wh + CFont.OffY + Scr->WBorBottom) > Scr->Height) 
      wtop = Scr->Height - wh;

   if ( !(IWnd = OpenWindowTags( NULL,

                   WA_Left,        wleft,
                   WA_Top,         wtop,
                   WA_Width,       ww + CFont.OffX + Scr->WBorRight,
                   WA_Height,      wh + CFont.OffY + Scr->WBorBottom,
                   WA_IDCMP,       BUTTONIDCMP | IDCMP_GADGETUP
                     | IDCMP_REFRESHWINDOW | IDCMP_CLOSEWINDOW,

                   WA_Flags,       WFLG_SMART_REFRESH | WFLG_CLOSEGADGET 
                     | WFLG_ACTIVATE | WFLG_RMBTRAP,

                   WA_Gadgets,     NULL,
                   WA_Title,       IWTitle,
                   WA_ScreenTitle, ScrTitle,
                   TAG_DONE ))
      )
      return( -4 );

   return( 0 );
}

PRIVATE int HandleInfoIDCMP( void )
{
   struct IntuiMessage	*m;
   BOOL			running = TRUE;

   while (running == TRUE)
      {
      if ((m = (struct IntuiMessag *) GetMsg( IWnd->UserPort )) == NULL)
         {
         (void) Wait( 1L << IWnd->UserPort->mp_SigBit );
         continue;
         }

      CopyMem( (char *) m, (char *) &IMsg, 
               (long) sizeof( struct IntuiMessage )
             );

      ReplyMsg( (struct Message *) m );

      switch (IMsg.Class) 
         {
   	 case IDCMP_CLOSEWINDOW:
   	    running = ICloseWindow();
            break;
         }
      }

   return( running );
}

PUBLIC int HandleWindowInfo( void *structptr, int whichdisplay )
{
   int rval = 0;
   
   switch (whichdisplay)
      {
      case 0: // Screen data:
         rval = OpenIWindow( 16 );
         break;

      case 1: // Window data:
         rval = OpenIWindow( 25 );
         break;

      case 2: // Task data:
         rval = OpenIWindow( 13 );
         break;

      case 3: // Process data:
         rval = OpenIWindow( 28 );
         break;
      }
   
   if (rval < 0)
      {
      (void) Handle_Problem( "Couldn't open Information Window!", 
                             "Allocation Problem:", NULL 
                           );
      return( -1 );
      }

   DisplayStructure( structptr, whichdisplay );
      
   (void) HandleInfoIDCMP();

   return( 0 );
}

/* --------------------- END of WindowInfo.c file! ----------------- */
