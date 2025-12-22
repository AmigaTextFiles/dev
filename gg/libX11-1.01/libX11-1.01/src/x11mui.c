/* Copyright (c) 1997 by A BIG Corporation.  All Rights Reserved */

/***
   NAME
     x11mui
   PURPOSE
     
   NOTES
     
   HISTORY
     Terje Pedersen - Aug 3, 1997: Created.
***/

#ifdef XMUI
#include "amiga.h"
#include <stdio.h>
#include <assert.h>

#include <libraries/mui.h>
//#include <proto/muimaster.h>

#include "x11mui.h"

extern Object **X11DrawablesMUI;
extern int *X11DrawablesMap;

extern int GetNumMUI( void );
extern int GetNumDrawables( void );
extern int isopen( Object *win );

void
MUIUnmapWindow( Window w )
{
  Object *mwin;

  assert( w>=0 && w<GetNumDrawables() );
  assert( X11DrawablesMap[w]>=0 && X11DrawablesMap[w]<GetNumMUI() );
  mwin = X11DrawablesMUI[X11DrawablesMap[w]];
  assert( mwin );

  set(mwin,MUIA_Window_Open,FALSE);
}

void
MUISetAPenBG( Window w )
{
  Object *mwin;

  assert( w>=0 && w<GetNumDrawables() );
  assert( X11DrawablesMap[w]>=0 && X11DrawablesMap[w]<GetNumMUI() );
  mwin = X11DrawablesMUI[X11DrawablesMap[w]];

  SetAPen(_rp(mwin),_dri(mwin)->dri_Pens[BACKGROUNDPEN]);
}

void
MUIClearWindow( Window w )
{
  Object *mwin;

  assert( w>=0 && w<GetNumDrawables() );
  assert( X11DrawablesMap[w]>=0 && X11DrawablesMap[w]<GetNumMUI() );
  mwin = X11DrawablesMUI[X11DrawablesMap[w]];
  assert( mwin );

  if( !isopen(mwin) )
    return;

  SetAPen(_rp(mwin),_dri(mwin)->dri_Pens[BACKGROUNDPEN]);
  SetDrMd(_rp(mwin),JAM1);
  RectFill(_rp(mwin),_mleft(mwin),_mtop(mwin),_mright(mwin),_mbottom(mwin));
}

int
MUIMapRaised( Window w )
{
  Object *mwin;
  LONG open;

  assert( w>=0 && w<GetNumDrawables() );
  assert( X11DrawablesMap[w]>=0 && X11DrawablesMap[w]<GetNumMUI() );
  mwin = X11DrawablesMUI[X11DrawablesMap[w]];
  assert( mwin );

  set(mwin,MUIA_Window_Open,TRUE);
  get(mwin,MUIA_Window_Open,&open);
  if( !open )
    return(BadWindow);

    return 0;
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

void
X11SetMui( XID window, Object* obj )
{
  X11DrawablesMUI[X11DrawablesMap[window]] = obj;
}

void
MUIsetup_win( Window w,
	      struct RastPort** rp,
	      struct Window** vWindow,
	      int* vWinX,
	      int* vWinY,
	      int* vWinWidth,
	      int* vWinHeight )
{
  Object *mwin;

  assert( w>=0 && w<GetNumDrawables() );
  assert( X11DrawablesMap[w]>=0 && X11DrawablesMap[w]<GetNumMUI() );
  mwin = X11DrawablesMUI[X11DrawablesMap[w]];
  assert( mwin );

  get(mwin,MUIA_LeftEdge,vWinX);
  get(mwin,MUIA_TopEdge,vWinY);
  get(mwin,MUIA_Width,vWinWidth);
  get(mwin,MUIA_Height,vWinHeight);

  *rp = _rp(mwin);
  *vWindow = _window(X11DrawablesMUI[X11DrawablesMap[w]]);
}

void
MUIGetWin( Window w, struct Window **win, int* left, int* top, int* width, int* height )
{
  Object *mwin;

  assert( w>=0 && w<GetNumDrawables() );
  assert( X11DrawablesMap[w]>=0 && X11DrawablesMap[w]<GetNumMUI() );
  mwin = X11DrawablesMUI[X11DrawablesMap[w]];
  assert( mwin );

  *win = _window( mwin );
  *left = _mleft( mwin );
  *top = _mtop( mwin );
  *width = _mwidth( mwin );
  *height = _mheight( mwin );
}
#endif /* XMUI */
