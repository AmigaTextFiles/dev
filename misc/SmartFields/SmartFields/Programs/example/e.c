/**************************************
*  SMART FIELDS EXAMPLE PROGRAM v1.01
*  © Copyright 1988 Timm Martin
*  All Rights Reserved
***************************************/

#include <exec/io.h>
#include <exec/memory.h>
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
*  VENDOR STRUCTURE
*********************/

struct Phone {
  int AreaCode;
  int Prefix;
  int Suffix;
};

#define NAME_SIZE 30
#define ADDRESS_SIZE 30
struct Vendor {
  char   Name[NAME_SIZE];
  char   Address[4][ADDRESS_SIZE];
  char   Contact[NAME_SIZE];
  struct Phone Telephone;
  int    Number;
  struct Vendor *Next;
};

struct Vendor *first_vendor = NULL;  /* top of vendor list */
struct Vendor *chnge_vendor = NULL;  /* vendor being changed */

/********************
*  FIELD STRUCTURES
*********************/

/*** TITLES ***/

#define STRING_TEXT 1,0,JAM1,-3,-11,NULL
struct IntuiText name_text = { STRING_TEXT, (STRPTR)"Name", NULL };
struct IntuiText addr_text = { STRING_TEXT, (STRPTR)"Address", NULL };
struct IntuiText cont_text = { STRING_TEXT, (STRPTR)"Contact", NULL };
struct IntuiText phon_text = { STRING_TEXT, (STRPTR)"Phone", NULL };
struct IntuiText numb_text = { STRING_TEXT, (STRPTR)"Vendor Number", NULL };

/*** BORDERS ***/

SHORT name_pairs2[] = { 2,11, 274,11, 274, 1, 275, 1, 275,11 };
SHORT name_pairs1[] = { 0, 0, 273, 0, 273,10,   0,10,   0, 0 };
SHORT addr_pairs2[] = { 2,41, 274,41, 274, 1, 275, 1, 275,41 };
SHORT phon_pairs2[] = { 2,11, 140,11, 140, 1, 141, 1, 141,11 };
SHORT phon_pairs1[] = { 0, 0, 139, 0, 139,10,   0,10,   0, 0 };
SHORT numb_pairs2[] = { 2,11, 102,11, 102, 1, 103, 1, 103,11 };
SHORT numb_pairs1[] = { 0, 0, 101, 0, 101,10,   0,10,   0, 0 };

#define BORDER2 -3,-2,2,0,JAM1,5
#define BORDER1 -3,-2,1,0,JAM1,5
struct Border name_border2 = { BORDER1, name_pairs1, NULL };
struct Border name_border1 = { BORDER2, name_pairs2, &name_border2 };
struct Border addr_border1 = { BORDER2, addr_pairs2, &name_border2 };
struct Border phon_border2 = { BORDER2, phon_pairs2, NULL };
struct Border phon_border1 = { BORDER1, phon_pairs1, &phon_border2 };
struct Border numb_border2 = { BORDER2, numb_pairs2, NULL };
struct Border numb_border1 = { BORDER1, numb_pairs1, &numb_border2 };

/*** BUFFERS ***/

#define PHONE_SIZE 15  /* (xxx) xxx-xxxx */
#define NUMBER_SIZE 5  /* #### */

UBYTE name_input[NAME_SIZE];
UBYTE add1_input[ADDRESS_SIZE];
UBYTE add2_input[ADDRESS_SIZE];
UBYTE add3_input[ADDRESS_SIZE];
UBYTE add4_input[ADDRESS_SIZE];
UBYTE cont_input[NAME_SIZE];
UBYTE phon_input[PHONE_SIZE];
UBYTE numb_input[NUMBER_SIZE];

UBYTE name_undo[NAME_SIZE];
UBYTE add1_undo[ADDRESS_SIZE];
UBYTE add2_undo[ADDRESS_SIZE];
UBYTE add3_undo[ADDRESS_SIZE];
UBYTE add4_undo[ADDRESS_SIZE];
UBYTE cont_undo[NAME_SIZE];
UBYTE phon_undo[PHONE_SIZE];
UBYTE numb_undo[NUMBER_SIZE];

UBYTE name_dup[NAME_SIZE];
UBYTE add1_dup[ADDRESS_SIZE];
UBYTE add2_dup[ADDRESS_SIZE];
UBYTE add3_dup[ADDRESS_SIZE];
UBYTE add4_dup[ADDRESS_SIZE];
UBYTE cont_dup[NAME_SIZE];
UBYTE phon_dup[PHONE_SIZE];
UBYTE numb_dup[NUMBER_SIZE];

/*** FIELDS ***/

#define NAME_FIELD 1
#define ADD1_FIELD 2
#define ADD2_FIELD 3
#define ADD3_FIELD 4
#define ADD4_FIELD 5
#define CONT_FIELD 6
#define PHON_FIELD 7
#define NUMB_FIELD 8

struct FieldMask phon_mask = MASK_ENTIRE_DISABLED;
struct FieldMask numb_mask = MASK_ENTIRE_DISABLED;

#define LEFT_EDGE  78
#define RIGHT_EDGE 251

#define FIRST_FIELD name_field
struct Field name_field = {
  NULL, LATER, name_input, name_undo, name_dup, 1, 0, CON_PLAIN,
  FIELD_ENABLED, NULL, NULL, LEFT_EDGE, 28, 0, 0, NAME_SIZE, 0,
  0, 0, 0, &name_text, &name_border1, NULL, NAME_FIELD, NULL, NULL, NULL
};
struct Field add1_field = {
  &name_field, LATER, add1_input, add1_undo, add1_dup, 1, 0, CON_PLAIN,
  FIELD_ENABLED, NULL, NULL, LEFT_EDGE, 54, 0, 0, ADDRESS_SIZE, 0,
  0, 0, 0, &addr_text, &addr_border1, NULL, ADD1_FIELD, NULL, NULL, NULL
};
struct Field add2_field = {
  &add1_field, LATER, add2_input, add2_undo, add2_dup, 1, 0, CON_PLAIN,
  FIELD_ENABLED, NULL, NULL, LEFT_EDGE, 64, 0, 0, ADDRESS_SIZE, 0,
  0, 0, 0, NULL, &name_border2, NULL, ADD2_FIELD, NULL, NULL, NULL
};
struct Field add3_field = {
  &add2_field, LATER, add3_input, add3_undo, add3_dup, 1, 0, CON_PLAIN,
  FIELD_ENABLED, NULL, NULL, LEFT_EDGE, 74, 0, 0, ADDRESS_SIZE, 0,
  0, 0, 0, NULL, &name_border2, NULL, ADD3_FIELD, NULL, NULL, NULL
};
struct Field add4_field = {
  &add3_field, LATER, add4_input, add4_undo, add4_dup, 1, 0, CON_PLAIN,
  FIELD_ENABLED, NULL, NULL, LEFT_EDGE, 84, 0, 0, ADDRESS_SIZE, 0,
  0, 0, 0, NULL, &name_border2, NULL, ADD4_FIELD, NULL, NULL, NULL
};
struct Field cont_field = {
  &add4_field, LATER, cont_input, cont_undo, cont_dup, 1, 0, CON_PLAIN,
  FIELD_ENABLED, NULL, NULL, LEFT_EDGE, 111, 0, 0, NAME_SIZE, 0,
  0, 0, 0, &cont_text, &name_border1, NULL, CONT_FIELD, NULL, NULL, NULL
};
struct Field phon_field = {
  &cont_field, LATER, phon_input, phon_undo, phon_dup, 1, 0, CON_PLAIN,
  FIELD_ENABLED, &phon_mask, NULL, LEFT_EDGE, 138, 0, 0, PHONE_SIZE, 0,
  0, 0, 0, &phon_text, &phon_border1, NULL, PHON_FIELD, NULL, NULL, NULL
};
struct Field numb_field = {
  &phon_field, NULL, numb_input, numb_undo, numb_dup, 1, 0, CON_PLAIN,
  FIELD_ENABLED, &numb_mask, NULL, RIGHT_EDGE, 138, 0, 0, NUMBER_SIZE, 0,
  0, 0, 0, &numb_text, &numb_border1, NULL, NUMB_FIELD, NULL, NULL, NULL
};
#define FINAL_FIELD numb_field

struct  FieldHeader field_header = { INIT_FIELD_HEADER };
#define CURRENT_FIELD field_header.CurrentField
UBYTE   con_buffer[CONSOLE_BUFFER_SIZE];

/***************
*  WINDOW TEXT
****************/

UBYTE add_string[]    = (STRPTR)"Mode: ADD   ";
UBYTE change_string[] = (STRPTR)"Mode: CHANGE";
UBYTE blank_string[]  = (STRPTR)"            ";

struct IntuiText mode_wtext = {
  1, 0, JAM2, LEFT_EDGE, 160, NULL, LATER, NULL
};

/*******************
*  MENU STRUCTURES
********************/

#define MENU_TEXT 2,1,JAM1,4,1,NULL
struct IntuiText cancel_mtext = { MENU_TEXT, (STRPTR)"Cancel Changes", NULL };
struct IntuiText enter_mtext  = { MENU_TEXT, (STRPTR)"Enter Vendor", NULL };

#define ACTION_MENU   0
#define ACTION_CANCEL 0
#define ACTION_ENTER  1
#define ACTION_WIDTH  160

#define MENUNUMBER(m,i,s) (m|(i<<5)|(s<<11))
#define ACTION_ENTER_ITEM MENUNUMBER(ACTION_MENU,ACTION_ENTER,NULL)

struct MenuItem enter_item = {
  NULL, 0, 10, ACTION_WIDTH, 10, HIGHCOMP | ITEMTEXT | COMMSEQ,
  NULL, (APTR)&enter_mtext, NULL, 'E', NULL, MENUNULL
};
struct MenuItem cancel_item = {
  &enter_item, 0, 0, ACTION_WIDTH, 10, HIGHCOMP | ITEMTEXT | COMMSEQ | ITEMENABLED,
  NULL, (APTR)&cancel_mtext, NULL, 'C', NULL, MENUNULL
};
struct Menu action_menu = {
  NULL, 0, 0, 56, 0, MENUENABLED, "Action", &cancel_item
};

/************************
*  NEW WINDOW STRUCTURE
*************************/

struct NewWindow new_window = {
  0, 0, 430, 200, 0, 1, CLOSEWINDOW | MENUPICK | MOUSEBUTTONS | REFRESHWINDOW,
  ACTIVATE | SMART_REFRESH | WINDOWCLOSE | WINDOWDEPTH | WINDOWDRAG |
  WINDOWSIZING, NULL, NULL, (STRPTR)"SmartFields Example Program v1.0",
  NULL, NULL, 50, 25, 430, 200, WBENCHSCREEN
};

/********************
*  GLOBAL VARIABLES
*********************/

#define WAIT_FOR_INPUT Wait(1L<<field_header.ReadPort->mp_SigBit|1L<<win->UserPort->mp_SigBit)
#define CONSOLE_INPUT  message=(struct Message *)GetMsg(field_header.ReadPort)
#define WINDOW_INPUT   imessage=(struct IntuiMessage *)GetMsg(win->UserPort)

int working_ven = FALSE;  /* whether working on a vendor */

/**************************
*  M A I N  P R O G R A M
***************************/

main()
{
  open_all();
  initialize();
  get_inputs();
}

/**************
*  ADD VENDOR
***************/

add_vendor()
{
  struct Vendor *new;

  /* dynamically allocate memory to hold new vendor structure */
  if (!(new = (struct Vendor *) AllocMem( (long)sizeof(struct Vendor), MEMF_CLEAR )))
    end_program( 1 );

  get_data( new );           /* returns pointer to Vendor struct in RAM */
  new->Next = first_vendor;  /* point new vendor to top of list */
  first_vendor = new;        /* new vendor becomes top of list */
  new_vendor();              /* clear fields */
}

/*****************
*  CHANGE VENDOR
******************/

change_vendor()
{
  get_data( chnge_vendor );  /* write over old field values */
  chnge_vendor = NULL;       /* no longer changing a vendor */
  new_vendor();              /* clear fields */
}

/************
*  DO MENUS
*************/

do_menus( menu, item, subitem )
  int menu, item, subitem;
{
  switch (menu) {      /* this is set up for more than one menu */
    case ACTION_MENU:
      switch (item) {
        case ACTION_ENTER:
          if (chnge_vendor)
            change_vendor();
          else
            add_vendor();
          break;
        case ACTION_CANCEL:
          new_vendor();
          break;
        }
      break;
  } /* switch menu */
}

/***************
*  DRAW SCREEN
****************/

draw_screen()
{
  PrintIText( rp, &mode_wtext, 0L, 0L );
  field_refresh( &field_header, &FIRST_FIELD, -1, CURRENT_FIELD );
}

/***************
*  END PROGRAM
****************/

end_program( return_code )
  int return_code;
{
  struct Vendor *hold;

  /* deallocate memory used by vendor list */
  while (first_vendor) {
    hold = first_vendor->Next;
    FreeMem( first_vendor, (long)sizeof(struct Vendor) );
    first_vendor = hold;
  }

  field_close( &field_header );

  if (win)           { ClearMenuStrip( win ); CloseWindow( win ); }
  if (GfxBase)         CloseLibrary( GfxBase );
  if (IntuitionBase)   CloseLibrary( IntuitionBase );

  exit( return_code );
}

/************
*  GET DATA
*************/

get_data( new )
  struct Vendor *new;
{
  strcpy( new->Name, name_input );
  strcpy( new->Address[0], add1_input );
  strcpy( new->Address[1], add2_input );
  strcpy( new->Address[2], add3_input );
  strcpy( new->Address[3], add4_input );
  strcpy( new->Contact, cont_input );
  to_phone( &(new->Telephone), phon_input );
  new->Number = atoi( numb_input );
}

/**************
*  GET INPUTS
***************/

get_inputs()
{
  #define MENU_NUMBERS MENUNUM(imessage->Code),ITEMNUM(imessage->Code),SUBNUM(imessage->Code)
  struct  IntuiMessage *imessage;
  ULONG   key;
  struct  Message *message;
  struct  Field *where;

  FOREVER {
    WAIT_FOR_INPUT;

    if (CONSOLE_INPUT) {
      key = field_input( &field_header );
      switch (key) {
        case FIELD_SWALLOW:  break;
        case FIELD_RETURN:
        case FIELD_NEXT:     next_field(); break;
        case FIELD_PREVIOUS: previous_field(); break;
        case FIELD_FIRST:
          if (working_ven)
            field_goto( &field_header, &add1_field );
          break;
        case FIELD_FINAL:
          if (working_ven)
            field_goto( &field_header, &FINAL_FIELD );
          break;
      } /* switch key */
    }   /* if keyboard input */

    while (WINDOW_INPUT) {
      switch (imessage->Class) {
        case MENUPICK:
          if (MENUNUM( imessage->Code ) != MENUNULL)
            do_menus( MENU_NUMBERS );
          break;
        case MOUSEBUTTONS:
          if (imessage->Code == LEFT_MOUSE_BUTTON)
            if (where = field_click( &field_header,
                        imessage->MouseX, imessage->MouseY ))
              if (working_ven ||
                (!working_ven && where->FieldID == NAME_FIELD)) {
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

/**************
*  INITIALIZE
***************/

initialize()
{
  mask_chars( &phon_mask, "0123456789()-/ ", MASK_ENABLE );
  mask_range( &numb_mask, '0', '9', MASK_ENABLE );
  draw_screen();
  SetMenuStrip( win, &action_menu );
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

/**************
*  NEW VENDOR
***************/

new_vendor()
{
  field_clear( &field_header, &FIRST_FIELD, -1, &FIRST_FIELD );
  OffMenu( win, ACTION_ENTER_ITEM );
  working_ven = FALSE;
  mode_wtext.IText = (STRPTR)blank_string;
  PrintIText( rp, &mode_wtext, 0L, 0L );
}

/**************
*  NEXT FIELD
***************/

next_field()
{
  switch (CURRENT_FIELD->FieldID) {
    case NAME_FIELD:
      vendor_lookup();
      break;
    case ADD1_FIELD:
      if (add1_input[0])
        field_goto( &field_header, &add2_field );
      else
        field_goto( &field_header, &cont_field );
      break;
    case ADD2_FIELD:
      if (add2_input[0])
        field_goto( &field_header, &add3_field );
      else
        field_goto( &field_header, &cont_field );
      break;
    case ADD3_FIELD:
      if (add3_input[0])
        field_goto( &field_header, &add4_field );
      else
        field_goto( &field_header, &cont_field );
      break;
    case PHON_FIELD:
      vendor_phone();
      break;
    case NUMB_FIELD:
      vendor_number();
      break;
    default:
      field_goto( &field_header, CURRENT_FIELD->NextField );
      break;
  } /* switch current field */
}

/************
*  PUT DATA
*************/

put_data( old )
  struct Vendor *old;
{
  strcpy( name_input, old->Name );
  strcpy( add1_input, old->Address[0] );
  strcpy( add2_input, old->Address[1] );
  strcpy( add3_input, old->Address[2] );
  strcpy( add4_input, old->Address[3] );
  strcpy( cont_input, old->Contact );
  sprintf( phon_input, "(%03d) %03d-%04d",
           old->Telephone.AreaCode, old->Telephone.Prefix, old->Telephone.Suffix );
  sprintf( numb_input, "%04d", old->Number );
}

/******************
*  PREVIOUS FIELD
*******************/

previous_field()
{
  if (CURRENT_FIELD->FieldID == CONT_FIELD) {
         if (add4_input[0]) field_goto( &field_header, &add4_field );
    else if (add3_input[0]) field_goto( &field_header, &add3_field );
    else if (add2_input[0]) field_goto( &field_header, &add2_field );
    else                    field_goto( &field_header, &add1_field );
  }
  else if (CURRENT_FIELD->FieldID == NAME_FIELD);
  else if (CURRENT_FIELD->FieldID == ADD1_FIELD)
    field_goto( &field_header, &FINAL_FIELD );
  else
    field_goto( &field_header, CURRENT_FIELD->PrevField );
}

/************
*  TO PHONE
*************/

to_phone( p, s )
  struct Phone *p;
  char *s;
{
  int i;

  p->AreaCode = p->Prefix = p->Suffix = 0;

  for (i = 0; i < 3 && *s; s++)
    if (*s >= '0' && *s <= '9')
      { p->AreaCode = p->AreaCode * 10 + *s - '0'; i++; }
  for (i = 0; i < 3 && *s; s++)
    if (*s >= '0' && *s <= '9')
      { p->Prefix = p->Prefix * 10 + *s - '0'; i++; }
  for (i = 0; i < 4 && *s; s++)
    if (*s >= '0' && *s <= '9')
      { p->Suffix = p->Suffix * 10 + *s - '0'; i++; }
}

/*****************
*  VENDOR LOOKUP
******************/

vendor_lookup()
{
  struct Vendor *next;

  next = first_vendor;
  while (next && strcmp( name_input, next->Name ))
    next = next->Next;

  chnge_vendor = next;
  if (chnge_vendor) {
    put_data( chnge_vendor );
    field_redisplay( &field_header, &add1_field, -1 );
    mode_wtext.IText = (STRPTR)change_string;
  }
  else
    mode_wtext.IText = (STRPTR)add_string;
  PrintIText( rp, &mode_wtext, 0L, 0L );
  OnMenu( win, ACTION_ENTER_ITEM );
  working_ven = TRUE;
  field_goto( &field_header, &add1_field );
}

/*****************
*  VENDOR NUMBER
******************/

vendor_number()
{
  int number, atoi();

  number = atoi( numb_input );
  sprintf( numb_input, "%04d", number );
  field_redisplay( &field_header, &numb_field, 1, &add1_field );
}

/****************
*  VENDOR PHONE
*****************/

vendor_phone()
{
  struct Phone phone;

  to_phone( &phone, phon_input );
  sprintf( phon_input, "(%03d) %03d-%04d",
           phone.AreaCode, phone.Prefix, phone.Suffix );
  field_redisplay( &field_header, &phon_field, 1, &numb_field );
}
