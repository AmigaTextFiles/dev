/* Copyright (c) 1996 by A BIG Corporation.  All Rights Reserved */

/***
   NAME
     cursors
   PURPOSE
     
   NOTES
     
   HISTORY
     Terje Pedersen - Nov 8, 1996: Created.
***/

#ifndef CURSORS
#define CURSORS

/********************************************************************************/
/* Prototypes */
/********************************************************************************/

void X11expand_cursors( void );
void X11init_cursors( void );
void X11exit_cursors( void );

/********************************************************************************/
/* Defines */
/********************************************************************************/

typedef struct {
  Pixmap pm;
  VOID *pointer;
} X11InternalCursor;

/********************************************************************************/

#endif /* CURSORS */
