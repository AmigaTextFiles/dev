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
     xtmui
   PURPOSE
     
   NOTES
     
   HISTORY
     terjepe - Jul 16, 1996: Created.
***/

#ifndef __XTMUI
#define __XTMUI

typedef struct ObjApp {
  APTR App;
  APTR Root;
  APTR Canvas;
} ObjApp_t;

void X11mui_init(void);
void X11mui_cleanup(void);

#endif /* __XTMUI */
