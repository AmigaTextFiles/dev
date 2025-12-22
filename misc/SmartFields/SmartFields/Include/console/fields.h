/***************************************
*  console/fields.h v1.40
*  © Copyright 1988 Timm Martin
*  All Rights Reserved
****************************************/

#ifndef CONSOLE_FIELDS_H
#define CONSOLE_FIELDS_H

#include <exec/io.h>
#include <exec/ports.h>
#include <exec/types.h>
#include <intuition/intuition.h>
#include <console/console.h>

#define MASK_ELEMENTS 8
#define MASK_ENABLE  0x0001L
#define MASK_DISABLE 0x0000L
#define MASK_ENTIRE_DISABLED {0,0,0,0,0,0,0,0}
#define MASK_ENTIRE_ENABLED  {0xffffffff,0xffffffff,0xffffffff,0xffffffff,\
                              0xffffffff,0xffffffff,0xffffffff,0xffffffff}

struct FieldMask {
  ULONG Element[MASK_ELEMENTS];
};

#define FIELD_ENABLED  1
#define FIELD_DISABLED 0

#define FIELD_CLIP_SIZE 80

struct Field {
  struct Field *PrevField;
  struct Field *NextField;
  UBYTE  *Buffer;
  UBYTE  *UndoBuffer;
  UBYTE  *DupBuffer;
  UBYTE  FrontPen;
  UBYTE  BackPen;
  UBYTE  Style;
  UBYTE  Enabled;
  struct FieldMask *Mask;
  USHORT Flags;
  SHORT  Left,Top;
  SHORT  Right,Bottom;
  SHORT  MaxChars;
  SHORT  NumChars;
  SHORT  DispChars;
  SHORT  BufferPos;
  SHORT  DispPos;
  struct IntuiText *FieldTitle;
  struct Border *FieldBorder;
  struct Image *FieldImage;
  SHORT  FieldID;
  APTR   UserPtr;
  LONG   Reserved1;
  LONG   Reserved2;
};

struct FieldHeader {
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
  struct Field *FirstField;
  struct Field *FinalField;
  struct Field *CurrentField;
  SHORT  BufferPos;
};

#define INIT_FIELD_HEADER NULL,NULL,NULL,NULL,NULL,CONSOLE_ERROR,NULL,NULL,0,\
                          NULL,NULL,NULL,NULL,NULL,NULL,0

#define FIELD_OPEN_OK      0
#define FIELD_EXIT_WPORT   30011
#define FIELD_EXIT_WREQ    30012
#define FIELD_EXIT_RPORT   30013
#define FIELD_EXIT_RREQ    30014
#define FIELD_EXIT_CONSOLE 30015

#define FIELD_FIRST      1000
#define FIELD_FINAL      1001
#define FIELD_PREVIOUS   1002
#define FIELD_NEXT       1003
#define FIELD_ESCAPE     1004
#define FIELD_HELP       1005
#define FIELD_SWALLOW    1006
#define FIELD_RETURN     1008
#define FIELD_OFF        1009
#define FIELD_NO_CURRENT 1010

#define LEFT_MOUSE_BUTTON 0x68

/* Remove this comment if your compiler supports the BUILTIN feature!
#ifdef strcpy
#undef strcpy
#endif
#ifdef strlen
#undef strlen
#endif
#define strcpy _BUILTIN_strcpy
#define strlen _BUILTIN_strlen
*/

#endif
