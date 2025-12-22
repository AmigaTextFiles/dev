/* Copyright (c) 1997 by A BIG Corporation.  All Rights Reserved */

/***
   NAME
     x11mui
   PURPOSE
     
   NOTES
     
   HISTORY
     Terje Pedersen - Aug 3, 1997: Created.
***/

#ifndef X11MUI
#define X11MUI

typedef unsigned long XID;
typedef XID Window;
#define BadWindow	   3	/* parameter not a Window */

void MUIUnmapWindow( Window w );
void MUISetAPenBG( Window w );
void MUIClearWindow( Window w );
int MUIMapRaised( Window w );
void X11SetMui( XID window, Object* obj );
void MUIsetup_win( Window w,
		   struct RastPort** rp,
		   struct Window** vWindow,
		   int* vWinX,
		   int* vWinY,
		   int* vWinWidth,
		   int* vWinHeight );

void
MUIGetWin( Window w, struct Window **win, int* left, int* top, int* width, int* height );

#endif /* X11MUI */
