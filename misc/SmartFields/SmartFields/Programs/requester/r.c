/****************************************
*  SMART FIELDS REQUESTER PROGRAM v1.00
*  © Copyright 1988 Timm Martin
*  All Rights Reserved
*****************************************/

#include <exec/io.h>
#include <exec/memory.h>
#include <exec/ports.h>
#include <exec/types.h>
#include <functions.h>
#include <graphics/gfxbase.h>
#include <intuition/intuition.h>
#include <intuition/intuitionbase.h>
#include <console/console.h>
#include <console/fields.h>
#include <console/functions.h>
#include <toolkit/toolkit.h>

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

struct IntuiText field1_text = {
  1, 0, JAM1, -3, 11, NULL, (STRPTR)"Field 1", NULL
};
struct IntuiText field2_text = {
  1, 0, JAM1, -3, 11, NULL, (STRPTR)"Field 2", NULL
};

/*** BORDERS ***/

SHORT field_pairs2[] = { 2,11, 274,11, 274, 1, 275, 1, 275,11 };
SHORT field_pairs1[] = { 0, 0, 273, 0, 273,10,   0,10,   0, 0 };

struct Border field_border2 = { 
  -3, -2, 2, 0, JAM1, 5, field_pairs2, NULL
};
struct Border field_border1 = {
  -3, -2, 1, 0, JAM1, 5, field_pairs1, &field_border2
};

/*** BUFFERS ***/

#define FIELD_SIZE 31

UBYTE field1_input[FIELD_SIZE];
UBYTE field2_input[FIELD_SIZE];

UBYTE field1_undo[FIELD_SIZE];
UBYTE field2_undo[FIELD_SIZE];

/*** FIELDS ***/

#define FIELD1_FIELD 1
#define FIELD2_FIELD 2

#define LEFT_EDGE 78
#define FIRST_FIELD field1_field
struct Field field1_field = {
  NULL, LATER, field1_input, field1_undo, NULL, 1, 0, CON_PLAIN,
  FIELD_ENABLED, NULL, NULL, LEFT_EDGE, 28, 0, 0, FIELD_SIZE, 0,
  0, 0, 0, &field1_text, &field_border1, NULL, FIELD1_FIELD, NULL, NULL, NULL
};
struct Field field2_field = {
  &field1_field, NULL, field2_input, field2_undo, NULL, 1, 0, CON_PLAIN,
  FIELD_ENABLED, NULL, NULL, LEFT_EDGE, 54, 0, 0, FIELD_SIZE, 0,
  0, 0, 0, &field2_text, &field_border1, NULL, FIELD2_FIELD, NULL, NULL, NULL
};
#define FINAL_FIELD field2_field

struct  FieldHeader field_header = { INIT_FIELD_HEADER };
#define CURRENT_FIELD field_header.CurrentField
UBYTE   con_buffer[CONSOLE_BUFFER_SIZE];

/***************
*  REQUESTER 1
****************/

struct IntuiText req1_text9 = {
  1, 2, JAM1, 20, 10, NULL, (STRPTR)"With SmartFields, you can display simple", NULL
};
struct IntuiText req1_text8 = {
  1, 2, JAM1, 36, 21, NULL, (STRPTR)"message requesters that the user can", &req1_text9
};
struct IntuiText req1_text7 = {
  1, 2, JAM1, 28, 32, NULL, (STRPTR)"answer with the mouse or the keyboard.", &req1_text8
};
struct IntuiText req1_text6 = {
  1, 2, JAM1, 28, 43, NULL, (STRPTR)"You can decide which keys the user can", &req1_text7
};
struct IntuiText req1_text5 = {
  1, 2, JAM1, 32, 54, NULL, (STRPTR)"press to make this requester go away.", &req1_text6
};
struct IntuiText req1_text4 = {
  1, 2, JAM1, 32, 65, NULL, (STRPTR)"In this case, pressing either the 'O'", &req1_text5
};
struct IntuiText req1_text3 = {
  1, 2, JAM1, 28, 76, NULL, (STRPTR)"key, <RETURN> key, or <ESCape> key, or", &req1_text4
};
struct IntuiText req1_text2 = {
  1, 2, JAM1, 40, 87, NULL, (STRPTR)"clicking on the OK gadget will make", &req1_text3
};
struct IntuiText req1_text1 = {
  1, 2, JAM1, 80, 98, NULL, (STRPTR)"this requester disappear.", &req1_text2
};
struct IntuiText ok_text = {
  1, 2, JAM1, 18, 2, NULL, (STRPTR)"OK", NULL
};

SHORT req1_pairs[] = {
  2,1, 357,1, 357,135, 2,135, 2,1, 356,1, 356,135, 3,135, 3,1
};
SHORT ok_pairs2[] = { 2,13, 52,13, 52,1, 53,1, 53,13 };
SHORT ok_pairs1[] = { 0,0, 51,0, 51,12, 0,12, 0,0 };

struct Border req1_border = {
  0, 0, 1, 0, JAM1, 9, req1_pairs, NULL
};
struct Border ok_border2 = {
  -1, -1, 1, 0, JAM1, 5, ok_pairs2, NULL
};
struct Border ok_border1 = {
  -1, -1, 1, 0, JAM1, 5, ok_pairs1, &ok_border2
};

struct Gadget ok_gadget = {
  NULL, 154, 115, 50, 11, GADGHCOMP, RELVERIFY, BOOLGADGET | REQGADGET,
  (APTR)&ok_border1, NULL, &ok_text, NULL, NULL, 1, NULL
};

struct Requester req1_requester = {
  NULL, 35, 32, 360, 137, 0, 0, &ok_gadget, &req1_border,
  &req1_text1, NOISYREQ, 2, NULL, NULL, NULL, NULL, NULL
};

/***************
*  REQUESTER 2
****************/

struct IntuiText req2_text7 = {
  2, 3, JAM1, 32, 76, NULL, (STRPTR)"press either the 'Y' or 'N' key.", NULL
};
struct IntuiText req2_text6 = {
  2, 3, JAM1, 40, 65, NULL, (STRPTR)"make this requester disappear,", &req2_text7
};
struct IntuiText req2_text5 = {
  2, 3, JAM1, 28, 54, NULL, (STRPTR)"letter of the desired gadget.  To", &req2_text6
};
struct IntuiText req2_text4 = {
  2, 3, JAM1, 36, 43, NULL, (STRPTR)"gadget or by pressing the first", &req2_text5
};
struct IntuiText req2_text3 = {
  2, 3, JAM1, 32, 32, NULL, (STRPTR)"either by clicking on the proper", &req2_text4
};
struct IntuiText req2_text2 = {
  2, 3, JAM1, 20, 21, NULL, (STRPTR)"requesters that the user can answer", &req2_text3
};
struct IntuiText req2_text1 = {
  2, 3, JAM1, 20, 10, NULL, (STRPTR)"You can also display multi-response", &req2_text2
};
struct IntuiText yes_text = {
  2, 3, JAM1, 14, 2, NULL, (STRPTR)"YES", NULL
};
struct IntuiText no_text = {
  2, 3, JAM1, 18, 2, NULL, (STRPTR)"NO", NULL
};

SHORT req2_pairs[] = {
  2,1, 317,1, 317,113, 2,113, 2,1, 316,1, 316,113, 3,113, 3,1
};
struct Border yes_border2 = {
  -1, -1, 2, 0, JAM1, 5, ok_pairs2, NULL
};
struct Border yes_border1 = {
  -1, -1, 2, 0, JAM1, 5, ok_pairs1, &yes_border2
};

struct Border req2_border = {
  0, 0, 2, 0, JAM1, 9, req2_pairs, NULL
};

#define YES_GADGET 1
#define NO_GADGET  2
struct Gadget yes_gadget = {
  NULL, 22, 93, 50, 11, GADGHCOMP, RELVERIFY, BOOLGADGET | REQGADGET,
  (APTR)&yes_border1, NULL, &yes_text, NULL, NULL, YES_GADGET, NULL
};
struct Gadget no_gadget = {
  &yes_gadget, 248, 93, 50, 11, GADGHCOMP, RELVERIFY, BOOLGADGET | REQGADGET,
  (APTR)&yes_border1, NULL, &no_text, NULL, NULL, NO_GADGET, NULL
};

struct Requester req2_requester = {
  NULL, 55, 37, 320, 115, 0, 0, &no_gadget, &req2_border,
  &req2_text1, NOISYREQ, 3, NULL, NULL, NULL, NULL, NULL
};

/***************
*  WINDOW TEXT
****************/

struct IntuiText win5_text = {
  1, 0, JAM2, 139, 120, NULL, (STRPTR)"manage requesters.", NULL
};
struct IntuiText win4_text = {
  1, 0, JAM2, 91, 110, NULL, (STRPTR)"use SmartFields to display and", &win5_text
};
struct IntuiText win3_text = {
  1, 0, JAM2, 99, 100, NULL, (STRPTR)"demonstration on how you can", &win4_text
};
struct IntuiText win2_text = {
  1, 0, JAM2, 99, 90, NULL, (STRPTR)"and press the HELP key for a", &win3_text
};
struct IntuiText win1_text = {
  1, 0, JAM2, 95, 80, NULL, (STRPTR)"Type anything into the fields", &win2_text
};

struct IntuiText yup_text = {
  3, 0, JAM2, 103, 160, NULL, (STRPTR)"You selected the YES gadget!", NULL
};
struct IntuiText nop_text = {
  3, 0, JAM2, 103, 160, NULL, (STRPTR)"You selected the NO gadget! ", NULL
};

/************************
*  NEW WINDOW STRUCTURE
*************************/

struct NewWindow new_window = {
  0, 0, 430, 200, 0, 1, CLOSEWINDOW | GADGETUP | MOUSEBUTTONS | REFRESHWINDOW,
  ACTIVATE | SMART_REFRESH | WINDOWCLOSE | WINDOWDEPTH | WINDOWDRAG |
  WINDOWSIZING, NULL, NULL, (STRPTR)"SmartFields Requester Program v1.00",
  NULL, NULL, 50, 25, 430, 200, WBENCHSCREEN
};

/********************
*  GLOBAL VARIABLES
*********************/

#define WAIT_FOR_INPUT Wait(1L<<field_header.ReadPort->mp_SigBit|1L<<win->UserPort->mp_SigBit)
#define CONSOLE_INPUT  message=(struct Message *)GetMsg(field_header.ReadPort)
#define WINDOW_INPUT   imessage=(struct IntuiMessage *)GetMsg(win->UserPort)

/*************
*  FUNCTIONS
**************/

void   draw_screen();    /* draws window & fields */
void   end_program();    /* terminates program */
void   get_inputs();     /* monitors user input */
USHORT help();           /* display help requesters */
void   open_all();       /* opens libraries, windows, devices */
void   next_field();     /* moves cursor to next field */

/**************************
*  M A I N  P R O G R A M
***************************/

void main()
{
  open_all();
  draw_screen();
  get_inputs();
}

/***************
*  DRAW SCREEN
****************/

void draw_screen()
{
  PrintIText( rp, &win1_text, 0L, 0L );
  field_refresh( &field_header, &FIRST_FIELD, -1, CURRENT_FIELD );
}

/***************
*  END PROGRAM
****************/

void end_program( return_code )
  int return_code;
{
  field_close( &field_header );

  if (win)           { ClearMenuStrip( win ); CloseWindow( win ); }
  if (GfxBase)         CloseLibrary( GfxBase );
  if (IntuitionBase)   CloseLibrary( IntuitionBase );

  exit( return_code );
}

/**************
*  GET INPUTS
***************/

void get_inputs()
{
  struct IntuiMessage *imessage;
  USHORT gadget;
  int    key;
  struct Message *message;
  struct Field *where;

  FOREVER {
    WAIT_FOR_INPUT;

    if (CONSOLE_INPUT) {
      key = field_input( &field_header );
      switch (key) {
        case FIELD_SWALLOW:  break;
        case FIELD_RETURN:
        case FIELD_NEXT:
        case FIELD_PREVIOUS: next_field(); break;
        case FIELD_FIRST:    field_goto( &field_header, &FIRST_FIELD ); break;
        case FIELD_FINAL:    field_goto( &field_header, &FINAL_FIELD ); break;
        case FIELD_HELP:
          if ((gadget = help()) == YES_GADGET)
            PrintIText( rp, &yup_text, 0L, 0L );
          else if (gadget == NO_GADGET)
            PrintIText( rp, &nop_text, 0L, 0L );
          break;
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

USHORT help()
{
  USHORT finished = 0;
  struct IntuiMessage *imessage;
  int    key;
  struct Message *message;

  if (Request( &req1_requester, win )) {
    while (!finished) {
      WAIT_FOR_INPUT;

      if (CONSOLE_INPUT) {
        key = console_input( &field_header );
        finished = key == 'o' || key == 'O' || key == CON_ESCAPE || key == CON_RETURN;
      }
      while (WINDOW_INPUT) {
        finished = imessage->Class == GADGETUP && imessage->IAddress == &ok_gadget;
        ReplyMsg( imessage );
      }
    } /* while not finished */
    EndRequest( &req1_requester, win );
  } /* if opened requester ok */

  if (Request( &req2_requester, win )) {
    finished = 0;
    while (!finished) {
      WAIT_FOR_INPUT;

      if (CONSOLE_INPUT) {
        key = console_input( &field_header );
        if (key == 'y' || key == 'Y')
          finished = YES_GADGET;
        else if (key == 'n' || key == 'N')
          finished = NO_GADGET;
      }
      while (WINDOW_INPUT) {
        if (imessage->Class == GADGETUP)
          finished = ((struct Gadget *)imessage->IAddress)->GadgetID;
        ReplyMsg( imessage );
      }
    } /* while not finished */
    EndRequest( &req2_requester, win );
  } /* if opened requester ok */
  return (finished);
}

/************
*  OPEN ALL
*************/

void open_all()
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

/**************
*  NEXT FIELD
***************/

void next_field()
{
  switch (CURRENT_FIELD->FieldID) {
    case FIELD1_FIELD: field_goto( &field_header, &field2_field ); break;
    case FIELD2_FIELD: field_goto( &field_header, &field1_field ); break;
  } /* switch current field */
}
