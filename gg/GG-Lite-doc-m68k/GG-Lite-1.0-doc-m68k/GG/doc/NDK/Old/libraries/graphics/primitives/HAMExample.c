/*
   Hold-And-Modify Example
   For Lattice, compile and link with:  LC -b1 -cfist -L -v -y HAMExample.c

   Copyright (c) 1990 Commodore-Amiga, Inc.
  
   This example is provided in electronic form by Commodore-Amiga, Inc. for
   use with the 1.3 revisions of the Addison-Wesley Amiga reference manuals. 
   The 1.3 Addison-Wesley Amiga Reference Manual series contains additional
   information on the correct usage of the techniques and operating system
   functions presented in this example.  The source and executable code of
   this example may only be distributed in free electronic form, via bulletin
   board or as part of a fully non-commercial and freely redistributable
   diskette.  Both the source and executable code (including comments) must
   be included, without modification, in any copy.  This example may not be
   published in printed form or distributed with any commercial product.
   However, the programming techniques and support routines set forth in
   this example may be used in the development of original executable
   software products for Commodore Amiga computers.
   All other rights reserved.
   This example is provided "as-is" and is subject to change; no warranties
   are made.  All use is at your own risk.  No liability or responsibility
   is assumed.
*/

#include <exec/types.h>
#include <intuition/intuitionbase.h>
#include <graphics/gfxbase.h>
#include <libraries/dos.h>

#include <proto/all.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

#define  XSIZE 11    /* Color box sizes. */
#define  YSIZE 6

struct IntuitionBase *IntuitionBase = NULL;
struct GfxBase *GfxBase = NULL;

struct TextAttr textAttr =
{
    "topaz.font",    /* Standard system font. */
    8,
    0,
    0
};

struct Window *window = NULL;
struct Screen *screen = NULL;

struct NewScreen newScreen =
{
    0, 0,
    320, 200, 6,
    0, 1,
    HAM,
    CUSTOMSCREEN,
    &textAttr,
    (UBYTE *)" 256 different colors out of",
    NULL,
    NULL
};

struct NewWindow newWindow =
{
    0, 11,                    /* LeftEdge, TopEdge, */
    320, 186,                 /* Width, Height, */
    -1, -1,                   /* DetailPen, BlockPen, (-1 == "use Screen's") */
    MOUSEBUTTONS|CLOSEWINDOW, /* IDCMPFlags, */
    ACTIVATE|WINDOWCLOSE,     /* Flags, */
    NULL,                     /* FirstGadget, */
    NULL,                     /* CheckMark, */
    (UBYTE *)"4,096 at any given moment.",    /* Title, */
    NULL,                     /* Screen, */
    NULL,                     /* BitMap, */
    0, 0,                     /* MinWidth, MinHeight, */
    320, 186,                 /* MaxWidth, MaxHeight, */
    CUSTOMSCREEN              /* Type */
};

#define BLACK 0x000
#define RED   0xf00
#define GREEN 0x0f0
#define BLUE  0x00f
#define WHITE 0xfff

#define COLOR0 0
#define COLOR1 1
#define COLOR2 2
#define COLOR3 3

VOID cleanExit(LONG exitStatus);
VOID hamBox(struct RastPort *rastPort, LONG color, LONG x, LONG y);
VOID prompt(struct RastPort *rastPort);
VOID
  colorWheel(struct RastPort *rastPort, SHORT xpos[], SHORT ypos[], BOOL textneeded);
VOID
  colorFull(struct RastPort *rastPort, SHORT xpos[], SHORT ypos[], BOOL textneeded);
extern ULONG RangeRand(ULONG);

VOID main(VOID)
{
BOOL wheelmode = TRUE, textneeded = TRUE;
SHORT xpos[16], ypos[16];
USHORT code, i;
static UWORD colors[] = {BLACK, RED, GREEN, BLUE, WHITE};
ULONG class;
struct RastPort *rastPort;    /* Graphics structures. */
struct ViewPort *viewPort;
struct IntuiMessage *intuiMessage;

for(i=0; i<16; i++)     /* Establish color square positions. */
    {
    xpos[i] = (XSIZE + 4) * i + 20;
    ypos[i] = (YSIZE + 3) * i + 21;
    }

IntuitionBase = (struct IntuitionBase *)OpenLibrary("intuition.library", 33L);
if (IntuitionBase == NULL)
    cleanExit(ERROR_INVALID_RESIDENT_LIBRARY);

GfxBase = (struct GfxBase *)OpenLibrary("graphics.library", 33L);
if (GfxBase == NULL)
    cleanExit(ERROR_INVALID_RESIDENT_LIBRARY);

screen = OpenScreen(&newScreen); 
if (screen == NULL)
    cleanExit(ERROR_NO_FREE_STORE);

newWindow.Screen = screen;    /* Open window in our new screen. */
window = OpenWindow(&newWindow);
if (window == NULL)
    cleanExit(ERROR_NO_FREE_STORE);

viewPort = &(screen->ViewPort);     /* Set colors in screen's ViewPort. */
rastPort = window->RPort;    /* Render into the window's RastPort. */

/*  Set the color registers:  Black, Red, Green, Blue, White. */
LoadRGB4(viewPort, colors, 5L);

SetBPen(rastPort, COLOR0);    /* Insure clean text. */

/* Process any and all messages in the queue, then update the display
 * colors once, then come back here to look at the queue again.  If you
 * see a left-mouse-button-down event, then switch display modes.  If you
 * see a Close-Window-gadget event, then clean up and exit the program.
 * NOTE: This is a BUSY LOOP so the colors will cycle as quickly as possible.
 */
while (1)
    {
    while(intuiMessage=(struct IntuiMessage *)GetMsg(window->UserPort))
        {
         /* Can't reply until done using it! */
         class = intuiMessage->Class;
         code = intuiMessage->Code;
         ReplyMsg((struct Message *)intuiMessage);

         if (class == CLOSEWINDOW)    /* Exit the program. */
                cleanExit(RETURN_OK);

         if (class == MOUSEBUTTONS && code == SELECTDOWN)    /* Swap modes. */
             {
             wheelmode = NOT wheelmode;

             SetAPen(rastPort, COLOR0);    /* Clear the drawing area. */
             SetDrMd(rastPort, JAM1);
             RectFill(rastPort, 3, 12, 318, 183);
             textneeded = TRUE; 
             }
        }
    if (wheelmode)
        colorWheel(rastPort, xpos, ypos, textneeded);
    else
        colorFull(rastPort, xpos, ypos, textneeded);

    textneeded = FALSE;
    }
}


/*
    Display a randomized set of colors.
*/
VOID
  colorFull(struct RastPort *rastPort, SHORT xpos[], SHORT ypos[], BOOL textneeded)
{
SHORT usesquare;
ULONG sChoice, cChoice;
LONG usecolor;
static SHORT sStop, cStop;
static SHORT squares[16 * 16];
static LONG squarecolor[16 * 16], freecolors[4096-(16*16)];

if(textneeded)    /* First call since mode change? */
    {
    prompt(rastPort);
    sStop = 255;    /* Top of list of squares yet to change. */
    cStop = 4095 - 256;    /* Top of list of colors still needing use. */

    for(usecolor=0; usecolor<256; usecolor++)    /* Initialize colors. */
        {
        usesquare = usecolor;
        squares[usesquare] = usesquare;
        squarecolor[usesquare] = usecolor;
        hamBox(rastPort, usecolor, xpos[usesquare % 16], ypos[usesquare / 16]);
        }

    for(usecolor=256; usecolor<4095; usecolor++)    /* Ones not yet used. */
        freecolors[usecolor - 256] = usecolor;

    }

/***************************************************************************
* Randomly choose next square to change such that all squares change color
* at least once before any square changes twice.  squares[0] through squares
* [sStop] are the square numbers that have not yet changed in this pass.
* RangeRand(r) is an integer function provided in "amiga.lib" that produces
* a random result in the range 0 to (r-1) given an integer r in the range 1 to 65535.
**************************************************************************/

sChoice = RangeRand(sStop + 1);    /* Pick a remaining square. */

usesquare = squares[sChoice];    /* Extract square number. */
squares[sChoice] = squares[sStop];    /* Swap it with sStop slot. */
squares[sStop] = usesquare;

if (NOT sStop--)
    sStop = 255;    /* Only one change per pass. */

/***************************************************************************
 * Randomly choose new color for selected square such that all colors are
 * used once before any color is used again, and such that no two squares
 * simultaneously have the same color.  freecolors[0] through freecolors[cStop]
 * are the colors that have not yet been chosen in this pass.  Note that
 * the 256 colors in use at the end of the previous pass are not available
 * for choice in this pass.
 ***************************************************************************/

cChoice = RangeRand(cStop + 1);

usecolor = freecolors[cChoice];
freecolors[cChoice] = freecolors[cStop];
freecolors[cStop] = squarecolor[usesquare];
squarecolor[usesquare] = usecolor;

if (NOT cStop--)
    cStop = 4095 - 256;

hamBox(rastPort, usecolor, xpos[usesquare % 16], ypos[usesquare / 16]);
}


/*
    Display an ordered set of colors.
*/
VOID
  colorWheel(struct RastPort *rastPort, SHORT xpos[], SHORT ypos[], BOOL textneeded)
{
SHORT  i, j;
static SHORT sequence;
static UBYTE  *number[] =
{
    "0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F"
};
static UBYTE red[] = "Red", blue[] = "Blue", green[] = "Green";
if(textneeded)
    {
    prompt(rastPort);

    SetAPen(rastPort, COLOR2);    /* Green pen for green color numbers. */
    Move(rastPort, 260, ypos[15]+17);
    Text(rastPort, green, strlen(green));
    for(i=0; i<16; i++)
        {
        Move(rastPort, xpos[i]+3, ypos[15]+17);
        Text(rastPort, number[i], strlen(number[i]));
        }

    SetAPen(rastPort, COLOR3);    /* Blue pen for blue color numbers. */
    Move(rastPort, 4, 18);
    Text(rastPort, blue, strlen(blue));
    for(i=0; i<16; i++)
        {
        Move(rastPort, 7, ypos[i]+6);
        Text(rastPort, number[i], strlen(number[i]));
        }

    SetAPen(rastPort, COLOR1);    /* Red pen for red color numbers. */
    Move(rastPort, 271, 100);
    Text(rastPort, red, strlen(red));

    sequence = 0;
    }

SetAPen(rastPort, COLOR1);    /* Identify the red color in use. */
SetDrMd(rastPort, JAM2);
Move(rastPort, 280, 115);
Text(rastPort, number[sequence], strlen(number[sequence]));

for(j=0; j<16; j++)    /* Update all of the squares. */
    {
    for(i=0; i<16; i++)
        hamBox(rastPort, (sequence<<8 | i<<4 | j), xpos[i], ypos[j]);

    }

if (++sequence == 16)
    sequence = 0;
}


/* Display mode changing prompt. */
VOID  prompt(struct RastPort *rastPort)
{
static UBYTE text[] = "[left mouse button = new mode]";

SetDrMd(rastPort, JAM2);
SetAPen(rastPort, 4);
Move(rastPort, 23, 183);
Text(rastPort, text, strlen(text));
}


/**********************************************************************
 *  hamBox() -- routine to draw a colored box in Hold and Modify mode.  Draws a
 *    box of size XSIZE by YSIZE with an upper left corner at (x,y).  The
 *    desired color is achieved in 3 steps on each horizontal line of the box.
 *    First we set the red component, then the green, then the blue.  We
 *    achieve this by drawing a vertical line of Modify-Red, followed by a
 *    vertical line of Modify-Green, followed by a rectangle of Modify-Blue.
 *    Note that the resulting color for the first two vertical lines depends 
 *    upon the color(s) of the pixels immediately to the left of that
 *    line.  By the time we reach the rectangle we are assured of getting
 *    (and maintaining) the desired color because we have set all 3
 *    components (R, G, and B) straight from the bit map.
 ***********************************************************************/

VOID hamBox(struct RastPort *rastPort, LONG color, LONG x, LONG y)
{
SHORT  c;

SetDrMd(rastPort, JAM1);    /* Establish Drawing Mode in RastPort. */

c = (color & 0xf00) >> 8;    /* Extract desired Red color component. */
SetAPen(rastPort, c + 0x20);    /* Hold G, B from previous pixel.  Set R=n. */
Move(rastPort, x, y);
Draw(rastPort, x, y+YSIZE);

x++;
c = (color & 0xf0) >> 4;    /* Extract desired Green color component. */
SetAPen(rastPort, c + 0x30);    /* Hold R, B from previous pixel.  Set G=n. */
Move(rastPort, x, y);
Draw(rastPort, x, y+YSIZE);

x++;
c = (color & 0xf);        /* Extract desired Blue color component.*/
SetAPen(rastPort, c + 0x10);    /* Hold R, G from previous pixel.  Set B=n. */
RectFill(rastPort, x, y, x+XSIZE-2, y+YSIZE);
}


/*
    Clean up and exit.
*/
VOID  cleanExit(LONG exitStatus)
{
struct IntuiMessage *intuiMessage;

if (window)
    {
    /* Reply to any pending IntuiMessages. */
    while(intuiMessage=(struct IntuiMessage *)GetMsg(window->UserPort))
        ReplyMsg((struct Message *)intuiMessage);
    CloseWindow(window);
    }
if (screen)
    CloseScreen(screen);
if (GfxBase)
    CloseLibrary((struct Library *)GfxBase);
if (IntuitionBase)
    CloseLibrary((struct Library *)IntuitionBase);

exit(exitStatus);
}

