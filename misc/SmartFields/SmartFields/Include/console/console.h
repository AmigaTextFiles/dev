/***************************************
*  console/console.h v1.30
*  © Copyright 1988 Timm Martin
*  All Rights Reserved
****************************************/

#ifndef CONSOLE_CONSOLE_H
#define CONSOLE_CONSOLE_H

#include <exec/io.h>
#include <exec/ports.h>
#include <exec/types.h>
#include <intuition/intuition.h>
#include <console/fields.h>

struct ConsoleHeader {
  struct Window *Window;
  struct MsgPort *WritePort;
  struct IOStdReq *WriteReq;
  struct MsgPort *ReadPort;
  struct IOStdReq *ReadReq;
  LONG   ConsoleError;
  UBYTE  *Buffer;
  struct FieldMask *Mask;
  SHORT  TypeMode;
  APTR   UserPtr;
  LONG   Reserved1;
  LONG   Reserved2;
};

#define INIT_CONSOLE_HEADER NULL,NULL,NULL,NULL,NULL,CONSOLE_ERROR,NULL,NULL,0,NULL,NULL,NULL

#define ALT_SPACE_CODE  0xa0
#define BACKSPACE_CODE  0x08
#define CONTROL_CODE    0x60
#define CSI             0x9b
#define DELETE_CODE     0x7f
#define ESCAPE_CODE     0x1b
#define FORMFEED_CODE   0x0c
#define LINEFEED_CODE   0x0a
#define RETURN_CODE     0x0d
#define TAB_CODE        0x09

#define CON_CONTROL      1000
#define CON_BACKSPACE    2001
#define CON_DELETE       2002
#define CON_ESCAPE       2003
#define CON_HELP         2004
#define CON_RETURN       2005
#define CON_SHIFT_TAB    2006
#define CON_TAB          2007
#define CON_ALT_ESCAPE   2008
#define CON_CURSOR_UP    2101
#define CON_CURSOR_DOWN  2102
#define CON_CURSOR_LEFT  2103
#define CON_CURSOR_RIGHT 2104
#define CON_SHIFT_UP     2201
#define CON_SHIFT_DOWN   2202
#define CON_SHIFT_LEFT   2203
#define CON_SHIFT_RIGHT  2204

#define CON_F   3000
#define CON_F1  3001
#define CON_F2  3002
#define CON_F3  3003
#define CON_F4  3004
#define CON_F5  3005
#define CON_F6  3006
#define CON_F7  3007
#define CON_F8  3008
#define CON_F9  3009
#define CON_F10 3010

#define CON_SHIFT_F   3010
#define CON_SHIFT_F1  3011
#define CON_SHIFT_F2  3012
#define CON_SHIFT_F3  3013
#define CON_SHIFT_F4  3014
#define CON_SHIFT_F5  3015
#define CON_SHIFT_F6  3016
#define CON_SHIFT_F7  3017
#define CON_SHIFT_F8  3018
#define CON_SHIFT_F9  3019
#define CON_SHIFT_F10 3020

#define CONSOLE_OPEN_OK      0
#define CONSOLE_EXIT_WPORT   30001
#define CONSOLE_EXIT_WREQ    30002
#define CONSOLE_EXIT_RPORT   30003
#define CONSOLE_EXIT_RREQ    30004
#define CONSOLE_EXIT_CONSOLE 30005

#define CONSOLE_ERROR    -1L
#define CLOSE_CONSOLE(r) CloseDevice(r)
#define FLASH_SCREEN     DisplayBeep(0L)

#define CONSOLE_BUFFER_SIZE 200
#define TAB_JUMP 4

#define INSERT_TYPE_MODE   1
#define TYPEOVER_TYPE_MODE 2
#define DEFAULT_TYPE_MODE  TYPEOVER_TYPE_MODE

#define SET_EVENTS   '{'
#define RESET_EVENTS '}'

#define CON_PLAIN      0x0000
#define CON_BOLD       0x0001
#define CON_ITALIC     0x0002
#define CON_UNDERSCORE 0x0004
#define CON_INVERSE    0x0008

#endif
