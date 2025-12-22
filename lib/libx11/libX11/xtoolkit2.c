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
     xtoolkit2
   PURPOSE
     attempt to use MUI as a base for X11 applications!
   NOTES
     
   HISTORY
     Terje Pedersen - Dec 14, 1994: Created.
***/

#include "libX11.h"

#include <intuition/intuition.h>
#include <intuition/intuitionbase.h>

#include <graphics/gfx.h>
#include <graphics/gfxbase.h>
#include <graphics/gfxmacros.h>
#include <graphics/displayinfo.h>
#include <devices/timer.h>

#include <proto/intuition.h>
#include <proto/graphics.h>
#include <proto/gadtools.h>
#include <proto/layers.h>

#include <dos.h>
#include <signal.h>
#include <stdlib.h>
#include <time.h>
#include <stdio.h>

#define XLIB_ILLEGAL_ACCESS 1

#include <X11/X.h>
#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <X11/Intrinsic.h>
#include <X11/Stringdefs.h>

/*
#include <X11/IntrinsicP.h>
#include <X11/Core.h>
#include <X11/CoreP.h>
*/

#include <libraries/mui.h>
#include <proto/muimaster.h>

struct ObjApp{
  APTR App;
  APTR Root;
  APTR Canvas;
} *X11App = NULL;

struct ObjApp *createMUI_app(char *title){
  struct ObjApp * Object;

  if (!(Object = AllocVec( sizeof( struct ObjApp ), MEMF_PUBLIC|MEMF_CLEAR ))) return( NULL );
  Object->App = ApplicationObject,
		MUIA_Application_Author, "TP",
		MUIA_Application_Base, "NONE",
		MUIA_Application_Title, title,
		MUIA_Application_Version, "$VER: NONE XX.XX (XX.XX.XX)",
		MUIA_Application_Copyright, "NOBODY",
		MUIA_Application_Description, "NONE",
		SubWindow, Object->Root = WindowObject,
		  WindowContents, Object->Canvas=GroupObject, End,
		End,  
  End;

  if (!(Object->App)){
    FreeVec(Object);
    Object = NULL;
  }
  return(Object);
}


Widget XtInitialize(shell_name, application_class, options,
		    num_options, argc, argv)
     String shell_name;    /* unused */
     String application_class;
     XrmOptionDescRec options[];
     Cardinal num_options;
     Cardinal *argc;
     char *argv[];

{/*            File 'xlogo.o'*/
#ifdef DEBUGXEMUL
  printf("XtInitialize\n");
#endif
  X11App=createMUI_app(shell_name);

  return(X11App->App);
}

void XtMainLoop(){/*              File 'xlogo.o'*/
  int running=TRUE;
  ULONG sigs;
#ifdef DEBUGXEMUL
  printf("XtMainLoop\n");
#endif
/*  XtAppMainLoop(amiga_Context);*/
  while (running){
    switch (DoMethod(X11App->App,MUIM_Application_Input,&sigs)){
    case MUIV_Application_ReturnID_Quit: running=FALSE;
      break;
    }
    if (running && sigs) Wait(sigs);
  }
  return(0);
}

/*
extern struct IClass *MyClass;
#define MyObject NewObject(MyClass,NULL
*/

const ULONG sourcecolors[6] ={
  0xb4b4b4b4,0xb4b4b4b4,0xb4b4b4b4,
  0x00000000,0x00000000,0x00000000,
};

Widget XtCreateManagedWidget(name, widget_class, parent,
			     args, num_args)
     String name;
     WidgetClass widget_class;
     Widget parent;
     ArgList args;
     Cardinal num_args;
{
  Object *newobj=NULL,*bmobj=NULL;
  if(args[0].name==XtNbitmap){
    struct BitMap *bm=(struct BitMap*)args[0].value;
    bmobj=BitmapObject,
      ButtonFrame,
      MUIA_InputMode, MUIV_InputMode_RelVerify,
      MUIA_Bitmap_Bitmap,bm,
      MUIA_Bitmap_Height,bm->Rows,
      MUIA_Bitmap_Width,bm->BytesPerRow*8,
      MUIA_FixWidth,bm->BytesPerRow*8,
      MUIA_FixHeight,bm->Rows,
      MUIA_Bitmap_Transparent,0,
      MUIA_Bitmap_SourceColors,sourcecolors,
      MUIA_Background,MUII_ButtonBack,
    End;
  }

  switch((int)widget_class){
/*
  case xmDrawingAreaWidgetClass:
    newobj=MyObject,
        MUIA_FixWidth,100,
	MUIA_FixHeight,100,
      End;
    break;*/
  case commandWidgetClass:
    if(bmobj) newobj=bmobj;
    break;
  }
  if(newobj)
    DoMethod(parent,OM_ADDMEMBER,newobj);
}

void XtDestroyWidget(w)
     Widget w;
{
}


void XtRealizeWidget(w)
     Widget w;
{
  set(w,MUIA_Window_Open,TRUE);
}
