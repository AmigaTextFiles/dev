/* Copyright (c) 1996 by Terje Pedersen.  All Rights Reserved   */
/*                                                              */
/* By using this code you will agree to these terms:            */
/*                                                              */
/* 1. You may not use this code for profit in any way or form   */
/*    unless an agreement with the author has been reached.     */
/*                                                              */
/* 2. The author is not responsible for any damages caused by   */
/*    the use of this code.                                     */
/*                                                              */
/* 3. All modifications are to be released to the public.       */
/*                                                              */
/* Thats it! Have fun!                                          */
/* TP                                                           */
/*                                                              */

/***
   NAME
     text
   PURPOSE
     text drawing functions
   NOTES
     
   HISTORY
     Terje Pedersen - Mar 21, 1995: Created.

7. Nov 96: Added comment headers to all functions and cleaned the code up
           somewhat. If you have the manual pages you may notice an eerie
	   similarity..
***/

#include "amiga.h"
#include "libX11.h"

/*#define XLIB_ILLEGAL_ACCESS 1*/

#include <X11/Xutil.h>
#include <X11/Intrinsic.h>
#include <X11/IntrinsicP.h>
#include <X11/CoreP.h>

#include <X11/Xlibint.h>

#include "x11display.h"
#include "x11text.h"

/********************************************************************************/
/* external */
/********************************************************************************/

extern int X11muiapp;
extern int X11FunctionMapping[];

/********************************************************************************/
/* internal */
/********************************************************************************/

#ifdef DEBUGXEMUL_ENTRY
int bIgnoreText = 1; /* ignore outputting information about text */
int bSkipText = 0;
#endif

/********************************************************************************
Function : XDrawString()
Author   : Terje Pedersen
Input    : 
     display   Specifies  a  connection  to  an  X  server;  returned  from
               XOpenDisplay().

     drawable  Specifies the drawable.

     gc        Specifies the graphics context.

     x
     y
               Specify the x and y coordinates  of  the  baseline  starting
               position  for  the  character, relative to the origin of the
               specified drawable.

     string    Specifies the character string.

     length    Specifies the number of characters in string.

Output   : 
Function : draw an 8-bit text string, foreground only.
********************************************************************************/

boolean
X11SimpleTextClip( char* string, char* Xtempstr, int length, int* x, int* y )
{
  int nWidth;
  int nNewWidth;

  nWidth = TextLength(DG.drp,Xtempstr,length);
  if( *x+nWidth>DG.vWinWidth ){ /* shave off some characters at the end of the string */
    int vNewLength = length;

    if( length==1 )
      return FALSE;
    nNewWidth = DG.vWinWidth-*x;
    vNewLength = (int)(length*nNewWidth/nWidth);
    while( TextLength(DG.drp,Xtempstr,vNewLength)>nNewWidth && vNewLength>0 ) {
      vNewLength--;
    }
    if( !vNewLength )
      return FALSE;
    
    length = vNewLength;
    Xtempstr[length] = 0;
  }
  if( *y-DG.drp->Font->tf_Baseline<0 ){ 
    return FALSE; /* The simple solution.. */
  }
  if( *y>DG.vWinHeight ){ 
    return FALSE; /* The simple solution.. */
  }
  if( *x<0 ){ /* shave off some characters in the front of the string */
    int vNewLength;
    int vAdd;
    
    vNewLength = (int)(length*-*x/nWidth);
    if( !vNewLength ){
      vNewLength = 1;
    }
    while( (vAdd = TextLength(DG.drp,Xtempstr,vNewLength))<-*x && vNewLength>0 ) {
      vNewLength++;
    }
    if( vNewLength>length )
      return FALSE;
    length -= vNewLength;
    *x += vAdd;
    strncpy(Xtempstr,&string[vNewLength],length);
    Xtempstr[length] = 0;
  }

  return TRUE;
}

XDrawString( Display* d,
	     Drawable win,
	     GC gc,
	     int x,
	     int y,
	     char* string,
	     int length )
{ 
  char Xtempstr[256];
  struct IntuiText itext;

  strncpy(Xtempstr,string,length);
  Xtempstr[length] = 0;

#ifdef DEBUGXEMUL_ENTRY
  if( !bIgnoreText )

  if( bSkipText )
    return;
#endif
  if( win!=DG.vPrevWindow )
    if( !(DG.drp=setup_win(win)) )
      return;
#if 1
  if( gc!=vPrevGC )
    setup_gc(gc);
#endif

  if( X11Drawables[win]==X11WINDOW ){
    x -= X11Windows[X11DrawablesMap[win]].RelX;
    y -= X11Windows[X11DrawablesMap[win]].RelY;
#if 0
/* def OPTDBG */
    printf("(drawing)XDrawString [%s] to %d (%d %d) -> (%d %d) rel %d %d\n",Xtempstr,win,x,y,DG.vWinX+x,DG.vWinY+y,X11Windows[X11DrawablesMap[win]].RelX,X11Windows[X11DrawablesMap[win]].RelY); 
#endif
  }

  if( x>DG.vWinWidth || length<1 || !string )
    return;

  if( gc->values.font /*&&!X11muiapp*/ ){
    ULONG new;

    struct TextFont *tf = (struct TextFont*)((sFont*)gc->values.font)->tfont;
    struct TextAttr *tattr = (struct TextAttr*)((sFont*)gc->values.font)->tattr;

    SetFont(DG.drp,tf);
    new = SetSoftStyle(DG.drp,tattr->ta_Style ^ tf->tf_Style,(FSF_BOLD|FSF_UNDERLINED|FSF_ITALIC));

/*    if(tf->tf_Flags==42||tf==(struct TextFont*)DG.X11GC->values.font)StripFont(tf);*/
  }

#ifndef DOCLIPPING
  /* if I am not using intuition clipping I have to clip the text myself */
  if( !X11SimpleTextClip(string,Xtempstr,length,&x,&y) )
    return;
#endif

  itext.IText = (char *)Xtempstr;
  itext.LeftEdge = 0;
  itext.TopEdge = 0;
#if 0
  if( gc->values.function==GXinvert || gc->values.function==GXxor ){
    itext.DrawMode = COMPLEMENT;
  } else /* if( gc->values.background==X11DrawablesBackground[win] ){*/
    itext.DrawMode = JAM1;
#else
  itext.DrawMode = X11FunctionMapping[gc->values.function];
#endif
  itext.ITextFont = NULL;
  itext.NextText = NULL;
  itext.FrontPen = gc->values.foreground;
  itext.BackPen = gc->values.background;

#if 0
  if( gc->values.foreground == X11DrawablesBackground[win] )
    printf("Invisible?\n");

  itext.DrawMode = JAM2;
#endif

  PrintIText(DG.drp,&itext,DG.vWinX+x,DG.vWinY+y-DG.drp->Font->tf_Baseline);
}

/********************************************************************************
Function : XDrawImageString()
Author   : Terje Pedersen
Input    : 
     display   Specifies  a  connection  to  an  X  server;  returned  from
               XOpenDisplay().

     drawable  Specifies the drawable.

     gc        Specifies the graphics context.

     x
     y
               Specify the x and y coordinates  of  the  baseline  starting
               position  for  the  image  text  character,  relative to the
               origin of the specified drawable.

     string    Specifies the character string.

     length    Specifies the number of characters in the string argument.

Output   : 
Function : draw 8-bit image text characters.
********************************************************************************/

XDrawImageString( Display* display,
		  Window win,
		  struct _XGC* gc,
		  int x,
		  int y,
		  char* string,
		  int length )
{
  char Xtempstr[256];
  struct IntuiText itext;
  int origx,origy;

#ifdef DEBUGXEMUL_ENTRY
  if( !bIgnoreText )
    printf("(events)XDrawImageString %d,%d %s (%d)in window %d\n",x,y,string,length,(int)win);
  if( bSkipText )
    return;
#endif 
  if( win!=DG.vPrevWindow )
    if( !(DG.drp=setup_win(win)) )
      return;
  if( gc!=vPrevGC )
    setup_gc(gc);

  if( gc->values.font /*&&!X11muiapp*/ ){
    struct TextFont *tf = (struct TextFont*)((sFont*)gc->values.font)->tfont;
/*
    struct TextAttr *tattr = (struct TextAttr*)((sFont*)gc->values.font)->tattr;
*/
    SetFont(DG.drp,tf);
/*    if(tf->tf_Flags==42||tf==(struct TextFont*)DG.X11GC->values.font)StripFont(tf);*/
  }
  origx = DG.vWinX+x;
  origy = DG.vWinY+y-DG.drp->Font->tf_Baseline;

  if( length<1 || !string ) {
    /*printf("zero length string in xdrawimagestring\n");*/ 
    return;
  }

  strncpy(Xtempstr,string,length);
  Xtempstr[length] = 0;

#ifndef DOCLIPPING
  /* if I am not using intuition clipping I have to clip the text myself */
  if( !X11SimpleTextClip(string,Xtempstr,length,&x,&y) )
    return;
#endif

  itext.IText = Xtempstr;
  itext.LeftEdge = 0;
  itext.TopEdge = 0;
#if 1
  if( gc->values.function==GXinvert || gc->values.function==GXxor ){
    itext.DrawMode = COMPLEMENT;
  } else {
    itext.DrawMode = JAM2;
  }
#else
  itext.DrawMode = X11FunctionMapping[gc->values.function];
#endif
  itext.ITextFont = NULL;
  itext.NextText = NULL;
  itext.FrontPen = gc->values.foreground;
  itext.BackPen = gc->values.background;
  PrintIText(DG.drp,&itext,origx,origy);
}

/********************************************************************************
Function : XDrawText16()
Author   : Terje Pedersen
Input    : 
     display   Specifies  a  connection  to  an  X  server;  returned  from
               XOpenDisplay().

     drawable  Specifies the drawable.

     gc        Specifies the graphics context.

     x
     y
               Specify the x and y coordinates  of  the  baseline  starting
               position  for  the initial string, relative to the origin of
               the specified drawable.

     items     Specifies a pointer to an array of text items using two-byte
               characters.

     nitems    Specifies the number of text items in the array.

Output   : 
Function : draw 16-bit polytext strings.
********************************************************************************/

XDrawText16( Display* display,
	     Drawable drawable,
	     GC gc,
	     int x,
	     int y,
	     XTextItem16* items,
	     int nitems )
{
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XDrawText16\n");
#endif

  return(0);
}

/********************************************************************************
Function : XDrawString16()
Author   : Terje Pedersen
Input    : 
     display   Specifies  a  connection  to  an  X  server;  returned  from
               XOpenDisplay().

     drawable  Specifies the drawable.

     gc        Specifies the graphics context.

     x
     y
               Specify the x and y coordinates  of  the  baseline  starting
               position  for  the  character, relative to the origin of the
               specified drawable.

     string    Specifies the character string.  Characters  are  two  bytes
               wide.

     length    Specifies the number of characters in string.

Output   : 
Function : draw two-byte text strings.
********************************************************************************/

XDrawString16( Display* display,
	       Drawable drawable,
	       GC gc,
	       int x,
	       int y,
	       char* string,
	       int length )
{
#if (DEBUGXEMUL_ENTRY)
  if( !bIgnoreText )
    printf("XDrawString16\n");
#endif
  XDrawString(display,drawable,gc,x,y,string,length);

  return(0);
}

/********************************************************************************
Function : XDrawImageString16()
Author   : Terje Pedersen
Input    : 
     display   Specifies a connection to an X server; returned from
               XOpenDisplay().

     drawable  Specifies the drawable.

     gc        Specifies the graphics context.

     x
     y
               Specify the x and y coordinates of the baseline starting
               position for the image text character, relative to the
               origin of the specified drawable.

     string    Specifies the character string.

     length    Specifies the number of characters in the string argument.

Output   : 
Function : draw 16-bit image text characters.
********************************************************************************/

XDrawImageString16( Display* display,
		    Drawable win,
		    GC gc,
		    int x,
		    int y,
		    char* string,
		    int length )
{
#ifdef DEBUGXEMUL_ENTRY
  if( !bIgnoreText )
    printf("XDrawImageString16\n");
#endif
  XDrawImageString(display,win,gc,x,y,string,length);

  return(0);
}


/********************************************************************************
Function : XDrawText()
Author   : Terje Pedersen
Input    : 
     display   Specifies  a  connection  to  an  X  server;  returned  from
               XOpenDisplay().

     drawable  Specifies the drawable.

     gc        Specifies the graphics context.

     x
     y
               Specify the x and y coordinates  of  the  baseline  starting
               position  for  the initial string, relative to the origin of
               the specified drawable.

     items     Specifies a pointer to an array of text items.

     nitems    Specifies the number of text items in the items array.

Output   : 
Function : draw 8-bit polytext strings.
********************************************************************************/

XDrawText( Display* display,
	   Drawable drawable,
	   GC gc,
	   int x,
	   int y,
	   XTextItem* items,
	   int nitems )
{
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XDrawText\n");
#endif

  return(0);
}

XTextExtents16(font_struct, string, nchars, direction_return,
               font_ascent_return, font_descent_return, overall_return)
     XFontStruct *font_struct;
     XChar2b *string;
     int nchars;
     int *direction_return;
     int *font_ascent_return, *font_descent_return;
     XCharStruct *overall_return;
{/*          File 'auxtext.o' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XTextExtents16\n");
#endif
  return(0);
}
