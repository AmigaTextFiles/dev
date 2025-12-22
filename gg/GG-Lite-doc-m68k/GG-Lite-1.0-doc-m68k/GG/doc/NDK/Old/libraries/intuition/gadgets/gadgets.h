/* gadgets.h -- has all of the structures needed for the gadgets */
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


struct TextAttr TOPAZ80 = 
    {
    (STRPTR)"topaz.font",TOPAZ_EIGHTY,0,0
    };

UBYTE   Buffer[512];    /* This is for showing any messages or entries */

struct IntuiText Messages =
    {
    1,0,JAM2,0,0,&TOPAZ80,&Buffer[0],NULL
    };

struct Image BackImage1 = 
    {
    0,0,                /* X, Y origin relative to TopLeft of Gadget */
    150,90,             /* Image width and height in pixels */
    0,                  /* number of bitplanes in Image */
    NULL,               /* pointer to ImageData, NULL for Rectangle */
    0x0000,0x0002,      /* PlanePick and PlaneOnOff */
    NULL                /* next Image structure */
    };

struct Gadget BackDrop =     /* This is just for our blank images */
    {
    NULL,5,1,1,1,GADGIMAGE,NULL,BOOLGADGET,(APTR)&BackImage1,
    NULL,NULL,NULL,NULL,0,NULL
    };

USHORT chip MaskData1[]=     /* No Border Button Mask Data */
    {
    0x07FF,0xFFFF,0xFFFF,0xFFFF,0xF000,0x3FFF,0xFFFF,0xFFFF,
    0xFFFF,0xFE00,0x7FFF,0xFFFF,0xFFFF,0xFFFF,0xFF00,0xFFFF,
    0xFFFF,0xFFFF,0xFFFF,0xFF80,0xFFFF,0xFFFF,0xFFFF,0xFFFF,
    0xFF80,0xFFFF,0xFFFF,0xFFFF,0xFFFF,0xFF80,0xFFFF,0xFFFF,
    0xFFFF,0xFFFF,0xFF80,0x7FFF,0xFFFF,0xFFFF,0xFFFF,0xFF00,
    0x3FFF,0xFFFF,0xFFFF,0xFFFF,0xFE00,0x07FF,0xFFFF,0xFFFF,
    0xFFFF,0xF000
    };

struct Image ButtonI1 = 
    {
    0,0,73,10,1,MaskData1,0x0001,0x0000,NULL
    };

/* Text for our buttons */
struct IntuiText IText1 = {2,0,JAM1,14,1,&TOPAZ80,"Cancel",NULL};
struct IntuiText IText2 = {2,0,JAM1,20,1,&TOPAZ80,"OKAY",NULL};

/* Mask information for gadget */
struct BoolInfo OkayMask = {BOOLMASK,MaskData1,0};

struct Gadget ButtonGads[] =
    {
       {
       &BackDrop,     100,106, 73,10, GADGHCOMP|GADGIMAGE, 
       RELVERIFY|GADGIMMEDIATE|BOOLEXTEND, BOOLGADGET, (APTR)&ButtonI1,
       NULL, &IText1, NULL, (APTR)&OkayMask, 7, NULL
       },
       {
       &ButtonGads[0],  5,106, 73,10, GADGHCOMP|GADGIMAGE,
       RELVERIFY|GADGIMMEDIATE|BOOLEXTEND, BOOLGADGET, (APTR)&ButtonI1,
       NULL, &IText2, NULL, (APTR)&OkayMask, 6, NULL
       }
    };

SHORT BorderVectors3[] = {
    0,0,
    151,0,
    151,91,
    0,91,
    0,0
};
struct Border Border3 = {
    -1,-1,              /* XY origin relative to TopLeft */
    1,0,JAM1,           /* front pen, back pen and drawmode */
    5,                  /* number of XY vectors */
    BorderVectors3,     /* pointer to XY vectors */
    NULL                /* next border in list */
};

struct Gadget EntryBox = {
    &ButtonGads[1],     /* next gadget */
    5,1,                /* origin XY of hit box relative to window TopLeft */
    150,90,             /* hit box width and height */
    GADGHBOX|GADGHIMAGE,/* gadget flags */
    RELVERIFY|GADGIMMEDIATE,    /* activation flags */
    BOOLGADGET,         /* gadget type flags */
    (APTR)&Border3,     /* gadget border or image to be rendered */
    NULL,               /* alternate imagery for selection */
    NULL,               /* first IntuiText structure */
    NULL,               /* gadget mutual-exclude long word */
    NULL,               /* SpecialInfo structure */
    1,                  /* user-definable data */
    NULL                /* pointer to user-definable data */
};

SHORT BorderVectors4[] = {
    0,0,
    169,0,
    169,10,
    0,10,
    0,0
};
struct Border Border4 = {
    -1,-1,                        /* XY origin relative to TopLeft */
    1,0,JAM1,                     /* front pen, back pen and drawmode */
    5,                            /* number of XY vectors */
    BorderVectors4,               /* pointer to XY vectors */
    NULL                          /* next border in list */
};

UBYTE UNDOBUFFER[255];
UBYTE NameGadSIBuff[255];

struct StringInfo NameGadSInfo = {
    NameGadSIBuff,      /* buffer where text will be edited */
    UNDOBUFFER,         /* optional undo buffer */
    0,                  /* character position in buffer */
    25,                 /* maximum number of characters to allow */
    0,                  /* first displayed character buffer position */
    0,0,0,0,0,          /* Intuition initialized and maintained variables */
    0,                  /* Rastport of gadget */
    0,                  /* initial value for integer gadgets */
    NULL                /* alternate keymap (fill in if you set the flag) */
};

struct Gadget NameGad = {
    &EntryBox,
    5,94,
    168,9,
    NULL,
    RELVERIFY|GADGIMMEDIATE|LONGINT, /* Make into a Integer gadget */
    STRGADGET,                    /* String gadget */
    (APTR)&Border4,
    NULL,
    NULL,
    NULL,
    (APTR)&NameGadSInfo,          /* SpecialInfo structure */
    5,
    NULL
};

USHORT chip DArrowData[] =        /* Down Arrow */
    {
    0xFFFF,0xF81F,0xF81F,0xF81F,0xF81F,0x8001,0xE007,0xF81F,0xFE7F
    };

USHORT chip UArrowData[] =        /* Up Arrow */
    {
    0xFE7F,0xF81F,0xE007,0x8001,0xF81F,0xF81F,0xF81F,0xF81F,0xFFFF
    };

USHORT chip RArrowData[] =        /* Right Arrow */
    {
    0xFFFF,0xFF3F,0xFF0F,0xC003,0xC000,0xC003,0xFF0F,0xFF3F,0xFFFF
    };

USHORT chip LArrowData[] =        /* Left Arrow */
    {
    0xFFFF,0xFCFF,0xF0FF,0xC003,0x0003,0xC003,0xF0FF,0xFCFF,0xFFFF
    };

struct Image Arrows[] =
    {
    {0,0,16,9,2,UArrowData,0x0001,0x0000,NULL},
    {0,0,16,9,2,DArrowData,0x0001,0x0000,NULL},
    {0,0,16,9,2,LArrowData,0x0001,0x0000,NULL},
    {0,0,16,9,2,RArrowData,0x0001,0x0000,NULL}
    };

struct Gadget ArrowGads[] =
    {
       {
       &NameGad,     158, 73, 16,9, GADGIMAGE, RELVERIFY|GADGIMMEDIATE,
       BOOLGADGET,(APTR)&Arrows[0], NULL, NULL, NULL, NULL, 4, NULL
       },
       {
       &ArrowGads[0],158, 83,16,9,GADGIMAGE, RELVERIFY|GADGIMMEDIATE,
       BOOLGADGET,(APTR)&Arrows[1], NULL, NULL, NULL, NULL, 3, NULL
       }
    };

struct PropInfo VertSliderSInfo = {
    AUTOKNOB|FREEVERT, /* PropInfo flags */
    -1,-1,             /* horizontal and vertical pot values */
    -1,-1,             /* horizontal and vertical body values */
};

struct Image Image3 = 
    {0,0,7,72,0, NULL,0x0000,0x0000, NULL};

struct Gadget VertSlider =
    {
    &ArrowGads[1], 158,0, 16,72, NULL,
    RELVERIFY|GADGIMMEDIATE,
    PROPGADGET,                   /* Proportional Gadget */
    (APTR)&Image3,                /* Slider Imagry */
    NULL,NULL,NULL,
    (APTR)&VertSliderSInfo,       /* SpecialInfo structure */
    2, NULL
    };

struct NewWindow NewWindow = {
    160,25, 178,150, 0,1,
    INTUITICKS|GADGETDOWN|GADGETUP|CLOSEWINDOW,
    WINDOWDRAG|WINDOWDEPTH|
    WINDOWCLOSE|ACTIVATE|NOCAREREFRESH,
    NULL,NULL, "Gadgets", NULL, NULL, 0,0, -1,-1, WBENCHSCREEN 
};
