
/* dblmenureq.h -- The structures for the requester and its gadgets. */
/* Copyright (c) 1990 Commodore-Amiga, Inc.
 *
 * This example is provided in electronic form by Commodore-Amiga, Inc. for
 * use with the 1.3 revisions of the Addison-Wesley Amiga reference manuals. 
 * The 1.3 Addison-Wesley Amiga Reference Manual series contains additional
 * information on the correct usage of the techniques and operating system
 * functions presented in this example.  The source and executable code of
 * this example may only be distributed in free electronic form, via bulletin
 * board or as part of a fully non-commercial and freely redistributable
 * diskette.  Both the source and executable code (including comments) must
 * be included, without modification, in any copy.  This example may not be
 * published in printed form or distributed with any commercial product.
 * However, the programming techniques and support routines set forth in
 * this example may be used in the development of original executable
 * software products for Commodore Amiga computers.
 * All other rights reserved.
 * This example is provided "as-is" and is subject to change; no warranties
 * are made.  All use is at your own risk.  No liability or responsibility
 * is assumed.
 */

#define BACKPEN  0

/* Force text to use Topaz 8 font */
struct TextAttr TOPAZ80 = 
    {(STRPTR)"topaz.font",TOPAZ_EIGHTY, 0, 0};

/* Tell something about the program */
struct IntuiText WinText[] =
    { 
       {3,0,JAM2,95,66,&TOPAZ80,"to activate",                    NULL},
       {3,0,JAM2,48,56,&TOPAZ80,"Double-Click Menu Button",&WinText[0]}
    };

/* Text for the Requester and its gadgets */
struct IntuiText ReqTxt[] =
    {
       {3,BACKPEN,JAM2,23,3,&TOPAZ80,"Control Panel",NULL},
       {2,0,      JAM1,22,1,&TOPAZ80,"Exit",         NULL},
       {2,0,      JAM1,22,1,&TOPAZ80,"Fast",         NULL},
       {2,0,      JAM1,21,1,&TOPAZ80,"Slow",         NULL}
    };

/* image and mask data for cool buttons */
USHORT chip MaskData[] =
    {
    0x07FF,0xFFFF,0xFFFF,0xFFFF,0xF000,0x3FFF,0xFFFF,0xFFFF,
    0xFFFF,0xFE00,0x7FFF,0xFFFF,0xFFFF,0xFFFF,0xFF00,0xFFFF,
    0xFFFF,0xFFFF,0xFFFF,0xFF80,0xFFFF,0xFFFF,0xFFFF,0xFFFF,
    0xFF80,0xFFFF,0xFFFF,0xFFFF,0xFFFF,0xFF80,0xFFFF,0xFFFF,
    0xFFFF,0xFFFF,0xFF80,0x7FFF,0xFFFF,0xFFFF,0xFFFF,0xFF00,
    0x3FFF,0xFFFF,0xFFFF,0xFFFF,0xFE00,0x07FF,0xFFFF,0xFFFF,
    0xFFFF,0xF000
    };

struct Image Button = 
    {0,0,73,10,1,MaskData,0x0001,0x0000,NULL};

/* Mask information for gadgets */
struct BoolInfo ButtonMask = {BOOLMASK,MaskData,0};

/*The buttons for the requester use REQGADGET
 *to indicate that they are gadgets for a
 *requester.  ENDGADGET indicates that the
 *requester ends when this button is released.
*/ 

struct Gadget ReqGad[] =
    {
       {NULL,      35,60,73,10,GADGHCOMP|GADGIMAGE,
        RELVERIFY|GADGIMMEDIATE|ENDGADGET|BOOLEXTEND,
        BOOLGADGET|REQGADGET,(APTR)&Button,NULL,&ReqTxt[1],NULL,
        (APTR)&ButtonMask,100,NULL
       },
       {&ReqGad[0],35,40,73,10,GADGHCOMP|GADGIMAGE,
        RELVERIFY|GADGIMMEDIATE|ENDGADGET|BOOLEXTEND,
        BOOLGADGET|REQGADGET,(APTR)&Button,NULL,&ReqTxt[2],NULL,
        (APTR)&ButtonMask,101,NULL
       },
       {&ReqGad[1],35,20,73,10,GADGHCOMP|GADGIMAGE,
        RELVERIFY|GADGIMMEDIATE|ENDGADGET|BOOLEXTEND,
        BOOLGADGET|REQGADGET,(APTR)&Button,NULL,&ReqTxt[3],NULL,
        (APTR)&ButtonMask,102,NULL 
       }
    };

/* Draw a pretty border around the requester */
SHORT BorderVectors[] = 
    {
      0, 0,
    148, 0,
    148,84,
      0,84,
      0, 0
    };

struct Border ReqBorder = {0,0,1,0,JAM1,5,BorderVectors,NULL};

struct Requester DMRequester =
    {
    NULL,
    79,14,       /* LeftEdge and TopEdge */
    149,85,      /* Width and Height */
    -75,-43,
    &ReqGad[2],  /* Gadgets used */
    &ReqBorder,  /* Border */
    &ReqTxt[0],  /* Text to render within requester */
    POINTREL,
    BACKPEN,     /* Color to use as the background */
    NULL,
    NULL,
    NULL
    };

/* End of dblmenureq.h */
