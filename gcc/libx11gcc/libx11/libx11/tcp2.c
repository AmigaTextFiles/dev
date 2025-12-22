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
     tcp
   PURPOSE
     
   NOTES
     
   HISTORY
     terjepe - May 30, 1996: Created.
***/
#include <stdio.h>
#define DEBUGXEMUL_WARNING 1

XFetchBytes(){/*             File 'cutpaste.o' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XFetchBytes\n");
#endif
  return(0);
}

XConnectionNumber(){/*       File 'exec.o' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XConnectionNumber\n");
#endif
  return(0);
}
