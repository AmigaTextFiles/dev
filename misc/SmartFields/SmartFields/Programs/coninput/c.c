/************************************************
*  SMART FIELDS CONSOLE INPUT TEST PROGRAM v1.0
*  © Copyright 1988 Timm Martin
*  All Rights Reserved
*************************************************/

#include <exec/io.h>
#include <exec/memory.h>
#include <exec/ports.h>
#include <exec/types.h>
#include <graphics/gfxbase.h>
#include <intuition/intuition.h>
#include <intuition/intuitionbase.h>
#include <console/console.h>
#include <console/functions.h>
#include <toolkit/toolkit.h>
#include <functions.h>

/************************
*  INTUITION STRUCTURES
*************************/

struct IntuitionBase *IntuitionBase = NULL;
struct GfxBase       *GfxBase = NULL;
struct Window        *win = NULL;
struct RastPort      *rp;

struct ConsoleHeader console_header;

/**************
*  TEXT ARRAY
***************/

char *keys1[] = {
  "BACKSPACE", "DELETE", "ESCAPE", "HELP",
  "RETURN", "SHIFT_TAB", "TAB", "ALT_ESCAPE"
};
char *keys2[] = {
  "CURSOR_UP", "CURSOR_DOWN", "CURSOR_LEFT", "CURSOR_RIGHT"
};
char *keys3[] = {
  "SHIFT_UP", "SHIFT_DOWN", "SHIFT_LEFT", "SHIFT_RIGHT"
};

/************************
*  NEW WINDOW STRUCTURE
*************************/

struct NewWindow new_window = {
  0, 0, 640, 25, 0, 1, CLOSEWINDOW, ACTIVATE | NOCAREREFRESH |
  SIMPLE_REFRESH | WINDOWCLOSE | WINDOWDEPTH | WINDOWDRAG |
  WINDOWSIZING, NULL, NULL,
  (STRPTR)"SmartFields Console Input Test Program v1.0",
  NULL, NULL, 50, 25, 640, 200, WBENCHSCREEN
};

/********************
*  GLOBAL VARIABLES
*********************/

#define WAIT_FOR_INPUT Wait(1L<<console_header.ReadPort->mp_SigBit|1L<<win->UserPort->mp_SigBit)
#define CONSOLE_INPUT  message=(struct Message *)GetMsg(console_header.ReadPort)
#define WINDOW_INPUT   imessage=(struct IntuiMessage *)GetMsg(win->UserPort)
UBYTE   con_buffer[CONSOLE_BUFFER_SIZE];

/**************************
*  M A I N  P R O G R A M
***************************/

main()
{
  open_all();
  get_inputs();
}

/***************
*  END PROGRAM
****************/

end_program( return_code )
  int return_code;
{
  console_close( &console_header );

  if (win)           { ClearMenuStrip( win ); CloseWindow( win ); }
  if (GfxBase)         CloseLibrary( GfxBase );
  if (IntuitionBase)   CloseLibrary( IntuitionBase );

  exit( return_code );
}

/**************
*  GET INPUTS
***************/

get_inputs()
{
  struct  IntuiMessage *imessage;
  int     key;
  struct  Message *message;
  struct  Field *where;

  FOREVER {
    WAIT_FOR_INPUT;

    if (CONSOLE_INPUT) {
      key = console_input( &console_header );
        if ((key >= 0x20 && key <= 0x7e) || (key >= 0xa0 && key <= 0xff))
          printf( "%03d 0x%2x %c\n", key, key, key );
        else if (key > CON_CONTROL && key <= CON_CONTROL + 0xff)
          printf( "CTRL-%c\n", key - CON_CONTROL );
        else if (key >= CON_F1 && key <= CON_F10)
          printf( "F%1d\n", key - CON_F );
        else if (key >= CON_SHIFT_F1 && key <= CON_SHIFT_F10)
          printf( "SHIFT_F%1d\n", key - CON_SHIFT_F );
        else if (key >= CON_BACKSPACE && key <= CON_ALT_ESCAPE)
          printf( "%s\n", keys1[key-CON_BACKSPACE] );
        else if (key >= CON_CURSOR_UP && key <= CON_CURSOR_RIGHT)
          printf( "%s\n", keys2[key-CON_CURSOR_UP] );
        else if (key >= CON_SHIFT_UP && key <= CON_SHIFT_RIGHT)
          printf( "%s\n", keys3[key-CON_SHIFT_UP] );
        else if (!key)
          printf( "CTRL-(hyphen)\n" );
        else
          printf( "UNRECOGNIZABLE CHARACTER\n" );
    }   /* if keyboard input */

    while (WINDOW_INPUT) {
      switch (imessage->Class) {
        case CLOSEWINDOW:
          end_program( 0 );
          break;
      } /* switch */
      ReplyMsg( imessage );
    } /* while window messages */
  }   /* forever */
}

/************
*  OPEN ALL
*************/

open_all()
{
  int error;

  if (!(IntuitionBase = (struct IntuitionBase *)
        OpenLibrary( "intuition.library", LIBRARY_VERSION )))
    end_program( 0x0100 );
  if (!(GfxBase = (struct GfxBase *) OpenLibrary( "graphics.library", 0L )))
    end_program( 0x0101 );

  if (!(win = OpenWindow( &new_window )))
    end_program( 0x0102 );
  rp = win->RPort;

  if (error = console_open( win, &console_header, con_buffer ))
    end_program( error );
}
