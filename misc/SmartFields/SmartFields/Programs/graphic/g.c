/******************************************************
*  SMART FIELDS GRAPHIC RENDITION TEST PROGRAM v1.01
*  © Copyright 1988 Timm Martin - All Rights Reserved
*******************************************************/

#include <exec/io.h>
#include <exec/ports.h>
#include <exec/types.h>
#include <graphics/gfxbase.h>
#include <intuition/intuition.h>
#include <intuition/intuitionbase.h>
#include <console/console.h>
#include <console/fields.h>
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

/********************
*  FIELD STRUCTURES
*********************/

/*** TITLES ***/

#define STRING_TEXT 1,0,JAM1,-3,-11,NULL
struct IntuiText fp_text = { STRING_TEXT, (STRPTR)"Front Pen", NULL };
struct IntuiText bp_text = { STRING_TEXT, (STRPTR)"Back Pen", NULL };
struct IntuiText st_text = { STRING_TEXT, (STRPTR)"Style", NULL };
struct IntuiText te_text = { STRING_TEXT, (STRPTR)"Test Field", NULL };

/*** BORDERS ***/

SHORT small_pairs2[] = { 2,11, 100,11, 100, 1, 101, 1, 101,11 };
SHORT small_pairs1[] = { 0, 0,  99, 0,  99,10,   0,10,   0, 0 };
SHORT large_pairs2[] = { 2,11, 404,11, 404, 1, 405, 1, 405,11 };
SHORT large_pairs1[] = { 0, 0, 403, 0, 403,10,   0,10,   0, 0 };

#define BORDER2 -3,-2,2,0,JAM1,5
#define BORDER1 -3,-2,1,0,JAM1,5
struct Border small_border2 = { BORDER2, small_pairs2, NULL };
struct Border small_border1 = { BORDER1, small_pairs1, &small_border2 };
struct Border large_border2 = { BORDER2, large_pairs2, NULL };
struct Border large_border1 = { BORDER1, large_pairs1, &large_border2 };

/*** BUFFERS ***/

#define FP_SIZE 2
#define BP_SIZE 2
#define ST_SIZE 3
#define TE_SIZE 50

UBYTE fp_input[FP_SIZE];
UBYTE bp_input[BP_SIZE];
UBYTE st_input[ST_SIZE];
UBYTE te_input[TE_SIZE];

UBYTE fp_undo[FP_SIZE];
UBYTE bp_undo[BP_SIZE];
UBYTE st_undo[ST_SIZE];
UBYTE te_undo[TE_SIZE];

/*** FIELDS ***/

#define FP_FIELD 1
#define BP_FIELD 2
#define ST_FIELD 3
#define TE_FIELD 4

struct FieldMask color_mask = MASK_ENTIRE_DISABLED;
struct FieldMask style_mask = MASK_ENTIRE_DISABLED;

#define LEFT_EDGE 117
#define FP_TOP 60
#define BP_TOP 86
#define ST_TOP 112
#define TE_TOP 138

#define FIRST_FIELD fp_field
struct Field fp_field = {
  NULL, LATER, fp_input, fp_undo, NULL, 1, 0, CON_PLAIN,
  FIELD_ENABLED, &color_mask, NULL, LEFT_EDGE, FP_TOP,
  0, 0, FP_SIZE, 0, 0, 0, 0, &fp_text, &small_border1,
  NULL, FP_FIELD, NULL, NULL, NULL
};
struct Field bp_field = {
  &fp_field, LATER, bp_input, bp_undo, NULL, 1, 0, CON_PLAIN,
  FIELD_ENABLED, &color_mask, NULL, LEFT_EDGE, BP_TOP,
  0, 0, BP_SIZE, 0, 0, 0, 0, &bp_text, &small_border1,
  NULL, BP_FIELD, NULL, NULL, NULL
};
struct Field st_field = {
  &bp_field, LATER, st_input, st_undo, NULL, 1, 0, CON_PLAIN,
  FIELD_ENABLED, &style_mask, NULL, LEFT_EDGE, ST_TOP,
  0, 0, ST_SIZE, 0, 0, 0, 0, &st_text, &small_border1,
  NULL, ST_FIELD, NULL, NULL, NULL
};
struct Field te_field = {
  &st_field, NULL, te_input, te_undo, NULL, 1, 0, CON_PLAIN,
  FIELD_ENABLED, NULL, NULL, LEFT_EDGE, TE_TOP,
  0, 0, TE_SIZE, 0, 0, 0, 0, &te_text, &large_border1,
  NULL, TE_FIELD, NULL, NULL, NULL
};
#define FINAL_FIELD te_field

struct FieldHeader field_header;
#define CURRENT_FIELD field_header.CurrentField

/***************
*  WINDOW TEXT
****************/

UBYTE *color_text[] = {
  (STRPTR)"BLUE  ", (STRPTR)"WHITE ", (STRPTR)"BLACK ", (STRPTR)"ORANGE"
};
#define TEXT_LEFT LEFT_EDGE+118
struct IntuiText fp_wtext = {
  1, 0, JAM2, TEXT_LEFT, FP_TOP, NULL, LATER, NULL
};
struct IntuiText bp_wtext = {
  1, 0, JAM2, TEXT_LEFT, BP_TOP, NULL, LATER, &fp_wtext
};
UBYTE st_string[37];
struct IntuiText st_wtext = {
  1, 0, JAM2, TEXT_LEFT, ST_TOP, NULL, (STRPTR)st_string, &bp_wtext
};
#define WINDOW_TEXT st_wtext

/************************
*  NEW WINDOW STRUCTURE
*************************/

struct NewWindow new_window = {
  0, 0, 640, 200, 0, 1, CLOSEWINDOW | MOUSEBUTTONS |
  REFRESHWINDOW, ACTIVATE | SMART_REFRESH | WINDOWCLOSE |
  WINDOWDEPTH | WINDOWDRAG | WINDOWSIZING, NULL, NULL,
  (STRPTR)"SmartFields Graphic Rendition Test Program v1.0",
  NULL, NULL, 50, 25, 640, 200, WBENCHSCREEN
};

/********************
*  GLOBAL VARIABLES
*********************/

#define WAIT_FOR_INPUT Wait(1L<<field_header.ReadPort->mp_SigBit|1L<<win->UserPort->mp_SigBit)
#define CONSOLE_INPUT  message=(struct Message *)GetMsg(field_header.ReadPort)
#define WINDOW_INPUT   imessage=(struct IntuiMessage *)GetMsg(win->UserPort)
UBYTE   con_buffer[CONSOLE_BUFFER_SIZE];

/**************************
*  M A I N  P R O G R A M
***************************/

main()
{
  open_all();
  initialize();
  get_inputs();
}

/***************
*  DRAW SCREEN
****************/

draw_screen()
{
  PrintIText( rp, &WINDOW_TEXT, 0L, 0L );
  field_refresh( &field_header, &FIRST_FIELD, -1, CURRENT_FIELD );
}

/***************
*  END PROGRAM
****************/

end_program( return_code )
  int return_code;
{
  field_close( &field_header );

  if (win)             CloseWindow( win );
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
  ULONG   key;
  struct  Message *message;
  struct  Field *where;

  FOREVER {
    WAIT_FOR_INPUT;

    if (CONSOLE_INPUT) {
      key = field_input( &field_header );
      switch (key) {
        case FIELD_SWALLOW:
          break;
        case FIELD_RETURN:
        case FIELD_NEXT:
          prepare_text();
          if (CURRENT_FIELD == &FINAL_FIELD)
            field_goto( &field_header, &FIRST_FIELD );
          else
            field_goto( &field_header, CURRENT_FIELD->NextField );
          break;
        case FIELD_PREVIOUS:
          if (CURRENT_FIELD == &FIRST_FIELD)
            field_goto( &field_header, &FINAL_FIELD );
          else
            field_goto( &field_header, CURRENT_FIELD->PrevField );
          break;
        case FIELD_FIRST:
          field_goto( &field_header, &FIRST_FIELD ); break;
        case FIELD_FINAL:
          field_goto( &field_header, &FINAL_FIELD ); break;
        case FIELD_HELP:
          help(); break;
      } /* switch key */
    }   /* if keyboard input */

    while (WINDOW_INPUT) {
      switch (imessage->Class) {
        case MOUSEBUTTONS:
          if (imessage->Code == LEFT_MOUSE_BUTTON)
            if (where = field_click( &field_header,
                        imessage->MouseX, imessage->MouseY )) {
              where->BufferPos = field_header.BufferPos;
              field_goto( &field_header, where );
            }
          break;
        case REFRESHWINDOW:
          draw_screen();
          BeginRefresh( win );
          EndRefresh( win, TRUE );
          break;
        case CLOSEWINDOW:
          end_program( 0 );
          break;
      } /* switch */
      ReplyMsg( imessage );
    } /* while window messages */
  }   /* forever */
}

/********
*  HELP
*********/

help()
{
  printf( "HELP!\n" );
}

/**************
*  INITIALIZE
***************/

initialize()
{
  /* this will set for bp_field also since it shares mask with fp_field */
  mask_range( &color_mask, '0', '3', MASK_ENABLE );
  mask_range( &style_mask, '0', '9', MASK_ENABLE );

  st_string[0] = '\0';  /* to display nothing first time */
  draw_screen();
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

  if (error = field_open( win, &field_header, &FIRST_FIELD, &FINAL_FIELD, con_buffer ))
    end_program( error );
}

/****************
*  PREPARE TEXT
*****************/

prepare_text()
{
  te_field.FrontPen = atoi( fp_field.Buffer );
  te_field.BackPen  = atoi( bp_field.Buffer );
  te_field.Style    = atoi( st_field.Buffer );

  /* Style should only have values 0-15 */
  te_field.Style   %= 16;
  itoa( st_field.Buffer, te_field.Style );
  field_redisplay( &field_header, &st_field, 1, CURRENT_FIELD );

  fp_wtext.IText = color_text[te_field.FrontPen];
  bp_wtext.IText = color_text[te_field.BackPen];

  /* using con_buffer to accumulate Style flags */
  con_buffer[0] = '\0';
  if (te_field.Style & CON_BOLD)
    strcpy( con_buffer, "BOLD" );
  if (te_field.Style & CON_ITALIC) {
    if (con_buffer[0])
      strcat( con_buffer, " | ITALIC" );
    else
      strcpy( con_buffer, "ITALIC" );
  }
  if (te_field.Style & CON_UNDERSCORE) {
    if (con_buffer[0])
      strcat( con_buffer, " | UNDERSCORE" );
    else
      strcpy( con_buffer, "UNDERSCORE" );
  }
  if (te_field.Style & CON_INVERSE) {
    if (con_buffer[0])
      strcat( con_buffer, " | INVERSE" );
    else
      strcpy( con_buffer, "INVERSE" );
  }
  if (!con_buffer[0])
    strcpy( con_buffer, "PLAIN" );
  sprintf( st_string, "%-36s", con_buffer );
  PrintIText( rp, &WINDOW_TEXT, 0L, 0L );
}
