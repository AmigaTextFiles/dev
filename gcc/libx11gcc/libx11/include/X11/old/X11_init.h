/* Copyright (c) 1995 by A BIG Corporation.  All Rights Reserved */

/***
   NAME
     X11_init
   PURPOSE
     
   NOTES
     
   HISTORY
     Terje Pedersen - Mar 18, 1995: Created.
***/

#ifndef X11_INIT
#define X11_INIT

struct Library *X11Base;
struct Library *XtBase;

void X11_open(void);
void X11_close(void);

void X11_open(){
  X11Base = OpenLibrary("X11.library",0);
  if(!X11Base){
    printf("can't open X11.library!\n");
    exit(0);
  }
  XtBase = OpenLibrary("Xt.library",0);
  if(!XtBase){
    printf("can't open Xt.library!\n");
    exit(0);
  }
}

void X11_close(){
  CloseLibrary(XtBase);
  CloseLibrary(X11Base);
}

#endif /* X11_INIT */
